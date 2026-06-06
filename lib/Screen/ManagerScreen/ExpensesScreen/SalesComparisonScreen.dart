// =============================================================================
// SalesComparisonScreen.dart
//
// Refactored to match the dashboard design system:
//   • Gradient AppBar (gradPrimary) with frosted-glass badge
//   • Styled item dropdown in a surface card with AppColors tokens
//   • Three KPI summary tiles (This Month / Last Month / Last Year)
//   • SfCartesianChart with dashboard-aligned colors and styled axes
//   • Themed legend row with rounded color indicators
//   • All API calls, business logic, navigation preserved exactly
// =============================================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../ConstantScreen/widgets.dart';
import '../../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/styles/app_colors.dart';
import 'GetDashProductSaleComparisonMob.dart';
import '../../../newTheam/core/theme/app_typography.dart';

// =============================================================================
// Colors used only in this screen — kept local to avoid polluting AppColors
// =============================================================================
const _kThisMonth   = Color(0xFF0EA5E9); // sky-500
const _kLastMonth   = Color(0xFF1E3A8A); // primary / navy
const _kLastYear    = Color(0xFFD97706); // AppColors.orange

class SalesComparisonScreen extends StatefulWidget {
  static const screenName = '/salesComparisonScreen';

  @override
  State<SalesComparisonScreen> createState() => _SalesComparisonScreenState();
}

class _SalesComparisonScreenState extends State<SalesComparisonScreen> {
  // ── State ──────────────────────────────────────────────────────────────────
  CylItemListModel? _selectedItemModel;
  List<CylItemListModel> _items = [];
  String _selectedItem = '';
  int? selectedItemId;
  List<GetDashProductSaleComparisonMob> _salesItem = [];
  GetDashProductSaleComparisonMob? _selectedSalesItemModel;
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, '/bottomNavBarExample', (route) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background2,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item selector card
              _buildItemSelector(),
              const SizedBox(height: 14),

              // KPI summary tiles
              if (_selectedSalesItemModel != null) ...[
                _buildKpiRow(),
                const SizedBox(height: 14),
              ],

              // Chart card
              _buildChartCard(),
              const SizedBox(height: 14),

