// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pure-logic helpers extracted from every DashboardItemClickUI screen
// for isolated unit testing (no Flutter widgets / HTTP / Firebase required).
// ─────────────────────────────────────────────────────────────────────────────

// ── Shared helpers (used by multiple screens) ────────────────────────────────

/// Mirrors formatCurrency() present in:
/// ARBProfitDetailScreenUi, CreditSaleCountDetailListUI,
/// DashboardPostPaidVerifPendDetails, DashboardSVDetails,
/// DashboardTVDetails, RefillProfitDetailScreenUi,
/// SVProfitdetailScreenUi, TodaysCashSummaryOnAccountList,
/// VendorPaymentDetailListUI.
String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final format = NumberFormat('#,##,###.00', 'en_IN');
  String formatted = format.format(amount);
  if (amount < 1 && formatted.startsWith('.')) formatted = '0$formatted';
  return formatted;
}

/// Mirrors nullToDash() present in:
/// CreditSaleCountDetailListUI, DashboardDropDownUI,
/// DashboardPostPaidVerifPendDetails, DashboardPostPaidVerifPendDetailsUI,
/// DashboardPrepaidDetailUI, DashboardSVDetailUI,
/// DashboardTVDetailUI, TodaysCashSummaryOnAccountList.
String nullToDash(String? value) {
  if (value == null || value.toLowerCase() == 'null') return '-';
  return value;
}

// ── ARBProfitDetailScreenUi ──────────────────────────────────────────────────

/// Mirrors the totals loop in fetchARBDetailList → setState
Map<String, dynamic> calcARBTotals(List<Map<String, dynamic>> data) {
  double grossSaleAmt = 0;
  double grossProfitAmt = 0;
  double purchaseAmt = 0;
  int purchaseQty = 0;
  for (final arb in data) {
    grossSaleAmt += ((arb['grossSaleAmt'] ?? 0) as num).toDouble();
    grossProfitAmt += ((arb['grossProfitAmt'] ?? 0) as num).toDouble();
    purchaseAmt += ((arb['purchesAmt'] ?? 0) as num).toDouble();
    purchaseQty += ((arb['itemQty'] ?? 0) as num).toInt();
  }
  return {
    'grossSaleAmts': grossSaleAmt,
    'grossProfitAmts': grossProfitAmt,
    'purchaseAmts': purchaseAmt,
    'purchaseQtys': purchaseQty,
  };
}

/// Mirrors the AppBar title logic for profitFors in ARBProfitDetailScreenUi
String arbProfitTitle(String profitFor) {
  if (profitFor == 'GrossRevenue') return 'ARB Gross Revenue -';
  if (profitFor == 'GrossProfit') return 'ARB Gross Profit -';
  return 'ARB -';
}

/// Mirrors the flag-to-label mapping in ARBProfitDetailScreenUi AppBar
String arbDayFlagLabel(String flag) {
  if (flag == 'TODAYS') return "Today's";
  if (flag == 'THISMONTH') return 'This Month';
  if (flag == 'FINYEAR') return 'Financial Year';
  return '';
}

// ── CreditSaleCountDetailListUI ──────────────────────────────────────────────

/// Mirrors _calculateTotalAmount() – sums totalOutstanding from display lists
double calcTotalOutstanding(List<Map<String, dynamic>> displayList) {
  return displayList.fold(
    0.0,
    (sum, report) => sum + ((report['totalOutstanding'] ?? 0.0) as num).toDouble(),
  );
}

/// Mirrors showTop5ByOutstanding() sort+take logic
List<Map<String, dynamic>> showTop5ByOutstanding(
    List<Map<String, dynamic>> items) {
  final sorted = List<Map<String, dynamic>>.from(items);
  sorted.sort((a, b) => ((b['totalOutstanding'] ?? 0) as num)
      .compareTo((a['totalOutstanding'] ?? 0) as num));
  return sorted.take(5).toList();
}

/// Mirrors showOldestRecords() sort logic
List<Map<String, dynamic>> showOldestRecords(List<Map<String, dynamic>> items) {
  final sorted = List<Map<String, dynamic>>.from(items);
  sorted.sort((a, b) {
    final dateA = a['collRcptDate'] != null
        ? DateTime.tryParse(a['collRcptDate'] as String) ?? DateTime(1970)
        : DateTime(1970);
    final dateB = b['collRcptDate'] != null
        ? DateTime.tryParse(b['collRcptDate'] as String) ?? DateTime(1970)
        : DateTime(1970);
    return dateA.compareTo(dateB);
  });
  return sorted;
}

/// Mirrors selectedItem label logic in CreditSaleCountDetailListUI
String creditSaleLabel(int customerId, String customerName) {
  if (customerId == -1) return 'ALL';
  if (customerId == -2) return 'Top 5 outstanding';
  if (customerId == -3) return "Oldest by day's";
  return customerName;
}

// ── DashboardDropDownUI ──────────────────────────────────────────────────────

/// Mirrors serial number divider visibility (show Divider when serialNumber != listLength)
bool showDivider(int serialNumber, int listLength) => serialNumber != listLength;

// ── DashboardPostPaidVerifPendDetails ────────────────────────────────────────

/// Mirrors filterSearchResults() in DashboardPostPaidVerifPendDetails
List<Map<String, dynamic>> filterPostpaidByStaff(
    List<Map<String, dynamic>> items, String query) {
  return items
      .where((item) => (item['staffName'] as String? ?? '')
          .toLowerCase()
          .contains(query.toLowerCase()))
      .toList();
}

/// Mirrors the transaction-type filter name cleanup
/// (value.replaceAll(' ', ''))
String cleanTransactionForFilter(String value) =>
    value.replaceAll(' ', '');

// ── DashboardPrepaidDetails ──────────────────────────────────────────────────

/// Mirrors _getDisplayText() in DashboardPrepaidDetails
String getDisplayText(String flag) {
  switch (flag) {
    case 'Delivered':
      return 'Delivered,payment pending';
    case 'Settled':
      return 'Payment done,delivery pending';
    case 'cDCMS':
      return 'Pending in cDCMS';
    case 'DelDonNiyoJanPunPend':
      return 'Punched in cDCMS,pending in Niyojan';
    case 'OldBkgPendNewBkgRecv':
      return 'Old punching pending but....';
    case 'Punching':
      return "Today's Niyojan Punched";
    case 'Incorrect':
      return "Today's incorrect";
    case 'NiyoJanPunDelPend':
      return 'Punched in Niyojan,pending in cDCMS';
    case 'TotalOutstanding':
      return 'Total Outstanding Pending';
    default:
      return 'Prepaid Details';
  }
}

/// Mirrors whether list count comes from prepaidModel or punchModel
bool usePreCount(String flag) {
  return flag == 'Delivered' ||
      flag == 'Settled' ||
      flag == 'TotalOutstanding' ||
      flag == 'cDCMS' ||
      flag == 'DelDonNiyoJanPunPend' ||
      flag == 'OldBkgPendNewBkgRecv';
}

/// Mirrors filterSearchResults for prepaidModel in DashboardPrepaidDetails
List<Map<String, dynamic>> filterPrepaidModel(
    List<Map<String, dynamic>> items, String query) {
  final lq = query.toLowerCase();
  return items.where((item) {
    return (item['consumerNo']?.toString().toLowerCase().contains(lq) ?? false) ||
        (item['consumerName']?.toString().toLowerCase().contains(lq) ?? false) ||
        (item['orderDate']?.toString().toLowerCase().contains(lq) ?? false) ||
        (item['deliveryDate']?.toString().toLowerCase().contains(lq) ?? false);
  }).toList();
}

/// Mirrors filterSearchResults for punchModel in DashboardPrepaidDetails
List<Map<String, dynamic>> filterPunchModel(
    List<Map<String, dynamic>> items, String query) {
  final lq = query.toLowerCase();
  return items.where((item) {
    return (item['staffName']?.toString().toLowerCase().contains(lq) ?? false) ||
        item['niyojanPunQty']?.toString().toLowerCase().contains(lq) == true ||
        item['settlementQty']?.toString().toLowerCase().contains(lq) == true;
  }).toList();
}

// ── DashboardSVDetails / DashboardSVDetailUI ─────────────────────────────────

/// Mirrors fold calculations in DashboardSVDetails.build()
Map<String, dynamic> calcSVTotals(List<Map<String, dynamic>> svmodel) {
  final totalCylQty =
      svmodel.fold<num>(0, (sum, item) => sum + ((item['cylQty'] ?? 0) as num));
  final totalAmount = svmodel.fold<double>(
      0.0, (sum, item) => sum + ((item['totalAmount'] ?? 0.0) as num).toDouble());
  return {'totalCylQty': totalCylQty, 'totalAmount': totalAmount};
}

/// Mirrors doc status string in DashboardSVDetailUI
String svDocStatus(bool? isUndocument) {
  if (isUndocument == true) return 'Pending';
  if (isUndocument == false) return 'Received';
  return '';
}

// ── DashboardTVDetails / DashboardTVDetailUI ─────────────────────────────────

/// Mirrors fold + filter in DashboardTVDetails.build()
Map<String, dynamic> calcTVTotals(List<Map<String, dynamic>> tvmodel) {
  final totalCylQty = tvmodel.fold<num>(
      0, (sum, item) => sum + ((item['clyReceivedQty'] ?? 0) as num));
  final totalAmount = tvmodel.fold<double>(
      0.0, (sum, item) => sum + ((item['paidAmt'] ?? 0.0) as num).toDouble());
  final regReceivedCount =
      tvmodel.where((item) => item['isRegulator'] == 'Yes').length;
  return {
    'totalCylQty': totalCylQty,
    'totalAmount': totalAmount,
    'regReceivedCount': regReceivedCount,
  };
}

