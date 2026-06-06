import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/DsrReportExpenseModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118,
    'Date': '2026-05-15T00:00:00',
    'expensehead': 'Vehicle Maint',
    'Cash': 440.00,
    'Bank': 0.00,
    'StaffId': 12,
    'StaffName': 'Bhagwat',
    'ExpHeadId': 3,
    'ExpenseAmount': 440.0,
    'Flag': 'N',
  };

  // ── fromJson ─────────────────────────────────────────────────────────────
  group('DsrReportExpenseModel.fromJson', () {
    test('parses all fields correctly', () {
      final m = DsrReportExpenseModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.date, '2026-05-15T00:00:00');
      expect(m.expensehead, 'Vehicle Maint');
      expect(m.cash, 440.00);
      expect(m.bank, 0.00);
      expect(m.staffId, 12);
      expect(m.staffName, 'Bhagwat');
      expect(m.expHeadId, 3);
      expect(m.expenseAmount, 440.0);
      expect(m.flag, 'N');
    });

    test('handles null fields gracefully', () {
      final m = DsrReportExpenseModel.fromJson({
        'DistributorId': 8118,
        'Date': null,
        'expensehead': null,
        'Cash': 0.0,
        'Bank': 0.0,
        'StaffId': 0,
        'StaffName': null,
        'ExpHeadId': 0,
        'ExpenseAmount': 0.0,
        'Flag': null,
      });
      expect(m.date, isNull);
      expect(m.expensehead, isNull);
      expect(m.staffName, isNull);
      expect(m.flag, isNull);
    });

    test('handles completely empty JSON', () {
      final m = DsrReportExpenseModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.cash, isNull);
      expect(m.expensehead, isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('DsrReportExpenseModel.toJson', () {
    test('serialises all fields correctly', () {
      final j = DsrReportExpenseModel.fromJson(fullJson).toJson();
      expect(j['DistributorId'], 8118);
      expect(j['expensehead'], 'Vehicle Maint');
      expect(j['Cash'], 440.00);
      expect(j['StaffName'], 'Bhagwat');
    });

    test('toJson contains 10 keys', () {
      final j = DsrReportExpenseModel.fromJson(fullJson).toJson();
      expect(j.length, 10);
    });

    test('round-trips fromJson → toJson → fromJson', () {
      final original = DsrReportExpenseModel.fromJson(fullJson);
      final restored = DsrReportExpenseModel.fromJson(original.toJson());
      expect(restored.expensehead, original.expensehead);
      expect(restored.cash, original.cash);
      expect(restored.staffName, original.staffName);
    });
  });

  // ── copyWith ─────────────────────────────────────────────────────────────
  group('DsrReportExpenseModel.copyWith', () {
    test('replaces expensehead only', () {
      final m = DsrReportExpenseModel.fromJson(fullJson);
      final copy = m.copyWith(expensehead: 'Salary');
      expect(copy.expensehead, 'Salary');
      expect(copy.cash, m.cash);
      expect(copy.distributorId, m.distributorId);
    });

    test('replaces cash and bank together', () {
      final m = DsrReportExpenseModel.fromJson(fullJson);
      final copy = m.copyWith(cash: 1000.0, bank: 500.0);
      expect(copy.cash, 1000.0);
      expect(copy.bank, 500.0);
      expect(copy.expensehead, m.expensehead);
    });

    test('copyWith without args preserves all', () {
      final m = DsrReportExpenseModel.fromJson(fullJson);
      final copy = m.copyWith();
      expect(copy.distributorId, m.distributorId);
      expect(copy.expensehead, m.expensehead);
    });
  });

  // ── Constructor ───────────────────────────────────────────────────────────
  group('DsrReportExpenseModel constructor', () {
    test('sets values via named parameters', () {
      final m = DsrReportExpenseModel(
        distributorId: 999,
        expensehead: 'Rent',
        cash: 5000.0,
        bank: 0.0,
      );
      expect(m.distributorId, 999);
      expect(m.expensehead, 'Rent');
      expect(m.cash, 5000.0);
      expect(m.bank, 0.0);
    });

    test('un-set fields default to null', () {
      final m = DsrReportExpenseModel(distributorId: 1);
      expect(m.expensehead, isNull);
      expect(m.cash, isNull);
    });
  });
}