              // Legend
              _buildLegend(),
            ],
          ),
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
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sales Comparison',
                        style: AppTypography.heroTitle,
                        textScaler: TextScaler.noScaling,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedItem.isNotEmpty
                            ? _selectedItem
                            : 'Select an item to compare',
                        style: AppTypography.heroSubtitle,
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ),
                _AppBarBadge(
                  icon: Icons.bar_chart_rounded,
                  label: 'Monthly',
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Item selector card ─────────────────────────────────────────────────────
  Widget _buildItemSelector() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.propane_tank_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Label
          Text(
            'Item',
            style: AppTypography.labelMD.copyWith(
              color: AppColors.textSecondary,
            ),
            textScaler: TextScaler.noScaling,
          ),
          const SizedBox(width: 12),

          // Dropdown
          Expanded(
            child: DropdownButtonFormField<CylItemListModel>(
              isExpanded: true,
              value: _selectedItemModel,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                filled: true,
                fillColor: AppColors.background2,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              style: AppTypography.cardSubtitle.copyWith(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
              dropdownColor: AppColors.surface,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textMuted,
              ),
              items: _items.map((CylItemListModel item) {
                return DropdownMenuItem<CylItemListModel>(
                  value: item,
                  child: Text(
                    item.itemName ?? '',
                    style: AppTypography.cardSubtitle.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textScaler: TextScaler.noScaling,
                  ),
                );
              }).toList(),
              onChanged: (CylItemListModel? selectedItem) async {
                if (selectedItem != null) {
                  setState(() {
                    _selectedItemModel = selectedItem;
                    _selectedItem = selectedItem.itemName!;
                    selectedItemId = selectedItem.itemId?.toInt();
                  });
                  await getDashProductSaleComparisonMob(
                      selectedItem.itemId?.toInt() ?? 0);
                }
              },
              hint: Text(
                'Select item…',
                style: AppTypography.cardSubtitle.copyWith(
                  color: AppColors.textDisabled,
                  fontSize: 13,
                ),
                textScaler: TextScaler.noScaling,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── KPI tiles row ──────────────────────────────────────────────────────────
  Widget _buildKpiRow() {
    final s = _selectedSalesItemModel;
    return Row(
      children: [
        Expanded(
          child: _KpiTile(
            label: 'This Month',
            value: '${s?.thisMonthSaleQty?.toInt() ?? 0}',
            unit: 'cylinders',
            accentColor: _kThisMonth,
            accentBg: const Color(0xFFE0F2FE),
            icon: Icons.calendar_today_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _KpiTile(
            label: 'Last Month',
            value: '${s?.preMonthSaleQty?.toInt() ?? 0}',
            unit: 'cylinders',
            accentColor: _kLastMonth,
            accentBg: AppColors.primaryXLight,
            icon: Icons.calendar_month_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _KpiTile(
            label: 'Last Year',
            value: '${s?.preYearSameMonthSaleQty?.toInt() ?? 0}',
            unit: 'same month',
            accentColor: _kLastYear,
            accentBg: AppColors.orangeXLight,
            icon: Icons.history_rounded,
          ),
        ),
      ],
    );
  }

  // ── Chart card ─────────────────────────────────────────────────────────────
  Widget _buildChartCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'SALES VOLUME',
                  style: AppTypography.sectionHeader,
                  textScaler: TextScaler.noScaling,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: SfCartesianChart(
              tooltipBehavior: _tooltipBehavior,
              plotAreaBorderWidth: 0,
              legend: const Legend(isVisible: false),
              primaryXAxis: CategoryAxis(
                isVisible: true,
                interval: 1,
                labelStyle: AppTypography.labelSM.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}',
                labelStyle: AppTypography.labelSM.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                majorGridLines: MajorGridLines(
                  width: 1,
                  color: AppColors.divider,
                  dashArray: const [4, 4],
                ),
              ),
              series: <CartesianSeries>[
                ColumnSeries<SalesData, String>(
                  dataSource: [
                    SalesData(
                      'This\nMonth',
                      _selectedSalesItemModel?.thisMonthSaleQty?.toDouble() ??
                          0.0,
                    ),
                    SalesData(
                      'Last\nMonth',
                      _selectedSalesItemModel?.preMonthSaleQty?.toDouble() ??
                          0.0,
                    ),
                    SalesData(
                      'Last Year\nSame Month',
                      _selectedSalesItemModel
                          ?.preYearSameMonthSaleQty
                          ?.toDouble() ??
                          0.0,
                    ),
                  ],
                  xValueMapper: (SalesData d, _) => d.label,
                  yValueMapper: (SalesData d, _) => d.sales,
                  width: 0.55,
                  spacing: 0.1,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                    textStyle: AppTypography.labelSM.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  pointColorMapper: (SalesData d, int index) {
                    if (index == 0) return _kThisMonth;
                    if (index == 1) return _kLastMonth;
                    if (index == 2) return _kLastYear;
                    return AppColors.textDisabled;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Legend ─────────────────────────────────────────────────────────────────
  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _LegendItem(color: _kThisMonth, label: 'This Month'),
          _LegendItem(color: _kLastMonth, label: 'Last Month'),
          _LegendItem(color: _kLastYear, label: 'Last Year'),
        ],
      ),
    );
  }

  // ── API calls (UNCHANGED) ──────────────────────────────────────────────────
  Future<void> fetchItems() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) throw Exception('Bearer Token Is Missing');

      final response = await http.get(
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/c'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint(
          'Fetching Items from: ${AppUrl.GetItemMasterList}/$distributorId/1/c');
      debugPrint('Response: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        debugPrint('Decoded Response: $data');

        if (data.isNotEmpty) {
          setState(() {
            _items = data
                .map((json) => CylItemListModel.fromJson(json))
                .toList();
          });

          _selectedItemModel = _items.firstWhere(
                (item) => item.itemName == '14.2 KG',
            orElse: () => _items.first,
          );
          _selectedItem = _selectedItemModel?.itemName ?? 'All Items';
          selectedItemId = _selectedItemModel?.itemId?.toInt();

          await getDashProductSaleComparisonMob(selectedItemId ?? 0);
        } else {
          debugPrint('No items found in the response.');
        }
      } else {
        throw Exception(
            'Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> getDashProductSaleComparisonMob(int itemId) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) throw Exception('Bearer Token Is Missing');

      final response = await http.get(
        Uri.parse(
            '${AppUrl.GetDashProductSaleComparisonMob}/$distributorId/$itemId'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint(
          'item ${AppUrl.GetDashProductSaleComparisonMob}/$distributorId/$itemId');
      debugPrint('item ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          if (data.isNotEmpty) {
            _salesItem = data
                .map((json) =>
                GetDashProductSaleComparisonMob.fromJson(json))
                .toList();
            _selectedSalesItemModel = _salesItem[0];
          } else {
            _salesItem = [];
            _selectedSalesItemModel = null;
          }
        });
      } else {
        throw Exception(
            'Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }
}

// =============================================================================
// SalesData — updated to carry an x-axis label
// =============================================================================
class SalesData {
  SalesData(this.label, this.sales);
  final String label;
  final double sales;
}

// =============================================================================
// _KpiTile — compact KPI summary card above the chart
// =============================================================================
class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.accentColor,
    required this.accentBg,
    required this.icon,
  });

  final String label;
  final String value;
  final String unit;
  final Color accentColor;
  final Color accentBg;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentBg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: accentColor),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.kpiValueMD.copyWith(
              fontSize: 20,
              color: accentColor,
            ),
            textScaler: TextScaler.noScaling,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.labelSM.copyWith(color: accentColor),
            textScaler: TextScaler.noScaling,
          ),
          Text(
            unit,
            style: AppTypography.miniLabel.copyWith(
              color: AppColors.textDisabled,
              fontSize: 10,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _AppBarBadge — frosted-glass pill badge in the gradient AppBar
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
// _LegendItem — color-dot + label row used in the legend card
// =============================================================================
class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.labelSM.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.2,
          ),
          textScaler: TextScaler.noScaling,
        ),
      ],
    );
  }
}