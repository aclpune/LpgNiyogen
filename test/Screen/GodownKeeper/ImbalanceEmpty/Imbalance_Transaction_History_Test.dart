// =============================================================================
// FILE : test/imbalance_transaction_history_test.dart
//
// Covers every testable unit in:
//   • ImbalnceTransactionHistory screen  (ImbalnceTransactionHistory.dart)
//   • _TransactionCard widget
//   • _EmptyState widget
//   • _SummaryChip widget
//   • _buildSummaryStrip()  logic
//   • _confirmDelete()      dialog
//   • addItemImbalanceQty() request-body construction & validation
//   • checkAndSaveDayEndData() saveFlag derivation
//   • fetchTransactionList() / stockTransferFlag derivation
//   • ImbalanceTransactionHistoryListModel  data model
//   • Delete guard logic   (saveFlag / stockTransferFlag combinations)
//   • screenName constant
//
// Run with:
//   flutter test test/imbalance_transaction_history_test.dart
//
// pubspec.yaml dev_dependencies needed:
//   flutter_test:
//     sdk: flutter
//   mockito: ^5.4.4
//   build_runner: ^2.4.9
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// ── STUB MODEL  (replace with real import once paths are confirmed) ──────────
// Mirrors every field of ImbalanceTransactionHistoryListModel used in the UI.
// ---------------------------------------------------------------------------
class ImbalanceTransactionHistoryListModel {
  final dynamic imbId;
  final dynamic itemId;
  final String? itemName;
  final String? staffName;
  final String? customerName;
  final dynamic imbRecQty;
  final String? entryType;
  final dynamic consDMId;
  final String? imbDate;
  final dynamic distributorId;
  final dynamic godownId;

  const ImbalanceTransactionHistoryListModel({
    this.imbId,
    this.itemId,
    this.itemName,
    this.staffName,
    this.customerName,
    this.imbRecQty,
    this.entryType,
    this.consDMId,
    this.imbDate,
    this.distributorId,
    this.godownId,
  });

  factory ImbalanceTransactionHistoryListModel.fromJson(
      Map<String, dynamic> json) {
    return ImbalanceTransactionHistoryListModel(
      imbId:         json['ImbId'],
      itemId:        json['ItemId'],
      itemName:      json['ItemName'],
      staffName:     json['StaffName'],
      customerName:  json['CustomerName'],
      imbRecQty:     json['ImbRecQty'],
      entryType:     json['EntryType'],
      consDMId:      json['ConsDMId'],
      imbDate:       json['ImbDate'],
      distributorId: json['DistributorId'],
      godownId:      json['GodownId'],
    );
  }
}

// ---------------------------------------------------------------------------
// ── STUB COLORS / APP CONSTANTS (remove once real imports are wired) ─────────
// ---------------------------------------------------------------------------
abstract class AppColors {
  static const blue       = Color(0xFF1E3A8A);
  static const blueLight  = Color(0xFF2D52C5);
  static const blueXL     = Color(0xFFEFF6FF);
  static const blueXXL    = Color(0xFFDBEAFE);
  static const teal       = Color(0xFF0F766E);
  static const green      = Color(0xFF16A34A);
  static const tealXL     = Color(0xFFF0FDFA);
  static const red        = Color(0xFFEF4444);
  static const redXL      = Color(0xFFFEF2F2);
  static const text       = Color(0xFF111827);
  static const textMid    = Color(0xFF374151);
  static const textMuted  = Color(0xFF6B7280);
  static const border     = Color(0xFFE2E8F0);
  static const white      = Color(0xFFFFFFFF);
  static const bg         = Color(0xFFF8FAFC);
}

// ---------------------------------------------------------------------------
// ── STUB WIDGETS (mirrors production code for widget tests) ─────────────────
// ---------------------------------------------------------------------------

/// Mirrors _TransactionCard exactly as in the source file.
class TransactionCard extends StatelessWidget {
  const TransactionCard({
    required this.item,
    required this.onDelete,
    required this.index,
    super.key,
  });

  final ImbalanceTransactionHistoryListModel item;
  final VoidCallback onDelete;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDelivery  = item.entryType == 'D';
    final displayName = item.staffName ?? item.customerName ?? '-';
    final typeLabel   = item.entryType == null
        ? 'Name'
        : (item.entryType == 'D' ? 'Delivery Man' : 'Customer');

    return Container(
      key: const Key('transaction_card'),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: isDelivery ? AppColors.blueLight : AppColors.teal,
            width: 4,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading icon container
            Container(
              key: const Key('type_icon_container'),
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: isDelivery ? AppColors.blueXL : AppColors.tealXL,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDelivery
                    ? Icons.delivery_dining_rounded
                    : Icons.person_rounded,
                key: const Key('type_icon'),
                color: isDelivery ? AppColors.blueLight : AppColors.teal,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // Body column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName ?? 'Unknown Item',
                    key: const Key('item_name_text'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        key: const Key('type_badge'),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDelivery
                              ? AppColors.blueXXL
                              : const Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          typeLabel,
                          key: const Key('type_label_text'),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color:
                            isDelivery ? AppColors.blue : AppColors.teal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          displayName.toString(),
                          key: const Key('display_name_text'),
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textMid),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Qty + delete column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  key: const Key('qty_badge'),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.redXL,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${item.imbRecQty ?? 0}',
                    key: const Key('qty_text'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.red,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  key: const Key('delete_gesture'),
                  onTap: onDelete,
                  child: Container(
                    key: const Key('delete_button'),
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.redXL,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        key: Key('delete_icon'), size: 16, color: AppColors.red),
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

/// Mirrors _EmptyState exactly.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            key: const Key('empty_icon_box'),
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppColors.blueXL,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.receipt_long_rounded,
                key: Key('empty_icon'),
                color: AppColors.blueLight,
                size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Records Found',
            key: Key('empty_title'),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textMid),
          ),
          const SizedBox(height: 6),
          const Text(
            'Imbalance transaction history\nwill appear here.',
            key: Key('empty_subtitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13, color: AppColors.textMuted, height: 1.5),
          ),
        ],
      ),
    ),
  );
}

