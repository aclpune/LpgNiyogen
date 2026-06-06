
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/RefillProfitDetailDataGetModel.dart';

// ─────────────────────────────────────────────────────────────────────────────
// REFILL PROFIT DETAIL SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class RefillProfitDetailScreenUi extends StatefulWidget {
  static const screenName = '/refillProfitDetailScreenUi';
  const RefillProfitDetailScreenUi({super.key});

  @override
  State<RefillProfitDetailScreenUi> createState() =>
      _RefillProfitDetailScreenUiState();
}

class _RefillProfitDetailScreenUiState
    extends State<RefillProfitDetailScreenUi> {
  // ── State ──────────────────────────────────────────────────────────────────
  late List<RefillProfitDetailDataGetModel> refillProfitDetailDataGetModel = [];
  bool isLoading = true;
  String? flags;
  double? grossRevenueAmts = 0;
  double? grossProfitAmts = 0;
  int saleQtys = 0;
  String? profitFors;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      final String dayFlags = argValue?['DAYFLAG'] ?? '';
      profitFors = argValue?['PROFITFOR'] ?? '';
      flags = dayFlags;
      debugPrint('flags $flags');
      fetchRefillDetailList(profitFors!, dayFlags);
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  bool get _showProfit => profitFors == 'GrossProfit';

  String get _periodLabel {
    switch (flags) {
      case 'TODAYS':
        return "Today's";
      case 'THISMONTH':
        return 'This Month';
      case 'FINYEAR':
        return 'Financial Year';
      default:
        return '';
    }
  }

  String get _profitTypeLabel {
    if (profitFors == 'GrossRevenue') return 'Gross Revenue';
    if (profitFors == 'GrossProfit') return 'Gross Profit';
    return '';
  }

  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    return NumberFormat('#,##,###.00', 'en_IN').format(amount);
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.bg2,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppGradientHeader(
            title: 'Refill – $_profitTypeLabel',
            subtitle: _periodLabel,
            icon: Icons.receipt_long_rounded,
            onBack: () =>
                // Navigator.pushReplacementNamed(context, '/bottomNavBarExample'),
              Navigator.pop(context)
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.blueLight),
      );
    }

    return Column(
      children: [
        _buildTotalsCard(),
        _buildTableHeader(),
        Expanded(child: _buildTableRows()),
      ],
    );
  }

  // ── Totals summary card ────────────────────────────────────────────────────
  // FIX: _SummaryTile no longer returns Expanded internally.
  //      Every tile is wrapped in Expanded exactly once here, at the call site,
  //      so all three tiles share the Row's space equally and there are no
  //      competing ParentDataWidgets on the same RenderObject.
  Widget _buildTotalsCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: AppColors.gradAccent,
        borderRadius: BorderRadius.circular(16),
        boxShadow:  [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Tile 1 – Sale Qty
          Expanded(
            child: _SummaryTile(
              label: 'Sale Qty',
              value: saleQtys.toString(),
              icon: Icons.inventory_2_outlined,
            ),
          ),
          _VerticalDividerLine(),
          // Tile 2 – Gross Revenue
          Expanded(
            child: _SummaryTile(
              label: 'Gross Revenue',
              value: '₹${formatCurrency(grossRevenueAmts ?? 0)}',
              icon: Icons.trending_up_rounded,
            ),
          ),
          // Tile 3 – Gross Profit (conditional)
          if (_showProfit) ...[
            _VerticalDividerLine(),
            Expanded(
              child: _SummaryTile(
                label: 'Gross Profit',
                value: '₹${formatCurrency(grossProfitAmts ?? 0)}',
                icon: Icons.account_balance_wallet_outlined,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Table header ───────────────────────────────────────────────────────────
  Widget _buildTableHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.blueXXL,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Item Name',
              style:
              AppTypography.sectionHeader.copyWith(color: AppColors.blue),
            ),
          ),
          _HeaderCell(label: 'Qty', flex: 1),
          _HeaderCell(label: 'Revenue', flex: 2),
          if (_showProfit) _HeaderCell(label: 'Profit', flex: 2),
        ],
      ),
    );
  }

  // ── Table rows ─────────────────────────────────────────────────────────────
  Widget _buildTableRows() {
    if (refillProfitDetailDataGetModel.isEmpty) {
      return _EmptyState(message: 'No records found for $_periodLabel');
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
        const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border.all(color: AppColors.border),
        boxShadow:  [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: refillProfitDetailDataGetModel.length,
        separatorBuilder: (_, __) =>
         Divider(height: 1, color: AppColors.divider),
        itemBuilder: (context, index) {
          final refill = refillProfitDetailDataGetModel[index];
          final isEven = index.isEven;
          return Container(
            color: isEven ? AppColors.white : AppColors.bg2,
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    refill.itemName.toString(),
                    style:
                    AppTypography.dataRowLabel.copyWith(fontSize: 13),
                  ),
                ),
                _DataCell(
                  value: refill.saleQty?.toString() ?? '0',
                  flex: 1,
                  color: AppColors.blueLight,
                ),
                _DataCell(
                  value: refill.grossRevenue != null
                      ? formatCurrency(refill.grossRevenue!.toDouble())
                      : '0.00',
                  flex: 2,
                  color: AppColors.teal,
                ),
                if (_showProfit)
                  _DataCell(
                    value: refill.grossProfit != null
                        ? formatCurrency(refill.grossProfit!.toDouble())
                        : '0.00',
                    flex: 2,
                    color: AppColors.green,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── API ────────────────────────────────────────────────────────────────────
  Future<void> fetchRefillDetailList(String profitFor, String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    try {
      final response = await http.get(
        Uri.parse(
            '${AppUrl.GetDashboardProductListForMob}/$distributorId/$profitFor/$flag'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint('GetDashboardProductListForMob request '
          '${AppUrl.GetDashboardProductListForMob}/$distributorId/$profitFor/$flag');
      debugPrint('GetDashboardProductListForMob response ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          refillProfitDetailDataGetModel =
              data.map((j) => RefillProfitDetailDataGetModel.fromJson(j)).toList();

          double grossRevenueAmt = 0;
          double grossProfitAmt = 0;
          int saleQty = 0;

          for (var r in refillProfitDetailDataGetModel) {
            grossRevenueAmt += (r.grossRevenue ?? 0).toDouble();
            grossProfitAmt += (r.grossProfit ?? 0).toDouble();
            saleQty += (r.saleQty ?? 0).toInt();
          }

          grossRevenueAmts = grossRevenueAmt;
          grossProfitAmts = grossProfitAmt;
          saleQtys = saleQty;
          isLoading = false;
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        throw Exception('Failed to load items');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('Exception $e');
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE REUSABLE SUB-WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

/// KPI tile used inside the gradient summary card.
///
/// IMPORTANT: this widget returns a plain [Column] — NOT [Expanded].
/// The caller in [_buildTotalsCard] wraps it in [Expanded] exactly once.
/// Previously the widget returned [Expanded] itself AND the call site also
/// wrapped it in [Expanded], giving the same RenderObject two competing
/// FlexParentData ancestors → crash.
class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    // Returns Column, NOT Expanded — flex is the caller's responsibility.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTypography.kpiValueLG.copyWith(
            color: Colors.white,
            fontSize: 15,
            letterSpacing: -0.4,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.miniLabel.copyWith(
            color: Colors.white70,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Thin white vertical divider for inside the summary card.
class _VerticalDividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withOpacity(0.25),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

/// Styled header cell for the table.
/// Returns [Expanded] internally — must be a direct child of a Row/Flex.
class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label, required this.flex});
  final String label;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: AppTypography.sectionHeader.copyWith(color: AppColors.blue),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Styled data cell for table rows.
/// Returns [Expanded] internally — must be a direct child of a Row/Flex.
class _DataCell extends StatelessWidget {
  const _DataCell({
    required this.value,
    required this.flex,
    required this.color,
  });

  final String value;
  final int flex;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        value,
        style: AppTypography.dataRowValue.copyWith(
          fontSize: 13,
          color: color,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Empty-state placeholder.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.blueXL,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.inbox_outlined,
                size: 32, color: AppColors.blueLight),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style:
            AppTypography.cardSubtitle.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}