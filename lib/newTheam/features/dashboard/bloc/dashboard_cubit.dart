import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/dashboard_models.dart';
import '../../../core/theme/app_colors.dart';

// ── States ──
sealed class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  DashboardLoaded(this.data);
  final DashboardData data;
}

class DashboardError extends DashboardState {
  DashboardError(this.message);
  final String message;
}

// ── Cubit ──
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    try {
      // Simulate API call — replace with real repository
      await Future.delayed(const Duration(milliseconds: 800));
      emit(DashboardLoaded(_mockData()));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> refresh() => loadDashboard();

  // ── Mock data matching the old app screenshot ──
  DashboardData _mockData() {
    return DashboardData(
      businessName: 'Demo Niyojan',
      ownerName: 'Snehal',
      ownerInitials: 'SN',
      date: DateTime.now(),
      revenueToday: 0,
      stockSummary: const StockSummary(
        filled: 998,
        empty: 205,
        defective: 7,
        weightKg: 14.2,
      ),
      alerts: [
        AlertItem(
          title: 'Postpaid Verification Pending',
          subtitle: '98 parties · awaiting verification',
          value: '₹7,25,256.00',
          severity: AlertSeverity.danger,
          icon: Icons.warning_amber_rounded,
        ),
        AlertItem(
          title: 'Outstanding Settlement',
          subtitle: 'Collect from customers',
          value: '₹11,86,437.00',
          severity: AlertSeverity.warning,
          icon: Icons.receipt_long_rounded,
        ),
        AlertItem(
          title: 'Vendor Payment Due',
          subtitle: 'Pending to be cleared',
          value: '₹34,700.00',
          severity: AlertSeverity.warning,
          icon: Icons.local_shipping_rounded,
        ),
        AlertItem(
          title: 'Undocumented Deliveries (SV)',
          subtitle: 'Need to be recorded urgently',
          value: '81 Pending',
          severity: AlertSeverity.info,
          icon: Icons.description_rounded,
        ),
      ],
      financialKpis: [
        FinancialKpi(
          label: "Today's Revenue",
          value: '₹0.00',
          subtitle: 'NC · ARB · Refill combined',
          badgeLabel: 'No Data',
          badgeColor: AppColors.orangeXL,
          badgeFg: const Color(0xFF9A3412),
          iconBg: AppColors.blueXL,
          icon: Icons.currency_rupee_rounded,
        ),
        FinancialKpi(
          label: 'On Account Balance',
          value: '₹2,783.00',
          subtitle: 'Today: ₹0 · Total: ₹2,783',
          badgeLabel: 'Active',
          badgeColor: AppColors.blueXXL,
          badgeFg: AppColors.blue,
          iconBg: AppColors.tealXL,
          icon: Icons.account_balance_wallet_rounded,
        ),
        FinancialKpi(
          label: 'Credit Sale Pending',
          value: '₹0.00',
          subtitle: 'No outstanding credit sales',
          badgeLabel: 'Clear ✓',
          badgeColor: AppColors.greenXL,
          badgeFg: const Color(0xFF166534),
          iconBg: AppColors.redXL,
          icon: Icons.credit_card_rounded,
        ),
      ],
      onAccountToday: 0,
      onAccountTotal: 2783,
      svPending: 36,
      tvPending: 7,
      unsettledCount: 0,
      unsettledAmount: 0,
      imbalanceToday: 0,
      imbalanceTotal: 15,
      outstandingSettlement: 1186437,
      profitRows: const [
        ProfitRow(label: 'NC', grossRevenue: 0, grossProfit: 0),
        ProfitRow(label: 'ARB', grossRevenue: 0, grossProfit: 0),
        ProfitRow(label: 'Refill', grossRevenue: 0, grossProfit: 0),
      ],
      totalExpenses: 0,
    );
  }
}
