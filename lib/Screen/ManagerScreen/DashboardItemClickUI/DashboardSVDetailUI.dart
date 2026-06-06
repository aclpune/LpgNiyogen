// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../ConstantScreen/widgets.dart';
// import '../ClickModelClass/GetDashboardSVStockPendCtnListForMobListModel.dart';
// import 'DashboardSVDetails.dart';
//
// class DashboardSVDetailUI extends StatefulWidget {
//   GetDashboardSvStockPendCtnListForMobListModel svmodel;
//
//   DashboardSVDetailUI( this.svmodel,{super.key});
//
//   @override
//   State<StatefulWidget> createState() {
//     return _DashboardSVDetailUI();
//   }
// }
//
//
// class _DashboardSVDetailUI extends State<DashboardSVDetailUI> {
//   @override
//   Widget build(BuildContext context) {
//     var sale = widget.svmodel;
//
//     String nullToDash(String? value) {
//       if (value == null || value.toLowerCase() == "null") {
//         return "-";  // If value is null or the string "null", replace with '-'
//       }
//       return value;  // If not null or "null", return the original value
//     }
//     return
//       Column(
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(flex:0,child: countTextWidgetTextWithoutHeading(context,DateFormat('dd-MM-yyyy').format(DateTime.parse(sale.sVDate ?? '')))),
//               Expanded(flex:0,child: countTextWidgetTextWithoutHeading(context, nullToDash(sale.itemName))),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Cons./Challan", nullToDash(sale.consuDCNo))),
//               Expanded(flex:1,child: countTextWidgetText(context,"Cyl. Qty", nullToDash(sale.cylQty.toString()))),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context, "Doc. Status", nullToDash(sale.isUndocument == true ? "Pending" : (sale.isUndocument == false ? "Received" : ""))),),
//               Expanded(flex:1,child: countTextWidgetText(context,"SV Type", sale.sVType ?? '')),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Amount", nullToDash(formatCurrency((sale.totalAmount ?? 0.0).toDouble())))),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Stock Status", nullToDash(sale.stockStatus))),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Delivery Date", '')),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Consumer No.", sale.consumerNo ?? '-')),
//
//
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Con Name", nullToDash(sale.consumerName))),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Ref. By", sale.referredBy ?? '')),
//             ],
//           ),
//
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Delivery Men", '')),
//             ],
//           ),
//
//           Divider(),
//         ],
//       );
//   }
// }
// //
//


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Utils/BoxShadow/app_typography.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import '../ClickModelClass/GetDashboardSVStockPendCtnListForMobListModel.dart';
import 'DashboardSVDetails.dart';

// =============================================================================
// DashboardSVDetailUI
// Dashboard-style card for a single SV Stock Movement record.
//
//   • Left-border accent (cycles through palette, matching AlertActionCard pattern)
//   • Header: icon badge + item name + date + doc-status pill
//   • Two-column info chip grid: Cons./Challan, Cyl. Qty, SV Type, Amount
//   • Full-width info rows: Stock Status, Consumer No., Consumer Name,
//                           Referred By, Delivery Date, Delivery Men
//   • Staggered slide+fade animation (identical contract to AlertActionCard)
//
// Design tokens used: AppColors · AppSpacing · AppTypography
// =============================================================================

class DashboardSVDetailUI extends StatefulWidget {
  /// The SV record to render.
  final GetDashboardSvStockPendCtnListForMobListModel svmodel;

  /// Position in the parent list — drives stagger delay and accent colour.
  final int index;

  const DashboardSVDetailUI(this.svmodel, {super.key, this.index = 0});

  @override
  State<DashboardSVDetailUI> createState() => _DashboardSVDetailUIState();
}

