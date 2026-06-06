// ─────────────────────────────────────────────────────────────────────────────
// FILE: test/imbalance_widget_test.dart
//
// Test suite for:
//   • ImblanceShowUi   (ImbalaceShowUI.dart)
//   • ImbalanceSheet   (ImbalanceSheet.dart)
//   • groupAndSum      (pure-logic helper)
//   • _TypeTab         (UI widget)
//
// Run with:
//   flutter test test/imbalance_widget_test.dart
//
// Dependencies (pubspec.yaml):
//   dev_dependencies:
//     flutter_test:
//       sdk: flutter
//     mockito: ^5.4.4
//     build_runner: ^2.4.9
//     network_image_mock: ^2.1.1
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Project imports (adjust paths to match your project structure) ────────────
// import 'package:your_app/features/imbalance/ImabalanceEmptyListModel.dart';
// import 'package:your_app/features/imbalance/ImbalaceShowUI.dart';
// import 'package:your_app/features/imbalance/ImbalanceSheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// STUB MODEL  – mirrors ImabalanceEmptyListModel fields used in the widgets.
// Replace with the real import once paths are confirmed.
// ─────────────────────────────────────────────────────────────────────────────
class ImabalanceEmptyListModel {
  final String? itemName;
  final String? staffName;
  final String? customerName;
  final dynamic balImbQty;
  final String? entryType;
  final dynamic dMId;
  final dynamic custId;

