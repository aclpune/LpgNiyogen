
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DashboardItemClickUI/DashboardPrepaidDetailUI.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../newTheam/core/theme/app_typography.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/styles/app_colors.dart';
import '../ClickModelClass/GetDashboardNiyojanPunchCtnLstModel.dart';
import '../ClickModelClass/GetDashboardSettlementCtnListModel.dart';
import 'DashboardPunchDetailUI.dart';


// =============================================================================
// Widget
// =============================================================================

class DashboardPrepaidDetails extends StatefulWidget {
  static const screenName = '/dashboardPrepaidDetails';

  @override
  State<StatefulWidget> createState() => _DashboardPrepaidDetailsState();
}

class _DashboardPrepaidDetailsState extends State<DashboardPrepaidDetails> {
  // ── State ──────────────────────────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  late List<GetDashboardSettlementCtnListModel> prepaidModel = [];
  late List<GetDashboardNiyojanPunchCtnLstModel> punchModel = [];
  List<GetDashboardSettlementCtnListModel> filteredPrepaidModel = [];
  List<GetDashboardNiyojanPunchCtnLstModel> filteredPunchModel = [];
  bool isLoading = true;
  String todayDate = DateTime.now().toString();
  var argValue;
  String? flag;

  // ── Derived helpers ────────────────────────────────────────────────────────
  static const _prepaidFlags = {
    'Delivered', 'Settled', 'TotalOutstanding',
    'cDCMS', 'DelDonNiyoJanPunPend', 'OldBkgPendNewBkgRecv',
  };
  static const _punchFlags = {'Punching', 'Incorrect', 'NiyoJanPunDelPend'};

  bool get _isPrepaidFlag => _prepaidFlags.contains(flag);
  bool get _isPunchFlag => _punchFlags.contains(flag);

  int get _listCount =>
      _isPrepaidFlag ? prepaidModel.length : punchModel.length;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    filteredPrepaidModel = prepaidModel;
    filteredPunchModel = punchModel;

    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        flag = argValue['flag'];
        debugPrint('flag :- ${flag.toString()}');
        fetchSettled(flag!);
        fetchPunch(flag!);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Search filter (UNCHANGED logic) ───────────────────────────────────────
  void filterSearchResults(String query) {
    setState(() {
      final lowerQuery = query.toLowerCase();

      filteredPrepaidModel = prepaidModel.where((item) {
        return (item.consumerNo?.toLowerCase().contains(lowerQuery) ?? false) ||
            (item.consumerName?.toLowerCase().contains(lowerQuery) ?? false) ||
            (item.orderDate?.toLowerCase().contains(lowerQuery) ?? false) ||
            (item.deliveryDate?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();

      filteredPunchModel = punchModel.where((item) {
        return (item.staffName?.toLowerCase().contains(lowerQuery) ?? false) ||
            (item.niyojanPunQty?.toString().toLowerCase().contains(lowerQuery) ??
                false) ||
            (item.settlementQty?.toString().toLowerCase().contains(lowerQuery) ??
                false);
      }).toList();
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      // appBar: _buildAppBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppGradientHeader(
          title: 'Prepaid Details',
          subtitle: 'Count: ${_listCount}',
          icon: Icons.receipt_long_rounded,
          // onBack: () => Navigator.pushReplacementNamed(context, '/bottomNavBarExample'),
          onBack: () => Navigator.pop(context)
        ),
      ),
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
                        _getDisplayText(flag ?? ''),
                        style: AppTypography.heroTitle.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.noScaling,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Prepaid Details',
                        style: AppTypography.heroSubtitle,
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ),

                // Count badge
                _CountBadge(count: _listCount),
                const SizedBox(width: 8),
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
          hintText: 'Search by name, date, consumer…',
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
            icon: const Icon(Icons.close_rounded,
                color: AppColors.textMuted, size: 18),
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
        children: _isPrepaidFlag
            ? _prepaidHeaders()
            : _isPunchFlag
            ? _punchHeaders()
            : [],
      ),
    );
  }

  List<Widget> _prepaidHeaders() => [
    _HeaderCell(label: 'Consumer No.', flex: 2),
    _HeaderDivider(),
    _HeaderCell(label: 'Name', flex: 3),
    _HeaderDivider(),
    _HeaderCell(label: 'Order Date', flex: 2, align: TextAlign.center),
    _HeaderDivider(),
    _HeaderCell(label: 'Delivery Date', flex: 2, align: TextAlign.center),
    _HeaderDivider(),
    _HeaderCell(label: 'Settl. Date', flex: 2, align: TextAlign.center),
  ];