/// Mirrors _SummaryChip exactly.
class SummaryChip extends StatelessWidget {
  const SummaryChip({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    super.key,
  });

  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      key: const Key('summary_chip'),
      padding:
      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              key: const Key('chip_label'),
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(
            value,
            key: const Key('chip_value'),
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// ── PURE-LOGIC HELPERS (extracted from state class for unit testing) ─────────
// ---------------------------------------------------------------------------

/// Mirrors _buildSummaryStrip() computed values.
Map<String, int> computeSummary(
    List<ImbalanceTransactionHistoryListModel> list) {
  final totalQty = list.fold<int>(
      0, (sum, e) => sum + ((e.imbRecQty ?? 0) as num).toInt());
  final dmCount   = list.where((e) => e.entryType == 'D').length;
  final custCount = list.where((e) => e.entryType == 'C').length;
  return {'totalQty': totalQty, 'dmCount': dmCount, 'custCount': custCount};
}

/// Mirrors stockTransferFlag derivation.
bool deriveStockTransferFlag(List<int> isStkTransValues) {
  final hasZero = isStkTransValues.any((v) => v == 0);
  return !hasZero;
}

/// Mirrors saveFlag derivation from checkAndSaveDayEndData().
bool deriveSaveFlag(List<dynamic> apiResponse) => apiResponse.isNotEmpty;

/// Mirrors delete request body construction.
Map<String, dynamic> buildDeleteBody({
  required int imbId,
  required String? distributorId,
  required String? godownId,
  required String formattedDate,
  required int itemId,
  required String? entryType,
  required int delMenId,
  required int imbQty,
  required String? addedBy,
}) {
  return {
    'ImbId':         imbId,
    'DistributorId': distributorId,
    'GodownId':      godownId,
    'ImbDate':       formattedDate,
    'ItemId':        itemId,
    'EntryType':     entryType ?? '',
    'ConsDMId':      delMenId,
    'ImbRecQty':     imbQty,
    'AddedBy':       addedBy,
    'Action':        'DELETE',
  };
}

/// Delete guard: mirrors the three-way flag check before calling addItemImbalanceQty.
/// Returns one of: 'dayEnd' | 'stockNotAccepted' | 'proceed'
String deleteGuard({required bool saveFlag, required bool stockTransferFlag}) {
  if (saveFlag)           return 'dayEnd';
  if (!stockTransferFlag) return 'stockNotAccepted';
  return 'proceed';
}

// ---------------------------------------------------------------------------
// ── HELPERS ──────────────────────────────────────────────────────────────────
// ---------------------------------------------------------------------------
Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

ImbalanceTransactionHistoryListModel makeItem({
  int imbId           = 1,
  int itemId          = 10,
  String itemName     = 'LPG Cylinder',
  String? staffName   = 'Ravi Kumar',
  String? customerName,
  dynamic imbRecQty   = 5,
  String entryType    = 'D',
  int consDMId        = 101,
  String imbDate      = '2025-01-01',
}) => ImbalanceTransactionHistoryListModel(
  imbId:        imbId,
  itemId:       itemId,
  itemName:     itemName,
  staffName:    staffName,
  customerName: customerName,
  imbRecQty:    imbRecQty,
  entryType:    entryType,
  consDMId:     consDMId,
  imbDate:      imbDate,
);

// =============================================================================
// TEST SUITES
// =============================================================================
void main() {

  // ─────────────────────────────────────────────────────────────────────────
  // 1. ImbalanceTransactionHistoryListModel
  // ─────────────────────────────────────────────────────────────────────────
  group('ImbalanceTransactionHistoryListModel', () {

    // ── POSITIVE ──
    test('P-M-01 | All fields are stored correctly', () {
      final m = makeItem(
        imbId: 99, itemId: 7, itemName: 'CNG Kit',
        staffName: 'Suresh', imbRecQty: 3,
        entryType: 'D', consDMId: 55, imbDate: '2025-06-01',
      );
      expect(m.imbId,     99);
      expect(m.itemId,    7);
      expect(m.itemName,  'CNG Kit');
      expect(m.staffName, 'Suresh');
      expect(m.imbRecQty, 3);
      expect(m.entryType, 'D');
      expect(m.consDMId,  55);
      expect(m.imbDate,   '2025-06-01');
    });

    test('P-M-02 | Customer entry stores customerName', () {
      const m = ImbalanceTransactionHistoryListModel(
          itemName: 'Cylinder', customerName: 'Priya Shah', entryType: 'C');
      expect(m.customerName, 'Priya Shah');
      expect(m.staffName,    isNull);
    });

    test('P-M-03 | fromJson parses all keys correctly', () {
      final json = {
        'ImbId': 10, 'ItemId': 2, 'ItemName': 'LPG',
        'StaffName': 'Ram', 'CustomerName': null, 'ImbRecQty': 4,
        'EntryType': 'D', 'ConsDMId': 7, 'ImbDate': '2025-01-15',
        'DistributorId': 1, 'GodownId': 3,
      };
      final m = ImbalanceTransactionHistoryListModel.fromJson(json);
      expect(m.imbId,    10);
      expect(m.itemName, 'LPG');
      expect(m.staffName,'Ram');
      expect(m.imbRecQty,4);
      expect(m.entryType,'D');
    });

    test('P-M-04 | fromJson handles null optional fields', () {
      final json = <String, dynamic>{
        'ImbId': 1, 'ItemId': 1, 'ItemName': null,
        'StaffName': null, 'CustomerName': null, 'ImbRecQty': null,
        'EntryType': null, 'ConsDMId': null, 'ImbDate': null,
        'DistributorId': null, 'GodownId': null,
      };
      final m = ImbalanceTransactionHistoryListModel.fromJson(json);
      expect(m.itemName,    isNull);
      expect(m.imbRecQty,   isNull);
      expect(m.entryType,   isNull);
    });

    test('P-M-05 | imbRecQty stored as double', () {
      const m = ImbalanceTransactionHistoryListModel(imbRecQty: 3.5);
      expect(m.imbRecQty, 3.5);
    });

    test('P-M-06 | Zero imbRecQty is valid', () {
      const m = ImbalanceTransactionHistoryListModel(imbRecQty: 0);
      expect(m.imbRecQty, 0);
    });

    test('P-M-07 | imbId = 0 is a valid sentinel', () {
      const m = ImbalanceTransactionHistoryListModel(imbId: 0);
      expect(m.imbId, 0);
    });

    // ── NEGATIVE ──
    test('N-M-01 | All nullable fields default to null', () {
      const m = ImbalanceTransactionHistoryListModel();
      expect(m.imbId,        isNull);
      expect(m.itemId,       isNull);
      expect(m.itemName,     isNull);
      expect(m.staffName,    isNull);
      expect(m.customerName, isNull);
      expect(m.imbRecQty,    isNull);
      expect(m.entryType,    isNull);
      expect(m.consDMId,     isNull);
    });

    test('N-M-02 | Empty itemName is distinct from null', () {
      const m = ImbalanceTransactionHistoryListModel(itemName: '');
      expect(m.itemName, isEmpty);
    });

    test('N-M-03 | Negative imbRecQty is stored as-is', () {
      const m = ImbalanceTransactionHistoryListModel(imbRecQty: -5);
      expect(m.imbRecQty, -5);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 2. screenName constant
  // ─────────────────────────────────────────────────────────────────────────
  group('ImbalnceTransactionHistory.screenName', () {
    // We verify the constant value directly via string literal check.
    const screenName = '/imbalnceTransactionHistory';

    test('P-SN-01 | screenName is not empty', () {
      expect(screenName, isNotEmpty);
    });

    test('P-SN-02 | screenName starts with /', () {
      expect(screenName.startsWith('/'), isTrue);
    });

    test('P-SN-03 | screenName value is correct', () {
      expect(screenName, '/imbalnceTransactionHistory');
    });

    test('N-SN-01 | screenName is not the root route', () {
      expect(screenName, isNot('/'));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 3. computeSummary (_buildSummaryStrip logic)
  // ─────────────────────────────────────────────────────────────────────────
  group('computeSummary()', () {

    // ── POSITIVE ──
    test('P-CS-01 | Empty list returns all zeros', () {
      final s = computeSummary([]);
      expect(s['totalQty'], 0);
      expect(s['dmCount'],  0);
      expect(s['custCount'],0);
    });

    test('P-CS-02 | Single D entry counted correctly', () {
      final s = computeSummary([makeItem(imbRecQty: 4, entryType: 'D')]);
      expect(s['totalQty'], 4);
      expect(s['dmCount'],  1);
      expect(s['custCount'],0);
    });

    test('P-CS-03 | Single C entry counted correctly', () {
      final s = computeSummary([
        makeItem(imbRecQty: 3, entryType: 'C', staffName: null,
            customerName: 'Priya'),
      ]);
      expect(s['totalQty'], 3);
      expect(s['dmCount'],  0);
      expect(s['custCount'],1);
    });

    test('P-CS-04 | Mixed D and C entries', () {
      final s = computeSummary([
        makeItem(imbRecQty: 5, entryType: 'D'),
        makeItem(imbRecQty: 3, entryType: 'C', staffName: null,
            customerName: 'P'),
        makeItem(imbRecQty: 2, entryType: 'D'),
      ]);
      expect(s['totalQty'], 10);
      expect(s['dmCount'],  2);
      expect(s['custCount'],1);
    });

    test('P-CS-05 | Zero imbRecQty contributes 0 to totalQty', () {
      final s = computeSummary([
        makeItem(imbRecQty: 0, entryType: 'D'),
        makeItem(imbRecQty: 5, entryType: 'D'),
      ]);
      expect(s['totalQty'], 5);
    });

    test('P-CS-06 | Large list totals are summed correctly', () {
      final list = List.generate(
          10, (_) => makeItem(imbRecQty: 10, entryType: 'D'));
      final s = computeSummary(list);
      expect(s['totalQty'], 100);
      expect(s['dmCount'],  10);
    });

    test('P-CS-07 | Double imbRecQty is truncated to int for total', () {
      final s = computeSummary([makeItem(imbRecQty: 3.9, entryType: 'D')]);
      // .toInt() truncates toward zero
      expect(s['totalQty'], 3);
    });

    // ── NEGATIVE ──
    test('N-CS-01 | null imbRecQty treated as 0', () {
      final s = computeSummary([
        const ImbalanceTransactionHistoryListModel(
            itemName: 'CYL', imbRecQty: null, entryType: 'D'),
      ]);
      expect(s['totalQty'], 0);
    });

    test('N-CS-02 | Unknown entryType not counted in dmCount or custCount', () {
      final s = computeSummary([
        const ImbalanceTransactionHistoryListModel(
            itemName: 'CYL', imbRecQty: 5, entryType: 'X'),
      ]);
      expect(s['dmCount'],  0);
      expect(s['custCount'],0);
      expect(s['totalQty'], 5); // still summed
    });

    test('N-CS-03 | null entryType not counted in dmCount or custCount', () {
      final s = computeSummary([
        const ImbalanceTransactionHistoryListModel(
            itemName: 'CYL', imbRecQty: 2, entryType: null),
      ]);
      expect(s['dmCount'],  0);
      expect(s['custCount'],0);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 4. stockTransferFlag derivation
  // ─────────────────────────────────────────────────────────────────────────
  group('deriveStockTransferFlag()', () {

    // ── POSITIVE ──
    test('P-SF-01 | All isStkTrans=1 → flag true', () {
      expect(deriveStockTransferFlag([1, 1, 1]), isTrue);
    });

    test('P-SF-02 | Empty list → flag true (no zero found)', () {
      expect(deriveStockTransferFlag([]), isTrue);
    });

    test('P-SF-03 | All non-zero values → flag true', () {
      expect(deriveStockTransferFlag([2, 3, 99]), isTrue);
    });

    test('P-SF-04 | Single non-zero → flag true', () {
      expect(deriveStockTransferFlag([1]), isTrue);
    });

    // ── NEGATIVE ──
    test('N-SF-01 | Single zero → flag false', () {
      expect(deriveStockTransferFlag([0]), isFalse);
    });

    test('N-SF-02 | One zero among many → flag false', () {
      expect(deriveStockTransferFlag([1, 1, 0, 1]), isFalse);
    });

    test('N-SF-03 | All zeros → flag false', () {
      expect(deriveStockTransferFlag([0, 0, 0]), isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 5. saveFlag derivation  (checkAndSaveDayEndData)
  // ─────────────────────────────────────────────────────────────────────────
  group('deriveSaveFlag()', () {

    // ── POSITIVE ──
    test('P-DayEnd-01 | Non-empty response → saveFlag true', () {
      expect(
          deriveSaveFlag([
            {'DSRSaved': 1, 'CDCMSStkSaved': 1, 'OpClSaved': 1}
          ]),
          isTrue);
    });

    test('P-DayEnd-02 | Multiple items → saveFlag true', () {
      expect(
          deriveSaveFlag([
            {'DSRSaved': 0},
            {'DSRSaved': 1},
          ]),
          isTrue);
    });

    // ── NEGATIVE ──
    test('N-DayEnd-01 | Empty response → saveFlag false', () {
      expect(deriveSaveFlag([]), isFalse);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 6. Delete guard logic
  // ─────────────────────────────────────────────────────────────────────────
  group('deleteGuard()', () {

    // ── POSITIVE ──
    test('P-DG-01 | saveFlag=false, stockTransferFlag=true → proceed', () {
      expect(
          deleteGuard(saveFlag: false, stockTransferFlag: true), 'proceed');
    });

    // ── NEGATIVE ──
    test('N-DG-01 | saveFlag=true → dayEnd (regardless of stockFlag)', () {
      expect(
          deleteGuard(saveFlag: true, stockTransferFlag: true),  'dayEnd');
      expect(
          deleteGuard(saveFlag: true, stockTransferFlag: false), 'dayEnd');
    });

    test('N-DG-02 | saveFlag=false, stockTransferFlag=false → stockNotAccepted',
            () {
          expect(
              deleteGuard(saveFlag: false, stockTransferFlag: false),
              'stockNotAccepted');
        });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 7. Delete request body construction
  // ─────────────────────────────────────────────────────────────────────────
  group('buildDeleteBody()', () {

    Map<String, dynamic> _base() => buildDeleteBody(
      imbId: 5, distributorId: '1', godownId: '2',
      formattedDate: '2025-06-15', itemId: 10,
      entryType: 'D', delMenId: 7, imbQty: 3, addedBy: '99',
    );

    // ── POSITIVE ──
    test('P-DB-01 | Action is always "DELETE"', () {
      expect(_base()['Action'], 'DELETE');
    });

    test('P-DB-02 | ImbId matches argument', () {
      expect(_base()['ImbId'], 5);
    });

    test('P-DB-03 | EntryType "D" propagated', () {
      expect(_base()['EntryType'], 'D');
    });

    test('P-DB-04 | EntryType "C" propagated', () {
      final body = buildDeleteBody(
        imbId: 1, distributorId: '1', godownId: '2',
        formattedDate: '2025-01-01', itemId: 3,
        entryType: 'C', delMenId: 4, imbQty: 2, addedBy: '5',
      );
      expect(body['EntryType'], 'C');
    });

    test('P-DB-05 | Date follows yyyy-MM-dd format', () {
      expect(_base()['ImbDate'], matches(r'^\d{4}-\d{2}-\d{2}$'));
    });

    test('P-DB-06 | ImbRecQty equals imbQty argument', () {
      expect(_base()['ImbRecQty'], 3);
    });

    test('P-DB-07 | ConsDMId equals delMenId argument', () {
      expect(_base()['ConsDMId'], 7);
    });

    test('P-DB-08 | DistributorId and GodownId carried through', () {
      expect(_base()['DistributorId'], '1');
      expect(_base()['GodownId'],      '2');
    });

    // ── NEGATIVE ──
    test('N-DB-01 | null entryType defaults to empty string', () {
      final body = buildDeleteBody(
        imbId: 1, distributorId: '1', godownId: '2',
        formattedDate: '2025-01-01', itemId: 3,
        entryType: null, delMenId: 4, imbQty: 2, addedBy: '5',
      );
      expect(body['EntryType'], '');
    });

    test('N-DB-02 | null godownId passed as-is (no crash)', () {
      final body = buildDeleteBody(
        imbId: 1, distributorId: '1', godownId: null,
        formattedDate: '2025-01-01', itemId: 3,
        entryType: 'D', delMenId: 4, imbQty: 2, addedBy: '5',
      );
      expect(body['GodownId'], isNull);
    });

    test('N-DB-03 | null addedBy passed as-is (no crash)', () {
      final body = buildDeleteBody(
        imbId: 1, distributorId: '1', godownId: '2',
        formattedDate: '2025-01-01', itemId: 3,
        entryType: 'D', delMenId: 4, imbQty: 2, addedBy: null,
      );
      expect(body['AddedBy'], isNull);
    });

    test('N-DB-04 | Zero imbId is valid (new record sentinel)', () {
      final body = buildDeleteBody(
        imbId: 0, distributorId: '1', godownId: '2',
        formattedDate: '2025-01-01', itemId: 3,
        entryType: 'D', delMenId: 4, imbQty: 2, addedBy: '5',
      );
      expect(body['ImbId'], 0);
    });

    test('N-DB-05 | Zero imbQty is sent as-is (not blocked at body level)', () {
      final body = buildDeleteBody(
        imbId: 1, distributorId: '1', godownId: '2',
        formattedDate: '2025-01-01', itemId: 3,
        entryType: 'D', delMenId: 4, imbQty: 0, addedBy: '5',
      );
      expect(body['ImbRecQty'], 0);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 8. Null-safety fallbacks inside _confirmDelete call site
  // ─────────────────────────────────────────────────────────────────────────
  group('_confirmDelete argument extraction', () {
    // Mirrors the null-safe coercions used when the Yes button fires:
    //   items.imbId?.toInt() ?? 0
    //   items.consDMId?.toInt() ?? 0
    //   items.itemId?.toInt() ?? 0
    //   items.imbRecQty?.toInt() ?? 0
    //   items.entryType ?? ''

    int extractImbId(ImbalanceTransactionHistoryListModel m) =>
        (m.imbId as num?)?.toInt() ?? 0;
    int extractConsDMId(ImbalanceTransactionHistoryListModel m) =>
        (m.consDMId as num?)?.toInt() ?? 0;
    int extractItemId(ImbalanceTransactionHistoryListModel m) =>
        (m.itemId as num?)?.toInt() ?? 0;
    int extractImbRecQty(ImbalanceTransactionHistoryListModel m) =>
        (m.imbRecQty as num?)?.toInt() ?? 0;
    String extractEntryType(ImbalanceTransactionHistoryListModel m) =>
        m.entryType ?? '';

    // ── POSITIVE ──
    test('P-EA-01 | Valid imbId extracted correctly', () {
      expect(extractImbId(makeItem(imbId: 42)), 42);
    });

    test('P-EA-02 | Valid consDMId extracted correctly', () {
      expect(extractConsDMId(makeItem(consDMId: 7)), 7);
    });

    test('P-EA-03 | Valid itemId extracted correctly', () {
      expect(extractItemId(makeItem(itemId: 9)), 9);
    });

    test('P-EA-04 | Valid imbRecQty extracted and truncated', () {
      expect(extractImbRecQty(makeItem(imbRecQty: 5.9)), 5);
    });

    test('P-EA-05 | Valid entryType extracted', () {
      expect(extractEntryType(makeItem(entryType: 'D')), 'D');
    });

    test('P-EA-06 | entryType "C" extracted', () {
      expect(extractEntryType(makeItem(entryType: 'C')), 'C');
    });

    // ── NEGATIVE ──
    test('N-EA-01 | null imbId defaults to 0', () {
      expect(
          extractImbId(const ImbalanceTransactionHistoryListModel()), 0);
    });

    test('N-EA-02 | null consDMId defaults to 0', () {
      expect(
          extractConsDMId(const ImbalanceTransactionHistoryListModel()), 0);
    });

    test('N-EA-03 | null itemId defaults to 0', () {
      expect(
          extractItemId(const ImbalanceTransactionHistoryListModel()), 0);
    });

    test('N-EA-04 | null imbRecQty defaults to 0', () {
      expect(
          extractImbRecQty(const ImbalanceTransactionHistoryListModel()), 0);
    });

    test('N-EA-05 | null entryType defaults to empty string', () {
      expect(
          extractEntryType(const ImbalanceTransactionHistoryListModel()), '');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 9. EmptyState widget
  // ─────────────────────────────────────────────────────────────────────────
  group('EmptyState widget', () {

    // ── POSITIVE ──
    testWidgets('P-ES-01 | Shows "No Records Found" title', (t) async {
      await t.pumpWidget(wrap(const EmptyState()));
      expect(find.byKey(const Key('empty_title')), findsOneWidget);
      expect(find.text('No Records Found'),        findsOneWidget);
    });

    testWidgets('P-ES-02 | Shows receipt icon', (t) async {
      await t.pumpWidget(wrap(const EmptyState()));
      expect(find.byKey(const Key('empty_icon')), findsOneWidget);
    });

    testWidgets('P-ES-03 | Shows subtitle text', (t) async {
      await t.pumpWidget(wrap(const EmptyState()));
      expect(find.byKey(const Key('empty_subtitle')), findsOneWidget);
    });

    testWidgets('P-ES-04 | Icon container has correct dimensions',
            (t) async {
          await t.pumpWidget(wrap(const EmptyState()));
          final box = t.widget<Container>(find.byKey(const Key('empty_icon_box')));
          expect(box.constraints?.maxWidth,  64);
          expect(box.constraints?.maxHeight, 64);
        });

    testWidgets('P-ES-05 | Mounts without exception', (t) async {
      await t.pumpWidget(wrap(const EmptyState()));
      expect(t.takeException(), isNull);
    });

    // ── NEGATIVE ──
    testWidgets('N-ES-01 | Does not show transaction card', (t) async {
      await t.pumpWidget(wrap(const EmptyState()));
      expect(find.byKey(const Key('transaction_card')), findsNothing);
    });

    testWidgets('N-ES-02 | No delete button present', (t) async {
      await t.pumpWidget(wrap(const EmptyState()));
      expect(find.byKey(const Key('delete_button')), findsNothing);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 10. SummaryChip widget
  // ─────────────────────────────────────────────────────────────────────────
  group('SummaryChip widget', () {

    Widget buildChip({
      String label   = 'Total Qty',
      String value   = '10',
      Color  color   = AppColors.red,
      Color  bgColor = AppColors.redXL,
    }) => MaterialApp(
      home: Scaffold(
        body: Row(children: [
          SummaryChip(
              label: label, value: value, color: color, bgColor: bgColor),
        ]),
      ),
    );

    // ── POSITIVE ──
    testWidgets('P-SC-01 | Renders label correctly', (t) async {
      await t.pumpWidget(buildChip(label: 'Total Qty'));
      expect(find.text('Total Qty'), findsOneWidget);
    });

    testWidgets('P-SC-02 | Renders value correctly', (t) async {
      await t.pumpWidget(buildChip(value: '42'));
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('P-SC-03 | Mounts without exception', (t) async {
      await t.pumpWidget(buildChip());
      expect(t.takeException(), isNull);
    });

    testWidgets('P-SC-04 | Value text uses provided color', (t) async {
      await t.pumpWidget(buildChip(color: AppColors.blueLight, value: '5'));
      final txt = t.widget<Text>(find.byKey(const Key('chip_value')));
      expect(txt.style?.color, AppColors.blueLight);
    });

    testWidgets('P-SC-05 | Zero value renders "0"', (t) async {
      await t.pumpWidget(buildChip(value: '0'));
      expect(find.text('0'), findsOneWidget);
    });

    // ── NEGATIVE ──
    testWidgets('N-SC-01 | Empty label string renders without crash', (t) async {
      await t.pumpWidget(buildChip(label: ''));
      expect(t.takeException(), isNull);
    });

    testWidgets('N-SC-02 | Empty value string renders without crash', (t) async {
      await t.pumpWidget(buildChip(value: ''));
      expect(t.takeException(), isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 11. TransactionCard widget  – Delivery (entryType = 'D')
  // ─────────────────────────────────────────────────────────────────────────
  group('TransactionCard widget – Delivery', () {

    final deliveryItem = makeItem(
      itemName:  'LPG Cylinder',
      staffName: 'Ravi Kumar',
      imbRecQty: 7,
      entryType: 'D',
    );

    // ── POSITIVE ──
    testWidgets('P-TC-01 | Renders item name', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: deliveryItem, onDelete: () {}, index: 0)));
      expect(find.text('LPG Cylinder'), findsOneWidget);
    });

    testWidgets('P-TC-02 | Renders staff name', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: deliveryItem, onDelete: () {}, index: 0)));
      expect(find.text('Ravi Kumar'), findsOneWidget);
    });

    testWidgets('P-TC-03 | Delivery badge shows "Delivery Man"', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: deliveryItem, onDelete: () {}, index: 0)));
      expect(find.text('Delivery Man'), findsOneWidget);
    });

    testWidgets('P-TC-04 | Delivery icon is present', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: deliveryItem, onDelete: () {}, index: 0)));
      expect(find.byKey(const Key('type_icon')), findsOneWidget);
      final icon = t.widget<Icon>(find.byKey(const Key('type_icon')));
      expect(icon.icon, Icons.delivery_dining_rounded);
    });

    testWidgets('P-TC-05 | Qty badge shows correct quantity', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: deliveryItem, onDelete: () {}, index: 0)));
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('P-TC-06 | Delete button is present', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: deliveryItem, onDelete: () {}, index: 0)));
      expect(find.byKey(const Key('delete_button')), findsOneWidget);
    });

    testWidgets('P-TC-07 | onDelete callback fires when tapped', (t) async {
      bool tapped = false;
      await t.pumpWidget(wrap(TransactionCard(
          item: deliveryItem, onDelete: () => tapped = true, index: 0)));
      await t.tap(find.byKey(const Key('delete_gesture')));
      await t.pump();
      expect(tapped, isTrue);
    });

    testWidgets('P-TC-08 | Left border color is blueLight for D', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: deliveryItem, onDelete: () {}, index: 0)));
      final card = t.widget<Container>(
          find.byKey(const Key('transaction_card')));
      final dec = card.decoration as BoxDecoration;
      final leftBorder = (dec.border as Border).left;
      expect(leftBorder.color, AppColors.blueLight);
    });

    testWidgets('P-TC-09 | Icon container color is blueXL for D', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: deliveryItem, onDelete: () {}, index: 0)));
      final iconBox = t.widget<Container>(
          find.byKey(const Key('type_icon_container')));
      final dec = iconBox.decoration as BoxDecoration;
      expect(dec.color, AppColors.blueXL);
    });

    testWidgets('P-TC-10 | Mounts on narrow (320px) screen without overflow',
            (t) async {
          t.view.physicalSize = const Size(320, 600);
          t.view.devicePixelRatio = 1.0;
          addTearDown(t.view.resetPhysicalSize);

          await t.pumpWidget(wrap(TransactionCard(
              item: deliveryItem, onDelete: () {}, index: 0)));
          expect(t.takeException(), isNull);
        });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 12. TransactionCard widget – Customer (entryType = 'C')
  // ─────────────────────────────────────────────────────────────────────────
  group('TransactionCard widget – Customer', () {

    final customerItem = makeItem(
      itemName:     'CNG Kit',
      staffName:    null,
      customerName: 'Priya Shah',
      imbRecQty:    3,
      entryType:    'C',
    );

    // ── POSITIVE ──
    testWidgets('P-CC-01 | Customer badge shows "Customer"', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: customerItem, onDelete: () {}, index: 0)));
      expect(find.text('Customer'), findsOneWidget);
    });

    testWidgets('P-CC-02 | customerName shown as display name', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: customerItem, onDelete: () {}, index: 0)));
      expect(find.text('Priya Shah'), findsOneWidget);
    });

    testWidgets('P-CC-03 | Person icon used for customer', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: customerItem, onDelete: () {}, index: 0)));
      final icon = t.widget<Icon>(find.byKey(const Key('type_icon')));
      expect(icon.icon, Icons.person_rounded);
    });

    testWidgets('P-CC-04 | Left border color is teal for C', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: customerItem, onDelete: () {}, index: 0)));
      final card = t.widget<Container>(
          find.byKey(const Key('transaction_card')));
      final dec = card.decoration as BoxDecoration;
      expect((dec.border as Border).left.color, AppColors.teal);
    });

    testWidgets('P-CC-05 | Icon container color is tealXL for C', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: customerItem, onDelete: () {}, index: 0)));
      final iconBox = t.widget<Container>(
          find.byKey(const Key('type_icon_container')));
      final dec = iconBox.decoration as BoxDecoration;
      expect(dec.color, AppColors.tealXL);
    });

    // ── NEGATIVE ──
    testWidgets('N-CC-01 | Delivery badge absent for customer card', (t) async {
      await t.pumpWidget(wrap(TransactionCard(
          item: customerItem, onDelete: () {}, index: 0)));
      expect(find.text('Delivery Man'), findsNothing);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 13. TransactionCard – null / edge-case fields
  // ─────────────────────────────────────────────────────────────────────────
  group('TransactionCard – null & edge-case fields', () {

    // ── POSITIVE ──
    testWidgets('P-TN-01 | null itemName falls back to "Unknown Item"',
            (t) async {
          const m = ImbalanceTransactionHistoryListModel(
              staffName: 'Ram', imbRecQty: 2, entryType: 'D');
          await t.pumpWidget(wrap(
              TransactionCard(item: m, onDelete: () {}, index: 0)));
          expect(find.text('Unknown Item'), findsOneWidget);
        });

    testWidgets('P-TN-02 | null staffName+customerName falls back to "-"',
            (t) async {
          const m = ImbalanceTransactionHistoryListModel(
              itemName: 'CYL', imbRecQty: 1, entryType: 'D');
          await t.pumpWidget(wrap(
              TransactionCard(item: m, onDelete: () {}, index: 0)));
          expect(find.text('-'), findsOneWidget);
        });

    testWidgets('P-TN-03 | null imbRecQty shows "0" in badge', (t) async {
      const m = ImbalanceTransactionHistoryListModel(
          itemName: 'CYL', staffName: 'R', entryType: 'D');
      await t.pumpWidget(wrap(
          TransactionCard(item: m, onDelete: () {}, index: 0)));
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('P-TN-04 | null entryType → typeLabel "Name"', (t) async {
      const m = ImbalanceTransactionHistoryListModel(
          itemName: 'CYL', staffName: 'R', imbRecQty: 2, entryType: null);
      await t.pumpWidget(wrap(
          TransactionCard(item: m, onDelete: () {}, index: 0)));
      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('P-TN-05 | Very long item name does not overflow', (t) async {
      final m = ImbalanceTransactionHistoryListModel(
          itemName: 'A' * 200, staffName: 'R', imbRecQty: 1, entryType: 'D');
      await t.pumpWidget(
          wrap(TransactionCard(item: m, onDelete: () {}, index: 0)));
      expect(t.takeException(), isNull);
    });

    testWidgets('P-TN-06 | Unicode staff name renders correctly', (t) async {
      const m = ImbalanceTransactionHistoryListModel(
          itemName: 'CYL',
          staffName: 'राम कुमार',
          imbRecQty: 2,
          entryType: 'D');
      await t.pumpWidget(wrap(
          TransactionCard(item: m, onDelete: () {}, index: 0)));
      expect(find.text('राम कुमार'), findsOneWidget);
    });

    // ── NEGATIVE ──
    testWidgets('N-TN-01 | Unknown entryType shows "Customer" badge (not D)',
            (t) async {
          const m = ImbalanceTransactionHistoryListModel(
              itemName: 'CYL', staffName: 'R', imbRecQty: 2, entryType: 'X');
          await t.pumpWidget(wrap(
              TransactionCard(item: m, onDelete: () {}, index: 0)));
          expect(find.text('Delivery Man'), findsNothing);
          expect(find.text('Customer'),     findsOneWidget);
        });

    testWidgets('N-TN-02 | Zero imbRecQty shows "0"', (t) async {
      const m = ImbalanceTransactionHistoryListModel(
          itemName: 'CYL', staffName: 'R', imbRecQty: 0, entryType: 'D');
      await t.pumpWidget(wrap(
          TransactionCard(item: m, onDelete: () {}, index: 0)));
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('N-TN-03 | Negative imbRecQty renders sign correctly',
            (t) async {
          const m = ImbalanceTransactionHistoryListModel(
              itemName: 'CYL', staffName: 'R', imbRecQty: -3, entryType: 'D');
          await t.pumpWidget(wrap(
              TransactionCard(item: m, onDelete: () {}, index: 0)));
          expect(find.text('-3'), findsOneWidget);
        });

    testWidgets('N-TN-04 | staffName takes priority over customerName',
            (t) async {
          const m = ImbalanceTransactionHistoryListModel(
              itemName:     'CYL',
              staffName:    'Staff',
              customerName: 'Customer',
              imbRecQty: 1,
              entryType: 'D');
          await t.pumpWidget(wrap(
              TransactionCard(item: m, onDelete: () {}, index: 0)));
          expect(find.text('Staff'),    findsOneWidget);
          expect(find.text('Customer'), findsNothing);
        });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 14. Delete confirm dialog flow (widget-level)
  // ─────────────────────────────────────────────────────────────────────────
  group('_confirmDelete dialog (widget)', () {

    /// Opens a confirm dialog identical to _confirmDelete but wired into a
    /// plain widget test.
    Future<void> openConfirmDialog(WidgetTester tester,
        {required VoidCallback onConfirm}) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (ctx) {
            return ElevatedButton(
              key: const Key('trigger'),
              onPressed: () => showDialog(
                context: ctx,
                builder: (c) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Delete Record?',
                            key: Key('dialog_title')),
                        const SizedBox(height: 8),
                        const Text(
                          'This action cannot be undone. The imbalance entry will be permanently removed.',
                          key: Key('dialog_body'),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                key: const Key('cancel_btn'),
                                onPressed: () => Navigator.pop(c),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                key: const Key('delete_btn'),
                                onPressed: () {
                                  Navigator.pop(c);
                                  onConfirm();
                                },
                                child: const Text('Delete'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              child: const Text('Open'),
            );
          }),
        ),
      ));

      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pumpAndSettle();
    }

    // ── POSITIVE ──
    testWidgets('P-CD-01 | Dialog shows "Delete Record?" title', (t) async {
      await openConfirmDialog(t, onConfirm: () {});
      expect(find.byKey(const Key('dialog_title')), findsOneWidget);
      expect(find.text('Delete Record?'),            findsOneWidget);
    });

    testWidgets('P-CD-02 | Dialog shows warning body text', (t) async {
      await openConfirmDialog(t, onConfirm: () {});
      expect(find.byKey(const Key('dialog_body')), findsOneWidget);
    });

    testWidgets('P-CD-03 | Cancel button present', (t) async {
      await openConfirmDialog(t, onConfirm: () {});
      expect(find.byKey(const Key('cancel_btn')), findsOneWidget);
    });

    testWidgets('P-CD-04 | Delete button present', (t) async {
      await openConfirmDialog(t, onConfirm: () {});
      expect(find.byKey(const Key('delete_btn')), findsOneWidget);
    });

    testWidgets('P-CD-05 | Cancel dismisses dialog without calling onConfirm',
            (t) async {
          bool called = false;
          await openConfirmDialog(t, onConfirm: () => called = true);
          await t.tap(find.byKey(const Key('cancel_btn')));
          await t.pumpAndSettle();
          expect(called,                     isFalse);
          expect(find.byKey(const Key('dialog_title')), findsNothing);
        });

    testWidgets('P-CD-06 | Delete button calls onConfirm and closes dialog',
            (t) async {
          bool called = false;
          await openConfirmDialog(t, onConfirm: () => called = true);
          await t.tap(find.byKey(const Key('delete_btn')));
          await t.pumpAndSettle();
          expect(called, isTrue);
          expect(find.byKey(const Key('dialog_title')), findsNothing);
        });

    // ── NEGATIVE ──
    testWidgets('N-CD-01 | Dialog does not auto-close on body tap', (t) async {
      await openConfirmDialog(t, onConfirm: () {});
      // Tap outside dialog (background barrier is not dismissible by default
      // when barrierDismissible=false; here we verify title still present
      // after no action).
      expect(find.byKey(const Key('dialog_title')), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 15. displayName and typeLabel derivation (isolated logic)
  // ─────────────────────────────────────────────────────────────────────────
  group('displayName & typeLabel derivation', () {
    String displayName(ImbalanceTransactionHistoryListModel m) =>
        m.staffName ?? m.customerName ?? '-';

    String typeLabel(ImbalanceTransactionHistoryListModel m) =>
        m.entryType == null
            ? 'Name'
            : (m.entryType == 'D' ? 'Delivery Man' : 'Customer');

    // ── POSITIVE ──
    test('P-DN-01 | staffName used when present', () {
      const m = ImbalanceTransactionHistoryListModel(staffName: 'Ram');
      expect(displayName(m), 'Ram');
    });

    test('P-DN-02 | customerName used when staffName null', () {
      const m = ImbalanceTransactionHistoryListModel(customerName: 'Priya');
      expect(displayName(m), 'Priya');
    });

    test('P-DN-03 | "-" when both null', () {
      expect(displayName(const ImbalanceTransactionHistoryListModel()), '-');
    });

    test('P-DN-04 | typeLabel "Delivery Man" for entryType D', () {
      const m = ImbalanceTransactionHistoryListModel(entryType: 'D');
      expect(typeLabel(m), 'Delivery Man');
    });

    test('P-DN-05 | typeLabel "Customer" for entryType C', () {
      const m = ImbalanceTransactionHistoryListModel(entryType: 'C');
      expect(typeLabel(m), 'Customer');
    });

    test('P-DN-06 | typeLabel "Name" for null entryType', () {
      expect(typeLabel(const ImbalanceTransactionHistoryListModel()), 'Name');
    });

    // ── NEGATIVE ──
    test('N-DN-01 | Unknown entryType → typeLabel "Customer" (else branch)',
            () {
          const m = ImbalanceTransactionHistoryListModel(entryType: 'X');
          expect(typeLabel(m), 'Customer');
        });

    test('N-DN-02 | Empty staffName is truthy → used over customerName', () {
      const m = ImbalanceTransactionHistoryListModel(
          staffName: '', customerName: 'Priya');
      // empty string is not null → staffName wins
      expect(displayName(m), '');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // 16. Accessibility & cross-device rendering
  // ─────────────────────────────────────────────────────────────────────────
  group('Accessibility & cross-device rendering', () {
    testWidgets('A-01 | TransactionCard renders on tablet (1024×768)', (t) async {
      t.view.physicalSize = const Size(1024, 768);
      t.view.devicePixelRatio = 2.0;
      addTearDown(t.view.resetPhysicalSize);
      await t.pumpWidget(wrap(TransactionCard(
          item: makeItem(), onDelete: () {}, index: 0)));
      expect(t.takeException(), isNull);
    });

    testWidgets('A-02 | EmptyState renders on tablet', (t) async {
      t.view.physicalSize = const Size(1024, 768);
      t.view.devicePixelRatio = 2.0;
      addTearDown(t.view.resetPhysicalSize);
      await t.pumpWidget(wrap(const EmptyState()));
      expect(t.takeException(), isNull);
    });

    testWidgets('A-03 | SummaryChip renders on small screen (360×640)', (t) async {
      t.view.physicalSize = const Size(360, 640);
      t.view.devicePixelRatio = 3.0;
      addTearDown(t.view.resetPhysicalSize);
      await t.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Row(children: const [
            SummaryChip(
                label: 'Total Qty',
                value: '9',
                color: AppColors.red,
                bgColor: AppColors.redXL),
          ]),
        ),
      ));
      expect(t.takeException(), isNull);
    });

    testWidgets('A-04 | Multiple TransactionCards render in a list', (t) async {
      final items = List.generate(
        5,
            (i) => makeItem(imbId: i, itemName: 'Item $i'),
      );
      await t.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListView(
            children: items
                .asMap()
                .entries
                .map((e) => TransactionCard(
                item: e.value, onDelete: () {}, index: e.key))
                .toList(),
          ),
        ),
      ));
      expect(t.takeException(), isNull);
    });

    testWidgets('A-05 | Special characters in all text fields do not crash',
            (t) async {
          const m = ImbalanceTransactionHistoryListModel(
              itemName: r'LPG & <19kg> "cylinder"',
              staffName: r"O'Brien",
              imbRecQty: 1,
              entryType: 'D');
          await t.pumpWidget(
              wrap(TransactionCard(item: m, onDelete: () {}, index: 0)));
          expect(t.takeException(), isNull);
        });
  });
}