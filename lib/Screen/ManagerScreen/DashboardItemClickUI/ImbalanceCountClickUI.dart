
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/app_url.dart';
import '../../Utils/styles/app_colors.dart';
import '../ClickModelClass/ImbalanceItemWiseCountListModel.dart';
import '../../../newTheam/core/theme/app_typography.dart';

// =============================================================================
// Widget
// =============================================================================

class ImbalanceCountClickUI extends StatefulWidget {
  static const screenName = '/imbalanceCountClickUI';
  const ImbalanceCountClickUI({super.key});

  @override
  State<ImbalanceCountClickUI> createState() => _ImbalanceCountClickUIState();
}

class _ImbalanceCountClickUIState extends State<ImbalanceCountClickUI> {
  // ── State ──────────────────────────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  late List<ImbalanceItemWiseCountListModel> imbalanceList = [];
  List<ImbalanceItemWiseCountListModel> filteredImbalanceList = [];
  bool isLoading = true;
  var argValue;
  int? itemIds;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        itemIds = argValue['ItemId'];
        debugPrint('itemIds :- ${itemIds.toString()}');
        fetchImbalanceListList(itemIds!);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      )
          : Column(
        children: [
          _buildSearchBar(),
          _buildTableHeader(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
// ── AppBar ─────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(82), // increased height
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradPrimary,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),

                /// TITLE SECTION
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // IMPORTANT
                    children: [
                      Flexible(
                        child: Text(
                          'Current Imbalance Stock',
                          style: AppTypography.heroTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textScaler: TextScaler.noScaling,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Flexible(
                        child: Text(
                          'Item-wise staff breakdown',
                          style: AppTypography.heroSubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textScaler: TextScaler.noScaling,
                        ),
                      ),
                    ],
                  ),
                ),

                // const SizedBox(width: 8),
                //
                // /// BADGE
                // Flexible(
                //   child: _AppBarBadge(
                //     icon: Icons.inventory_2_rounded,
                //     label: '${filteredImbalanceList.length} records',
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // ── Search bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: TextField(
        controller: _searchController,
        onChanged: filterSearchResults,
        style: AppTypography.cardSubtitle.copyWith(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Search by staff, item or quantity…',
          hintStyle: AppTypography.cardSubtitle.copyWith(
            color: AppColors.textDisabled,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textMuted,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.textMuted,
              size: 18,
            ),
            onPressed: () {
              _searchController.clear();
              filterSearchResults('');
            },
          )
              : null,
          filled: true,
          fillColor: AppColors.background2,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ── Sticky table header ────────────────────────────────────────────────────
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
          _HeaderCell(label: 'Staff Name', flex: 3),
          _HeaderDivider(),
          _HeaderCell(label: 'Item Name', flex: 2, align: TextAlign.center),
          _HeaderDivider(),
          _HeaderCell(
            label: 'Imbalance Qty.',
            flex: 2,
            align: TextAlign.center,
            // color: AppColors.orange,
          ),
        ],
      ),
    );
  }

  // ── Item list ──────────────────────────────────────────────────────────────
  Widget _buildList() {
    if (filteredImbalanceList.isEmpty) {
      return const _EmptyState(
        icon: Icons.balance_rounded,
        message: 'No imbalance records found\nfor the selected item.',
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: filteredImbalanceList.length,
      itemBuilder: (context, index) {
        final item = filteredImbalanceList[index];
        final qty = item.imbalanceQty ?? 0;
        return _DataRow(
          isEven: index.isEven,
          staffName: item.staffName?.toString() ?? '—',
          itemName: item.itemName?.toString() ?? '—',
          imbalanceQty: qty.toString(),
          isPositive: qty > 0,
        );
      },
    );
  }

  // ── API call (UNCHANGED) ───────────────────────────────────────────────────
  Future<void> fetchImbalanceListList(int itemId) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse(
          '${AppUrl.GetDashboardImbalanceDtlsListMob_V1}/$distributorId/$itemId/0'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint(
        'GetDashboardImbalanceDtlsListMob_V1 ${AppUrl.GetDashboardImbalanceDtlsListMob_V1}/$distributorId');
    debugPrint('GetDashboardImbalanceDtlsListMob_V1 ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      debugPrint('GetDashboardImbalanceDtlsListMob_V1 $data');
      setState(() {
        imbalanceList = data
            .map((json) =>
            ImbalanceItemWiseCountListModel.fromJson(json))
            .toList();
        filteredImbalanceList = List.from(imbalanceList);
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  // ── Filter (UNCHANGED logic) ───────────────────────────────────────────────
  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredImbalanceList = List.from(imbalanceList);
      } else {
        final lowerQuery = query.toLowerCase();
        filteredImbalanceList = imbalanceList.where((item) {
          return (item.staffName?.toLowerCase().contains(lowerQuery) ??
              false) ||
              (item.itemName?.toLowerCase().contains(lowerQuery) ?? false) ||
              (item.imbalanceQty?.toString().contains(lowerQuery) ?? false);
        }).toList();
      }
    });
  }
}

// =============================================================================
// _DataRow — one item row; alternating row tint + color-coded imbalance qty
// =============================================================================
class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.isEven,
    required this.staffName,
    required this.itemName,
    required this.imbalanceQty,
    required this.isPositive,
  });

  final bool isEven;
  final String staffName;
  final String itemName;
  final String imbalanceQty;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isEven ? AppColors.surface : AppColors.surfaceMuted,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Staff name
          Expanded(
            flex: 3,
            child: Row(
              children: [
                // Avatar circle
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryXLight,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Center(
                    child: Text(
                      staffName.isNotEmpty
                          ? staffName[0].toUpperCase()
                          : '?',
                      style: AppTypography.labelMD.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                      textScaler: TextScaler.noScaling,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    staffName,
                    style: AppTypography.cardSubtitle.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ],
            ),
          ),
          _RowDivider(),
          // Item name
          Expanded(
            flex: 2,
            child: Text(
              itemName,
              style: AppTypography.labelMD.copyWith(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textScaler: TextScaler.noScaling,
            ),
          ),
          _RowDivider(),
          // Imbalance qty — color-coded chip
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColors.orangeXLight
                      : AppColors.redXLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  imbalanceQty,
                  style: AppTypography.labelMD.copyWith(
                    fontSize: 12,
                    color: isPositive ? AppColors.orange : AppColors.red,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                  textScaler: TextScaler.noScaling,
                ),
              ),
            ),
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
// _HeaderCell — reusable column header text cell
// =============================================================================
class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.label,
    required this.flex,
    this.align = TextAlign.left,
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