import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Utils/styles/app_colors.dart';
import '../../Utils/BoxShadow/app_typography.dart';
import '../ClickModelClass/GetDashboardNiyojanPunchCtnLstModel.dart';
import 'DashboardDropDownUI.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD PUNCH DETAIL ROW
//
// A single row inside the "Niyojan Punch" table.
// Shows: date | staff name (with expand toggle) | punch qty | settled | pending
// Tapping the chevron expands an animated panel listing each ConsumerDetail.
// ─────────────────────────────────────────────────────────────────────────────

class DashbobardPunchDetailUI extends StatefulWidget {
  const DashbobardPunchDetailUI(this.punchModel, {super.key});

  final GetDashboardNiyojanPunchCtnLstModel punchModel;

  @override
  State<DashbobardPunchDetailUI> createState() =>
      _DashboardPunchDetailUIState();
}

class _DashboardPunchDetailUIState extends State<DashbobardPunchDetailUI>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  late final AnimationController _animCtrl;
  late final Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _expandAnim = CurvedAnimation(
      parent: _animCtrl,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.selectionClick();
    setState(() => _expanded = !_expanded);
    _expanded ? _animCtrl.forward() : _animCtrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.punchModel;
    final consumers = p.consumerDetails ?? [];
    final pendingQty = p.pendingSttlQty ?? 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Main summary row ──────────────────────────────────────────────
        InkWell(
          onTap: consumers.isNotEmpty ? _toggle : null,
          splashColor: AppColors.primaryXXLight,
          highlightColor: AppColors.primaryXLight.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                // Date
                Expanded(
                  flex: 2,
                  child: Text(
                    p.todayDate ?? '',
                    style: AppTypography.labelMD.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Thin vertical divider
                _VDivider(),
                // Staff name + expand toggle
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          p.staffName ?? '',
                          style: AppTypography.cardTitle.copyWith(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (consumers.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 260),
                          curve: Curves.easeOutCubic,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Punch qty
                _VDivider(),
                Expanded(
                  flex: 2,
                  child: _StatCell(
                    value: '${p.niyojanPunQty ?? 0}',
                    color: AppColors.primary,
                  ),
                ),
                // Settled qty
                _VDivider(),
                Expanded(
                  flex: 2,
                  child: _StatCell(
                    value: '${p.settlementQty ?? 0}',
                    color: AppColors.teal,
                  ),
                ),
                // Pending qty
                _VDivider(),
                Expanded(
                  flex: 2,
                  child: _StatCell(
                    value: '${pendingQty}',
                    color: pendingQty > 0 ? AppColors.orange : AppColors.textMuted,
                    bold: pendingQty > 0,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Expandable consumer detail panel ─────────────────────────────
        SizeTransition(
          sizeFactor: _expandAnim,
          axisAlignment: -1,
          child: consumers.isEmpty
              ? const SizedBox.shrink()
              : _ConsumerDetailPanel(consumers: consumers),
        ),

        // ── Row divider ───────────────────────────────────────────────────
        const Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StatCell — right-aligned numeric value with accent colour
// ─────────────────────────────────────────────────────────────────────────────

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.value,
    required this.color,
    this.bold = false,
  });

  final String value;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: AppTypography.labelMD.copyWith(
        color: color,
        fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
        fontSize: 13,
      ),
      textAlign: TextAlign.center,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _VDivider — thin vertical separator between columns
// ─────────────────────────────────────────────────────────────────────────────

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: AppColors.divider,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ConsumerDetailPanel — animated sub-list of consumer details
// ─────────────────────────────────────────────────────────────────────────────

class _ConsumerDetailPanel extends StatelessWidget {
  const _ConsumerDetailPanel({required this.consumers});

  final List<ConsumerDetails> consumers;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.background2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryXXLight),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: consumers.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.divider,
          ),
          itemBuilder: (context, index) {
            return DashboardDropDownUI(
              consumers[index],
              index + 1,
              consumers.length,
            );
          },
        ),
      ),
    );
  }
}
