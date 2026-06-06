import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────
/// DASHBOARD MODELS
/// ─────────────────────────────────────────────

// ── Alert Severity ──
enum AlertSeverity { danger, warning, info }

// ── Alert Item ──
class AlertItem {
  const AlertItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.severity,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String value;
  final AlertSeverity severity;
  final IconData icon;
  final VoidCallback? onTap;
}

// ── Stock Summary ──
class StockSummary {
  const StockSummary({
    required this.filled,
    required this.empty,
    required this.defective,
    required this.weightKg,
  });

  int get total => filled + empty + defective;
  double get filledPct => total == 0 ? 0 : filled / total;
  double get emptyPct  => total == 0 ? 0 : empty / total;
  double get defectPct => total == 0 ? 0 : defective / total;

  final int filled;
  final int empty;
  final int defective;
  final double weightKg;
}

// ── Financial KPI ──
class FinancialKpi {
  const FinancialKpi({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeFg,
    required this.iconBg,
    required this.icon,
    this.onTap,
  });

  final String label;
  final String value;
  final String subtitle;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeFg;
  final Color iconBg;
  final IconData icon;
  final VoidCallback? onTap;
}

// ── Profit Row ──
class ProfitRow {
  const ProfitRow({
    required this.label,
    required this.grossRevenue,
    required this.grossProfit,
    this.isHighlight = false,
  });

  final String label;
  final double grossRevenue;
  final double grossProfit;
  final bool isHighlight;
}

// ── Dashboard State ──
class DashboardData {
  const DashboardData({
    required this.businessName,
    required this.ownerName,
    required this.ownerInitials,
    required this.date,
    required this.revenueToday,
    required this.stockSummary,
    required this.alerts,
    required this.financialKpis,
    required this.onAccountToday,
    required this.onAccountTotal,
    required this.svPending,
    required this.tvPending,
    required this.unsettledCount,
    required this.unsettledAmount,
    required this.imbalanceToday,
    required this.imbalanceTotal,
    required this.outstandingSettlement,
    required this.profitRows,
    required this.totalExpenses,
  });

  final String businessName;
  final String ownerName;
  final String ownerInitials;
  final DateTime date;
  final double revenueToday;
  final StockSummary stockSummary;
  final List<AlertItem> alerts;
  final List<FinancialKpi> financialKpis;
  final double onAccountToday;
  final double onAccountTotal;
  final int svPending;
  final int tvPending;
  final int unsettledCount;
  final double unsettledAmount;
  final int imbalanceToday;
  final int imbalanceTotal;
  final double outstandingSettlement;
  final List<ProfitRow> profitRows;
  final double totalExpenses;

  double get netProfit =>
      profitRows.fold(0.0, (s, r) => s + r.grossProfit) - totalExpenses;
}