class _DashboardSVDetailUIState extends State<DashboardSVDetailUI>
    with SingleTickerProviderStateMixin {

  // ── Animation — identical contract to AlertActionCard ─────────────────────
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0, 0.14), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(
      Duration(milliseconds: 55 * widget.index),
          () { if (mounted) _ctrl.forward(); },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  /// Converts null / empty / the string "null" → em-dash placeholder.
  static String _dash(String? v) =>
      (v == null || v.toLowerCase() == 'null' || v.trim().isEmpty) ? '—' : v;

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: _buildCard()),
    );
  }

  Widget _buildCard() {
    final sale = widget.svmodel;

    // Accent colour cycles through the dashboard palette —
    // same 5-step set used across the app's colour indicators.
    const List<Color> _accentColors = [
      AppColors.primary,
      AppColors.teal,
      AppColors.orange,
      AppColors.red,
      Color(0xFF6E69E2), // violet
    ];
    const List<Color> _accentBgColors = [
      AppColors.primaryXLight,
      AppColors.tealXLight,
      AppColors.orangeXLight,
      AppColors.redXLight,
      Color(0xFFF0EFFF), // violet tint
    ];
    final accent   = _accentColors[widget.index % _accentColors.length];
    final accentBg = _accentBgColors[widget.index % _accentBgColors.length];

    // Doc status — drives pill color using semantic tokens
    final isPending  = sale.isUndocument == true;
    final isReceived = sale.isUndocument == false;
    final docStatusLabel = isPending ? 'Pending' : isReceived ? 'Received' : '—';
    final docStatusColor = isPending ? AppColors.orange    : AppColors.green;
    final docStatusBg    = isPending ? AppColors.orangeXLight : AppColors.greenXLight;

    // Date — formatted; gracefully handles null/parse errors
    String formattedDate = '—';
    try {
      if (sale.sVDate != null && sale.sVDate!.isNotEmpty) {
        formattedDate =
            DateFormat('dd MMM yyyy').format(DateTime.parse(sale.sVDate!));
      }
    } catch (_) {}

    // Amount
    final amountStr = formatCurrency((sale.totalAmount ?? 0.0).toDouble());

    return Padding(
      // Consistent with AlertActionCard's bottom spacing
      padding: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.lg),     // 16
          border: Border(left: BorderSide(color: accent, width: 4)),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowCard,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md + 2,   // 14 — tighter than cardPadding (16),
            AppSpacing.md + 1,   // 13   keeps row density high
            AppSpacing.md + 2,
            AppSpacing.md + 1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header: icon badge + item name + date + doc status ─────
              _CardHeader(
                itemName: _dash(sale.itemName),
                formattedDate: formattedDate,
                accent: accent,
                accentBg: accentBg,
                docStatusLabel: docStatusLabel,
                docStatusColor: docStatusColor,
                docStatusBg: docStatusBg,
              ),

              const SizedBox(height: AppSpacing.sm + 2),   // 10
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: AppSpacing.sm + 2),   // 10

              // ── Primary info chips: row 1 ──────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.receipt_rounded,
                      label: 'Cons./Challan',
                      value: _dash(sale.consuDCNo),
                      accent: accent,
                      bg: accentBg,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.propane_tank_rounded,
                      label: 'Cyl. Qty',
                      value: _dash(sale.cylQty?.toString()),
                      accent: AppColors.teal,
                      bg: AppColors.tealXLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Primary info chips: row 2 ──────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.category_rounded,
                      label: 'SV Type',
                      value: _dash(sale.sVType),
                      accent: AppColors.primary,
                      bg: AppColors.primaryXLight,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.currency_rupee_rounded,
                      label: 'Amount',
                      value: '₹$amountStr',
                      accent: AppColors.orange,
                      bg: AppColors.orangeXLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Secondary info rows ────────────────────────────────────
              _InfoRow(label: 'Stock Status',   value: _dash(sale.stockStatus)),
              _InfoRow(label: 'Consumer No.',   value: _dash(sale.consumerNo)),
              _InfoRow(label: 'Consumer Name',  value: _dash(sale.consumerName)),
              _InfoRow(label: 'Referred By',    value: _dash(sale.referredBy)),
              _InfoRow(label: 'Delivery Date',  value: '—'),
              _InfoRow(label: 'Delivery Men',   value: '—', isLast: true),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _CardHeader
// Extracted header row: icon badge · item name + date · doc-status pill.
// Separating this keeps _buildCard lean and the header independently testable.
// =============================================================================
class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.itemName,
    required this.formattedDate,
    required this.accent,
    required this.accentBg,
    required this.docStatusLabel,
    required this.docStatusColor,
    required this.docStatusBg,
  });

  final String itemName;
  final String formattedDate;
  final Color accent;
  final Color accentBg;
  final String docStatusLabel;
  final Color docStatusColor;
  final Color docStatusBg;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon badge — matches AlertActionCard's 40×40 icon container
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: accentBg,
            borderRadius: BorderRadius.circular(AppSpacing.sm + 2), // 10
          ),
          child: Icon(Icons.local_shipping_rounded, color: accent, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm + 2), // 10

        // Item name + date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemName,
                style: AppTypography.cardTitle,
                textScaler: TextScaler.noScaling,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 11,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    formattedDate,
                    style: AppTypography.cardSubtitle.copyWith(fontSize: 11),
                    textScaler: TextScaler.noScaling,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Doc-status pill — reuses _StatusBadge
        _StatusBadge(
          label: docStatusLabel,
          color: docStatusColor,
          bg: docStatusBg,
        ),
      ],
    );
  }
}

// =============================================================================
// _InfoChip
// Compact two-column pill: icon · label (top) · value (bottom).
// Used for primary numeric/categorical fields (Cons./Challan, Cyl. Qty, etc.).
// =============================================================================
class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.bg,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,   // 10
        vertical: AppSpacing.sm - 1,     //  7
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.sm + 2), // 10
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: AppSpacing.sm - 2), // 6
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSM,
                  textScaler: TextScaler.noScaling,
                ),
                Text(
                  value,
                  style: AppTypography.cardTitle.copyWith(
                    fontSize: 13,
                    color: accent,
                  ),
                  textScaler: TextScaler.noScaling,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _InfoRow
// Full-width label : value row for secondary fields.
// [isLast] suppresses the bottom padding on the final row so the card
// doesn't have uneven internal whitespace.
// =============================================================================
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  // Fixed label column width — wide enough for "Consumer Name" (longest label).
  static const double _labelWidth = 118;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xs + 1), // 5
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _labelWidth,
            child: Text(
              label,
              style: AppTypography.cardSubtitle.copyWith(fontSize: 12),
              textScaler: TextScaler.noScaling,
            ),
          ),
          Text(
            ':  ',
            style: AppTypography.cardSubtitle.copyWith(fontSize: 12),
            textScaler: TextScaler.noScaling,
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.cardTitle.copyWith(fontSize: 13),
              textScaler: TextScaler.noScaling,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _StatusBadge
// Pill badge for Doc Status — Pending (orange) / Received (green).
// Colour values come from AppColors semantic tokens; no hardcoded Colors here.
// =============================================================================
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.bg,
  });

  final String label;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,  // 10
        vertical: AppSpacing.xs,        //  4
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.xl - 4), // 20
        border: Border.all(
          color: color.withOpacity(AppOpacity.heroBadgeBorder), // 0.30
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status dot
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs + 1), // 5
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.1,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }
}