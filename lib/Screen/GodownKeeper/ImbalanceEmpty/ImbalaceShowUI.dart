// import 'package:flutter/material.dart';
//
// import 'ImabalanceEmptyListModel.dart';
// class ImblanceShowUi extends StatefulWidget {
//   ImabalanceEmptyListModel listModel;
//   ImblanceShowUi({required this.listModel,super.key});
//
//   @override
//   State<ImblanceShowUi> createState() => _ImblanceShowUiState();
// }
//
// class _ImblanceShowUiState extends State<ImblanceShowUi> {
//   @override
//   Widget build(BuildContext context) {
//     var value = widget.listModel;
//     return
//       value != null && value != "" ?
//       Card(
//         child: SingleChildScrollView( // Make the Column scrollable
//           child:
// Container(),
//         ),
//       ) :
//       Container(
//         child: Text("No data found"),
//       );
//   }
// }


// import 'package:flutter/material.dart';
//
// import 'ImabalanceEmptyListModel.dart';
//
// // ── Design tokens ─────────────────────────────────────────────────────────────
// abstract final class _C {
//   static const blue       = Color(0xFF1E3A8A);
//   static const blueLight  = Color(0xFF2D52C5);
//   static const blueXL     = Color(0xFFEFF6FF);
//   static const blueXXL    = Color(0xFFDBEAFE);
//   static const teal       = Color(0xFF0F766E);
//   static const tealXL     = Color(0xFFF0FDFA);
//   static const green      = Color(0xFF16A34A);
//   static const greenXL    = Color(0xFFF0FDF4);
//   static const red        = Color(0xFFEF4444);
//   static const redXL      = Color(0xFFFEF2F2);
//   static const text       = Color(0xFF111827);
//   static const textMid    = Color(0xFF374151);
//   static const textMuted  = Color(0xFF6B7280);
//   static const border     = Color(0xFFE2E8F0);
//   static const white      = Color(0xFFFFFFFF);
//   static const bg         = Color(0xFFF8FAFC);
// }
//
// // ── Reusable widgets ──────────────────────────────────────────────────────────
//
// /// Displays a single imbalance entry row in a card.
// class _ImbalanceRow extends StatelessWidget {
//   const _ImbalanceRow({required this.model});
//   final ImabalanceEmptyListModel model;
//
//   @override
//   Widget build(BuildContext context) {
//     final isDelivery = model.entryType == 'D';
//     final name = (model.staffName ?? model.customerName ?? '-').toString();
//     final qty = model.balImbQty ?? 0;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           // Color dot
//           Container(
//             width: 8, height: 8,
//             decoration: BoxDecoration(
//               color: isDelivery ? _C.blueLight : _C.teal,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(width: 12),
//           // Item info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   model.itemName ?? '-',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: _C.textMid,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   name,
//                   style: const TextStyle(fontSize: 12, color: _C.textMuted),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 10),
//           // Qty
//           Text(
//             '$qty',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w800,
//               color: qty > 0 ? _C.red : _C.green,
//             ),
//           ),
//           const SizedBox(width: 8),
//           // Type badge
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//             decoration: BoxDecoration(
//               color: isDelivery ? _C.blueXXL : const Color(0xFFCCFBF1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               isDelivery ? 'DM' : 'CUST',
//               style: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w700,
//                 color: isDelivery ? _C.blue : _C.teal,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Empty-state placeholder when there is no data.
// class _EmptyPlaceholder extends StatelessWidget {
//   const _EmptyPlaceholder();
//   @override
//   Widget build(BuildContext context) => Padding(
//     padding: const EdgeInsets.symmetric(vertical: 32),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 52, height: 52,
//           decoration: BoxDecoration(
//             color: _C.blueXL,
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: const Icon(Icons.inbox_rounded, color: _C.blueLight, size: 26),
//         ),
//         const SizedBox(height: 12),
//         const Text(
//           'No data found',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//             color: _C.textMid,
//           ),
//         ),
//         const SizedBox(height: 4),
//         const Text(
//           'No imbalance records to display.',
//           style: TextStyle(fontSize: 12, color: _C.textMuted),
//         ),
//       ],
//     ),
//   );
// }
//
// // ── Main widget ───────────────────────────────────────────────────────────────
//
// class ImblanceShowUi extends StatefulWidget {
//   final ImabalanceEmptyListModel listModel;
//   const ImblanceShowUi({required this.listModel, super.key});
//
//   @override
//   State<ImblanceShowUi> createState() => _ImblanceShowUiState();
// }
//
// class _ImblanceShowUiState extends State<ImblanceShowUi> {
//   @override
//   Widget build(BuildContext context) {
//     final value = widget.listModel;
//     final hasData = value.itemName != null && value.itemName!.isNotEmpty;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _C.border),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x0A1E3A8A),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: hasData
//           ? Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Card header
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: const BoxDecoration(
//               color: Color(0xFFEFF6FF),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//             ),
//             child: const Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: Text(
//                     'Item / Name',
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700,
//                       color: _C.blue,
//                       letterSpacing: 0.4,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   'Qty',
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w700,
//                     color: _C.blue,
//                     letterSpacing: 0.4,
//                   ),
//                 ),
//                 SizedBox(width: 44),
//               ],
//             ),
//           ),
//           const Divider(height: 1, color: _C.border),
//           // Data row
//           _ImbalanceRow(model: value),
//         ],
//       )
//           : const _EmptyPlaceholder(),
//     );
//   }
// }



import 'package:flutter/material.dart';

import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import '../../Utils/styles/app_text_styles.dart';
import 'ImabalanceEmptyListModel.dart';



// ── Reusable widgets ──────────────────────────────────────────────────────────

/// Displays a single imbalance entry row in a card.
class _ImbalanceRow extends StatelessWidget {
  const _ImbalanceRow({required this.model});
  final ImabalanceEmptyListModel model;

  @override
  Widget build(BuildContext context) {
    final isDelivery = model.entryType == 'D';
    final name = (model.staffName ?? model.customerName ?? '-').toString();
    final qty = model.balImbQty ?? 0;

    return Container(
      padding: AppSpacing.imbalanceRowPadding,
      child: Row(
        children: [
          // Color dot
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: isDelivery ? AppColors.primaryLight : AppColors.teal,
              borderRadius: AppRadius.imbalanceColorDot,
            ),
          ),
          const SizedBox(width: 12),
          // Item info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.itemName ?? '-',
                  style: AppTextStyles.imbalanceRowItemName,
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: AppTextStyles.imbalanceRowPersonName,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Qty
          Text(
            '$qty',
            style: AppTextStyles.imbalanceQtyValue.copyWith(
              fontSize: 16,
              color: qty > 0 ? AppColors.red : AppColors.green,
            ),
          ),
          const SizedBox(width: 8),
          // Type badge
          Container(
            padding: AppSpacing.imbalanceTypeBadgePadding,
            decoration: BoxDecoration(
              color: isDelivery ? AppColors.primaryXXLight : const Color(0xFFCCFBF1),
              borderRadius: AppRadius.imbalanceTypeBadge,
            ),
            child: Text(
              isDelivery ? 'DM' : 'CUST',
              style: AppTextStyles.imbalanceTypeBadge.copyWith(
                color: isDelivery ? AppColors.primary : AppColors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty-state placeholder when there is no data.
class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder();
  @override
  Widget build(BuildContext context) => Padding(
    padding: AppSpacing.imbalancePlaceholderPadding,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: AppColors.primaryXLight,
            borderRadius: AppRadius.imbalanceEmptyIcon,
          ),
          child: const Icon(Icons.inbox_rounded, color: AppColors.primaryLight, size: 26),
        ),
        const SizedBox(height: 12),
        Text(
          'No data found',
          style: AppTextStyles.imbalancePlaceholderTitle,
        ),
        const SizedBox(height: 4),
        Text(
          'No imbalance records to display.',
          style: AppTextStyles.imbalancePlaceholderSubtitle,
        ),
      ],
    ),
  );
}

// ── Main widget ───────────────────────────────────────────────────────────────

class ImblanceShowUi extends StatefulWidget {
  final ImabalanceEmptyListModel listModel;
  const ImblanceShowUi({required this.listModel, super.key});

  @override
  State<ImblanceShowUi> createState() => _ImblanceShowUiState();
}

class _ImblanceShowUiState extends State<ImblanceShowUi> {
  @override
  Widget build(BuildContext context) {
    final value = widget.listModel;
    final hasData = value.itemName != null && value.itemName!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.imbalanceShowCard,
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: hasData
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Card header
          Container(
            padding: AppSpacing.imbalanceCardHeaderPadding,
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: AppRadius.imbalanceShowCardTop,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Item / Name',
                    style: AppTextStyles.imbalanceCardColHeader,
                  ),
                ),
                Text(
                  'Qty',
                  style: AppTextStyles.imbalanceCardColHeader,
                ),
                const SizedBox(width: 44),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          // Data row
          _ImbalanceRow(model: value),
        ],
      )
          : const _EmptyPlaceholder(),
    );
  }
}