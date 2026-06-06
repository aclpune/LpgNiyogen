
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../GodownKeeper/BottomNavigationForGodownKeeper.dart';
import '../../Utils/BoxShadow/app_typography.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/styles/app_colors.dart';
import '../ClickModelClass/ARBProfitDetailDataGetModel.dart';

// =============================================================================
// Widget
// =============================================================================

class ARBProfitDetailScreenUi extends StatefulWidget {
  static const screenName = '/aRBProfitDetailScreenUi';
  const ARBProfitDetailScreenUi({super.key});

  @override
  State<ARBProfitDetailScreenUi> createState() =>
      _ARBProfitDetailScreenUiState();
}

class _ARBProfitDetailScreenUiState
    extends State<ARBProfitDetailScreenUi> {
  // ── State ──────────────────────────────────────────────────────────────────
  late List<ArbProfitDetailDataGetModel> arbProfitDetailDataGetModel = [];
  bool isLoading = true;
  String? flags;
  double? grossSaleAmts = 0;
  double? grossProfitAmts = 0;
  double? purchaseAmts = 0;
  int purchaseQtys = 0;
  String? profitFors;

  // ── Derived helpers ────────────────────────────────────────────────────────
  bool get _isGrossProfit => profitFors == 'GrossProfit';

  String get _modeLabel => profitFors == 'GrossRevenue'
      ? 'Gross Revenue'
      : profitFors == 'GrossProfit'
      ? 'Gross Profit'
      : 'ARB';

  String get _periodLabel => flags == 'TODAYS'
      ? "Today's"
      : flags == 'THISMONTH'
      ? 'This Month'
      : flags == 'FINYEAR'
      ? 'Financial Year'
      : '';

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final argValue =
      ModalRoute.of(context)?.settings.arguments as Map?;
      final String dayFlags = argValue?['DAYFLAG'] ?? '';
      profitFors = argValue?['PROFITFOR'] ?? '';
      flags = dayFlags;
      debugPrint('flags $flags');
      fetchARBDetailList(profitFors!, dayFlags);
    });
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
        backgroundColor: AppColors.background2,
        // appBar: _buildAppBar(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppGradientHeader(
            title: 'ARB - $_modeLabel',
            subtitle: _periodLabel,
            icon: Icons.receipt_long_rounded,
              // onBack: () => Navigator.pushReplacementNamed(context, '/bottomNavBarExample'),
              onBack: () => Navigator.pop(context)
          ),
        ),
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        )
            : Column(
          children: [
            _buildTableHeader(),
            Expanded(child: _buildItemList()),
            _buildSummaryFooter(),
          ],
        ),
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradPrimary),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),

                // Title + subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ARB $_modeLabel',
                        style: AppTypography.heroTitle,
                        textScaler: TextScaler.noScaling,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _periodLabel,
                        style: AppTypography.heroSubtitle,
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ),

                // Period badge
                _AppBarBadge(
                  icon: Icons.calendar_today_rounded,
                  label: _periodLabel,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _HeaderCell(label: 'Item Name', flex: 3, align: TextAlign.left),
          _HeaderDivider(),
          _HeaderCell(label: 'Qty', flex: 1, align: TextAlign.center),
          _HeaderDivider(),
          _HeaderCell(label: 'Sale Amt.', flex: 2, align: TextAlign.center),
          if (_isGrossProfit) ...[
            _HeaderDivider(),
            _HeaderCell(label: 'Purchase', flex: 2, align: TextAlign.center),
            _HeaderDivider(),
            _HeaderCell(
              label: 'Profit',
              flex: 2,
              align: TextAlign.center,
              // color: AppColors.green,
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildItemList() {
    if (arbProfitDetailDataGetModel.isEmpty) {
      return _EmptyState(
        icon: Icons.bar_chart_rounded,
        message: 'No profit detail records found\nfor the selected period.',
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: arbProfitDetailDataGetModel.length,
      itemBuilder: (context, index) {
        final arb = arbProfitDetailDataGetModel[index];
        return _DataRow(
          isEven: index.isEven,
          isGrossProfit: _isGrossProfit,
          itemName: arb.itemName?.toString() ?? '—',
          qty: arb.itemQty?.toString() ?? '0',
          grossSaleAmt: arb.grossSaleAmt != null
              ? formatCurrency(arb.grossSaleAmt!.toDouble())
              : '0.00',
          purchaseAmt: arb.purchesAmt != null
              ? formatCurrency(arb.purchesAmt!.toDouble())
              : '0.00',
          grossProfitAmt: arb.grossProfitAmt != null
              ? formatCurrency(arb.grossProfitAmt!.toDouble())
              : '0.00',
          isProfit: (arb.grossProfitAmt ?? 0) >= 0,
        );
      },
    );
  }


  Widget _buildSummaryFooter() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "TOTALS" section label (reuses dashboard SectionHeader style)
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'TOTALS',
                style: AppTypography.sectionHeader,
                textScaler: TextScaler.noScaling,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // KPI tiles
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: 'Total Qty',
                  value: purchaseQtys.toString(),
                  icon: Icons.propane_tank_rounded,
                  accentColor: AppColors.primary,
                  accentBg: AppColors.primaryXLight,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryTile(
                  label: 'Sale Amt.',
                  value: formatCurrency(grossSaleAmts ?? 0),
                  icon: Icons.currency_rupee_rounded,
                  accentColor: AppColors.teal,
                  accentBg: AppColors.tealXLight,
                ),
              ),
              if (_isGrossProfit) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _SummaryTile(
                    label: 'Purchase',
                    value: formatCurrency(purchaseAmts ?? 0),
                    icon: Icons.shopping_cart_rounded,
                    accentColor: AppColors.orange,
                    accentBg: AppColors.orangeXLight,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SummaryTile(
                    label: 'Profit',
                    value: formatCurrency(grossProfitAmts ?? 0),
                    icon: Icons.trending_up_rounded,
                    accentColor: AppColors.green,
                    accentBg: AppColors.greenXLight,
                    valueColor: AppColors.green,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }


  Future<void> fetchARBDetailList(String profitFor, String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    try {
      final response = await http.get(
        Uri.parse(
            '${AppUrl.GetDashboardARBProfitDtls_Mob}/$distributorId/$profitFor/$flag'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint(
          'GetDashboardARBProfitDtls_Mob request ${AppUrl.GetDashboardARBProfitDtls_Mob}/$distributorId/$profitFor/$flag');
      debugPrint('GetDashboardARBProfitDtls_Mob response ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        debugPrint('GetDashboardARBProfitDtls_Mob $data');
        setState(() {
          arbProfitDetailDataGetModel = data
              .map((json) => ArbProfitDetailDataGetModel.fromJson(json))
              .toList();

          double grossSaleAmt = 0;
          double grossProfitAmt = 0;
          double purchaseAmt = 0;
          int purchaseQty = 0;

          for (var arbProfit in arbProfitDetailDataGetModel) {
            grossSaleAmt += (arbProfit.grossSaleAmt ?? 0).toDouble();
            grossProfitAmt += (arbProfit.grossProfitAmt ?? 0).toDouble();
            purchaseAmt += (arbProfit.purchesAmt ?? 0).toDouble();
            purchaseQty += (arbProfit.itemQty ?? 0).toInt();
          }
          grossSaleAmts = grossSaleAmt;
          grossProfitAmts = grossProfitAmt;
          purchaseAmts = purchaseAmt;
          purchaseQtys = purchaseQty;

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


  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    return format.format(amount);
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.label,
    required this.flex,
    required this.align,
    this.color,
  });

  final String label;
  final int flex;
  final TextAlign align;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: AppTypography.labelSM.copyWith(
          color: color ?? AppColors.textSecondary,
        ),
        textAlign: align,
        textScaler: TextScaler.noScaling,
      ),
    );
  }
}

// =============================================================================
// _DataRow — one item row; alternates surface / surfaceMuted for readability
// =============================================================================
class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.isEven,
    required this.isGrossProfit,
    required this.itemName,
    required this.qty,
    required this.grossSaleAmt,
    required this.purchaseAmt,
    required this.grossProfitAmt,
    required this.isProfit,
  });

  final bool isEven;
  final bool isGrossProfit;
  final String itemName;
  final String qty;
  final String grossSaleAmt;
  final String purchaseAmt;
  final String grossProfitAmt;
  final bool isProfit;

  @override
  Widget build(BuildContext context) {
    final profitColor = isProfit ? AppColors.green : AppColors.red;

    return Container(
      color: isEven ? AppColors.surface : AppColors.surfaceMuted,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Item name
          Expanded(
            flex: 3,
            child: Text(
              itemName,
              style: AppTypography.cardSubtitle.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textScaler: TextScaler.noScaling,
            ),
          ),
          _RowDivider(),
          // Qty
          Expanded(
            flex: 1,
            child: Text(
              qty,
              style: AppTypography.labelMD.copyWith(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              textScaler: TextScaler.noScaling,
            ),
          ),
          _RowDivider(),
          // Gross Sale Amt
          Expanded(
            flex: 2,
            child: Text(
              grossSaleAmt,
              style: AppTypography.labelMD.copyWith(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              textScaler: TextScaler.noScaling,
            ),
          ),
          if (isGrossProfit) ...[
            _RowDivider(),
            // Purchase amt
            Expanded(
              flex: 2,
              child: Text(
                purchaseAmt,
                style: AppTypography.labelMD.copyWith(
                  fontSize: 12,
                  color: AppColors.orange,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                textScaler: TextScaler.noScaling,
              ),
            ),
            _RowDivider(),
            // Gross Profit amt
            Expanded(
              flex: 2,
              child: Text(
                grossProfitAmt,
                style: AppTypography.labelMD.copyWith(
                  fontSize: 12,
                  color: profitColor,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
                textScaler: TextScaler.noScaling,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// _SummaryTile — one KPI cell in the summary footer
// =============================================================================
class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.accentBg,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;
  final Color accentBg;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(
        color: accentBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: accentColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.labelSM.copyWith(color: accentColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.kpiValueLG.copyWith(
              fontSize: 13,
              color: valueColor ?? accentColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _AppBarBadge — frosted-glass pill badge shown in the gradient AppBar
// =============================================================================
class _AppBarBadge extends StatelessWidget {
  const _AppBarBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border:
        Border.all(color: Colors.white.withOpacity(0.30), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.1,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _HeaderDivider / _RowDivider — thin vertical separators for the table
// =============================================================================
class _HeaderDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 16,
    color: AppColors.border,
    margin: const EdgeInsets.symmetric(horizontal: 6),
  );
}

class _RowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 28,
    color: AppColors.divider,
    margin: const EdgeInsets.symmetric(horizontal: 5),
  );
}

// =============================================================================
// _EmptyState — consistent empty-state matching the dashboard pattern
// =============================================================================
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryXLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'No Records Found',
              style: AppTypography.cardTitle,
              textScaler: TextScaler.noScaling,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: AppTypography.cardSubtitle,
              textAlign: TextAlign.center,
              textScaler: TextScaler.noScaling,
            ),
          ],
        ),
      ),
    );
  }
}