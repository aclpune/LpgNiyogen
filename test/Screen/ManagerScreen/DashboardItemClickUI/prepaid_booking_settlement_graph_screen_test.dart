// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/PrepaidBookingAndSettlementGraphScreen.dart

import 'package:flutter_test/flutter_test.dart';

// ── Pure-logic helpers extracted from PrepaidBookingAndSettlementGraphScreen ──

/// Mirrors: filterLabels map
const Map<String, String> filterLabels = {
  'PREVIOUS_MONTH': 'Previous Month',
  'THIS_MONTH':     'This Month',
  'THIS_WEEK':      'This Week',
};

/// Mirrors: getFilterLabel(key) → filterLabels[key] ?? key
String getFilterLabel(String key) => filterLabels[key] ?? key;

/// Mirrors: getBarWidth() logic
/// if (labelWidth > 50) return 0.8 else return 0.4 (baseWidth)
double getBarWidth(double labelWidth) {
  const double baseWidth = 0.4;
  if (labelWidth > 50) return 0.8;
  return baseWidth;
}

/// Mirrors: chartWidth calculation
/// (barWidth + barSpacing) * (itemCount < minBarsToShow ? minBarsToShow : itemCount)
double calcChartWidth(int itemCount) {
  const double barWidth    = 60;
  const double barSpacing  = 10;
  const int    minBars     = 10;
  return (barWidth + barSpacing) *
      (itemCount < minBars ? minBars : itemCount);
}

/// Mirrors: defaultFilter
const String defaultFilter = 'THIS_MONTH';

/// Mirrors: fetchChartData parse logic
/// dates = data[0].keys.where((k) => k != 'CountFor').toList()
List<Map<String, dynamic>> parseChartData(List<Map<String, dynamic>> data) {
  final dates = data[0].keys.where((k) => k != 'CountFor').toList();
  return dates.map((date) => {
    'date':          date,
    'totalPunchCnt': data[0][date] ?? 0.0,
    'totalSettlPer': data[1][date] ?? 0.0,
    'totalSettlAmt': data[2][date] ?? 0.0,
  }).toList();
}

