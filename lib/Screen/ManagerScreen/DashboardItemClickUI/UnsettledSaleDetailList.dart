
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';
import '../../Utils/CustomAppBarManager.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../BootomNavigatinBarManager.dart';
import '../ClickModelClass/UnsettledSaleListModel.dart';


// ─────────────────────────────────────────────
// UNSETTLED SALE DETAIL LIST SCREEN
// Refactored to match Niyojan dashboard theme
// ─────────────────────────────────────────────

class UnsettledSaleDetailList extends StatefulWidget {
  static const screenName = '/unsettledSaleDetailList';
  const UnsettledSaleDetailList({super.key});

  @override
  State<UnsettledSaleDetailList> createState() =>
      _UnsettledSaleDetailListState();
}

class _UnsettledSaleDetailListState extends State<UnsettledSaleDetailList> {
  // ── State ──────────────────────────────────────────────────────────────────
  late List<UnsettledSaleListModel> unsettledList = [];
  bool isLoading = true;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    fetchUnsettledList();
  }

  // ── Computed totals ────────────────────────────────────────────────────────
  int get _totalQty =>
      unsettledList.fold(0, (sum, e) => sum + (e.unsettQty ?? 0).toInt());

  double get _totalAmt =>
      unsettledList.fold(0.0, (sum, e) => sum + (e.unsettSaleAmt ?? 0.0));

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg2,
      // appBar: _buildAppBar(),
      // appBar: CustomAppBarManager(title: 'Unsettled Sale Details'),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppGradientHeader(
            title:  'Unsettled Sale Details',
            // subtitle: '${unsettledList.length} record${unsettledList.length == 1 ? '' : 's'}',
            subtitle:
              '${unsettledList.length} record${unsettledList.length == 1 ? '' : 's'}',
            icon: Icons.receipt_long_rounded,
            // onBack: () => Navigator.pushReplacementNamed(context, '/bottomNavBarExample'),
            onBack: () => Navigator.pop(context)
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // _buildHeader(),
            if (!isLoading && unsettledList.isNotEmpty) _buildSummaryCard(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.gradPrimary,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
            onPressed: () => Navigator.pushNamed(
                context, BottomNavBarExample.screenName),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unsettled Sale Details',
                  style: AppTypography.heroSubtitle.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (!isLoading)
                  Text(
                    '${unsettledList.length} record${unsettledList.length == 1 ? '' : 's'}',
                    style: AppTypography.heroSubtitle.copyWith(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          // Alert badge
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.22),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.orange.withOpacity(0.45)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 13, color: AppColors.orangeLight),
                const SizedBox(width: 4),
                Text(
                  'Unsettled',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.orangeLight,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary card ───────────────────────────────────────────────────────────
  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 14, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: AppColors.gradWarn,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _SummaryTile(
            icon: Icons.receipt_long_outlined,
            label: 'Total Records',
            value: unsettledList.length.toString(),
          ),
          _VerticalDividerLine(),
          _SummaryTile(
            icon: Icons.inventory_2_outlined,
            label: 'Total Qty',
            value: _totalQty.toString(),
          ),
          _VerticalDividerLine(),
          _SummaryTile(
            icon: Icons.currency_rupee_rounded,
            label: 'Total Amount',
            value: _totalAmt.toStringAsFixed(2),
          ),
        ],
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

    if (unsettledList.isEmpty) {
      return const _EmptyState();
    }

    return Column(
      children: [
        _buildTableHeader(),
        Expanded(child: _buildTableRows()),
      ],
    );
  }

  // ── Table header ───────────────────────────────────────────────────────────
  Widget _buildTableHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.blueXXL,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: const [
          _HeaderCell(label: 'Staff Name', flex: 3, align: TextAlign.left),
          _HeaderCell(label: 'Item', flex: 2),
          _HeaderCell(label: 'Qty', flex: 1),
          _HeaderCell(label: 'Amount', flex: 2),
        ],
      ),
    );
  }

  // ── Table rows ─────────────────────────────────────────────────────────────
  Widget _buildTableRows() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
        const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: unsettledList.length,
        separatorBuilder: (_, __) =>
        const Divider(height: 1, color: AppColors.divider),
        itemBuilder: (context, index) {
          final item = unsettledList[index];
          final isEven = index.isEven;
          return Container(
            color: isEven ? AppColors.white : AppColors.bg2,
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Staff name with subtle avatar
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      _StaffAvatar(name: item.staffName?.toString() ?? ''),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.staffName?.toString() ?? '-',
                          style: AppTypography.dataRowLabel
                              .copyWith(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Item name
                Expanded(
                  flex: 2,
                  child: Text(
                    item.itemName?.toString() ?? '-',
                    style: AppTypography.cardSubtitle
                        .copyWith(fontSize: 12),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Qty badge
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.blueXL,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.unsettQty?.toString() ?? '0',
                        style: AppTypography.badgeText.copyWith(
                          color: AppColors.blueLight,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // Amount
                Expanded(
                  flex: 2,
                  child: Text(
                    item.unsettSaleAmt != null
                        ? '₹${item.unsettSaleAmt!.toStringAsFixed(2)}'
                        : '₹0.00',
                    style: AppTypography.dataRowValue.copyWith(
                      fontSize: 12,
                      color: AppColors.orange,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── API (unchanged) ────────────────────────────────────────────────────────
  Future<void> fetchUnsettledList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse(
          '${AppUrl.GetDashboardUnsettledAmtListMob_V1}/$distributorId'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint('GetDashboardUnsettledAmtListMob_V1 '
        '${AppUrl.GetDashboardUnsettledAmtListMob_V1}/$distributorId');
    debugPrint('GetDashboardUnsettledAmtListMob_V1 ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        unsettledList = data
            .map((json) => UnsettledSaleListModel.fromJson(json))
            .where((item) => item.unsettQty != null && item.unsettQty! > 0)
            .toList();
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE REUSABLE SUB-WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

/// KPI tile inside the gradient summary card.
class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.kpiValueLG.copyWith(
              color: Colors.white,
              fontSize: 14,
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
      ),
    );
  }
}

/// Thin white vertical divider used inside the summary card.
class _VerticalDividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withOpacity(0.25),
      margin: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}

/// Styled table header cell.
class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.label,
    required this.flex,
    this.align = TextAlign.center,
  });

  final String label;
  final int flex;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: AppTypography.sectionHeader.copyWith(color: AppColors.blue),
        textAlign: align,
      ),
    );
  }
}

/// Initials-based avatar for staff name column.
class _StaffAvatar extends StatelessWidget {
  const _StaffAvatar({required this.name});

  final String name;

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || name.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Deterministic color from name so each staff always gets the same hue.
  Color get _color {
    const colors = [
      AppColors.blueLight,
      AppColors.teal,
      AppColors.orange,
      AppColors.green,
      AppColors.amber,
    ];
    return colors[name.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: _color,
        ),
      ),
    );
  }
}

/// Empty-state placeholder.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.orangeXL,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.check_circle_outline_rounded,
                size: 34, color: AppColors.orange),
          ),
          const SizedBox(height: 14),
          Text(
            'All Settled!',
            style: AppTypography.cardTitle
                .copyWith(color: AppColors.textMid, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'No unsettled sale records found.',
            style: AppTypography.cardSubtitle
                .copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}