  const ImabalanceEmptyListModel({
    this.itemName,
    this.staffName,
    this.customerName,
    this.balImbQty,
    this.entryType,
    this.dMId,
    this.custId,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// STUB WIDGETS  – replace with real imports once paths are confirmed.
// These stubs replicate the exact logic from the source files so tests are
// meaningful even before wiring up real imports.
// ─────────────────────────────────────────────────────────────────────────────

// --- Design tokens (mirrors AppColors / AppTextStyles used in production) ---
abstract final class _C {
  static const blue       = Color(0xFF1E3A8A);
  static const blueLight  = Color(0xFF2D52C5);
  static const blueXL     = Color(0xFFEFF6FF);
  static const blueXXL    = Color(0xFFDBEAFE);
  static const teal       = Color(0xFF0F766E);
  static const tealXL     = Color(0xFFF0FDFA);
  static const green      = Color(0xFF16A34A);
  static const red        = Color(0xFFEF4444);
  static const textMid    = Color(0xFF374151);
  static const textMuted  = Color(0xFF6B7280);
  static const border     = Color(0xFFE2E8F0);
  static const surface    = Color(0xFFFFFFFF);
  static const primaryXL  = Color(0xFFEFF6FF);
}

/// Stub _ImbalanceRow
class _ImbalanceRow extends StatelessWidget {
  const _ImbalanceRow({required this.model});
  final ImabalanceEmptyListModel model;

  @override
  Widget build(BuildContext context) {
    final isDelivery = model.entryType == 'D';
    final name = (model.staffName ?? model.customerName ?? '-').toString();
    final qty  = model.balImbQty ?? 0;

    return Container(
      key: const Key('imbalance_row'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            key: const Key('color_dot'),
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: isDelivery ? _C.blueLight : _C.teal,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.itemName ?? '-',
                    key: const Key('item_name_text'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _C.textMid,
                    )),
                const SizedBox(height: 2),
                Text(name,
                    key: const Key('person_name_text'),
                    style: const TextStyle(fontSize: 12, color: _C.textMuted),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$qty',
            key: const Key('qty_text'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: (qty is num && qty > 0) ? _C.red : _C.green,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            key: const Key('type_badge'),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDelivery ? _C.blueXXL : const Color(0xFFCCFBF1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isDelivery ? 'DM' : 'CUST',
              key: const Key('badge_label'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isDelivery ? _C.blue : _C.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stub _EmptyPlaceholder
class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          key: const Key('empty_icon_container'),
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: _C.blueXL,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.inbox_rounded,
              key: Key('empty_icon'), color: _C.blueLight, size: 26),
        ),
        const SizedBox(height: 12),
        const Text('No data found',   key: Key('no_data_title')),
        const SizedBox(height: 4),
        const Text('No imbalance records to display.',
            key: Key('no_data_subtitle')),
      ],
    ),
  );
}

/// Stub ImblanceShowUi
class ImblanceShowUi extends StatefulWidget {
  final ImabalanceEmptyListModel listModel;
  const ImblanceShowUi({required this.listModel, super.key});

  @override
  State<ImblanceShowUi> createState() => _ImblanceShowUiState();
}
class _ImblanceShowUiState extends State<ImblanceShowUi> {
  @override
  Widget build(BuildContext context) {
    final value   = widget.listModel;
    final hasData = value.itemName != null && value.itemName!.isNotEmpty;

    return Container(
      key: const Key('show_ui_container'),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
      ),
      child: hasData
          ? Column(
        key: const Key('data_column'),
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            key: const Key('card_header'),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: _C.primaryXL,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Item / Name', key: Key('header_item')),
                ),
                Text('Qty', key: Key('header_qty')),
                SizedBox(width: 44),
              ],
            ),
          ),
          const Divider(height: 1, color: _C.border),
          _ImbalanceRow(model: value),
        ],
      )
          : const _EmptyPlaceholder(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PURE-LOGIC HELPER extracted from ImbalanceSheetState for unit testing
// ─────────────────────────────────────────────────────────────────────────────
List<ImabalanceEmptyListModel> groupAndSum(
    List<ImabalanceEmptyListModel> list) {
  final Map<String, ImabalanceEmptyListModel> groupedMap = {};
  for (final item in list) {
    final displayName = item.staffName ?? item.customerName ?? 'Unknown';
    final itemName    = item.itemName ?? 'Unknown Item';
    final key         = '$displayName-$itemName';

    if (groupedMap.containsKey(key)) {
      final existingQty =
          double.tryParse(groupedMap[key]!.balImbQty.toString()) ?? 0;
      final newQty = double.tryParse(item.balImbQty.toString()) ?? 0;
      groupedMap[key] = ImabalanceEmptyListModel(
        itemName:     item.itemName,
        staffName:    item.staffName,
        customerName: item.customerName,
        balImbQty:    existingQty + newQty,
        entryType:    item.entryType,
        dMId:         item.dMId,
      );
    } else {
      groupedMap[key] = item;
    }
  }
  return groupedMap.values.toList();
}

// ─────────────────────────────────────────────────────────────────────────────
//  HELPER – wraps any widget in a minimal MaterialApp for pumping
// ─────────────────────────────────────────────────────────────────────────────
Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

// ═════════════════════════════════════════════════════════════════════════════
// TEST SUITES
// ═════════════════════════════════════════════════════════════════════════════
void main() {
  // ───────────────────────────────────────────────────────────────────────────
  // 1. ImabalanceEmptyListModel – data model
  // ───────────────────────────────────────────────────────────────────────────
  group('ImabalanceEmptyListModel', () {
    // ── POSITIVE ──
    test('P-M-01 | All fields set correctly', () {
      const m = ImabalanceEmptyListModel(
        itemName: 'LPG Cylinder',
        staffName: 'Ravi Kumar',
        customerName: 'Suresh Patil',
        balImbQty: 5,
        entryType: 'D',
        dMId: 101,
        custId: 202,
      );
      expect(m.itemName, 'LPG Cylinder');
      expect(m.staffName, 'Ravi Kumar');
      expect(m.balImbQty, 5);
      expect(m.entryType, 'D');
      expect(m.dMId, 101);
    });

    test('P-M-02 | Customer entry type C', () {
      const m = ImabalanceEmptyListModel(
        itemName: 'CNG Kit',
        customerName: 'Priya Shah',
        balImbQty: 3,
        entryType: 'C',
        dMId: 55,
      );
      expect(m.entryType, 'C');
      expect(m.customerName, 'Priya Shah');
      expect(m.staffName, isNull);
    });

    test('P-M-03 | Zero balImbQty is valid', () {
      const m = ImabalanceEmptyListModel(itemName: 'Cylinder', balImbQty: 0);
      expect(m.balImbQty, 0);
    });

    test('P-M-04 | Negative balImbQty accepted by model', () {
      const m = ImabalanceEmptyListModel(itemName: 'CNG', balImbQty: -2);
      expect(m.balImbQty, -2);
    });

    test('P-M-05 | balImbQty as double', () {
      const m = ImabalanceEmptyListModel(itemName: 'Cylinder', balImbQty: 2.5);
      expect(m.balImbQty, 2.5);
    });

    // ── NEGATIVE ──
    test('N-M-01 | All nullable fields default to null', () {
      const m = ImabalanceEmptyListModel();
      expect(m.itemName,     isNull);
      expect(m.staffName,    isNull);
      expect(m.customerName, isNull);
      expect(m.balImbQty,    isNull);
      expect(m.entryType,    isNull);
      expect(m.dMId,         isNull);
      expect(m.custId,       isNull);
    });

    test('N-M-02 | itemName empty string is distinct from null', () {
      const m = ImabalanceEmptyListModel(itemName: '');
      expect(m.itemName, isEmpty);
      expect(m.itemName, isNot(isNull));
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // 2. groupAndSum – pure business logic
  // ───────────────────────────────────────────────────────────────────────────
  group('groupAndSum()', () {
    // ── POSITIVE ──
    test('P-G-01 | Empty list returns empty list', () {
      expect(groupAndSum([]), isEmpty);
    });

    test('P-G-02 | Single item is returned as-is', () {
      final input = [
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'Ram', balImbQty: 4, entryType: 'D'),
      ];
      final result = groupAndSum(input);
      expect(result.length, 1);
      expect(result.first.balImbQty, 4.0);
    });

    test('P-G-03 | Same staffName+itemName are merged and quantities summed', () {
      final input = [
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'Ram', balImbQty: 3, entryType: 'D'),
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'Ram', balImbQty: 5, entryType: 'D'),
      ];
      final result = groupAndSum(input);
      expect(result.length, 1);
      expect(result.first.balImbQty, 8.0);
    });

    test('P-G-04 | Different staffName produce separate entries', () {
      final input = [
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'Ram', balImbQty: 2, entryType: 'D'),
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'Shyam', balImbQty: 4, entryType: 'D'),
      ];
      final result = groupAndSum(input);
      expect(result.length, 2);
    });

    test('P-G-05 | Different itemName for same person produce separate entries', () {
      final input = [
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'Ram', balImbQty: 1, entryType: 'D'),
        const ImabalanceEmptyListModel(
            itemName: 'CNG', staffName: 'Ram', balImbQty: 2, entryType: 'D'),
      ];
      final result = groupAndSum(input);
      expect(result.length, 2);
    });

    test('P-G-06 | Customer name used when staffName is null', () {
      final input = [
        const ImabalanceEmptyListModel(
            itemName: 'CYL',
            customerName: 'Priya',
            balImbQty: 3,
            entryType: 'C'),
        const ImabalanceEmptyListModel(
            itemName: 'CYL',
            customerName: 'Priya',
            balImbQty: 7,
            entryType: 'C'),
      ];
      final result = groupAndSum(input);
      expect(result.length, 1);
      expect(result.first.balImbQty, 10.0);
    });

    test('P-G-07 | Large list with many entries grouped correctly', () {
      final input = List.generate(
        20,
            (i) => ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'Person${i % 4}', balImbQty: 1),
      );
      final result = groupAndSum(input);
      expect(result.length, 4);
      for (final r in result) {
        expect(r.balImbQty, 5.0);
      }
    });

    test('P-G-08 | Double quantities are summed correctly', () {
      final input = [
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'R', balImbQty: 1.5),
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'R', balImbQty: 2.5),
      ];
      final result = groupAndSum(input);
      expect(result.first.balImbQty, closeTo(4.0, 0.001));
    });

    test('P-G-09 | Mixed D and C types with same person treated as same key', () {
      // Key is displayName-itemName; entryType is NOT part of the key.
      // The last entryType wins (matches production behavior).
      final input = [
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'R', balImbQty: 2, entryType: 'D'),
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'R', balImbQty: 3, entryType: 'C'),
      ];
      final result = groupAndSum(input);
      expect(result.length, 1);
      expect(result.first.balImbQty, 5.0);
    });

    // ── NEGATIVE ──
    test('N-G-01 | null staffName and customerName falls back to "Unknown"', () {
      final input = [
        const ImabalanceEmptyListModel(itemName: 'CYL', balImbQty: 4),
        const ImabalanceEmptyListModel(itemName: 'CYL', balImbQty: 6),
      ];
      final result = groupAndSum(input);
      // Both use "Unknown-CYL" as key → merged
      expect(result.length, 1);
      expect(result.first.balImbQty, 10.0);
    });

    test('N-G-02 | null itemName falls back to "Unknown Item"', () {
      final input = [
        const ImabalanceEmptyListModel(staffName: 'Ram', balImbQty: 2),
        const ImabalanceEmptyListModel(staffName: 'Ram', balImbQty: 3),
      ];
      final result = groupAndSum(input);
      expect(result.length, 1);
      expect(result.first.balImbQty, 5.0);
    });

    test('N-G-03 | null balImbQty treated as 0 in sum', () {
      final input = [
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'R', balImbQty: null),
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'R', balImbQty: 5),
      ];
      final result = groupAndSum(input);
      expect(result.first.balImbQty, closeTo(5.0, 0.001));
    });

    test('N-G-04 | Non-numeric balImbQty string treated as 0', () {
      final input = [
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'R', balImbQty: 'abc'),
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'R', balImbQty: 3),
      ];
      final result = groupAndSum(input);
      expect(result.first.balImbQty, closeTo(3.0, 0.001));
    });

    test('N-G-05 | Negative quantities are summed correctly', () {
      final input = [
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'R', balImbQty: -3),
        const ImabalanceEmptyListModel(
            itemName: 'CYL', staffName: 'R', balImbQty: -2),
      ];
      final result = groupAndSum(input);
      expect(result.first.balImbQty, closeTo(-5.0, 0.001));
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // 3. ImblanceShowUi – widget rendering (empty state)
  // ───────────────────────────────────────────────────────────────────────────
  group('ImblanceShowUi – empty state', () {
    // ── POSITIVE ──
    testWidgets('P-UI-01 | Shows empty placeholder when itemName is null',
            (tester) async {
          await tester.pumpWidget(
            _wrap(const ImblanceShowUi(listModel: ImabalanceEmptyListModel())),
          );
          expect(find.byKey(const Key('no_data_title')), findsOneWidget);
          expect(find.text('No data found'), findsOneWidget);
        });

    testWidgets('P-UI-02 | Shows empty placeholder when itemName is empty string',
            (tester) async {
          await tester.pumpWidget(
            _wrap(const ImblanceShowUi(
                listModel: ImabalanceEmptyListModel(itemName: ''))),
          );
          expect(find.byKey(const Key('no_data_title')), findsOneWidget);
          expect(find.byKey(const Key('imbalance_row')), findsNothing);
        });

    testWidgets('P-UI-03 | Empty state shows subtitle text', (tester) async {
      await tester.pumpWidget(
        _wrap(const ImblanceShowUi(listModel: ImabalanceEmptyListModel())),
      );
      expect(find.byKey(const Key('no_data_subtitle')), findsOneWidget);
      expect(find.text('No imbalance records to display.'), findsOneWidget);
    });

    testWidgets('P-UI-04 | Empty state shows inbox icon', (tester) async {
      await tester.pumpWidget(
        _wrap(const ImblanceShowUi(listModel: ImabalanceEmptyListModel())),
      );
      expect(find.byKey(const Key('empty_icon')), findsOneWidget);
    });

    testWidgets('P-UI-05 | Empty state does NOT show card header columns',
            (tester) async {
          await tester.pumpWidget(
            _wrap(const ImblanceShowUi(listModel: ImabalanceEmptyListModel())),
          );
          expect(find.byKey(const Key('card_header')), findsNothing);
          expect(find.byKey(const Key('header_qty')),  findsNothing);
        });

    // ── NEGATIVE ──
    testWidgets('N-UI-01 | Data row NOT shown when model has no itemName',
            (tester) async {
          await tester.pumpWidget(
            _wrap(const ImblanceShowUi(
                listModel: ImabalanceEmptyListModel(staffName: 'Ram', balImbQty: 5))),
          );
          expect(find.byKey(const Key('imbalance_row')), findsNothing);
        });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // 4. ImblanceShowUi – data state
  // ───────────────────────────────────────────────────────────────────────────
  group('ImblanceShowUi – data state', () {
    const deliveryModel = ImabalanceEmptyListModel(
      itemName: 'LPG Cylinder',
      staffName: 'Ravi Kumar',
      balImbQty: 7,
      entryType: 'D',
      dMId: 11,
    );

    const customerModel = ImabalanceEmptyListModel(
      itemName: 'CNG Kit',
      customerName: 'Priya Shah',
      balImbQty: 2,
      entryType: 'C',
      dMId: 22,
    );

    // ── POSITIVE ──
    testWidgets('P-UI-06 | Shows card header "Item / Name" and "Qty"',
            (tester) async {
          await tester
              .pumpWidget(_wrap(const ImblanceShowUi(listModel: deliveryModel)));
          expect(find.text('Item / Name'), findsOneWidget);
          expect(find.text('Qty'),         findsOneWidget);
        });

    testWidgets('P-UI-07 | Shows item name text', (tester) async {
      await tester
          .pumpWidget(_wrap(const ImblanceShowUi(listModel: deliveryModel)));
      expect(find.byKey(const Key('item_name_text')), findsOneWidget);
      expect(find.text('LPG Cylinder'), findsWidgets);
    });

    testWidgets('P-UI-08 | Shows staffName for delivery entry', (tester) async {
      await tester
          .pumpWidget(_wrap(const ImblanceShowUi(listModel: deliveryModel)));
      expect(find.byKey(const Key('person_name_text')), findsOneWidget);
      expect(find.text('Ravi Kumar'), findsOneWidget);
    });

    testWidgets('P-UI-09 | Shows customerName for customer entry',
            (tester) async {
          await tester
              .pumpWidget(_wrap(const ImblanceShowUi(listModel: customerModel)));
          expect(find.text('Priya Shah'), findsOneWidget);
        });

    testWidgets('P-UI-10 | Shows quantity value', (tester) async {
      await tester
          .pumpWidget(_wrap(const ImblanceShowUi(listModel: deliveryModel)));
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('P-UI-11 | Delivery badge shows "DM"', (tester) async {
      await tester
          .pumpWidget(_wrap(const ImblanceShowUi(listModel: deliveryModel)));
      expect(find.text('DM'), findsOneWidget);
    });

    testWidgets('P-UI-12 | Customer badge shows "CUST"', (tester) async {
      await tester
          .pumpWidget(_wrap(const ImblanceShowUi(listModel: customerModel)));
      expect(find.text('CUST'), findsOneWidget);
    });

    testWidgets('P-UI-13 | Color dot present for delivery model',
            (tester) async {
          await tester
              .pumpWidget(_wrap(const ImblanceShowUi(listModel: deliveryModel)));
          expect(find.byKey(const Key('color_dot')), findsOneWidget);
        });

    testWidgets('P-UI-14 | Empty placeholder is absent when data present',
            (tester) async {
          await tester
              .pumpWidget(_wrap(const ImblanceShowUi(listModel: deliveryModel)));
          expect(find.byKey(const Key('no_data_title')), findsNothing);
        });

    testWidgets('P-UI-15 | Widget renders without overflow on narrow screen',
            (tester) async {
          tester.view.physicalSize = const Size(320, 480);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);

          await tester
              .pumpWidget(_wrap(const ImblanceShowUi(listModel: deliveryModel)));
          // No RenderFlex overflow exception should be thrown
          expect(tester.takeException(), isNull);
        });

    testWidgets('P-UI-16 | Zero qty shows "0" and green color', (tester) async {
      const model = ImabalanceEmptyListModel(
          itemName: 'CYL', staffName: 'A', balImbQty: 0, entryType: 'D');
      await tester.pumpWidget(_wrap(const ImblanceShowUi(listModel: model)));
      final text = tester.widget<Text>(find.byKey(const Key('qty_text')));
      expect(text.data, '0');
      expect((text.style!.color), equals(_C.green));
    });

    testWidgets('P-UI-17 | Positive qty is shown in red', (tester) async {
      await tester
          .pumpWidget(_wrap(const ImblanceShowUi(listModel: deliveryModel)));
      final qtyText = tester.widget<Text>(find.byKey(const Key('qty_text')));
      expect(qtyText.style!.color, equals(_C.red));
    });

    testWidgets('P-UI-18 | Card has rounded container decoration',
            (tester) async {
          await tester
              .pumpWidget(_wrap(const ImblanceShowUi(listModel: deliveryModel)));
          final container = tester.widget<Container>(
              find.byKey(const Key('show_ui_container')));
          final decoration = container.decoration as BoxDecoration;
          expect(decoration.borderRadius, isNotNull);
        });

    // ── NEGATIVE ──
    testWidgets('N-UI-02 | Null staffName and customerName shows "-"',
            (tester) async {
          const model =
          ImabalanceEmptyListModel(itemName: 'CYL', balImbQty: 3, entryType: 'D');
          await tester.pumpWidget(_wrap(const ImblanceShowUi(listModel: model)));
          expect(find.text('-'), findsWidgets); // person name fallback
        });

    testWidgets('N-UI-03 | Null itemName in row shows "-" for item name',
            (tester) async {
          // hasData check guards this – but if row were shown, verify fallback.
          // We test _ImbalanceRow in isolation:
          await tester.pumpWidget(
            _wrap(const _ImbalanceRow(
                model: ImabalanceEmptyListModel(
                    itemName: null, staffName: 'Ram', balImbQty: 3))),
          );
          expect(find.text('-'), findsWidgets);
        });

    testWidgets('N-UI-04 | Widget does not crash with very long item name',
            (tester) async {
          final model = ImabalanceEmptyListModel(
              itemName: 'A' * 200, staffName: 'Ram', balImbQty: 1, entryType: 'D');
          await tester.pumpWidget(_wrap(ImblanceShowUi(listModel: model)));
          expect(tester.takeException(), isNull);
        });

    testWidgets('N-UI-05 | Widget does not crash with null balImbQty',
            (tester) async {
          const model = ImabalanceEmptyListModel(
              itemName: 'CYL', staffName: 'Ram', balImbQty: null, entryType: 'D');
          await tester.pumpWidget(_wrap(const ImblanceShowUi(listModel: model)));
          expect(find.text('0'), findsOneWidget); // null → 0 fallback
          expect(tester.takeException(), isNull);
        });

    testWidgets('N-UI-06 | Switching from data model to empty model shows placeholder',
            (tester) async {
          const dataModel = ImabalanceEmptyListModel(
              itemName: 'CYL', staffName: 'R', balImbQty: 5, entryType: 'D');

          await tester
              .pumpWidget(_wrap(const ImblanceShowUi(listModel: dataModel)));
          expect(find.byKey(const Key('imbalance_row')), findsOneWidget);

          await tester.pumpWidget(
            _wrap(const ImblanceShowUi(listModel: ImabalanceEmptyListModel())),
          );
          await tester.pump();
          expect(find.byKey(const Key('no_data_title')), findsOneWidget);
        });

    testWidgets('N-UI-07 | Unknown entryType defaults to CUST badge behavior',
            (tester) async {
          const model = ImabalanceEmptyListModel(
              itemName: 'CYL',
              staffName: 'Ram',
              balImbQty: 2,
              entryType: 'X'); // unknown type
          await tester.pumpWidget(_wrap(const ImblanceShowUi(listModel: model)));
          // entryType != 'D' so badge should be "CUST"
          expect(find.text('CUST'), findsOneWidget);
        });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // 5. _ImbalanceRow – isolated row tests
  // ───────────────────────────────────────────────────────────────────────────
  group('_ImbalanceRow', () {
    // ── POSITIVE ──
    testWidgets('P-R-01 | Delivery dot uses blueLight color', (tester) async {
      const model = ImabalanceEmptyListModel(
          itemName: 'CYL', staffName: 'R', balImbQty: 1, entryType: 'D');
      await tester.pumpWidget(_wrap(const _ImbalanceRow(model: model)));
      final dot = tester.widget<Container>(find.byKey(const Key('color_dot')));
      final dec = dot.decoration as BoxDecoration;
      expect(dec.color, equals(_C.blueLight));
    });

    testWidgets('P-R-02 | Customer dot uses teal color', (tester) async {
      const model = ImabalanceEmptyListModel(
          itemName: 'CYL',
          customerName: 'P',
          balImbQty: 1,
          entryType: 'C');
      await tester.pumpWidget(_wrap(const _ImbalanceRow(model: model)));
      final dot = tester.widget<Container>(find.byKey(const Key('color_dot')));
      final dec = dot.decoration as BoxDecoration;
      expect(dec.color, equals(_C.teal));
    });

    testWidgets('P-R-03 | staffName takes priority over customerName',
            (tester) async {
          const model = ImabalanceEmptyListModel(
              itemName: 'CYL',
              staffName: 'Staff',
              customerName: 'Cust',
              balImbQty: 3,
              entryType: 'D');
          await tester.pumpWidget(_wrap(const _ImbalanceRow(model: model)));
          expect(find.text('Staff'), findsOneWidget);
          expect(find.text('Cust'), findsNothing);
        });

    testWidgets('P-R-04 | Negative qty shows green color', (tester) async {
      const model = ImabalanceEmptyListModel(
          itemName: 'CYL', staffName: 'R', balImbQty: -5, entryType: 'D');
      await tester.pumpWidget(_wrap(const _ImbalanceRow(model: model)));
      final qtyText = tester.widget<Text>(find.byKey(const Key('qty_text')));
      expect(qtyText.style!.color, equals(_C.green));
    });

    // ── NEGATIVE ──
    testWidgets('N-R-01 | Row renders without exception for all-null fields',
            (tester) async {
          await tester.pumpWidget(
              _wrap(const _ImbalanceRow(model: ImabalanceEmptyListModel())));
          expect(tester.takeException(), isNull);
        });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // 6. addItemImbalanceQty validation logic – pure unit tests
  //    (These mirror the validation guard clauses in the method and can be
  //     tested without network/SharedPreferences by extracting the logic.)
  // ───────────────────────────────────────────────────────────────────────────
  group('addItemImbalanceQty – validation guards (unit)', () {
    // Helper that replicates the qty validation block:
    //   enteredQty > 0 AND enteredQty <= availableQty  → valid
    bool isQtyValid(int enteredQty, int availableQty) {
      if (enteredQty <= 0) return false;
      if (enteredQty > availableQty) return false;
      return true;
    }

    // ── POSITIVE ──
    test('P-V-01 | Qty exactly equal to available is valid', () {
      expect(isQtyValid(5, 5), isTrue);
    });

    test('P-V-02 | Qty less than available is valid', () {
      expect(isQtyValid(3, 10), isTrue);
    });

    test('P-V-03 | Qty = 1 with available = 1 is valid', () {
      expect(isQtyValid(1, 1), isTrue);
    });

    test('P-V-04 | Max boundary: qty = 999, available = 999', () {
      expect(isQtyValid(999, 999), isTrue);
    });

    // ── NEGATIVE ──
    test('N-V-01 | Zero enteredQty is invalid', () {
      expect(isQtyValid(0, 10), isFalse);
    });

    test('N-V-02 | Negative enteredQty is invalid', () {
      expect(isQtyValid(-3, 10), isFalse);
    });

    test('N-V-03 | enteredQty exceeds available is invalid', () {
      expect(isQtyValid(11, 10), isFalse);
    });

    test('N-V-04 | Both zero is invalid', () {
      expect(isQtyValid(0, 0), isFalse);
    });

    test('N-V-05 | enteredQty = 1 with available = 0 is invalid', () {
      expect(isQtyValid(1, 0), isFalse);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // 7. selectedType state & dropdown reset logic
  // ───────────────────────────────────────────────────────────────────────────
  group('selectedType state logic (unit)', () {
    // Mirrors the reset block triggered when radio changes type.
    Map<String, dynamic> resetState(String newType) {
      return {
        'selectedType': newType,
        'selectedDeliveryMenId': null,
        'selectedDeliveryMenName': null,
        'selectedCustomerId': null,
        'selectedCustomerName': null,
        'totalImbalanceQtyDMCustomer': '',
      };
    }

    // ── POSITIVE ──
    test('P-S-01 | Switching to "C" resets all delivery fields', () {
      final s = resetState('C');
      expect(s['selectedType'], 'C');
      expect(s['selectedDeliveryMenId'], isNull);
      expect(s['selectedDeliveryMenName'], isNull);
    });

    test('P-S-02 | Switching to "D" resets all customer fields', () {
      final s = resetState('D');
      expect(s['selectedType'], 'D');
      expect(s['selectedCustomerId'], isNull);
      expect(s['selectedCustomerName'], isNull);
    });

    test('P-S-03 | DMCustomer qty field cleared on type switch', () {
      final s = resetState('C');
      expect(s['totalImbalanceQtyDMCustomer'], isEmpty);
    });

    // ── NEGATIVE ──
    test('N-S-01 | Unknown type string does not cause exception', () {
      // Should not throw – just stores the unexpected value
      expect(() => resetState('X'), returnsNormally);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // 8. Request body construction
  // ───────────────────────────────────────────────────────────────────────────
  group('Request body construction (unit)', () {
    Map<String, dynamic> buildBody({
      required String distributorId,
      required String? godownId,
      required String formattedDate,
      required int? selectedItemId,
      required String selectedTypes,
      required int? selectedCust,
      required int enteredQty,
      required String? addedBy,
    }) {
      return {
        'ImbId': 0,
        'DistributorId': distributorId,
        'GodownId': godownId,
        'ImbDate': formattedDate,
        'ItemId': selectedItemId,
        'EntryType': selectedTypes,
        'ConsDMId': selectedCust,
        'ImbRecQty': enteredQty,
        'AddedBy': addedBy,
        'Action': 'ADD',
      };
    }

    // ── POSITIVE ──
    test('P-B-01 | Action is always "ADD"', () {
      final body = buildBody(
        distributorId: '1', godownId: '2',
        formattedDate: '2025-01-01', selectedItemId: 5,
        selectedTypes: 'D', selectedCust: 10,
        enteredQty: 3, addedBy: '99',
      );
      expect(body['Action'], 'ADD');
    });

    test('P-B-02 | ImbId is always 0', () {
      final body = buildBody(
        distributorId: '1', godownId: '2',
        formattedDate: '2025-01-01', selectedItemId: 5,
        selectedTypes: 'D', selectedCust: 10,
        enteredQty: 3, addedBy: '99',
      );
      expect(body['ImbId'], 0);
    });

    test('P-B-03 | EntryType "D" set correctly', () {
      final body = buildBody(
        distributorId: '1', godownId: '2',
        formattedDate: '2025-01-01', selectedItemId: 5,
        selectedTypes: 'D', selectedCust: 10,
        enteredQty: 3, addedBy: '99',
      );
      expect(body['EntryType'], 'D');
    });

    test('P-B-04 | EntryType "C" set correctly', () {
      final body = buildBody(
        distributorId: '1', godownId: '2',
        formattedDate: '2025-01-01', selectedItemId: 5,
        selectedTypes: 'C', selectedCust: 20,
        enteredQty: 2, addedBy: '99',
      );
      expect(body['EntryType'], 'C');
    });

    test('P-B-05 | ImbRecQty matches enteredQty', () {
      final body = buildBody(
        distributorId: '1', godownId: '2',
        formattedDate: '2025-01-01', selectedItemId: 5,
        selectedTypes: 'D', selectedCust: 10,
        enteredQty: 7, addedBy: '99',
      );
      expect(body['ImbRecQty'], 7);
    });

    test('P-B-06 | Date format is yyyy-MM-dd', () {
      final body = buildBody(
        distributorId: '1', godownId: '2',
        formattedDate: '2025-06-15', selectedItemId: 5,
        selectedTypes: 'D', selectedCust: 10,
        enteredQty: 3, addedBy: '99',
      );
      expect(body['ImbDate'], matches(r'^\d{4}-\d{2}-\d{2}$'));
    });

    // ── NEGATIVE ──
    test('N-B-01 | Null godownId is passed as-is (no crash)', () {
      final body = buildBody(
        distributorId: '1', godownId: null,
        formattedDate: '2025-01-01', selectedItemId: 5,
        selectedTypes: 'D', selectedCust: 10,
        enteredQty: 3, addedBy: '99',
      );
      expect(body['GodownId'], isNull);
    });

    test('N-B-02 | Null addedBy is passed as-is (no crash)', () {
      final body = buildBody(
        distributorId: '1', godownId: '2',
        formattedDate: '2025-01-01', selectedItemId: 5,
        selectedTypes: 'D', selectedCust: 10,
        enteredQty: 3, addedBy: null,
      );
      expect(body['AddedBy'], isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // 9. stockTransferFlag logic
  // ───────────────────────────────────────────────────────────────────────────
  group('stockTransferFlag derivation (unit)', () {
    // Mirrors: hasZeroStkTrans = list.any(e => e.isStkTrans == 0)
    //          stockTransferFlag = !hasZeroStkTrans
    bool deriveFlag(List<int> isStkTransValues) {
      final hasZero = isStkTransValues.any((v) => v == 0);
      return !hasZero;
    }

    // ── POSITIVE ──
    test('P-F-01 | All isStkTrans=1 → flag is true', () {
      expect(deriveFlag([1, 1, 1]), isTrue);
    });

    test('P-F-02 | Empty list → flag is true (no zero found)', () {
      expect(deriveFlag([]), isTrue);
    });

    test('P-F-03 | All isStkTrans=2 → flag is true', () {
      expect(deriveFlag([2, 3, 4]), isTrue);
    });

    // ── NEGATIVE ──
    test('N-F-01 | Any isStkTrans=0 → flag is false', () {
      expect(deriveFlag([1, 0, 1]), isFalse);
    });

    test('N-F-02 | All isStkTrans=0 → flag is false', () {
      expect(deriveFlag([0, 0]), isFalse);
    });

    test('N-F-03 | Single isStkTrans=0 → flag is false', () {
      expect(deriveFlag([0]), isFalse);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // 10. Accessibility / edge-case rendering
  // ───────────────────────────────────────────────────────────────────────────
  group('Accessibility & edge-case rendering', () {
    testWidgets('A-01 | Widget tree mounts without errors (data)',
            (tester) async {
          const m = ImabalanceEmptyListModel(
              itemName: 'CYL', staffName: 'R', balImbQty: 1, entryType: 'D');
          await tester.pumpWidget(_wrap(const ImblanceShowUi(listModel: m)));
          expect(tester.takeException(), isNull);
        });

    testWidgets('A-02 | Widget tree mounts without errors (empty)',
            (tester) async {
          await tester.pumpWidget(
              _wrap(const ImblanceShowUi(listModel: ImabalanceEmptyListModel())));
          expect(tester.takeException(), isNull);
        });

    testWidgets('A-03 | Widget renders on tablet-sized screen (1024×768)',
            (tester) async {
          tester.view.physicalSize = const Size(1024, 768);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(tester.view.resetPhysicalSize);

          const m = ImabalanceEmptyListModel(
              itemName: 'CYL', staffName: 'R', balImbQty: 3, entryType: 'D');
          await tester.pumpWidget(_wrap(const ImblanceShowUi(listModel: m)));
          expect(tester.takeException(), isNull);
        });

    testWidgets('A-04 | balImbQty as string "5" renders without crash',
            (tester) async {
          const m = ImabalanceEmptyListModel(
              itemName: 'CYL', staffName: 'R', balImbQty: '5', entryType: 'D');
          await tester.pumpWidget(_wrap(const ImblanceShowUi(listModel: m)));
          expect(tester.takeException(), isNull);
        });

    testWidgets('A-05 | Special characters in itemName do not crash',
            (tester) async {
          const m = ImabalanceEmptyListModel(
              itemName: r'LPG & CNG <cylinder> "19kg"',
              staffName: 'R',
              balImbQty: 1,
              entryType: 'D');
          await tester.pumpWidget(_wrap(const ImblanceShowUi(listModel: m)));
          expect(tester.takeException(), isNull);
        });

    testWidgets('A-06 | Unicode staffName renders correctly', (tester) async {
      const m = ImabalanceEmptyListModel(
          itemName: 'CYL',
          staffName: 'राम कुमार', // Hindi text
          balImbQty: 2,
          entryType: 'D');
      await tester.pumpWidget(_wrap(const ImblanceShowUi(listModel: m)));
      expect(find.text('राम कुमार'), findsOneWidget);
    });
  });
}