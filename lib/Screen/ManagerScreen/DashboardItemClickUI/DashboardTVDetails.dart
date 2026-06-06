import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../newTheam/core/theme/app_typography.dart';
import '../../ConstantScreen/widgets.dart';
import '../../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import '../ClickModelClass/GetDashboardTVStockPendCtnListForMob.dart';
import 'DashboardTVDetailUI.dart';

class DashboardTVDetails extends StatefulWidget {
  static const screenName = '/dashboardTVDetails';

  @override
  State<StatefulWidget> createState() => _DashboardTVDetails();
}

class _DashboardTVDetails extends State<DashboardTVDetails> {
  List<GetDashboardTvStockPendCtnListForMob> tvmodel = [];
  bool isLoading = true;
  var argValue;
  int? flag;
  List<CylItemListModel> _items = [];
  CylItemListModel? _selectedItemModel;
  String? _selectedItem;
  int? selectedItemId;
  final CylItemListModel allItem = CylItemListModel(itemId: -1, itemName: 'ALL');

  // ── Computed summaries ─────────────────────────────────
  num get _totalCylQty =>
      tvmodel.fold<num>(0, (sum, item) => sum + (item.clyReceivedQty ?? 0));
  double get _totalAmount =>
      tvmodel.fold<double>(0.0, (sum, item) => sum + (item.paidAmt ?? 0.0));
  int get _regReceivedCount =>
      tvmodel.where((item) => item.isRegulator == 'Yes').length;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        flag = argValue['flag'];
        fetchTV(flag!);
      });
    });
    fetchItems();
    _selectedItemModel = allItem;
  }

  // ── API calls (unchanged) ───────────────────────────────
  Future<void> fetchTV(int flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse(
          '${AppUrl.GetDashboardTVStockPendCtnListForMob}/$distributorId/$flag'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint('GetDashboardTVStockPendCtnListForMob : '
        '${AppUrl.GetDashboardTVStockPendCtnListForMob}/$distributorId/$flag');
    debugPrint(
        'GetDashboardTVStockPendCtnListForMobresponse : ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        tvmodel = data
            .map((json) => GetDashboardTvStockPendCtnListForMob.fromJson(json))
            .toList();
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> fetchItems() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer Token Is Missing');

    final response = await http.get(
      Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/c'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint('item${AppUrl.GetItemMasterList}/$distributorId/1/c');
    debugPrint('item${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
      });
    } else {
      throw Exception('Unable To Load Data At This Time. Please Try Again');
    }
  }

  // ── Item filter handler ────────────────────────────────
  void _onItemChanged(CylItemListModel? selectedItem) {
    if (selectedItem == null) return;
    setState(() {
      _selectedItemModel = selectedItem;
      if (selectedItem.itemId == -1) {
        _selectedItem = 'ALL';
        selectedItemId = -1;
        fetchTV(flag!);
      } else {
        _selectedItem = selectedItem.itemName!;
        selectedItemId = selectedItem.itemId?.toInt();
        fetchTV(selectedItemId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      // appBar: _buildAppBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppGradientHeader(
          title: 'TV Stock Movement',
          subtitle: 'Count: ${tvmodel.length}',
          icon: Icons.receipt_long_rounded,
          // onBack: () => Navigator.pushReplacementNamed(context, '/bottomNavBarExample'),
          onBack: () => Navigator.pop(context)
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : Column(
        children: [
          _FilterBar(),
          _buildList(),
          _SummaryFooter(
            totalCylQty: _totalCylQty,
            regReceivedCount: _regReceivedCount,
            totalAmount: _totalAmount,
            hasData: tvmodel.isNotEmpty,
          ),
        ],
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primary,
      surfaceTintColor: AppColors.primary,
      elevation: 0,
      flexibleSpace: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: AppSpacing.xs),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TV Stock Movement',
                    style: AppTypography.heroTitle.copyWith(fontSize: 16),
                  ),
                  Text(
                    'Count: ${tvmodel.length}',
                    style: AppTypography.heroSubtitle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Filter bar ─────────────────────────────────────────
  Widget _FilterBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Text('Item:', style: AppTypography.labelMD),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: DropdownButtonFormField<CylItemListModel>(
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 2,
                ),
                filled: true,
                fillColor: AppColors.primaryXLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: AppColors.primaryXXLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: AppColors.primaryXXLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
              ),
              value: _selectedItemModel,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary),
              items: [
                DropdownMenuItem<CylItemListModel>(
                  value: allItem,
                  child: const Text('ALL'),
                ),
                ..._items.map((item) => DropdownMenuItem<CylItemListModel>(
                  value: item,
                  child: Text(item.itemName ?? 'Unknown'),
                )),
              ],
              onChanged: _onItemChanged,
              hint: const Text('ALL'),
            ),
          ),
        ],
      ),
    );
  }

  // ── List body ──────────────────────────────────────────
  Widget _buildList() {
    if (tvmodel.isEmpty) {
      return Expanded(child: _EmptyState());
    }
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        physics: const BouncingScrollPhysics(),
        itemCount: tvmodel.length,
        itemBuilder: (context, index) {
          debugPrint('Rendering TV Item: ${tvmodel[index]}');
          return DashboardTVDetailUI(tvmodel[index]);
        },
      ),
    );
  }
}

// ── Empty state widget ─────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
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
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.inbox_rounded,
                size: 32, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('No Records Found', style: AppTypography.cardTitle),
          const SizedBox(height: AppSpacing.xs),
          Text('No TV stock entries available.',
              style: AppTypography.cardSubtitle),
        ],
      ),
    );
  }
}

// ── Summary footer ─────────────────────────────────────────────────────────────
class _SummaryFooter extends StatelessWidget {
  const _SummaryFooter({
    required this.totalCylQty,
    required this.regReceivedCount,
    required this.totalAmount,
    required this.hasData,
  });

  final num totalCylQty;
  final int regReceivedCount;
  final double totalAmount;
  final bool hasData;

  @override
  Widget build(BuildContext context) {
    final formattedAmount =
    hasData ? formatCurrency(totalAmount) : '0.00';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryChip(
              icon: Icons.propane_tank_outlined,
              label: 'Qty',
              value: '${hasData ? totalCylQty : 0}',
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _SummaryChip(
              icon: Icons.settings_outlined,
              label: 'Reg Rec',
              value: '${hasData ? regReceivedCount : 0}',
              color: AppColors.teal,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _SummaryChip(
              icon: Icons.currency_rupee_rounded,
              label: 'Amount',
              value: formattedAmount,
              color: AppColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.labelSM.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.dataRowValue.copyWith(
              fontSize: 14,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final format = NumberFormat('#,##,###.00', 'en_IN');
  String formattedAmount = format.format(amount);
  if (amount < 1 && formattedAmount.startsWith('.')) {
    formattedAmount = '0' + formattedAmount;
  }
  return formattedAmount;
}