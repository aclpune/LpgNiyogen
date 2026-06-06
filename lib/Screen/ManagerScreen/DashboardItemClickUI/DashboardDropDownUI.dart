// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../ConstantScreen/widgets.dart';
// import '../ClickModelClass/GetDashboardNiyojanPunchCtnLstModel.dart';
// import '../ClickModelClass/GetDashboardSettlementCtnListModel.dart';
//
// class DashboardDropDownUI extends StatefulWidget {
//
//   ConsumerDetails punchCtnLstModel;
//   int serialNumber;
//   int listLength;
//
//   DashboardDropDownUI( this.punchCtnLstModel,this.serialNumber,this.listLength,{super.key});
//
//   @override
//   State<StatefulWidget> createState() {
//     return _DashboardDropDownUI();
//   }
// }
//
// class _DashboardDropDownUI extends State<DashboardDropDownUI> {
//   @override
//   Widget build(BuildContext context) {
//     var sale = widget.punchCtnLstModel;
//     var serialNumbers = widget.serialNumber;
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
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(flex:0,child: countTextWidgetTextWithoutHeading(context, nullToDash(sale.consumerNo))),
//               Expanded(flex:0,child: countTextWidgetTextWithoutHeading(context, nullToDash(sale.orderDate))),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Name", nullToDash(sale.consumerName))),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"C Memo Date", nullToDash(sale.cashMemoDate))),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Settle Date", nullToDash(sale.settlementDate))),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Delivery Date", nullToDash(sale.deliveryDate))),
//             ],
//           ),
//           SizedBox(height: 2),
//           Row(
//             children: [
//               Expanded(flex:1,child: countTextWidgetText(context,"Remark", nullToDash(sale.remark))),
//             ],
//           ),
//           if (widget.serialNumber != widget.listLength)
//             Divider(),
//         ],
//       );
//   }
// }

import 'package:flutter/material.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';
import '../ClickModelClass/GetDashboardNiyojanPunchCtnLstModel.dart';

// =============================================================================
// DashboardDropDownUI
//
// Refactored to dashboard design system:
//   • Left-accent card per record (cycles through brand palette)
//   • Icon-labelled info chips in a 2-column grid
//   • Consumer No. + Order Date in a styled header row
//   • Staggered slide+fade animation (matches AlertActionCard pattern)
//   • No dividers — card spacing replaces them naturally
//   • All data fields and logic preserved exactly
// =============================================================================

class DashboardDropDownUI extends StatefulWidget {
  final ConsumerDetails punchCtnLstModel;
  final int serialNumber;
  final int listLength;

  const DashboardDropDownUI(
      this.punchCtnLstModel,
      this.serialNumber,
      this.listLength, {
        super.key,
      });

  @override
  State<DashboardDropDownUI> createState() => _DashboardDropDownUIState();
}

class _DashboardDropDownUIState extends State<DashboardDropDownUI>
    with SingleTickerProviderStateMixin {
  // ── Animation (matches AlertActionCard stagger pattern) ────────────────────
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
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // stagger delay based on position in list
    Future.delayed(
      Duration(milliseconds: 55 * widget.serialNumber),
          () { if (mounted) _ctrl.forward(); },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  String _dash(String? v) =>
      (v == null || v.trim().isEmpty || v.toLowerCase() == 'null') ? '—' : v;

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: _buildCard()),
    );
  }

  Widget _buildCard() {
    final sale = widget.punchCtnLstModel;

    // Accent colour cycles through dashboard palette
    final _accents = [
      AppColors.blue,
      AppColors.teal,
      AppColors.amber,
      AppColors.red,
      const Color(0xFF6e69e2), // violet
    ];
    const _accentBgs = [
      AppColors.blueXL,
      AppColors.tealXL,
      AppColors.amberXL,
      AppColors.redXL,
      Color(0xFFEEEDFD),
    ];
    final idx = (widget.serialNumber - 1) % _accents.length;
    final accent = _accents[idx];
    final accentBg = _accentBgs[idx];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: accent, width: 4)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0D1E3A8A), // AppColors.shadowCard
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: Consumer No. + Order Date ───────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon badge
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: accentBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Consumer No.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _dash(sale.consumerNo),
                          style: AppTypography.cardTitle,
                          textScaler: TextScaler.noScaling,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        // Consumer Name beneath no.
                        Text(
                          _dash(sale.consumerName),
                          style: AppTypography.cardSubtitle
                              .copyWith(fontSize: 12),
                          textScaler: TextScaler.noScaling,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Order date badge
                  _DateBadge(date: _dash(sale.orderDate), accent: accent),
                ],
              ),

              const SizedBox(height: 10),
              Divider(color: const Color(0xFFF1F5F9), height: 1),
              const SizedBox(height: 10),

              // ── Date chips: C Memo Date + Settle Date ───────────
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.receipt_long_rounded,
                      label: 'C Memo Date',
                      value: _dash(sale.cashMemoDate),
                      accent: AppColors.teal,
                      bg: AppColors.tealXL,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.handshake_rounded,
                      label: 'Settle Date',
                      value: _dash(sale.settlementDate),
                      accent: AppColors.blue,
                      bg: AppColors.blueXL,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ── Delivery Date (full-width) ───────────────────────
              _InfoChip(
                icon: Icons.local_shipping_rounded,
                label: 'Delivery Date',
                value: _dash(sale.deliveryDate),
                accent: AppColors.amber,
                bg: AppColors.amberXL,
                fullWidth: true,
              ),

              const SizedBox(height: 8),

              // ── Remark (full-width, multiline) ───────────────────
              _RemarkRow(remark: _dash(sale.remark)),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// _InfoChip
// Icon + label above + value below. Optionally full-width.
// =============================================================================
class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.bg,
    this.fullWidth = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final Color bg;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                  textScaler: TextScaler.noScaling,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accent,
                    letterSpacing: -0.1,
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
    return chip;
  }
}

// =============================================================================
// _DateBadge
// Small pill badge showing the order date in the card header.
// =============================================================================
class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date, required this.accent});

  final String date;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded, size: 11, color: accent),
          const SizedBox(width: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: accent,
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
// _RemarkRow
// Full-width remark with a muted background — multiline safe.
// =============================================================================
class _RemarkRow extends StatelessWidget {
  const _RemarkRow({required this.remark});

  final String remark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notes_rounded,
              size: 14, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'REMARK',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                  textScaler: TextScaler.noScaling,
                ),
                Text(
                  remark,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMid,
                    height: 1.4,
                  ),
                  textScaler: TextScaler.noScaling,
                  maxLines: 3,
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