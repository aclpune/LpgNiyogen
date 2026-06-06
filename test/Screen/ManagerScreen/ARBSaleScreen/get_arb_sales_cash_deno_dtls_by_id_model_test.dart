import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ARBSaleScreen/GetARBSalesCashDenoDtlsByIdModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'SalaryEntryId': 0,
    'PSVId': 0,
    'ARBSalesId': 281,
    'ARBPurId': 0,
    'DistributorId': 8118,
    'NoteId': 1,
    'NoteType': 500.00,
    'Qty': 3,
    'Amount': 1500.00,
    'RetNoteQty': 0,
    'RetNoteAmt': 0.00,
    'totalAmount': 1500.0,
    'totalAmountminus': 0.0,
  };

  // ── fromJson ─────────────────────────────────────────────────────────────
  group('GetArbSalesCashDenoDtlsByIdModel.fromJson', () {
    test('parses all 13 fields correctly', () {
      final m = GetArbSalesCashDenoDtlsByIdModel.fromJson(fullJson);
      expect(m.salaryEntryId, 0);
      expect(m.pSVId, 0);
      expect(m.aRBSalesId, 281);
      expect(m.aRBPurId, 0);
      expect(m.distributorId, 8118);
      expect(m.noteId, 1);
      expect(m.noteType, 500.00);
      expect(m.qty, 3);
      expect(m.amount, 1500.00);
      expect(m.retNoteQty, 0);
      expect(m.retNoteAmt, 0.00);
      expect(m.totalAmount, 1500.0);
      expect(m.totalAmountminus, 0.0);
    });

    test('handles all-zero JSON', () {
      final zeroJson = {for (var k in fullJson.keys) k: 0};
      final m = GetArbSalesCashDenoDtlsByIdModel.fromJson(zeroJson);
      expect(m.aRBSalesId, 0);
      expect(m.totalAmount, 0);
    });

    test('handles empty JSON', () {
      final m = GetArbSalesCashDenoDtlsByIdModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.noteType, isNull);
      expect(m.totalAmount, isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('GetArbSalesCashDenoDtlsByIdModel.toJson', () {
    test('serialises 13 fields', () {
      final j = GetArbSalesCashDenoDtlsByIdModel.fromJson(fullJson).toJson();
      expect(j.length, 13);
      expect(j['NoteType'], 500.00);
      expect(j['Qty'], 3);
      expect(j['totalAmount'], 1500.0);
    });

    test('round-trips correctly', () {
      final original = GetArbSalesCashDenoDtlsByIdModel.fromJson(fullJson);
      final restored =
          GetArbSalesCashDenoDtlsByIdModel.fromJson(original.toJson());
      expect(restored.aRBSalesId, original.aRBSalesId);
      expect(restored.noteType, original.noteType);
      expect(restored.totalAmount, original.totalAmount);
    });
  });

  // ── copyWith ─────────────────────────────────────────────────────────────
  group('GetArbSalesCashDenoDtlsByIdModel.copyWith', () {
    test('replaces qty and amount', () {
      final m = GetArbSalesCashDenoDtlsByIdModel.fromJson(fullJson);
      final copy = m.copyWith(qty: 5, amount: 2500.0);
      expect(copy.qty, 5);
      expect(copy.amount, 2500.0);
      expect(copy.noteType, m.noteType);
    });

    test('replaces totalAmount', () {
      final m = GetArbSalesCashDenoDtlsByIdModel.fromJson(fullJson);
      final copy = m.copyWith(totalAmount: 9999.0);
      expect(copy.totalAmount, 9999.0);
      expect(copy.distributorId, m.distributorId);
    });

    test('copyWith without args preserves all', () {
      final m = GetArbSalesCashDenoDtlsByIdModel.fromJson(fullJson);
      final copy = m.copyWith();
      expect(copy.aRBSalesId, m.aRBSalesId);
      expect(copy.noteId, m.noteId);
    });
  });

  // ── Business logic ────────────────────────────────────────────────────────
  group('Cash denomination – business logic', () {
    test('amount = noteType × qty', () {
      final m = GetArbSalesCashDenoDtlsByIdModel.fromJson(fullJson);
      final expected = (m.noteType ?? 0) * (m.qty ?? 0);
      expect(expected, m.amount);
    });

    test('totalAmount equals amount when retNoteAmt is zero', () {
      final m = GetArbSalesCashDenoDtlsByIdModel.fromJson(fullJson);
      expect(m.totalAmount, m.amount);
    });

    test('totalAmountminus is zero for no returns', () {
      final m = GetArbSalesCashDenoDtlsByIdModel.fromJson(fullJson);
      expect(m.totalAmountminus, 0.0);
    });

    test('noteType represents valid denomination (500)', () {
      final m = GetArbSalesCashDenoDtlsByIdModel.fromJson(fullJson);
      const validDenominations = [10, 20, 50, 100, 200, 500, 2000];
      expect(validDenominations.contains(m.noteType?.toInt()), isTrue);
    });
  });
}

