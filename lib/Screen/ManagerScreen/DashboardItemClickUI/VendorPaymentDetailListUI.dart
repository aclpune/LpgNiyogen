import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../newTheam/core/theme/app_typography.dart';
import '../../../newTheam/features/dashboard/widgets/section_header.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/styles/app_colors.dart';
import '../ClickModelClass/GetVendorDetailListModel.dart';
import '../UpdatePaymentsScreen/GetVendorMasterListModel.dart';



// =============================================================================
// VendorPaymentDetailListUI
// Refactored to match dashboard design system:
//   • Hero gradient AppBar with KPI summary
//   • Themed vendor filter dropdown
//   • Dashboard-style payment cards with left-border severity accent
//   • Reuses AppColors, AppTypography, AppSpacing, SectionHeader
// =============================================================================

class VendorPaymentDetailListUI extends StatefulWidget {
  static const screenName = '/vendorPaymentDetailListUI';
  const VendorPaymentDetailListUI({super.key});

  @override
  State<VendorPaymentDetailListUI> createState() =>
      _VendorPaymentDetailListUIState();
}

class _VendorPaymentDetailListUIState
    extends State<VendorPaymentDetailListUI> {
  // ── State ──────────────────────────────────────────────────────────────────
  List<GetVendorMasterListModel> vendorModel = [];
  final GetVendorMasterListModel _allItem =
  GetVendorMasterListModel(vendorId: 0, vendorName: "ALL");
  GetVendorMasterListModel? _selectVendor;
  String? _selectedVendor;
  int? vendorId;
  List<GetVendorDetailListModel> getVendorDetailListModel = [];
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  bool isLoading = true;
  double totalPendingAmount = 0;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _selectVendor = _allItem;
    fetchVendorDetailList(0);
    getVendorMasterList();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background2,
        appBar: _buildAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVendorFilterBar(),
            SectionHeader(
              title: 'Due Payments',
              dotColor: AppColors.orange,
              seeAllLabel: null,
            ),
            Expanded(child: _buildBody()),
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
            padding:
            const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                // Title + subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vendor Due Payment',
                        style: AppTypography.heroTitle,
                        textScaler: TextScaler.noScaling,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Total Pending: ₹${formatCurrency(totalPendingAmount)}',
                        style: AppTypography.heroSubtitle,
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ),
                // KPI badge
                _PendingAmountBadge(amount: totalPendingAmount),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Vendor Filter ──────────────────────────────────────────────────────────
  Widget _buildVendorFilterBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Icon + label
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.storefront_rounded,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          const Text(
            'Vendor',
            style: AppTypography.labelMD,
          ),
          const SizedBox(width: 12),
          // Dropdown
          Expanded(
            child: _ThemedVendorDropdown(
              allItem: _allItem,
              vendorModel: vendorModel,
              selectedVendor: _selectVendor,
              onChanged: (GetVendorMasterListModel? selectedItem) {
                if (selectedItem != null) {
                  setState(() {
                    _selectVendor = selectedItem;
                    if (selectedItem.vendorId == 0) {
                      _selectedVendor = 'ALL';
                      vendorId = 0;
                    } else {
                      _selectedVendor = selectedItem.vendorName ?? '';
                      vendorId = selectedItem.vendorId?.toInt();
                    }
                    fetchVendorDetailList(vendorId!);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2.5,
        ),
      );
    }

    if (getVendorDetailListModel.isEmpty) {
      return _EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: getVendorDetailListModel.length,
      itemBuilder: (context, index) {
        final vendor = getVendorDetailListModel[index];
        return _VendorPaymentCard(
          vendor: vendor,
          animationDelay: Duration(milliseconds: 60 * index),
          formatCurrency: formatCurrency,
        );
      },
    );
  }

  // ── Currency formatter (unchanged) ────────────────────────────────────────
  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0$formattedAmount';
    }
    return formattedAmount;
  }

  // ── API: Vendor master list (unchanged) ────────────────────────────────────
  Future<void> getVendorMasterList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse('${AppUrl.GetVendorMasterList}/$distributorId/1'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint("GetVendorMasterList : ${AppUrl.GetVendorMasterList}/$distributorId/1");
    debugPrint("GetVendorMasterList : ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        vendorModel = data
            .map((json) => GetVendorMasterListModel.fromJson(json))
            .toList();
        vendorModel.sort((a, b) {
          final nameA = a.vendorName?.toLowerCase() ?? '';
          final nameB = b.vendorName?.toLowerCase() ?? '';
          return nameA.compareTo(nameB);
        });
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  // ── API: Vendor due payment list (unchanged) ───────────────────────────────
  Future<void> fetchVendorDetailList(int id) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    try {
      final response = await http.get(
        Uri.parse('${AppUrl.GetVendorDuePaymentList}/$distributorId/$id'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint("GetVendorDuePaymentList request: ${AppUrl.GetVendorDuePaymentList}/$distributorId/$id");
      debugPrint("GetVendorDuePaymentList response: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          getVendorDetailListModel = data
              .map((json) => GetVendorDetailListModel.fromJson(json))
              .toList();
          totalPendingAmount = getVendorDetailListModel.fold(
              0.0, (sum, item) => sum + (item.pendingAmount ?? 0.0));
          print("Total Pending Amount: $totalPendingAmount");
          isLoading = false;
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        throw Exception('Failed to load items');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint("Exception $e");
    }
  }
}

// =============================================================================
// _ThemedVendorDropdown
// Dashboard-styled dropdown for vendor selection
// =============================================================================
class _ThemedVendorDropdown extends StatelessWidget {
  const _ThemedVendorDropdown({
    required this.allItem,
    required this.vendorModel,
    required this.selectedVendor,
    required this.onChanged,
  });

  final GetVendorMasterListModel allItem;
  final List<GetVendorMasterListModel> vendorModel;
  final GetVendorMasterListModel? selectedVendor;
  final ValueChanged<GetVendorMasterListModel?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<GetVendorMasterListModel>(
      isExpanded: true,
      value: selectedVendor,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.primaryXLight,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryXXLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryXXLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.primary, size: 22),
      items: [
        DropdownMenuItem<GetVendorMasterListModel>(
          value: allItem,
          child: Text(
            'ALL',
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary),
            textScaler: TextScaler.noScaling,
          ),
        ),
        ...vendorModel.map((item) => DropdownMenuItem<GetVendorMasterListModel>(
          value: item,
          child: Text(
            item.vendorName ?? '',
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.normal),
            textScaler: TextScaler.noScaling,
          ),
        )),
      ],
      onChanged: onChanged,
      hint: Text('ALL',
          style: AppTypography.cardSubtitle, textScaler: TextScaler.noScaling),
    );
  }
}

