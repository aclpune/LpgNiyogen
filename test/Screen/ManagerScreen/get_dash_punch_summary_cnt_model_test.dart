import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/GetDashPuchSummaryCntModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118,
    'PunchManToday': 0,
    'PunchManAsOf': 7051,
    'PunchDACToday': 0,
    'PunchDACAsOf': 8911,
    'BkgManToday': 0,
    'BkgManAsOf': 6,
    'BkgOnlineToday': 0,
    'BkgOnlineAsOf': 932,
    'DeliveryDate': '2026-01-01T00:00:00',
    'OrderDate': '2025-02-07T00:00:00',
    'PunchManTodayPct': 0.0,
    'PunchManAsOfPct': 44.17,
    'PunchDACTodayPct': 0.0,
    'PunchDACAsOfPct': 55.83,
    'BkgManTodayPct': 0.0,
    'BkgManAsOfPct': 0.64,
    'BkgOnlineTodayPct': 0.0,
    'BkgOnlineAsOfPct': 99.36,
  };

  // ── fromJson ─────────────────────────────────────────────────────────────
  group('GetDashPunchSummaryCntModel.fromJson', () {
    test('parses all 19 fields correctly', () {
      final m = GetDashPunchSummaryCntModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.punchManToday, 0);
      expect(m.punchManAsOf, 7051);
      expect(m.punchDACToday, 0);
      expect(m.punchDACAsOf, 8911);
      expect(m.bkgManToday, 0);
      expect(m.bkgManAsOf, 6);
      expect(m.bkgOnlineToday, 0);
      expect(m.bkgOnlineAsOf, 932);
      expect(m.deliveryDate, '2026-01-01T00:00:00');
      expect(m.orderDate, '2025-02-07T00:00:00');
      expect(m.punchManTodayPct, 0.0);
      expect(m.punchManAsOfPct, 44.17);
      expect(m.punchDACTodayPct, 0.0);
      expect(m.punchDACAsOfPct, 55.83);
      expect(m.bkgManTodayPct, 0.0);
      expect(m.bkgManAsOfPct, 0.64);
      expect(m.bkgOnlineTodayPct, 0.0);
      expect(m.bkgOnlineAsOfPct, 99.36);
    });

    test('handles empty JSON – all fields null', () {
      final m = GetDashPunchSummaryCntModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.punchManAsOf, isNull);
      expect(m.deliveryDate, isNull);
    });

    test('handles partial JSON', () {
      final m = GetDashPunchSummaryCntModel.fromJson({
        'DistributorId': 1,
        'PunchManAsOf': 100,
      });
      expect(m.distributorId, 1);
      expect(m.punchManAsOf, 100);
      expect(m.bkgOnlineAsOf, isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('GetDashPunchSummaryCntModel.toJson', () {
    test('serialises 19 fields', () {
      final j = GetDashPunchSummaryCntModel.fromJson(fullJson).toJson();
      expect(j.length, 19);
    });

    test('pct values serialised correctly', () {
      final j = GetDashPunchSummaryCntModel.fromJson(fullJson).toJson();
      expect(j['PunchManAsOfPct'], 44.17);
      expect(j['PunchDACAsOfPct'], 55.83);
      expect(j['BkgOnlineAsOfPct'], 99.36);
    });

    test('round-trips correctly', () {
      final original = GetDashPunchSummaryCntModel.fromJson(fullJson);
      final restored = GetDashPunchSummaryCntModel.fromJson(original.toJson());
      expect(restored.punchManAsOf, original.punchManAsOf);
      expect(restored.bkgOnlineAsOfPct, original.bkgOnlineAsOfPct);
      expect(restored.deliveryDate, original.deliveryDate);
    });
  });

  // ── copyWith ─────────────────────────────────────────────────────────────
  group('GetDashPunchSummaryCntModel.copyWith', () {
    test('replaces punchManAsOf', () {
      final m = GetDashPunchSummaryCntModel.fromJson(fullJson);
      final copy = m.copyWith(punchManAsOf: 9999);
      expect(copy.punchManAsOf, 9999);
      expect(copy.punchDACAsOf, m.punchDACAsOf);
    });

    test('replaces delivery and order dates', () {
      final m = GetDashPunchSummaryCntModel.fromJson(fullJson);
      final copy = m.copyWith(
        deliveryDate: '2026-12-31T00:00:00',
        orderDate: '2026-12-01T00:00:00',
      );
      expect(copy.deliveryDate, '2026-12-31T00:00:00');
      expect(copy.orderDate, '2026-12-01T00:00:00');
    });

    test('copyWith without args preserves all', () {
      final m = GetDashPunchSummaryCntModel.fromJson(fullJson);
      final copy = m.copyWith();
      expect(copy.bkgOnlineAsOf, m.bkgOnlineAsOf);
      expect(copy.punchManAsOfPct, m.punchManAsOfPct);
    });
  });

  // ── Business logic – percentages ──────────────────────────────────────────
  group('Punch summary – percentage validations', () {
    test('PunchManAsOfPct + PunchDACAsOfPct ≈ 100', () {
      final m = GetDashPunchSummaryCntModel.fromJson(fullJson);
      final sum = (m.punchManAsOfPct ?? 0) + (m.punchDACAsOfPct ?? 0);
      expect(sum, closeTo(100.0, 0.01));
    });

    test('BkgManAsOfPct + BkgOnlineAsOfPct ≈ 100', () {
      final m = GetDashPunchSummaryCntModel.fromJson(fullJson);
      final sum = (m.bkgManAsOfPct ?? 0) + (m.bkgOnlineAsOfPct ?? 0);
      expect(sum, closeTo(100.0, 0.01));
    });

    test('today pct values are zero (no punches today)', () {
      final m = GetDashPunchSummaryCntModel.fromJson(fullJson);
      expect(m.punchManTodayPct, 0.0);
      expect(m.punchDACTodayPct, 0.0);
      expect(m.bkgManTodayPct, 0.0);
      expect(m.bkgOnlineTodayPct, 0.0);
    });

    test('asOf count is positive', () {
      final m = GetDashPunchSummaryCntModel.fromJson(fullJson);
      expect((m.punchManAsOf ?? 0) > 0, isTrue);
      expect((m.punchDACAsOf ?? 0) > 0, isTrue);
    });
  });
}