  List<Widget> _punchHeaders() => [
    _HeaderCell(label: 'Date', flex: 2, align: TextAlign.center),
    _HeaderDivider(),
    _HeaderCell(label: 'Staff Name', flex: 4),
    _HeaderDivider(),
    _HeaderCell(label: 'Niyojan Qty', flex: 2, align: TextAlign.center),
    _HeaderDivider(),
    _HeaderCell(label: 'Settl Qty', flex: 2, align: TextAlign.center),
    _HeaderDivider(),
    _HeaderCell(label: 'Pen Qty', flex: 2, align: TextAlign.center),
  ];

  // ── Item list ──────────────────────────────────────────────────────────────
  Widget _buildList() {
    if (_isPrepaidFlag) {
      if (filteredPrepaidModel.isEmpty) {
        return _EmptyState(
          icon: Icons.receipt_long_rounded,
          message: 'No prepaid records found\nfor the selected filter.',
        );
      }
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: filteredPrepaidModel.length,
        itemBuilder: (context, index) => DashboardPrepaidDetailUI(
          filteredPrepaidModel[index],
          index + 1,
        ),
      );
    }

    if (_isPunchFlag) {
      if (filteredPunchModel.isEmpty) {
        return _EmptyState(
          icon: Icons.punch_clock_rounded,
          message: 'No punch records found\nfor the selected filter.',
        );
      }
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: filteredPunchModel.length,
        itemBuilder: (context, index) =>
            DashbobardPunchDetailUI(filteredPunchModel[index]),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  // ── API calls (UNCHANGED) ──────────────────────────────────────────────────
  Future<void> fetchPunch(String flags) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse(
          '${AppUrl.GetDashboardNiyojanPunchCtnLstForMob}/$distributorId/$flags'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint(
        'GetDashboardNiyojanPunchCtnLstForMob ${AppUrl.GetDashboardNiyojanPunchCtnLstForMob}/$distributorId/$flags');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        punchModel = data.map((json) {
          if (json['TodayDate'] != null) {
            try {
              DateTime date = DateTime.parse(json['TodayDate']);
              json['TodayDate'] = DateFormat('yyyy-MM-dd').format(date);
            } catch (e) {
              debugPrint(
                  'Date parsing failed for: ${json['TodayDate']}, error: $e');
              json['TodayDate'] = '';
            }
          } else {
            json['TodayDate'] = '';
          }
          return GetDashboardNiyojanPunchCtnLstModel.fromJson(json);
        }).toList();
        filteredPunchModel = List.from(punchModel);
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> fetchSettled(String flags) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse(
          '${AppUrl.GetDashboardSettlementCtnList}/$distributorId/$flags'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint(
        'GetDashboardSettlementCtnList ${AppUrl.GetDashboardSettlementCtnList}/$distributorId/$flags');
    debugPrint('GetDashboardSettlementCtnList ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      debugPrint('GetDashboardSettlementCtnList $data');
      setState(() {
        prepaidModel = data
            .map((json) =>
            GetDashboardSettlementCtnListModel.fromJson(json))
            .toList();
        filteredPrepaidModel = List.from(prepaidModel);
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  // ── Display text (UNCHANGED) ───────────────────────────────────────────────
  String _getDisplayText(String flag) {
    switch (flag) {
      case 'Delivered':
        return 'Delivered, payment pending';
      case 'Settled':
        return 'Payment done, delivery pending';
      case 'cDCMS':
        return 'Pending in cDCMS';
      case 'DelDonNiyoJanPunPend':
        return 'Punched in cDCMS, pending in Niyojan';
      case 'OldBkgPendNewBkgRecv':
        return 'Old punching pending but....';
      case 'Punching':
        return "Today's Niyojan Punched";
      case 'Incorrect':
        return "Today's Incorrect";
      case 'NiyoJanPunDelPend':
        return 'Punched in Niyojan, pending in cDCMS';
      case 'TotalOutstanding':
        return 'Total Outstanding Pending';
      default:
        return 'Prepaid Details';
    }
  }
}

// =============================================================================
// _CountBadge — frosted-glass pill in the AppBar showing list count
// =============================================================================
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.30), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.format_list_numbered_rounded,
              color: Colors.white70, size: 12),
          const SizedBox(width: 4),
          Text(
            '$count records',
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
// _HeaderDivider — thin vertical separator in the sticky header
// =============================================================================
class _HeaderDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 16,
    color: AppColors.border,
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