void main() {
  // ── filterLabels map ─────────────────────────────────────────────────────────
  group('[PrepaidBookingAndSettlementGraphScreen] filterLabels', () {
    test('has 3 entries', () => expect(filterLabels.length, 3));
    test('PREVIOUS_MONTH → "Previous Month"', () =>
        expect(filterLabels['PREVIOUS_MONTH'], 'Previous Month'));
    test('THIS_MONTH → "This Month"', () =>
        expect(filterLabels['THIS_MONTH'], 'This Month'));
    test('THIS_WEEK → "This Week"', () =>
        expect(filterLabels['THIS_WEEK'], 'This Week'));
    test('unknown key → null', () =>
        expect(filterLabels['UNKNOWN'], isNull));
  });

  // ── getFilterLabel ────────────────────────────────────────────────────────────
  group('[PrepaidBookingAndSettlementGraphScreen] getFilterLabel', () {
    test('"PREVIOUS_MONTH" → "Previous Month"', () =>
        expect(getFilterLabel('PREVIOUS_MONTH'), 'Previous Month'));
    test('"THIS_MONTH" → "This Month"', () =>
        expect(getFilterLabel('THIS_MONTH'), 'This Month'));
    test('"THIS_WEEK" → "This Week"', () =>
        expect(getFilterLabel('THIS_WEEK'), 'This Week'));
    test('unknown key returns key itself', () =>
        expect(getFilterLabel('UNKNOWN_KEY'), 'UNKNOWN_KEY'));
    test('empty key returns empty', () =>
        expect(getFilterLabel(''), ''));
  });

  // ── defaultFilter ─────────────────────────────────────────────────────────────
  group('[PrepaidBookingAndSettlementGraphScreen] defaultFilter', () {
    test('default is THIS_MONTH', () => expect(defaultFilter, 'THIS_MONTH'));
    test('default has a label', () =>
        expect(getFilterLabel(defaultFilter), isNotEmpty));
    test('default label is "This Month"', () =>
        expect(getFilterLabel(defaultFilter), 'This Month'));
  });

  // ── getBarWidth ───────────────────────────────────────────────────────────────
  group('[PrepaidBookingAndSettlementGraphScreen] getBarWidth', () {
    test('labelWidth > 50 → 0.8', () =>
        expect(getBarWidth(51.0), closeTo(0.8, 0.001)));
    test('labelWidth == 50 → 0.4 (baseWidth)', () =>
        expect(getBarWidth(50.0), closeTo(0.4, 0.001)));
    test('labelWidth < 50 → 0.4', () =>
        expect(getBarWidth(30.0), closeTo(0.4, 0.001)));
    test('labelWidth 0 → 0.4', () =>
        expect(getBarWidth(0.0), closeTo(0.4, 0.001)));
    test('labelWidth 100 → 0.8', () =>
        expect(getBarWidth(100.0), closeTo(0.8, 0.001)));
    test('labelWidth 50.1 → 0.8', () =>
        expect(getBarWidth(50.1), closeTo(0.8, 0.001)));
    test('labelWidth 49.9 → 0.4', () =>
        expect(getBarWidth(49.9), closeTo(0.4, 0.001)));
  });

  // ── calcChartWidth ────────────────────────────────────────────────────────────
  group('[PrepaidBookingAndSettlementGraphScreen] calcChartWidth', () {
    test('0 items → uses minBars(10) → 700', () =>
        expect(calcChartWidth(0), closeTo(700.0, 0.001)));
    test('5 items < 10 → 700', () =>
        expect(calcChartWidth(5), closeTo(700.0, 0.001)));
    test('9 items < 10 → 700', () =>
        expect(calcChartWidth(9), closeTo(700.0, 0.001)));
    test('10 items == minBars → 700', () =>
        expect(calcChartWidth(10), closeTo(700.0, 0.001)));
    test('11 items → 770', () =>
        expect(calcChartWidth(11), closeTo(770.0, 0.001)));
    test('15 items → 1050', () =>
        expect(calcChartWidth(15), closeTo(1050.0, 0.001)));
    test('30 items → 2100', () =>
        expect(calcChartWidth(30), closeTo(2100.0, 0.001)));
    test('1 item < minBars → 700', () =>
        expect(calcChartWidth(1), closeTo(700.0, 0.001)));
  });

  // ── parseChartData ────────────────────────────────────────────────────────────
  group('[PrepaidBookingAndSettlementGraphScreen] parseChartData', () {
    test('parses 2 dates', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': 10.0, '2025-04-02': 8.0},
        {'CountFor': 'Settl', '2025-04-01': 9.0,  '2025-04-02': 7.0},
        {'CountFor': 'Amt',   '2025-04-01': 5000.0,'2025-04-02': 3500.0},
      ];
      expect(parseChartData(raw).length, 2);
    });
    test('"CountFor" key excluded from dates', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': 5.0},
        {'CountFor': 'Settl', '2025-04-01': 4.0},
        {'CountFor': 'Amt',   '2025-04-01': 2000.0},
      ];
      final r = parseChartData(raw);
      expect(r.every((e) => e['date'] != 'CountFor'), isTrue);
    });
    test('totalPunchCnt set', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': 15.0},
        {'CountFor': 'Settl', '2025-04-01': 12.0},
        {'CountFor': 'Amt',   '2025-04-01': 8000.0},
      ];
      expect(parseChartData(raw).first['totalPunchCnt'], closeTo(15.0, 0.001));
    });
    test('totalSettlPer set', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': 15.0},
        {'CountFor': 'Settl', '2025-04-01': 12.0},
        {'CountFor': 'Amt',   '2025-04-01': 8000.0},
      ];
      expect(parseChartData(raw).first['totalSettlPer'], closeTo(12.0, 0.001));
    });
    test('totalSettlAmt set', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': 15.0},
        {'CountFor': 'Settl', '2025-04-01': 12.0},
        {'CountFor': 'Amt',   '2025-04-01': 8000.0},
      ];
      expect(parseChartData(raw).first['totalSettlAmt'], closeTo(8000.0, 0.001));
    });
    test('null value defaults to 0.0', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': null},
        {'CountFor': 'Settl', '2025-04-01': null},
        {'CountFor': 'Amt',   '2025-04-01': null},
      ];
      final r = parseChartData(raw);
      expect(r.first['totalPunchCnt'], 0.0);
      expect(r.first['totalSettlPer'], 0.0);
      expect(r.first['totalSettlAmt'], 0.0);
    });
    test('date key preserved correctly', () {
      final raw = [
        {'CountFor': 'Punch', '2025-09-10': 5.0},
        {'CountFor': 'Settl', '2025-09-10': 3.0},
        {'CountFor': 'Amt',   '2025-09-10': 1000.0},
      ];
      expect(parseChartData(raw).first['date'], '2025-09-10');
    });
  });
}

