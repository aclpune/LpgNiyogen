import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetUnsettledAmountListModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118,
    'IncomeId': 0,
    'TransCate': 'DailySale',
    'Quantity': 10.0,
    'UnsettQty': 5,
    'SettQty': 5,
    'Mode': 'Cash',
    'Amount': 18000.00,
    'ItemName': '19 KG',
    'ItemId': 2,
    'Date': '0001-01-01T00:00:00',
    'StaffId': 24,
    'StaffName': 'Bhagwat',
    'Flag': 0,
    'Qty': 10,
  };

  // ── fromJson ─────────────────────────────────────────────────────────────
  group('GetUnsettledAmountListModel.fromJson', () {
    test('parses all fields correctly', () {
      final m = GetUnsettledAmountListModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.incomeId, 0);
      expect(m.transCate, 'DailySale');
      expect(m.quantity, 10.0);
      expect(m.unsettQty, 5);
      expect(m.settQty, 5);
      expect(m.mode, 'Cash');
      expect(m.amount, 18000.00);
      expect(m.itemName, '19 KG');
      expect(m.itemId, 2);
      expect(m.date, '0001-01-01T00:00:00');
      expect(m.staffId, 24);
      expect(m.staffName, 'Bhagwat');
      expect(m.flag, 0);
      expect(m.qty, 10);
    });

    test('handles null dynamic fields', () {
      final m = GetUnsettledAmountListModel.fromJson({
        'DistributorId': 8118,
        'IncomeId': 0,
        'TransCate': null,
        'Quantity': 0.0,
        'UnsettQty': 0,
        'SettQty': 0,
        'Mode': null,
        'Amount': 0.0,
        'ItemName': '19 KG',
        'ItemId': 2,
        'Date': '0001-01-01T00:00:00',
        'StaffId': 0,
        'StaffName': 'Unknown',
        'Flag': 0,
        'Qty': 0,
      });
      expect(m.transCate, isNull);
      expect(m.mode, isNull);
    });

    test('handles empty JSON', () {
      final m = GetUnsettledAmountListModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.amount, isNull);
      expect(m.staffName, isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('GetUnsettledAmountListModel.toJson', () {
    test('serialises all 15 fields', () {
      final j = GetUnsettledAmountListModel.fromJson(fullJson).toJson();
      expect(j.length, 15);
      expect(j['Amount'], 18000.00);
      expect(j['StaffName'], 'Bhagwat');
      expect(j['ItemName'], '19 KG');
    });

    test('round-trips correctly', () {
      final original = GetUnsettledAmountListModel.fromJson(fullJson);
      final restored = GetUnsettledAmountListModel.fromJson(original.toJson());
      expect(restored.amount, original.amount);
      expect(restored.staffName, original.staffName);
      expect(restored.unsettQty, original.unsettQty);
    });
  });

  // ── copyWith ─────────────────────────────────────────────────────────────
  group('GetUnsettledAmountListModel.copyWith', () {
    test('replaces amount only', () {
      final m = GetUnsettledAmountListModel.fromJson(fullJson);
      final copy = m.copyWith(amount: 0.0);
      expect(copy.amount, 0.0);
      expect(copy.staffName, m.staffName);
    });

    test('replaces unsettQty and settQty', () {
      final m = GetUnsettledAmountListModel.fromJson(fullJson);
      final copy = m.copyWith(unsettQty: 10, settQty: 0);
      expect(copy.unsettQty, 10);
      expect(copy.settQty, 0);
      expect(copy.amount, m.amount);
    });

    test('copyWith without args preserves all', () {
      final m = GetUnsettledAmountListModel.fromJson(fullJson);
      final copy = m.copyWith();
      expect(copy.itemId, m.itemId);
      expect(copy.qty, m.qty);
    });
  });

  // ── Business logic validations ────────────────────────────────────────────
  group('Unsettled amount – validation logic', () {
    test('unsettQty should not exceed qty', () {
      final m = GetUnsettledAmountListModel.fromJson(fullJson);
      final unsett = (m.unsettQty ?? 0).toInt();
      final total = (m.qty ?? 0).toInt();
      expect(unsett <= total, isTrue);
    });

    test('settQty + unsettQty equals qty', () {
      final m = GetUnsettledAmountListModel.fromJson(fullJson);
      final sum = (m.settQty ?? 0) + (m.unsettQty ?? 0);
      expect(sum, m.qty);
    });

    test('amount must be positive', () {
      final m = GetUnsettledAmountListModel.fromJson(fullJson);
      expect((m.amount ?? 0) > 0, isTrue);
    });
  });
}