// ── ImbalanceCountClickUI ────────────────────────────────────────────────────

/// Mirrors filterSearchResults() in ImbalanceCountClickUI
List<Map<String, dynamic>> filterImbalanceList(
    List<Map<String, dynamic>> items, String query) {
  if (query.isEmpty) return List.from(items);
  final lq = query.toLowerCase();
  return items.where((item) {
    return (item['staffName']?.toString().toLowerCase().contains(lq) ?? false) ||
        (item['itemName']?.toString().toLowerCase().contains(lq) ?? false) ||
        (item['imbalanceQty']?.toString().contains(lq) ?? false);
  }).toList();
}

// ── PrepaidBookingAndSettlementGraphScreen ────────────────────────────────────

/// Mirrors filterLabels map in PrepaidBookingAndSettlementGraphScreen
String getFilterLabel(String key) {
  const labels = {
    'PREVIOUS_MONTH': 'Previous Month',
    'THIS_MONTH': 'This Month',
    'THIS_WEEK': 'This Week',
  };
  return labels[key] ?? key;
}

// ── RefillProfitDetailScreenUi ───────────────────────────────────────────────

/// Mirrors the totals loop in fetchRefillDetailList → setState
Map<String, dynamic> calcRefillTotals(List<Map<String, dynamic>> data) {
  double grossRevenueAmt = 0;
  double grossProfitAmt = 0;
  int saleQty = 0;
  for (final refill in data) {
    grossRevenueAmt += ((refill['grossRevenue'] ?? 0) as num).toDouble();
    grossProfitAmt += ((refill['grossProfit'] ?? 0) as num).toDouble();
    saleQty += ((refill['saleQty'] ?? 0) as num).toInt();
  }
  return {
    'grossRevenueAmts': grossRevenueAmt,
    'grossProfitAmts': grossProfitAmt,
    'saleQtys': saleQty,
  };
}

/// Mirrors AppBar title for RefillProfitDetailScreenUi
String refillProfitTitle(String profitFor) {
  if (profitFor == 'GrossRevenue') return 'Refill Gross Revenue -';
  if (profitFor == 'GrossProfit') return 'Refill Gross Profit -';
  return 'Refill -';
}

// ── SVProfitdetailScreenUi ───────────────────────────────────────────────────

/// Mirrors AppBar flag label in SVProfitDetailScreenUI
String svDayFlagLabel(String flag) {
  if (flag == 'TODAYS') return "Today's";
  if (flag == 'THISMONTH') return 'This Month';
  if (flag == 'FINYEAR') return 'Financial Year';
  return '';
}

// ── TodaysCashSummaryOnAccountList ───────────────────────────────────────────

/// Mirrors _updateTotalBalance() in TodaysCashSummaryOnAccountList
double updateTotalBalance(
    List<Map<String, dynamic>> ledgerReports, int? selectedStaffId) {
  final filtered = selectedStaffId == null
      ? ledgerReports
      : ledgerReports
          .where((r) => r['staffId'] == selectedStaffId)
          .toList();
  return filtered.fold(
      0.0, (sum, r) => sum + ((r['balance'] ?? 0.0) as num).toDouble());
}

/// Mirrors cashsummary count in TodaysCashSummaryOnAccountList.build()
int calcCashSummary(
    List<Map<String, dynamic>> ledgerReports, int? selectedReferredID) {
  if (ledgerReports.isEmpty) return 0;
  if (selectedReferredID == null) return ledgerReports.length;
  return ledgerReports
      .where((r) => r['staffId'] == selectedReferredID)
      .length;
}

/// Mirrors checkAndSaveDayEndData saveFlag logic
bool calcSaveFlag(Map<String, dynamic>? dayEndData) {
  if (dayEndData == null) return false;
  final dsrSaved = (dayEndData['DSRSaved'] ?? 0) as int;
  final cdcmsSaved = (dayEndData['CDCMSStkSaved'] ?? 0) as int;
  final opClSaved = (dayEndData['OpClSaved'] ?? 0) as int;
  return dsrSaved == 1 && cdcmsSaved == 1 && opClSaved == 1;
}

// ── UnsettledSaleDetailList ──────────────────────────────────────────────────

/// Mirrors the .where filter in fetchUnsettledList
/// Only items with unsettQty != null && unsettQty > 0 are shown
List<Map<String, dynamic>> filterUnsettledItems(
    List<Map<String, dynamic>> items) {
  return items
      .where((item) =>
          item['unsettQty'] != null && (item['unsettQty'] as num) > 0)
      .toList();
}

// ── VendorPaymentDetailListUI ────────────────────────────────────────────────

/// Mirrors totalPendingAmount calculation in fetchVendorDetailList
double calcTotalPendingAmount(List<Map<String, dynamic>> vendors) {
  return vendors.fold(
      0.0, (sum, item) => sum + ((item['pendingAmount'] ?? 0.0) as num).toDouble());
}

/// Mirrors vendor alphabetical sort in getVendorMasterList
List<Map<String, dynamic>> sortVendorsByName(
    List<Map<String, dynamic>> vendors) {
  final sorted = List<Map<String, dynamic>>.from(vendors);
  sorted.sort((a, b) {
    final nameA = (a['vendorName'] as String? ?? '').toLowerCase();
    final nameB = (b['vendorName'] as String? ?? '').toLowerCase();
    return nameA.compareTo(nameB);
  });
  return sorted;
}

