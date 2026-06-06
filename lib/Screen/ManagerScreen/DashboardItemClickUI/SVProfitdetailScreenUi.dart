
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/SVProfitDetailDataGetModel.dart';

class SVProfitDetailScreenUI extends StatefulWidget {
  static const screenName = '/sVProfitDetailScreenUI';
  const SVProfitDetailScreenUI({super.key});

  @override
  State<SVProfitDetailScreenUI> createState() => _SVProfitDetailScreenUIState();
}


class _SVProfitDetailScreenUIState extends State<SVProfitDetailScreenUI> {
  late List<SvProfitDetailDataGetModel> svProfitDetailDataGetModel = [];
  bool isLoading = true;
  String? flags;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final argValue = ModalRoute.of(context)?.settings.arguments as Map?;
      final String dayFlags = argValue?['DAYFLAG'] ?? '';
      flags = dayFlags;
      fetchSVDetailList(dayFlags);
    });
  }

  String get _periodLabel {
    switch (flags) {
      case 'TODAYS':     return "Today's";
      case 'THISMONTH':  return 'This Month';
      case 'FINYEAR':    return 'Financial Year';
      default:           return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final argLRAdd = ModalRoute.of(context)?.settings.arguments;

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
            title: 'SV Detail',
            subtitle: _periodLabel,
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
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

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
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SV Detail',
                  style: AppTypography.heroSubtitle.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (_periodLabel.isNotEmpty)
                  Text(
                    _periodLabel,
                    style: AppTypography.heroSubtitle.copyWith(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          // Period badge
          if (_periodLabel.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.white.withOpacity(0.30)),
              ),
              child: Text(
                _periodLabel,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.blueLight),
      );
    }

    if (svProfitDetailDataGetModel.isEmpty) {
      return _EmptyState(message: 'No records found for $_periodLabel');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      itemCount: svProfitDetailDataGetModel.length,
      itemBuilder: (context, index) {
        final sv = svProfitDetailDataGetModel[index];
        return _SVDetailCard(sv: sv, index: index);
      },
    );
  }

  Future<void> fetchSVDetailList(String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    try {
      final response = await http.get(
        Uri.parse(
            '${AppUrl.GetDashboardSVProfitDtls_Mob}/$distributorId/$flag'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint('GetDashboardSVProfitDtls_Mob request '
          '${AppUrl.GetDashboardSVProfitDtls_Mob}/$distributorId/$flag');
      debugPrint('GetDashboardSVProfitDtls_Mob response ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          svProfitDetailDataGetModel =
              data.map((j) => SvProfitDetailDataGetModel.fromJson(j)).toList();
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


class _SVDetailCard extends StatelessWidget {
  const _SVDetailCard({required this.sv, required this.index});

  final SvProfitDetailDataGetModel sv;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Item name row with index badge ────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Index badge
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    sv.itemName.toString(),
                    style: AppTypography.cardTitle.copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 12),

            // ── Metrics row ───────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _MetricChip(
                    icon: Icons.inventory_2_outlined,
                    label: 'Quantity',
                    value: sv.itemQty.toString(),
                    color: AppColors.blueLight,
                    bgColor: AppColors.blueXL,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricChip(
                    icon: Icons.currency_rupee_rounded,
                    label: 'Profit Amt.',
                    value: sv.profitAmt!.toStringAsFixed(2),
                    color: AppColors.teal,
                    bgColor: AppColors.tealXL,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTypography.miniLabel
                        .copyWith(color: AppColors.textMuted, fontSize: 10)),
                const SizedBox(height: 2),
                Text(value,
                    style: AppTypography.kpiValueLG.copyWith(
                        fontSize: 14, color: color, letterSpacing: -0.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


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
          Text(message,
              style: AppTypography.cardSubtitle
                  .copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}