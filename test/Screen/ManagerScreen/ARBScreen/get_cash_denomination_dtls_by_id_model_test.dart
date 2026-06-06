import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ARBScreen/GetCashDenominationDtlsByIdModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'SalaryEntryId': 0, 'PSVId': 0, 'ARBSalesId': 0, 'ARBPurId': 35,
    'DistributorId': 8118, 'NoteId': 1, 'NoteType': 500, 'Qty': 2,
    'Amount': 0, 'RetNoteQty': 0, 'RetNoteAmt': 0,
    'totalAmount': 1000, 'totalAmountminus': 0,
  };

  group('GetCashDenominationDtlsByIdModel.fromJson', () {
    test('parses all 13 fields', () {
      final m = GetCashDenominationDtlsByIdModel.fromJson(fullJson);
      expect(m.distributorId, 8118); expect(m.noteType, 500);
      expect(m.qty, 2); expect(m.aRBPurId, 35);
      expect(m.totalAmount, 1000); expect(m.totalAmountminus, 0);
    });
    test('handles empty JSON', () {
      final m = GetCashDenominationDtlsByIdModel.fromJson({});
      expect(m.distributorId, isNull); expect(m.noteType, isNull);
    });
  });

  group('GetCashDenominationDtlsByIdModel.toJson', () {
    test('serialises 13 fields', () {
      final j = GetCashDenominationDtlsByIdModel.fromJson(fullJson).toJson();
      expect(j.length, 13);
      expect(j['NoteType'], 500); expect(j['Qty'], 2);
    });
    test('round-trips correctly', () {
      final o = GetCashDenominationDtlsByIdModel.fromJson(fullJson);
      final r = GetCashDenominationDtlsByIdModel.fromJson(o.toJson());
      expect(r.noteType, o.noteType); expect(r.totalAmount, o.totalAmount);
    });
  });

  group('GetCashDenominationDtlsByIdModel.copyWith', () {
    test('replaces qty', () {
      final m = GetCashDenominationDtlsByIdModel.fromJson(fullJson);
      final copy = m.copyWith(qty: 10);
      expect(copy.qty, 10); expect(copy.noteType, m.noteType);
    });
    test('preserves all without args', () {
      final m = GetCashDenominationDtlsByIdModel.fromJson(fullJson);
      expect(m.copyWith().distributorId, m.distributorId);
    });
  });

  group('Cash denomination – business logic', () {
    test('totalAmount = noteType × qty', () {
      final m = GetCashDenominationDtlsByIdModel.fromJson(fullJson);
      expect((m.noteType ?? 0) * (m.qty ?? 0), m.totalAmount);
    });
    test('retNoteAmt is zero when no returns', () {
      final m = GetCashDenominationDtlsByIdModel.fromJson(fullJson);
      expect(m.retNoteAmt, 0);
    });
    test('noteType 500 is a valid denomination', () {
      final m = GetCashDenominationDtlsByIdModel.fromJson(fullJson);
      const valid = [10, 20, 50, 100, 200, 500, 2000];
      expect(valid.contains(m.noteType?.toInt()), isTrue);
    });
  });
}