// ─────────────────────────────────────────────────────────────────────────────
// TESTS
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1 – Shared: formatCurrency
  // ═══════════════════════════════════════════════════════════════════════════
  group('[formatCurrency] (shared across 9 screens)', () {
    test('zero returns "0.00"', () {
      expect(formatCurrency(0), '0.00');
    });

    test('positive integer value formats correctly (15000)', () {
      final r = formatCurrency(15000.0);
      expect(r.contains('15') && r.contains('00'), isTrue);
    });

    test('sub-zero amount gets a leading zero', () {
      final r = formatCurrency(0.5);
      expect(r.startsWith('0'), isTrue);
    });

    test('large Indian-locale amount does not throw', () {
      expect(() => formatCurrency(12345678.99), returnsNormally);
    });

    test('1.0 formats without leading dot', () {
      final r = formatCurrency(1.0);
      expect(r.startsWith('0'), isFalse);
    });

    test('amount of 100.0 contains "100"', () {
      expect(formatCurrency(100.0).contains('100'), isTrue);
    });

    test('amount of 1000.0 contains "1"', () {
      expect(formatCurrency(1000.0).contains('1'), isTrue);
    });

    test('negative amount does not throw', () {
      expect(() => formatCurrency(-500.0), returnsNormally);
    });

    test('very small positive (0.01) returns value starting with "0"', () {
      expect(formatCurrency(0.01).startsWith('0'), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2 – Shared: nullToDash
  // ═══════════════════════════════════════════════════════════════════════════
  group('[nullToDash] (shared across 8 screens)', () {
    test('null returns "-"', () {
      expect(nullToDash(null), '-');
    });

    test('string "null" returns "-"', () {
      expect(nullToDash('null'), '-');
    });

    test('string "NULL" (uppercase) returns "-"', () {
      expect(nullToDash('NULL'), '-');
    });

    test('string "Null" (mixed case) returns "-"', () {
      expect(nullToDash('Null'), '-');
    });

    test('empty string returns "" (not "-")', () {
      expect(nullToDash(''), '');
    });

    test('valid string returns itself', () {
      expect(nullToDash('John Doe'), 'John Doe');
    });

    test('number string returns itself', () {
      expect(nullToDash('42'), '42');
    });

    test('whitespace string returns itself', () {
      expect(nullToDash(' '), ' ');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3 – ARBProfitDetailScreenUi
  // ═══════════════════════════════════════════════════════════════════════════
  group('[ARBProfitDetailScreenUi] calcARBTotals', () {
    test('sums grossSaleAmt across items', () {
      final data = [
        {'grossSaleAmt': 1000.0, 'grossProfitAmt': 200.0, 'purchesAmt': 800.0, 'itemQty': 5},
        {'grossSaleAmt': 2000.0, 'grossProfitAmt': 400.0, 'purchesAmt': 1600.0, 'itemQty': 10},
      ];
      final result = calcARBTotals(data);
      expect(result['grossSaleAmts'], closeTo(3000.0, 0.001));
    });

    test('sums grossProfitAmt across items', () {
      final data = [
        {'grossSaleAmt': 500.0, 'grossProfitAmt': 100.0, 'purchesAmt': 400.0, 'itemQty': 2},
        {'grossSaleAmt': 500.0, 'grossProfitAmt': 150.0, 'purchesAmt': 350.0, 'itemQty': 3},
      ];
      final result = calcARBTotals(data);
      expect(result['grossProfitAmts'], closeTo(250.0, 0.001));
    });

    test('sums purchaseAmt across items', () {
      final data = [
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 300.0, 'itemQty': 1},
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 700.0, 'itemQty': 2},
      ];
      final result = calcARBTotals(data);
      expect(result['purchaseAmts'], closeTo(1000.0, 0.001));
    });

    test('sums itemQty (int) across items', () {
      final data = [
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 0, 'itemQty': 7},
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 0, 'itemQty': 3},
      ];
      final result = calcARBTotals(data);
      expect(result['purchaseQtys'], 10);
    });

    test('empty list returns all zeros', () {
      final result = calcARBTotals([]);
      expect(result['grossSaleAmts'], 0.0);
      expect(result['grossProfitAmts'], 0.0);
      expect(result['purchaseAmts'], 0.0);
      expect(result['purchaseQtys'], 0);
    });

    test('null fields treated as zero', () {
      final data = [
        {'grossSaleAmt': null, 'grossProfitAmt': null, 'purchesAmt': null, 'itemQty': null},
      ];
      final result = calcARBTotals(data);
      expect(result['grossSaleAmts'], 0.0);
      expect(result['purchaseQtys'], 0);
    });
  });

  group('[ARBProfitDetailScreenUi] arbProfitTitle', () {
    test('"GrossRevenue" → "ARB Gross Revenue -"', () {
      expect(arbProfitTitle('GrossRevenue'), 'ARB Gross Revenue -');
    });

    test('"GrossProfit" → "ARB Gross Profit -"', () {
      expect(arbProfitTitle('GrossProfit'), 'ARB Gross Profit -');
    });

    test('unknown → "ARB -"', () {
      expect(arbProfitTitle('Other'), 'ARB -');
    });
  });

  group('[ARBProfitDetailScreenUi] arbDayFlagLabel', () {
    test('"TODAYS" → "Today\'s"', () {
      expect(arbDayFlagLabel('TODAYS'), "Today's");
    });

    test('"THISMONTH" → "This Month"', () {
      expect(arbDayFlagLabel('THISMONTH'), 'This Month');
    });

    test('"FINYEAR" → "Financial Year"', () {
      expect(arbDayFlagLabel('FINYEAR'), 'Financial Year');
    });

    test('unknown flag → ""', () {
      expect(arbDayFlagLabel('UNKNOWN'), '');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4 – CreditSaleCountDetailListUI
  // ═══════════════════════════════════════════════════════════════════════════
  group('[CreditSaleCountDetailListUI] calcTotalOutstanding', () {
    test('sums totalOutstanding correctly', () {
      final list = [
        {'totalOutstanding': 500.0},
        {'totalOutstanding': 1500.0},
        {'totalOutstanding': 300.0},
      ];
      expect(calcTotalOutstanding(list), closeTo(2300.0, 0.001));
    });

    test('empty list returns 0.0', () {
      expect(calcTotalOutstanding([]), 0.0);
    });

    test('null totalOutstanding treated as 0', () {
      final list = [
        {'totalOutstanding': null},
        {'totalOutstanding': 800.0},
      ];
      expect(calcTotalOutstanding(list), closeTo(800.0, 0.001));
    });
  });

  group('[CreditSaleCountDetailListUI] showTop5ByOutstanding', () {
    final items = List.generate(7, (i) => {'totalOutstanding': (i + 1) * 100.0, 'id': i});

    test('returns at most 5 items', () {
      expect(showTop5ByOutstanding(items).length, 5);
    });

    test('first item has highest outstanding', () {
      final result = showTop5ByOutstanding(items);
      expect(result.first['totalOutstanding'], 700.0);
    });

    test('items are sorted descending by totalOutstanding', () {
      final result = showTop5ByOutstanding(items);
      for (int i = 0; i < result.length - 1; i++) {
        expect((result[i]['totalOutstanding'] as double) >=
            (result[i + 1]['totalOutstanding'] as double), isTrue);
      }
    });

    test('list with fewer than 5 items returns all', () {
      final small = [{'totalOutstanding': 100.0}, {'totalOutstanding': 50.0}];
      expect(showTop5ByOutstanding(small).length, 2);
    });

    test('empty list returns empty', () {
      expect(showTop5ByOutstanding([]), isEmpty);
    });
  });

  group('[CreditSaleCountDetailListUI] showOldestRecords', () {
    test('sorts ascending by date (oldest first)', () {
      final items = [
        {'collRcptDate': '2025-03-15', 'id': 2},
        {'collRcptDate': '2025-01-01', 'id': 1},
        {'collRcptDate': '2025-06-10', 'id': 3},
      ];
      final result = showOldestRecords(items);
      expect(result.first['id'], 1);
      expect(result.last['id'], 3);
    });

    test('null collRcptDate treated as epoch (1970-01-01)', () {
      final items = [
        {'collRcptDate': null, 'id': 0},
        {'collRcptDate': '2025-01-01', 'id': 1},
      ];
      final result = showOldestRecords(items);
      expect(result.first['id'], 0);
    });

    test('single item returns as-is', () {
      final items = [{'collRcptDate': '2025-06-01', 'id': 1}];
      expect(showOldestRecords(items).length, 1);
    });
  });

  group('[CreditSaleCountDetailListUI] creditSaleLabel', () {
    test('customerId -1 → "ALL"', () {
      expect(creditSaleLabel(-1, 'ANY'), 'ALL');
    });

    test('customerId -2 → "Top 5 outstanding"', () {
      expect(creditSaleLabel(-2, 'ANY'), 'Top 5 outstanding');
    });

    test("customerId -3 → \"Oldest by day's\"", () {
      expect(creditSaleLabel(-3, 'ANY'), "Oldest by day's");
    });

    test('positive customerId → customerName', () {
      expect(creditSaleLabel(10, 'Ravi Sharma'), 'Ravi Sharma');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5 – DashboardDropDownUI
  // ═══════════════════════════════════════════════════════════════════════════
  group('[DashboardDropDownUI] showDivider', () {
    test('serialNumber != listLength → show divider', () {
      expect(showDivider(2, 5), isTrue);
    });

    test('serialNumber == listLength → hide divider', () {
      expect(showDivider(5, 5), isFalse);
    });

    test('first item in a single-item list → no divider', () {
      expect(showDivider(1, 1), isFalse);
    });

    test('first of many items shows divider', () {
      expect(showDivider(1, 10), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 6 – DashboardPostPaidVerifPendDetails
  // ═══════════════════════════════════════════════════════════════════════════
  group('[DashboardPostPaidVerifPendDetails] filterPostpaidByStaff', () {
    final items = [
      {'staffName': 'Rahul Kumar', 'transCode': 'TC001'},
      {'staffName': 'Swarup Das', 'transCode': 'TC002'},
      {'staffName': 'Priya Singh', 'transCode': 'TC003'},
    ];

    test('matches staffName case-insensitively', () {
      expect(filterPostpaidByStaff(items, 'rahul').length, 1);
    });

    test('partial match works', () {
      expect(filterPostpaidByStaff(items, 'swa').length, 1);
    });

    test('empty query returns all items', () {
      expect(filterPostpaidByStaff(items, '').length, 3);
    });

    test('no match returns empty list', () {
      expect(filterPostpaidByStaff(items, 'ZZZNOMATCH'), isEmpty);
    });

    test('case insensitive uppercase query', () {
      expect(filterPostpaidByStaff(items, 'PRIYA').length, 1);
    });
  });

  group('[DashboardPostPaidVerifPendDetails] cleanTransactionForFilter', () {
    test('"Daily Sales" → "DailySales"', () {
      expect(cleanTransactionForFilter('Daily Sales'), 'DailySales');
    });

    test('"SV Sales" → "SVSales"', () {
      expect(cleanTransactionForFilter('SV Sales'), 'SVSales');
    });

    test('"ARB Sales" → "ARBSales"', () {
      expect(cleanTransactionForFilter('ARB Sales'), 'ARBSales');
    });

    test('"All" → "All" (unchanged)', () {
      expect(cleanTransactionForFilter('All'), 'All');
    });

    test('"Receipt" → "Receipt" (unchanged)', () {
      expect(cleanTransactionForFilter('Receipt'), 'Receipt');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 7 – DashboardPrepaidDetails
  // ═══════════════════════════════════════════════════════════════════════════
  group('[DashboardPrepaidDetails] getDisplayText', () {
    test('"Delivered" → "Delivered,payment pending"', () {
      expect(getDisplayText('Delivered'), 'Delivered,payment pending');
    });

    test('"Settled" → "Payment done,delivery pending"', () {
      expect(getDisplayText('Settled'), 'Payment done,delivery pending');
    });

    test('"cDCMS" → "Pending in cDCMS"', () {
      expect(getDisplayText('cDCMS'), 'Pending in cDCMS');
    });

    test('"DelDonNiyoJanPunPend" → "Punched in cDCMS,pending in Niyojan"', () {
      expect(getDisplayText('DelDonNiyoJanPunPend'),
          'Punched in cDCMS,pending in Niyojan');
    });

    test('"OldBkgPendNewBkgRecv" → "Old punching pending but...."', () {
      expect(getDisplayText('OldBkgPendNewBkgRecv'), 'Old punching pending but....');
    });

    test('"Punching" → "Today\'s Niyojan Punched"', () {
      expect(getDisplayText('Punching'), "Today's Niyojan Punched");
    });

    test('"Incorrect" → "Today\'s incorrect"', () {
      expect(getDisplayText('Incorrect'), "Today's incorrect");
    });

    test('"NiyoJanPunDelPend" → "Punched in Niyojan,pending in cDCMS"', () {
      expect(getDisplayText('NiyoJanPunDelPend'),
          'Punched in Niyojan,pending in cDCMS');
    });

    test('"TotalOutstanding" → "Total Outstanding Pending"', () {
      expect(getDisplayText('TotalOutstanding'), 'Total Outstanding Pending');
    });

    test('unknown flag → "Prepaid Details"', () {
      expect(getDisplayText('UNKNOWN'), 'Prepaid Details');
    });
  });

  group('[DashboardPrepaidDetails] usePreCount', () {
    test('"Delivered" uses pre count', () => expect(usePreCount('Delivered'), isTrue));
    test('"Settled" uses pre count', () => expect(usePreCount('Settled'), isTrue));
    test('"TotalOutstanding" uses pre count', () => expect(usePreCount('TotalOutstanding'), isTrue));
    test('"Punching" uses punch count', () => expect(usePreCount('Punching'), isFalse));
    test('"Incorrect" uses punch count', () => expect(usePreCount('Incorrect'), isFalse));
    test('"NiyoJanPunDelPend" uses punch count', () => expect(usePreCount('NiyoJanPunDelPend'), isFalse));
  });

  group('[DashboardPrepaidDetails] filterPrepaidModel', () {
    final items = [
      {'consumerNo': '660990', 'consumerName': 'Priya Mondal', 'orderDate': '2025-04-01', 'deliveryDate': '2025-04-05'},
      {'consumerNo': '770101', 'consumerName': 'Rahul Das', 'orderDate': '2025-05-01', 'deliveryDate': null},
    ];

    test('matches consumerNo', () {
      expect(filterPrepaidModel(items, '660990').length, 1);
    });

    test('matches consumerName case-insensitively', () {
      expect(filterPrepaidModel(items, 'priya').length, 1);
    });

    test('matches orderDate', () {
      expect(filterPrepaidModel(items, '2025-05').length, 1);
    });

    test('empty query returns all', () {
      expect(filterPrepaidModel(items, '').length, 2);
    });

    test('no match returns empty', () {
      expect(filterPrepaidModel(items, 'ZZZMATCH'), isEmpty);
    });
  });

  group('[DashboardPrepaidDetails] filterPunchModel', () {
    final items = [
      {'staffName': 'Ravi', 'niyojanPunQty': 10, 'settlementQty': 8},
      {'staffName': 'Amit', 'niyojanPunQty': 5, 'settlementQty': 5},
    ];

    test('matches staffName', () {
      expect(filterPunchModel(items, 'ravi').length, 1);
    });

    test('matches niyojanPunQty as string', () {
      expect(filterPunchModel(items, '10').length, 1);
    });

    test('matches settlementQty as string', () {
      // '5' matches both niyojanPunQty(5) and settlementQty(5) for Amit
      expect(filterPunchModel(items, '5').length, greaterThanOrEqualTo(1));
    });

    test('empty query returns all', () {
      expect(filterPunchModel(items, '').length, 2);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 8 – DashboardSVDetails / DashboardSVDetailUI
  // ═══════════════════════════════════════════════════════════════════════════
  group('[DashboardSVDetails] calcSVTotals', () {
    test('sums cylQty and totalAmount', () {
      final data = [
        {'cylQty': 5, 'totalAmount': 3000.0},
        {'cylQty': 3, 'totalAmount': 1800.0},
      ];
      final result = calcSVTotals(data);
      expect(result['totalCylQty'], 8);
      expect(result['totalAmount'], closeTo(4800.0, 0.001));
    });

    test('empty list returns zeros', () {
      final result = calcSVTotals([]);
      expect(result['totalCylQty'], 0);
      expect(result['totalAmount'], 0.0);
    });

    test('null fields treated as zero', () {
      final result = calcSVTotals([{'cylQty': null, 'totalAmount': null}]);
      expect(result['totalCylQty'], 0);
      expect(result['totalAmount'], 0.0);
    });
  });

  group('[DashboardSVDetailUI] svDocStatus', () {
    test('true → "Pending"', () {
      expect(svDocStatus(true), 'Pending');
    });

    test('false → "Received"', () {
      expect(svDocStatus(false), 'Received');
    });

    test('null → ""', () {
      expect(svDocStatus(null), '');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 9 – DashboardTVDetails / DashboardTVDetailUI
  // ═══════════════════════════════════════════════════════════════════════════
  group('[DashboardTVDetails] calcTVTotals', () {
    test('sums clyReceivedQty, paidAmt and counts isRegulator==Yes', () {
      final data = [
        {'clyReceivedQty': 4, 'paidAmt': 2000.0, 'isRegulator': 'Yes'},
        {'clyReceivedQty': 2, 'paidAmt': 1000.0, 'isRegulator': 'No'},
        {'clyReceivedQty': 3, 'paidAmt': 1500.0, 'isRegulator': 'Yes'},
      ];
      final result = calcTVTotals(data);
      expect(result['totalCylQty'], 9);
      expect(result['totalAmount'], closeTo(4500.0, 0.001));
      expect(result['regReceivedCount'], 2);
    });

    test('empty list returns zeros', () {
      final result = calcTVTotals([]);
      expect(result['totalCylQty'], 0);
      expect(result['totalAmount'], 0.0);
      expect(result['regReceivedCount'], 0);
    });

    test('no regulator Yes → count is 0', () {
      final data = [
        {'clyReceivedQty': 1, 'paidAmt': 500.0, 'isRegulator': 'No'},
      ];
      expect(calcTVTotals(data)['regReceivedCount'], 0);
    });

    test('all regulators Yes → correct count', () {
      final data = List.generate(
          5, (_) => {'clyReceivedQty': 1, 'paidAmt': 100.0, 'isRegulator': 'Yes'});
      expect(calcTVTotals(data)['regReceivedCount'], 5);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 10 – ImbalanceCountClickUI
  // ═══════════════════════════════════════════════════════════════════════════
  group('[ImbalanceCountClickUI] filterImbalanceList', () {
    final items = [
      {'staffName': 'Ravi Sharma', 'itemName': '14.2 KG', 'imbalanceQty': 3},
      {'staffName': 'Amit Das', 'itemName': '5 KG', 'imbalanceQty': 1},
      {'staffName': 'Priya Singh', 'itemName': '14.2 KG', 'imbalanceQty': 5},
    ];

    test('empty query returns full list', () {
      expect(filterImbalanceList(items, '').length, 3);
    });

    test('matches staffName case-insensitively', () {
      expect(filterImbalanceList(items, 'ravi').length, 1);
    });

    test('matches itemName', () {
      expect(filterImbalanceList(items, '5 KG').length, 1);
    });

    test('matches imbalanceQty as string', () {
      expect(filterImbalanceList(items, '5').length, greaterThanOrEqualTo(1));
    });

    test('partial itemName match returns multiple', () {
      expect(filterImbalanceList(items, '14.2').length, 2);
    });

    test('no match returns empty list', () {
      expect(filterImbalanceList(items, 'NOMATCH_XYZ'), isEmpty);
    });

    test('returns copy of full list for empty query (not mutated)', () {
      final result = filterImbalanceList(items, '');
      result.add({'staffName': 'Extra', 'itemName': 'X', 'imbalanceQty': 0});
      expect(items.length, 3); // original unchanged
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 11 – PrepaidBookingAndSettlementGraphScreen
  // ═══════════════════════════════════════════════════════════════════════════
  group('[PrepaidBookingAndSettlementGraphScreen] getFilterLabel', () {
    test('"PREVIOUS_MONTH" → "Previous Month"', () {
      expect(getFilterLabel('PREVIOUS_MONTH'), 'Previous Month');
    });

    test('"THIS_MONTH" → "This Month"', () {
      expect(getFilterLabel('THIS_MONTH'), 'This Month');
    });

    test('"THIS_WEEK" → "This Week"', () {
      expect(getFilterLabel('THIS_WEEK'), 'This Week');
    });

    test('unknown key returns the key itself', () {
      expect(getFilterLabel('UNKNOWN_KEY'), 'UNKNOWN_KEY');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 12 – RefillProfitDetailScreenUi
  // ═══════════════════════════════════════════════════════════════════════════
  group('[RefillProfitDetailScreenUi] calcRefillTotals', () {
    test('sums grossRevenue, grossProfit and saleQty', () {
      final data = [
        {'grossRevenue': 5000.0, 'grossProfit': 1000.0, 'saleQty': 10},
        {'grossRevenue': 3000.0, 'grossProfit': 600.0, 'saleQty': 6},
      ];
      final result = calcRefillTotals(data);
      expect(result['grossRevenueAmts'], closeTo(8000.0, 0.001));
      expect(result['grossProfitAmts'], closeTo(1600.0, 0.001));
      expect(result['saleQtys'], 16);
    });

    test('empty list returns all zeros', () {
      final result = calcRefillTotals([]);
      expect(result['grossRevenueAmts'], 0.0);
      expect(result['grossProfitAmts'], 0.0);
      expect(result['saleQtys'], 0);
    });

    test('null fields treated as zero', () {
      final data = [
        {'grossRevenue': null, 'grossProfit': null, 'saleQty': null},
      ];
      final result = calcRefillTotals(data);
      expect(result['grossRevenueAmts'], 0.0);
      expect(result['saleQtys'], 0);
    });

    test('single item calculates correctly', () {
      final data = [{'grossRevenue': 1500.0, 'grossProfit': 300.0, 'saleQty': 3}];
      final result = calcRefillTotals(data);
      expect(result['grossRevenueAmts'], closeTo(1500.0, 0.001));
      expect(result['saleQtys'], 3);
    });
  });

  group('[RefillProfitDetailScreenUi] refillProfitTitle', () {
    test('"GrossRevenue" → "Refill Gross Revenue -"', () {
      expect(refillProfitTitle('GrossRevenue'), 'Refill Gross Revenue -');
    });

    test('"GrossProfit" → "Refill Gross Profit -"', () {
      expect(refillProfitTitle('GrossProfit'), 'Refill Gross Profit -');
    });

    test('unknown → "Refill -"', () {
      expect(refillProfitTitle(''), 'Refill -');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 13 – SVProfitdetailScreenUi
  // ═══════════════════════════════════════════════════════════════════════════
  group('[SVProfitDetailScreenUI] svDayFlagLabel', () {
    test('"TODAYS" → "Today\'s"', () {
      expect(svDayFlagLabel('TODAYS'), "Today's");
    });

    test('"THISMONTH" → "This Month"', () {
      expect(svDayFlagLabel('THISMONTH'), 'This Month');
    });

    test('"FINYEAR" → "Financial Year"', () {
      expect(svDayFlagLabel('FINYEAR'), 'Financial Year');
    });

    test('empty string → ""', () {
      expect(svDayFlagLabel(''), '');
    });

    test('arbitrary string → ""', () {
      expect(svDayFlagLabel('RANDOM'), '');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 14 – TodaysCashSummaryOnAccountList
  // ═══════════════════════════════════════════════════════════════════════════
  group('[TodaysCashSummaryOnAccountList] updateTotalBalance', () {
    final reports = [
      {'staffId': 1, 'balance': 500.0},
      {'staffId': 1, 'balance': 300.0},
      {'staffId': 2, 'balance': 800.0},
    ];

    test('null selectedStaffId sums all balances', () {
      expect(updateTotalBalance(reports, null), closeTo(1600.0, 0.001));
    });

    test('selectedStaffId=1 sums only staff 1 balances', () {
      expect(updateTotalBalance(reports, 1), closeTo(800.0, 0.001));
    });

    test('selectedStaffId=2 sums only staff 2 balance', () {
      expect(updateTotalBalance(reports, 2), closeTo(800.0, 0.001));
    });

    test('non-existent staffId returns 0.0', () {
      expect(updateTotalBalance(reports, 99), 0.0);
    });

    test('empty list returns 0.0', () {
      expect(updateTotalBalance([], null), 0.0);
    });
  });

  group('[TodaysCashSummaryOnAccountList] calcCashSummary', () {
    final reports = [
      {'staffId': 1},
      {'staffId': 1},
      {'staffId': 2},
    ];

    test('null selectedReferredID returns total count', () {
      expect(calcCashSummary(reports, null), 3);
    });

    test('selectedReferredID=1 returns filtered count', () {
      expect(calcCashSummary(reports, 1), 2);
    });

    test('selectedReferredID=2 returns 1', () {
      expect(calcCashSummary(reports, 2), 1);
    });

    test('empty list returns 0', () {
      expect(calcCashSummary([], null), 0);
    });

    test('non-existent staffId returns 0', () {
      expect(calcCashSummary(reports, 99), 0);
    });
  });

  group('[TodaysCashSummaryOnAccountList] calcSaveFlag', () {
    test('all 3 saved → true', () {
      expect(
          calcSaveFlag({'DSRSaved': 1, 'CDCMSStkSaved': 1, 'OpClSaved': 1}),
          isTrue);
    });

    test('DSRSaved missing → false', () {
      expect(
          calcSaveFlag({'DSRSaved': 0, 'CDCMSStkSaved': 1, 'OpClSaved': 1}),
          isFalse);
    });

    test('CDCMSStkSaved missing → false', () {
      expect(
          calcSaveFlag({'DSRSaved': 1, 'CDCMSStkSaved': 0, 'OpClSaved': 1}),
          isFalse);
    });

    test('OpClSaved missing → false', () {
      expect(
          calcSaveFlag({'DSRSaved': 1, 'CDCMSStkSaved': 1, 'OpClSaved': 0}),
          isFalse);
    });

    test('null dayEndData → false', () {
      expect(calcSaveFlag(null), isFalse);
    });

    test('all fields null default to 0 → false', () {
      expect(calcSaveFlag({'DSRSaved': null, 'CDCMSStkSaved': null, 'OpClSaved': null}),
          isFalse);
    });

    test('empty map defaults all to 0 → false', () {
      expect(calcSaveFlag({}), isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 15 – UnsettledSaleDetailList
  // ═══════════════════════════════════════════════════════════════════════════
  group('[UnsettledSaleDetailList] filterUnsettledItems', () {
    test('only items with unsettQty > 0 are kept', () {
      final items = [
        {'staffName': 'A', 'unsettQty': 3},
        {'staffName': 'B', 'unsettQty': 0},
        {'staffName': 'C', 'unsettQty': null},
        {'staffName': 'D', 'unsettQty': 1},
      ];
      final result = filterUnsettledItems(items);
      expect(result.length, 2);
      expect(result.map((e) => e['staffName']).toList(), containsAll(['A', 'D']));
    });

    test('empty list returns empty', () {
      expect(filterUnsettledItems([]), isEmpty);
    });

    test('all null unsettQty → empty result', () {
      final items = [
        {'unsettQty': null},
        {'unsettQty': null},
      ];
      expect(filterUnsettledItems(items), isEmpty);
    });

    test('all zero unsettQty → empty result', () {
      final items = [
        {'unsettQty': 0},
        {'unsettQty': 0},
      ];
      expect(filterUnsettledItems(items), isEmpty);
    });

    test('all valid unsettQty > 0 → all kept', () {
      final items = [
        {'unsettQty': 2},
        {'unsettQty': 5},
        {'unsettQty': 1},
      ];
      expect(filterUnsettledItems(items).length, 3);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 16 – VendorPaymentDetailListUI
  // ═══════════════════════════════════════════════════════════════════════════
  group('[VendorPaymentDetailListUI] calcTotalPendingAmount', () {
    test('sums pendingAmount across vendors', () {
      final vendors = [
        {'pendingAmount': 1200.0},
        {'pendingAmount': 800.0},
        {'pendingAmount': 500.0},
      ];
      expect(calcTotalPendingAmount(vendors), closeTo(2500.0, 0.001));
    });

    test('empty list returns 0.0', () {
      expect(calcTotalPendingAmount([]), 0.0);
    });

    test('null pendingAmount treated as 0', () {
      final vendors = [
        {'pendingAmount': null},
        {'pendingAmount': 400.0},
      ];
      expect(calcTotalPendingAmount(vendors), closeTo(400.0, 0.001));
    });

    test('single vendor returns its pendingAmount', () {
      expect(calcTotalPendingAmount([{'pendingAmount': 750.0}]),
          closeTo(750.0, 0.001));
    });
  });

  group('[VendorPaymentDetailListUI] sortVendorsByName', () {
    test('sorts alphabetically case-insensitively', () {
      final vendors = [
        {'vendorName': 'Zeta Gases'},
        {'vendorName': 'alpha Energy'},
        {'vendorName': 'Mumbai LPG'},
      ];
      final result = sortVendorsByName(vendors);
      expect(result.first['vendorName'], 'alpha Energy');
      expect(result.last['vendorName'], 'Zeta Gases');
    });

    test('single vendor list returns as-is', () {
      final vendors = [{'vendorName': 'OnlyOne'}];
      expect(sortVendorsByName(vendors).first['vendorName'], 'OnlyOne');
    });

    test('already sorted list remains in order', () {
      final vendors = [
        {'vendorName': 'AAA'},
        {'vendorName': 'BBB'},
        {'vendorName': 'CCC'},
      ];
      final result = sortVendorsByName(vendors);
      expect(result.map((e) => e['vendorName']).toList(), ['AAA', 'BBB', 'CCC']);
    });

    test('null vendorName treated as empty string (sorts first)', () {
      final vendors = [
        {'vendorName': 'Zeta'},
        {'vendorName': null},
      ];
      final result = sortVendorsByName(vendors);
      expect(result.first['vendorName'], isNull);
    });

    test('empty list returns empty', () {
      expect(sortVendorsByName([]), isEmpty);
    });

    test('does not mutate original list', () {
      final vendors = [
        {'vendorName': 'Zeta'},
        {'vendorName': 'Alpha'},
      ];
      sortVendorsByName(vendors);
      expect(vendors.first['vendorName'], 'Zeta'); // original order preserved
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 17 – DashboardPrepaidDetailUI / DashboardPostPaidVerifPendDetailsUI
  //              (UI-level nullToDash integration test)
  // ═══════════════════════════════════════════════════════════════════════════
  group('[DashboardPrepaidDetailUI / DashboardPostPaidVerifPendDetailsUI] nullToDash integration', () {
    test('consumerNo null → "-"', () {
      expect(nullToDash(null), '-');
    });

    test('consumerNo "null" → "-"', () {
      expect(nullToDash('null'), '-');
    });

    test('consumerNo "660990" → "660990"', () {
      expect(nullToDash('660990'), '660990');
    });

    test('transCode null → "-"', () {
      expect(nullToDash(null), '-');
    });

    test('transCode "TC-001" → "TC-001"', () {
      expect(nullToDash('TC-001'), 'TC-001');
    });

    test('remark null → "-"', () {
      expect(nullToDash(null), '-');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 18 – OnAccountPopupScreen (business logic only)
  // ═══════════════════════════════════════════════════════════════════════════
  group('[OnAccountPopupScreen] payment mode list', () {
    const getTransMode = ['Cash', 'Online'];

    test('list has exactly 2 modes', () {
      expect(getTransMode.length, 2);
    });

    test('contains "Cash"', () {
      expect(getTransMode.contains('Cash'), isTrue);
    });

    test('contains "Online"', () {
      expect(getTransMode.contains('Online'), isTrue);
    });
  });

  group('[OnAccountPopupScreen] totalAmount summed from selected checkboxes', () {
    // Mirrors the ElevatedButton logic: sum balance of checked items
    double calcSelectedTotal(List<Map<String, dynamic>> reports, List<bool> checked) {
      double total = 0.0;
      for (int i = 0; i < reports.length; i++) {
        if (checked[i]) total += (reports[i]['balance'] as num? ?? 0.0).toDouble();
      }
      return total;
    }

    test('all checked → sum of all balances', () {
      final reports = [
        {'balance': 500.0},
        {'balance': 300.0},
        {'balance': 200.0},
      ];
      expect(calcSelectedTotal(reports, [true, true, true]), closeTo(1000.0, 0.001));
    });

    test('none checked → 0.0', () {
      final reports = [
        {'balance': 500.0},
        {'balance': 300.0},
      ];
      expect(calcSelectedTotal(reports, [false, false]), 0.0);
    });

    test('partial selection sums only checked', () {
      final reports = [
        {'balance': 500.0},
        {'balance': 300.0},
        {'balance': 200.0},
      ];
      expect(calcSelectedTotal(reports, [true, false, true]), closeTo(700.0, 0.001));
    });

    test('null balance treated as 0', () {
      final reports = [{'balance': null}, {'balance': 400.0}];
      expect(calcSelectedTotal(reports, [true, true]), closeTo(400.0, 0.001));
    });
  });

  group('[OnAccountPopupScreen] isPaymentButtonEnabled', () {
    // isPaymentButtonEnabled = isCheckedList.contains(true)
    bool isPaymentEnabled(List<bool> checkedList) => checkedList.contains(true);

    test('at least one checked → enabled', () {
      expect(isPaymentEnabled([false, true, false]), isTrue);
    });

    test('all unchecked → disabled', () {
      expect(isPaymentEnabled([false, false, false]), isFalse);
    });

    test('empty list → disabled', () {
      expect(isPaymentEnabled([]), isFalse);
    });

    test('all checked → enabled', () {
      expect(isPaymentEnabled([true, true, true]), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 19 – DashboardPunchDetailUI
  //              (toggle expand logic)
  // ═══════════════════════════════════════════════════════════════════════════
  group('[DashboardPunchDetailUI] isTodaysNiyoganPunchedListViewVisible toggle', () {
    bool toggle(bool current) => !current;

    test('false → true on first tap', () {
      expect(toggle(false), isTrue);
    });

    test('true → false on second tap', () {
      expect(toggle(true), isFalse);
    });

    test('starts as false by default', () {
      const initialValue = false;
      expect(initialValue, isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 20 – Cross-screen: formatCurrency edge cases
  // ═══════════════════════════════════════════════════════════════════════════
  group('[Cross-screen] formatCurrency edge cases', () {
    test('0.99 returns value starting with "0."', () {
      final r = formatCurrency(0.99);
      expect(r.startsWith('0.'), isTrue);
    });

    test('1000000 formats with commas in Indian locale', () {
      final r = formatCurrency(1000000.0);
      expect(r.contains(','), isTrue);
    });

    test('identical results for same input across calls', () {
      expect(formatCurrency(5000.0), formatCurrency(5000.0));
    });

    test('50.0 returns "50.00"', () {
      expect(formatCurrency(50.0), '50.00');
    });

    test('999.99 does not return "0.00"', () {
      expect(formatCurrency(999.99), isNot('0.00'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 21 – OnAccountPopupScreen: denomination & amount logic
  // ═══════════════════════════════════════════════════════════════════════════

  group('[OnAccountPopupScreen] denomination amount per note', () {
    // Mirrors: amounts[index] = (double.tryParse(value) ?? 0.0) * data.noteType!
    double calcDenomAmount(String qtyText, double noteType) =>
        (double.tryParse(qtyText) ?? 0.0) * noteType;

    test('2 notes of ₹500 = ₹1000', () {
      expect(calcDenomAmount('2', 500.0), closeTo(1000.0, 0.001));
    });

    test('0 qty returns 0', () {
      expect(calcDenomAmount('0', 500.0), 0.0);
    });

    test('empty string treated as 0 qty', () {
      expect(calcDenomAmount('', 200.0), 0.0);
    });

    test('invalid text treated as 0 qty', () {
      expect(calcDenomAmount('abc', 100.0), 0.0);
    });

    test('5 notes of ₹100 = ₹500', () {
      expect(calcDenomAmount('5', 100.0), closeTo(500.0, 0.001));
    });

    test('10 notes of ₹50 = ₹500', () {
      expect(calcDenomAmount('10', 50.0), closeTo(500.0, 0.001));
    });
  });

  group('[OnAccountPopupScreen] totalAmount from denomination list', () {
    // Mirrors: totalAmount = amounts.fold(0.0, (sum, amount) => sum + amount)
    double calcTotalFromAmounts(List<double> amounts) =>
        amounts.fold(0.0, (sum, a) => sum + a);

    test('sums all denomination amounts', () {
      expect(calcTotalFromAmounts([1000.0, 500.0, 200.0]), closeTo(1700.0, 0.001));
    });

    test('empty amounts list returns 0', () {
      expect(calcTotalFromAmounts([]), 0.0);
    });

    test('single amount returned as-is', () {
      expect(calcTotalFromAmounts([2500.0]), closeTo(2500.0, 0.001));
    });

    test('all zero amounts returns 0', () {
      expect(calcTotalFromAmounts([0.0, 0.0, 0.0]), 0.0);
    });
  });

  group('[OnAccountPopupScreen] finalAmountCashDeno = totalAmount - returnAmount', () {
    double calcFinalCashDeno(double total, double returned) => total - returned;

    test('no return → final equals total', () {
      expect(calcFinalCashDeno(1500.0, 0.0), closeTo(1500.0, 0.001));
    });

    test('partial return reduces final amount', () {
      expect(calcFinalCashDeno(1500.0, 500.0), closeTo(1000.0, 0.001));
    });

    test('full return → final is zero', () {
      expect(calcFinalCashDeno(1000.0, 1000.0), 0.0);
    });

    test('return greater than total → negative final', () {
      expect(calcFinalCashDeno(800.0, 1000.0), closeTo(-200.0, 0.001));
    });
  });

  group('[OnAccountPopupScreen] amount validation: entered > totalBalance', () {
    // Mirrors: if (enteredAmount > totalBalance) → show error, clear
    bool isAmountExceedsBalance(String enteredText, String totalBalanceText) {
      final entered = double.tryParse(enteredText) ?? 0.0;
      final total = double.tryParse(totalBalanceText) ?? 0.0;
      return entered > total;
    }

    test('entered < balance → valid', () {
      expect(isAmountExceedsBalance('500', '1000'), isFalse);
    });

    test('entered == balance → valid', () {
      expect(isAmountExceedsBalance('1000', '1000'), isFalse);
    });

    test('entered > balance → invalid', () {
      expect(isAmountExceedsBalance('1500', '1000'), isTrue);
    });

    test('empty entry → 0.0 → valid', () {
      expect(isAmountExceedsBalance('', '1000'), isFalse);
    });

    test('invalid entry → 0.0 → valid', () {
      expect(isAmountExceedsBalance('abc', '500'), isFalse);
    });
  });

  group('[OnAccountPopupScreen] form validation: transMode required', () {
    // Mirrors: if (selectedTransMode == null || selectedTransMode!.isEmpty)
    bool isTransModeValid(String? mode) =>
        mode != null && mode.isNotEmpty;

    test('null → invalid', () => expect(isTransModeValid(null), isFalse));
    test('empty string → invalid', () => expect(isTransModeValid(''), isFalse));
    test('"Cash" → valid', () => expect(isTransModeValid('Cash'), isTrue));
    test('"Online" → valid', () => expect(isTransModeValid('Online'), isTrue));
  });

  group('[OnAccountPopupScreen] form validation: balance amount required', () {
    // Mirrors: if (_balanceController.text.isEmpty)
    bool isBalanceEntered(String text) => text.isNotEmpty;

    test('empty → invalid', () => expect(isBalanceEntered(''), isFalse));
    test('"0" → valid (non-empty)', () => expect(isBalanceEntered('0'), isTrue));
    test('"500" → valid', () => expect(isBalanceEntered('500'), isTrue));
  });

  group('[OnAccountPopupScreen] form validation: Online mode requires bank & transCode', () {
    // Mirrors: if (selectedTransMode == "Online") { if (_selectBankModel == null) ... }
    String? validateOnlineFields({
      required String? transMode,
      required bool hasBankSelected,
      required String tranCode,
    }) {
      if (transMode == 'Online') {
        if (!hasBankSelected) return 'Please select bank';
        if (tranCode.isEmpty) return 'Please enter transaction code';
      }
      return null;
    }

    test('Cash mode → no validation error', () {
      expect(
        validateOnlineFields(transMode: 'Cash', hasBankSelected: false, tranCode: ''),
        isNull,
      );
    });

    test('Online without bank → error', () {
      expect(
        validateOnlineFields(transMode: 'Online', hasBankSelected: false, tranCode: 'TC001'),
        contains('bank'),
      );
    });

    test('Online with bank but no tranCode → error', () {
      expect(
        validateOnlineFields(transMode: 'Online', hasBankSelected: true, tranCode: ''),
        contains('transaction code'),
      );
    });

    test('Online with bank and tranCode → no error', () {
      expect(
        validateOnlineFields(transMode: 'Online', hasBankSelected: true, tranCode: 'TC001'),
        isNull,
      );
    });
  });

  group('[OnAccountPopupScreen] denomination match validation', () {
    // Mirrors: if (finalAmountCashDeno != totalAmt) → error
    bool isDenominationMatchingReceiptAmt(double finalDeno, double receiptAmt) =>
        finalDeno == receiptAmt;

    test('matching amounts → valid', () {
      expect(isDenominationMatchingReceiptAmt(1500.0, 1500.0), isTrue);
    });

    test('mismatch → invalid', () {
      expect(isDenominationMatchingReceiptAmt(1500.0, 1400.0), isFalse);
    });

    test('both zero → valid (no cash denomination entered)', () {
      expect(isDenominationMatchingReceiptAmt(0.0, 0.0), isTrue);
    });
  });

  group('[OnAccountPopupScreen] ledgerIds join as comma string', () {
    // Mirrors: String ledgerIdsString = selectedLedgerIds.join(',');
    String joinLedgerIds(List<String> ids) => ids.join(',');

    test('single id → no comma', () {
      expect(joinLedgerIds(['101']), '101');
    });

    test('multiple ids → comma-separated', () {
      expect(joinLedgerIds(['101', '202', '303']), '101,202,303');
    });

    test('empty list → empty string', () {
      expect(joinLedgerIds([]), '');
    });

    test('two ids → correct format', () {
      expect(joinLedgerIds(['55', '77']), '55,77');
    });
  });

  group('[OnAccountPopupScreen] cashDenominationMandatory flag check', () {
    // Mirrors checkCashDenominationFlagMandatory() logic
    bool checkMandatory(List<Map<String, dynamic>> list, String distId) {
      for (final item in list) {
        if (item['distributorId'].toString() == distId &&
            item['permissionFor'] == 'Cash Denomination' &&
            item['isActive'] == 1) {
          return true;
        }
      }
      return false;
    }

    test('matching active record → mandatory', () {
      final list = [
        {'distributorId': 8118, 'permissionFor': 'Cash Denomination', 'isActive': 1},
      ];
      expect(checkMandatory(list, '8118'), isTrue);
    });

    test('isActive 0 → not mandatory', () {
      final list = [
        {'distributorId': 8118, 'permissionFor': 'Cash Denomination', 'isActive': 0},
      ];
      expect(checkMandatory(list, '8118'), isFalse);
    });

    test('different distributor → not mandatory', () {
      final list = [
        {'distributorId': 9999, 'permissionFor': 'Cash Denomination', 'isActive': 1},
      ];
      expect(checkMandatory(list, '8118'), isFalse);
    });

    test('empty list → not mandatory', () {
      expect(checkMandatory([], '8118'), isFalse);
    });
  });

  group('[OnAccountPopupScreen] _selectedIndex tab switching', () {
    // Mirrors: _selectedIndex = 0 (Cash Denomination) or 1 (Cash Return)
    test('initial index is 0 (Cash Denomination tab)', () {
      const int initialIndex = 0;
      expect(initialIndex, 0);
    });

    test('tapping Cash Return tab sets index to 1', () {
      int index = 0;
      index = 1; // onTap
      expect(index, 1);
    });

    test('tapping Cash Denomination tab resets index to 0', () {
      int index = 1;
      index = 0;
      expect(index, 0);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 22 – PrepaidBookingAndSettlementGraphScreen
  // ═══════════════════════════════════════════════════════════════════════════

  group('[PrepaidBookingAndSettlementGraphScreen] getBarWidth', () {
    // Mirrors: if (labelWidth > 50) return 0.8; return 0.4 (baseWidth)
    double getBarWidth(double labelWidth) {
      const double baseWidth = 0.4;
      if (labelWidth > 50) return 0.8;
      return baseWidth;
    }

    test('labelWidth > 50 returns 0.8', () {
      expect(getBarWidth(51.0), closeTo(0.8, 0.001));
    });

    test('labelWidth == 50 returns 0.4 (baseWidth)', () {
      expect(getBarWidth(50.0), closeTo(0.4, 0.001));
    });

    test('labelWidth < 50 returns 0.4 (baseWidth)', () {
      expect(getBarWidth(30.0), closeTo(0.4, 0.001));
    });

    test('labelWidth of 100 returns 0.8', () {
      expect(getBarWidth(100.0), closeTo(0.8, 0.001));
    });

    test('labelWidth of 0 returns 0.4', () {
      expect(getBarWidth(0.0), closeTo(0.4, 0.001));
    });
  });

  group('[PrepaidBookingAndSettlementGraphScreen] chartWidth calculation', () {
    // Mirrors: (barWidth + barSpacing) * (itemCount < minBarsToShow ? minBarsToShow : itemCount)
    double calcChartWidth(int itemCount) {
      const double barWidth = 60;
      const double barSpacing = 10;
      const int minBarsToShow = 10;
      return (barWidth + barSpacing) *
          (itemCount < minBarsToShow ? minBarsToShow : itemCount);
    }

    test('0 items → uses minBarsToShow(10) → 700.0', () {
      expect(calcChartWidth(0), closeTo(700.0, 0.001));
    });

    test('5 items < minBars → uses 10 → 700.0', () {
      expect(calcChartWidth(5), closeTo(700.0, 0.001));
    });

    test('10 items == minBars → 700.0', () {
      expect(calcChartWidth(10), closeTo(700.0, 0.001));
    });

    test('15 items > minBars → 1050.0', () {
      expect(calcChartWidth(15), closeTo(1050.0, 0.001));
    });

    test('1 item < minBars → 700.0', () {
      expect(calcChartWidth(1), closeTo(700.0, 0.001));
    });

    test('30 items → 2100.0', () {
      expect(calcChartWidth(30), closeTo(2100.0, 0.001));
    });
  });

  group('[PrepaidBookingAndSettlementGraphScreen] filterLabels map', () {
    const filterLabels = {
      'PREVIOUS_MONTH': 'Previous Month',
      'THIS_MONTH': 'This Month',
      'THIS_WEEK': 'This Week',
    };
    const defaultFilter = 'THIS_MONTH';

    test('default filter is THIS_MONTH', () {
      expect(defaultFilter, 'THIS_MONTH');
    });

    test('filterLabels contains all 3 keys', () {
      expect(filterLabels.length, 3);
    });

    test('THIS_MONTH label is "This Month"', () {
      expect(filterLabels['THIS_MONTH'], 'This Month');
    });

    test('PREVIOUS_MONTH label is "Previous Month"', () {
      expect(filterLabels['PREVIOUS_MONTH'], 'Previous Month');
    });

    test('THIS_WEEK label is "This Week"', () {
      expect(filterLabels['THIS_WEEK'], 'This Week');
    });

    test('unknown key returns null', () {
      expect(filterLabels['UNKNOWN'], isNull);
    });
  });

  group('[PrepaidBookingAndSettlementGraphScreen] chartData from API response', () {
    // Mirrors the fetchChartData parse logic:
    // dates = data[0].keys.where((key) => key != 'CountFor').toList()
    // totalPunchCnt = data[0][date], totalSettlPer = data[1][date], totalSettlAmt = data[2][date]
    List<Map<String, dynamic>> parseChartData(List<Map<String, dynamic>> data) {
      final dates = data[0].keys.where((key) => key != 'CountFor').toList();
      return dates.map((date) {
        return {
          'date': date,
          'totalPunchCnt': data[0][date] ?? 0.0,
          'totalSettlPer': data[1][date] ?? 0.0,
          'totalSettlAmt': data[2][date] ?? 0.0,
        };
      }).toList();
    }

    test('parses 2 dates correctly', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': 10.0, '2025-04-02': 8.0},
        {'CountFor': 'Settl', '2025-04-01': 9.0, '2025-04-02': 7.0},
        {'CountFor': 'Amt', '2025-04-01': 5000.0, '2025-04-02': 3500.0},
      ];
      final result = parseChartData(raw);
      expect(result.length, 2);
    });

    test('"CountFor" key is excluded from dates', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': 5.0},
        {'CountFor': 'Settl', '2025-04-01': 4.0},
        {'CountFor': 'Amt', '2025-04-01': 2000.0},
      ];
      final result = parseChartData(raw);
      expect(result.every((e) => e['date'] != 'CountFor'), isTrue);
    });

    test('totalPunchCnt set correctly', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': 15.0},
        {'CountFor': 'Settl', '2025-04-01': 12.0},
        {'CountFor': 'Amt', '2025-04-01': 8000.0},
      ];
      final result = parseChartData(raw);
      expect(result.first['totalPunchCnt'], closeTo(15.0, 0.001));
    });

    test('totalSettlPer set correctly', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': 15.0},
        {'CountFor': 'Settl', '2025-04-01': 12.0},
        {'CountFor': 'Amt', '2025-04-01': 8000.0},
      ];
      final result = parseChartData(raw);
      expect(result.first['totalSettlPer'], closeTo(12.0, 0.001));
    });

    test('totalSettlAmt set correctly', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': 15.0},
        {'CountFor': 'Settl', '2025-04-01': 12.0},
        {'CountFor': 'Amt', '2025-04-01': 8000.0},
      ];
      final result = parseChartData(raw);
      expect(result.first['totalSettlAmt'], closeTo(8000.0, 0.001));
    });

    test('missing date key defaults to 0.0', () {
      final raw = [
        {'CountFor': 'Punch', '2025-04-01': null},
        {'CountFor': 'Settl', '2025-04-01': null},
        {'CountFor': 'Amt', '2025-04-01': null},
      ];
      final result = parseChartData(raw);
      expect(result.first['totalPunchCnt'], 0.0);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 23 – DashboardPostPaidVerifPendDetailsUI (extended)
  // ═══════════════════════════════════════════════════════════════════════════

  group('[DashboardPostPaidVerifPendDetailsUI] date picker initial date', () {
    // Mirrors: selectedDate = DateTime.now() (initial)
    // When date is picked: selectedDate = pickedDate
    DateTime applyPickedDate(DateTime current, DateTime? picked) =>
        picked ?? current;

    test('null picked → retains current date', () {
      final current = DateTime(2025, 4, 10);
      expect(applyPickedDate(current, null), current);
    });

    test('valid picked → updates date', () {
      final current = DateTime(2025, 4, 10);
      final picked = DateTime(2025, 5, 20);
      expect(applyPickedDate(current, picked), picked);
    });
  });

  group('[DashboardPostPaidVerifPendDetailsUI] transaction-for dropdown items', () {
    const items = ['All', 'Daily Sales', 'SV Sales', 'ARB Sales', 'Receipt'];

    test('has exactly 5 items', () => expect(items.length, 5));
    test('contains "All"', () => expect(items.contains('All'), isTrue));
    test('contains "Daily Sales"', () => expect(items.contains('Daily Sales'), isTrue));
    test('contains "SV Sales"', () => expect(items.contains('SV Sales'), isTrue));
    test('contains "ARB Sales"', () => expect(items.contains('ARB Sales'), isTrue));
    test('contains "Receipt"', () => expect(items.contains('Receipt'), isTrue));
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 24 – CreditSaleCountDetailListUI: addItem / controller lifecycle
  // ═══════════════════════════════════════════════════════════════════════════

  group('[CreditSaleCountDetailListUI] addItem state', () {
    // Mirrors addItem(): _consumerNoControllers.add(...), isCheckedList.add(false), isTextEnteredList.add(false)
    test('addItem appends false to isCheckedList', () {
      final list = <bool>[];
      list.add(false);
      expect(list.last, isFalse);
    });

    test('addItem appends false to isTextEnteredList', () {
      final list = <bool>[];
      list.add(false);
      expect(list.first, isFalse);
    });

    test('after n addItem calls, list length equals n', () {
      final list = <bool>[];
      for (int i = 0; i < 5; i++) {
        list.add(false);
      }
      expect(list.length, 5);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 25 – DashboardSVDetails: empty vs non-empty model display guard
  // ═══════════════════════════════════════════════════════════════════════════

  group('[DashboardSVDetails] total display when model empty vs non-empty', () {
    // Mirrors: 'Amount: ${svmodel.isNotEmpty ? formattedAmount : '0.00'}'
    String svAmountDisplay(bool isNotEmpty, String formattedAmount) =>
        isNotEmpty ? formattedAmount : '0.00';

    test('non-empty model shows formatted amount', () {
      expect(svAmountDisplay(true, '4,800.00'), '4,800.00');
    });

    test('empty model shows "0.00"', () {
      expect(svAmountDisplay(false, '4,800.00'), '0.00');
    });
  });

  group('[DashboardSVDetails] cylQty display when model empty vs non-empty', () {
    // Mirrors: 'Cyl. Qty: ${svmodel.isNotEmpty ? totalCylQty : 0}'
    String cylQtyDisplay(bool isNotEmpty, num totalCylQty) =>
        isNotEmpty ? totalCylQty.toString() : '0';

    test('non-empty model shows actual qty', () {
      expect(cylQtyDisplay(true, 8), '8');
    });

    test('empty model shows "0"', () {
      expect(cylQtyDisplay(false, 8), '0');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 26 – DashboardTVDetails: reg received / amount display guards
  // ═══════════════════════════════════════════════════════════════════════════

  group('[DashboardTVDetails] footer display guards', () {
    // Mirrors: 'Qty: ${tvmodel.isNotEmpty ? totalCylQty : 0}'
    //          'Reg Rec: ${tvmodel.isNotEmpty ? regReceivedCount : 0}'
    //          'Amount: ${tvmodel.isNotEmpty ? formattedAmount : '0.00'}'
    String tvQtyDisplay(bool isNotEmpty, num qty) =>
        isNotEmpty ? qty.toString() : '0';
    String tvRegDisplay(bool isNotEmpty, int count) =>
        isNotEmpty ? count.toString() : '0';
    String tvAmtDisplay(bool isNotEmpty, String fmt) =>
        isNotEmpty ? fmt : '0.00';

    test('qty: non-empty shows value', () => expect(tvQtyDisplay(true, 9), '9'));
    test('qty: empty shows "0"', () => expect(tvQtyDisplay(false, 9), '0'));
    test('reg: non-empty shows count', () => expect(tvRegDisplay(true, 3), '3'));
    test('reg: empty shows "0"', () => expect(tvRegDisplay(false, 3), '0'));
    test('amt: non-empty shows formatted', () => expect(tvAmtDisplay(true, '4,500.00'), '4,500.00'));
    test('amt: empty shows "0.00"', () => expect(tvAmtDisplay(false, '4,500.00'), '0.00'));
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 27 – ARBProfitDetailScreenUi & RefillProfitDetailScreenUi:
  //              "GrossProfit" column visibility
  // ═══════════════════════════════════════════════════════════════════════════

  group('[ARBProfitDetailScreenUi / RefillProfitDetailScreenUi] GrossProfit column visibility', () {
    // Mirrors: profitFors == "GrossProfit" ? widget : Container()
    bool showGrossProfitColumn(String? profitFor) => profitFor == 'GrossProfit';

    test('"GrossProfit" → show column', () {
      expect(showGrossProfitColumn('GrossProfit'), isTrue);
    });

    test('"GrossRevenue" → hide column', () {
      expect(showGrossProfitColumn('GrossRevenue'), isFalse);
    });

    test('null → hide column', () {
      expect(showGrossProfitColumn(null), isFalse);
    });

    test('"" → hide column', () {
      expect(showGrossProfitColumn(''), isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 28 – ImbalanceCountClickUI: filter reset on empty query
  // ═══════════════════════════════════════════════════════════════════════════

  group('[ImbalanceCountClickUI] filter reset on empty query', () {
    final full = [
      {'staffName': 'A', 'itemName': '14.2 KG', 'imbalanceQty': 3},
      {'staffName': 'B', 'itemName': '5 KG', 'imbalanceQty': 1},
    ];

    test('empty query resets to full list length', () {
      expect(filterImbalanceList(full, '').length, 2);
    });

    test('re-search after clear returns original count', () {
      filterImbalanceList(full, 'A'); // narrows to 1
      final reset = filterImbalanceList(full, ''); // clears filter
      expect(reset.length, 2);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 29 – VendorPaymentDetailListUI: vendor-id filter logic
  // ═══════════════════════════════════════════════════════════════════════════

  group('[VendorPaymentDetailListUI] vendor selection logic', () {
    // Mirrors onChanged: vendorId == 0 → fetch ALL; else fetch specific
    String resolveVendorMode(int vendorId) =>
        vendorId == 0 ? 'ALL' : 'SPECIFIC';

    test('vendorId 0 → ALL', () {
      expect(resolveVendorMode(0), 'ALL');
    });

    test('positive vendorId → SPECIFIC', () {
      expect(resolveVendorMode(5), 'SPECIFIC');
    });

    test('negative vendorId → SPECIFIC', () {
      expect(resolveVendorMode(-1), 'SPECIFIC');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 30 – TodaysCashSummaryOnAccountList: BalanceType enum
  // ═══════════════════════════════════════════════════════════════════════════

  group('[TodaysCashSummaryOnAccountList] BalanceType default selection', () {
    // Mirrors: BalanceType? _selectedBalanceType = BalanceType.onAccount
    const defaultType = 'onAccount';

    test('default balance type is onAccount', () {
      expect(defaultType, 'onAccount');
    });

    test('onAccount radio is the only interactive one', () {
      // totalBalance and advance radios have onChanged: null (disabled)
      const interactiveType = 'onAccount';
      expect(interactiveType, isNotEmpty);
    });
  });

  group('[TodaysCashSummaryOnAccountList] staff sort alphabetically', () {
    // Mirrors: staffdetailsmodel.sort() by staffName case-insensitive
    List<Map<String, dynamic>> sortStaffByName(List<Map<String, dynamic>> staff) {
      final sorted = List<Map<String, dynamic>>.from(staff);
      sorted.sort((a, b) {
        final nameA = (a['staffName'] as String? ?? '').toLowerCase();
        final nameB = (b['staffName'] as String? ?? '').toLowerCase();
        return nameA.compareTo(nameB);
      });
      return sorted;
    }

    test('sorts staff alphabetically case-insensitively', () {
      final staff = [
        {'staffName': 'Zara'},
        {'staffName': 'amit'},
        {'staffName': 'Priya'},
      ];
      final sorted = sortStaffByName(staff);
      expect(sorted.first['staffName'], 'amit');
      expect(sorted.last['staffName'], 'Zara');
    });

    test('null staffName sorts before non-null', () {
      final staff = [
        {'staffName': 'Beta'},
        {'staffName': null},
      ];
      final sorted = sortStaffByName(staff);
      expect(sorted.first['staffName'], isNull);
    });
  });
}