// =============================================================================
// _VendorPaymentCard
// Dashboard-style card with orange left border accent, staggered animation
// =============================================================================
class _VendorPaymentCard extends StatefulWidget {
  const _VendorPaymentCard({
    required this.vendor,
    required this.animationDelay,
    required this.formatCurrency,
  });

  final GetVendorDetailListModel vendor;
  final Duration animationDelay;
  final String Function(double) formatCurrency;

  @override
  State<_VendorPaymentCard> createState() => _VendorPaymentCardState();
}

class _VendorPaymentCardState extends State<_VendorPaymentCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(
        begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(widget.animationDelay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: _buildCard()),
    );
  }

  Widget _buildCard() {
    final vendor = widget.vendor;
    final pendingAmt = vendor.pendingAmount?.toDouble() ?? 0;
    final purchaseAmt = vendor.purchaseAmount?.toDouble() ?? 0;

    // Determine accent color based on pending amount ratio
    final ratio = purchaseAmt > 0 ? pendingAmt / purchaseAmt : 0.0;
    final accentColor = ratio > 0.5
        ? AppColors.red
        : ratio > 0.2
        ? AppColors.orange
        : AppColors.green;
    final accentBg = ratio > 0.5
        ? AppColors.redXLight
        : ratio > 0.2
        ? AppColors.orangeXLight
        : AppColors.greenXLight;

    String formattedDate = '';
    try {
      formattedDate = DateFormat('dd MMM yyyy')
          .format(DateTime.parse(vendor.invoiceDate.toString()));
    } catch (_) {
      formattedDate = vendor.invoiceDate?.toString() ?? '';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: accentColor, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowCard,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row: vendor name + date badge ────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vendor icon
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: accentBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.storefront_rounded,
                        color: accentColor, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vendor.vendorName ?? '—',
                          style: AppTypography.cardTitle,
                          textScaler: TextScaler.noScaling,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 11, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(formattedDate,
                                style: AppTypography.labelMD,
                                textScaler: TextScaler.noScaling),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Pending badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ratio > 0.5
                          ? 'High Due'
                          : ratio > 0.2
                          ? 'Partial'
                          : 'Low Due',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                        letterSpacing: 0.2,
                      ),
                      textScaler: TextScaler.noScaling,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // ── Divider ─────────────────────────────────────────
              Container(
                height: 1,
                color: AppColors.divider,
              ),
              const SizedBox(height: 12),
              // ── Amount rows ──────────────────────────────────────
              _AmountRow(
                label: 'Purchase Amount',
                value: '₹${widget.formatCurrency(purchaseAmt)}',
                valueColor: AppColors.textPrimary,
              ),
              const SizedBox(height: 6),
              _AmountRow(
                label: 'Pending Amount',
                value: '₹${widget.formatCurrency(pendingAmt)}',
                valueColor: accentColor,
                isHighlight: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _AmountRow — reusable label/value row for the card
// =============================================================================
class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    required this.valueColor,
    this.isHighlight = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.dataRowLabel,
          textScaler: TextScaler.noScaling,
        ),
        Text(
          value,
          style: isHighlight
              ? AppTypography.alertValue.copyWith(color: valueColor)
              : AppTypography.dataRowValue.copyWith(
              color: valueColor, fontSize: 14),
          textScaler: TextScaler.noScaling,
        ),
      ],
    );
  }
}

// =============================================================================
// _PendingAmountBadge — hero KPI badge in the AppBar
// =============================================================================
class _PendingAmountBadge extends StatelessWidget {
  const _PendingAmountBadge({required this.amount});
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.30), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.account_balance_wallet_rounded,
              color: Colors.white70, size: 14),
          const SizedBox(width: 5),
          Text(
            '₹${_shortAmount(amount)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }

  String _shortAmount(double v) {
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }
}

// =============================================================================
// _EmptyState — shown when no records found
// =============================================================================
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              child: const Icon(Icons.search_off_rounded,
                  size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Records Found',
              style: AppTypography.cardTitle,
              textScaler: TextScaler.noScaling,
            ),
            const SizedBox(height: 6),
            const Text(
              'No due payments found for the selected vendor.',
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