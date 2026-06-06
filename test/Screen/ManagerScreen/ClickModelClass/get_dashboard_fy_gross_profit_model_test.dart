import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetDashboardFYGrossProfitDtlsModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'April': 10000.00,
    'May': 20000.00,
    'June': 15000.00,
    'July': 18000.00,
    'August': 22000.00,
    'September': 12000.00,
    'October': 30000.00,
    'November': 25000.00,
    'December': 35000.00,
    'January': 40000.00,
    'February': 146142.00,
    'March': 411577.00,
  };

  // ── fromJson ─────────────────────────────────────────────────────────────
  group('GetDashboardFyGrossProfitDtlsModel.fromJson', () {
    test('parses all 12 months correctly', () {
      final m = GetDashboardFyGrossProfitDtlsModel.fromJson(fullJson);
      expect(m.april, 10000.00);
      expect(m.may, 20000.00);
      expect(m.june, 15000.00);
      expect(m.july, 18000.00);
      expect(m.august, 22000.00);
      expect(m.september, 12000.00);
      expect(m.october, 30000.00);
      expect(m.november, 25000.00);
      expect(m.december, 35000.00);
      expect(m.january, 40000.00);
      expect(m.february, 146142.00);
      expect(m.march, 411577.00);
    });

    test('handles all zero values', () {
      final json = Map.fromEntries(
        ['April','May','June','July','August','September',
         'October','November','December','January','February','March']
            .map((k) => MapEntry(k, 0.00)),
      );
      final m = GetDashboardFyGrossProfitDtlsModel.fromJson(json);
      expect(m.april, 0.00);
      expect(m.march, 0.00);
    });

    test('handles empty JSON – all months null', () {
      final m = GetDashboardFyGrossProfitDtlsModel.fromJson({});
      expect(m.april, isNull);
      expect(m.february, isNull);
      expect(m.march, isNull);
    });

    test('handles partial JSON', () {
      final m = GetDashboardFyGrossProfitDtlsModel.fromJson({'February': 146142.00, 'March': 411577.00});
      expect(m.february, 146142.00);
      expect(m.march, 411577.00);
      expect(m.april, isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('GetDashboardFyGrossProfitDtlsModel.toJson', () {
    test('serialises all 12 months', () {
      final j = GetDashboardFyGrossProfitDtlsModel.fromJson(fullJson).toJson();
      expect(j['April'], 10000.00);
      expect(j['February'], 146142.00);
      expect(j['March'], 411577.00);
    });

    test('toJson contains 12 keys', () {
      final j = GetDashboardFyGrossProfitDtlsModel.fromJson(fullJson).toJson();
      expect(j.length, 12);
    });

    test('round-trips correctly', () {
      final original = GetDashboardFyGrossProfitDtlsModel.fromJson(fullJson);
      final restored = GetDashboardFyGrossProfitDtlsModel.fromJson(original.toJson());
      expect(restored.february, original.february);
      expect(restored.march, original.march);
      expect(restored.april, original.april);
    });
  });

  // ── copyWith ─────────────────────────────────────────────────────────────
  group('GetDashboardFyGrossProfitDtlsModel.copyWith', () {
    test('replaces march value', () {
      final m = GetDashboardFyGrossProfitDtlsModel.fromJson(fullJson);
      final copy = m.copyWith(march: 999999.0);
      expect(copy.march, 999999.0);
      expect(copy.february, m.february);
    });

    test('replaces multiple months', () {
      final m = GetDashboardFyGrossProfitDtlsModel.fromJson(fullJson);
      final copy = m.copyWith(april: 1.0, may: 2.0, june: 3.0);
      expect(copy.april, 1.0);
      expect(copy.may, 2.0);
      expect(copy.june, 3.0);
      expect(copy.july, m.july);
    });

    test('copyWith without args preserves all months', () {
      final m = GetDashboardFyGrossProfitDtlsModel.fromJson(fullJson);
      final copy = m.copyWith();
      expect(copy.april, m.april);
      expect(copy.march, m.march);
    });
  });

  // ── Business-logic helpers ────────────────────────────────────────────────
  group('FY gross profit – computed totals', () {
    test('sum of all months matches expected total', () {
      final m = GetDashboardFyGrossProfitDtlsModel.fromJson(fullJson);
      final months = [
        m.april, m.may, m.june, m.july, m.august, m.september,
        m.october, m.november, m.december, m.january, m.february, m.march,
      ];
      final total = months.fold<double>(0, (s, v) => s + (v?.toDouble() ?? 0));
      expect(total, closeTo(784719.0, 0.01));
    });

    test('february and march contribute the most in FY', () {
      final m = GetDashboardFyGrossProfitDtlsModel.fromJson(fullJson);
      expect((m.march ?? 0) > (m.april ?? 0), isTrue);
      expect((m.february ?? 0) > (m.may ?? 0), isTrue);
    });
  });
}

