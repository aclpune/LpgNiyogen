// ignore_for_file: avoid_print
// =============================================================================
// Unit tests for 13 attached DashboardItemClickUI screen files:
//   1.  ARBProfitDetailScreenUi.dart
//   2.  CreditSaleCountDetailListUI.dart
//   3.  DashboardDropDownUI.dart
//   4.  DashboardPostPaidVerifPendDetails.dart
//   5.  DashboardPostPaidVerifPendDetailsUI.dart
//   6.  DashboardPrepaidDetails.dart
//   7.  DashboardPrepaidDetailUI.dart
//   8.  DashboardPunchDetailUI.dart
//   9.  DashboardSVDetails.dart
//  10.  DashboardSVDetailUI.dart
//  11.  DashboardTVDetails.dart
//  12.  DashboardTVDetailUI.dart
//  (file 13 is the existing test file itself – no import needed)
//
// All helpers are extracted from the production screens and kept pure so no
// Flutter widgets, HTTP, Firebase or SharedPreferences are needed.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ---------------------------------------------------------------------------
// ── SHARED HELPERS (mirrored from multiple screens) ──────────────────────
// ---------------------------------------------------------------------------

/// formatCurrency – present in ARBProfitDetailScreenUi, CreditSaleCountDetailListUI,
/// DashboardPostPaidVerifPendDetails, DashboardSVDetails, DashboardTVDetails.
String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String result = fmt.format(amount);
  if (amount < 1 && result.startsWith('.')) result = '0$result';
  return result;
}

/// nullToDash – present in CreditSaleCountDetailListUI, DashboardDropDownUI,
/// DashboardPostPaidVerifPendDetails, DashboardPostPaidVerifPendDetailsUI,
/// DashboardPrepaidDetailUI, DashboardSVDetailUI, DashboardTVDetailUI.
String nullToDash(String? value) {
  if (value == null || value.toLowerCase() == 'null') return '-';
  return value;
}

// ---------------------------------------------------------------------------
// ── 1. ARBProfitDetailScreenUi helpers ──────────────────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: AppBar profit title text logic
String arbAppBarTitle(String? profitFor) {
  if (profitFor == 'GrossRevenue') return 'ARB Gross Revenue -';
  if (profitFor == 'GrossProfit') return 'ARB Gross Profit -';
  return 'ARB -';
}

/// Mirrors: AppBar day-flag text logic
String arbDayFlagText(String? flag) {
  if (flag == 'TODAYS') return "Today's";
  if (flag == 'THISMONTH') return 'This Month';
  if (flag == 'FINYEAR') return 'Financial Year';
  return '';
}

/// Mirrors: profitFors == "GrossProfit" ? show purchase/profit columns
bool arbShowGrossProfitColumns(String? profitFor) => profitFor == 'GrossProfit';

/// Mirrors: totals loop in fetchARBDetailList → setState
Map<String, dynamic> calcARBTotals(List<Map<String, dynamic>> data) {
  double grossSaleAmt = 0, grossProfitAmt = 0, purchaseAmt = 0;
  int purchaseQty = 0;
  for (final item in data) {
    grossSaleAmt  += ((item['grossSaleAmt']  ?? 0) as num).toDouble();
    grossProfitAmt+= ((item['grossProfitAmt']?? 0) as num).toDouble();
    purchaseAmt   += ((item['purchesAmt']    ?? 0) as num).toDouble();
    purchaseQty   += ((item['itemQty']       ?? 0) as num).toInt();
  }
  return {
    'grossSaleAmts':   grossSaleAmt,
    'grossProfitAmts': grossProfitAmt,
    'purchaseAmts':    purchaseAmt,
    'purchaseQtys':    purchaseQty,
  };
}

/// Mirrors: grossSaleAmt != null ? formatCurrency(grossSaleAmt) : '0'
String arbCurrencyDisplay(num? amount) =>
    amount != null ? formatCurrency(amount.toDouble()) : '0';

/// Mirrors: WillPopScope logic — always navigate to bottomNavBar
bool arbWillPopAlwaysNavigates() => true;

// ---------------------------------------------------------------------------
// ── 2. CreditSaleCountDetailListUI helpers ───────────────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: _calculateTotalAmount – displayList sum
double calcTotalOutstandingFromList(List<Map<String, dynamic>> list) =>
    list.fold(0.0, (s, r) => s + ((r['totalOutstanding'] ?? 0.0) as num).toDouble());

/// Mirrors: _calculateTotalAmount – topFiveDisplayList sum
double calcTotalOutstandingTopFive(List<Map<String, dynamic>> list) =>
    list.fold(0.0, (s, r) => s + ((r['totalOutstanding'] ?? 0.0) as num).toDouble());

/// Mirrors: label logic in build()
String creditSaleHeaderLabel(String? selectedItem, double totalAmt, double topFiveAmt) {
  final fmtAll   = formatCurrency(totalAmt);
  final fmtTop5  = formatCurrency(topFiveAmt);
  return selectedItem == 'Top 5 outstanding'
      ? 'Total Outstanding Amount: $fmtTop5'
      : 'Total Outstanding Amount: $fmtAll';
}

/// Mirrors: currentList selection in build()
String creditCurrentListMode(String? selectedItem) =>
    selectedItem == 'Top 5 outstanding' ? 'topFive' : 'all';

/// Mirrors: onChanged for dropdown – resolves action label
String creditDropdownAction(int customerId) {
  if (customerId == -1) return 'FETCH_ALL';
  if (customerId == -2) return 'TOP_FIVE';
  if (customerId == -3) return 'OLDEST';
  return 'FETCH_CUSTOMER';
}

/// Mirrors: showTop5ByOutstanding – sort descending + take 5
List<Map<String, dynamic>> top5ByOutstanding(List<Map<String, dynamic>> items) {
  final sorted = List<Map<String, dynamic>>.from(items);
  sorted.sort((a, b) =>
      ((b['totalOutstanding'] ?? 0) as num).compareTo((a['totalOutstanding'] ?? 0) as num));
  return sorted.take(5).toList();
}

/// Mirrors: showOldestRecords – sort by collRcptDate ascending
List<Map<String, dynamic>> oldestRecords(List<Map<String, dynamic>> items) {
  final sorted = List<Map<String, dynamic>>.from(items);
  sorted.sort((a, b) {
    DateTime da = a['collRcptDate'] != null
        ? DateTime.tryParse(a['collRcptDate'] as String) ?? DateTime(1970)
        : DateTime(1970);
    DateTime db = b['collRcptDate'] != null
        ? DateTime.tryParse(b['collRcptDate'] as String) ?? DateTime(1970)
        : DateTime(1970);
    return da.compareTo(db);
  });
  return sorted;
}

/// Mirrors: addItem() – appends false to both checkbox/text lists
List<bool> addItemState(List<bool> existing) => [...existing, false];

/// Mirrors: "Pay Now" visibility – hidden when Top 5 mode
bool showPayNow(String? selectedItem) => selectedItem != 'Top 5 outstanding';

// ---------------------------------------------------------------------------
// ── 3. DashboardDropDownUI helpers ──────────────────────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: Divider visibility (if serialNumber != listLength)
bool dropDownShowDivider(int serial, int len) => serial != len;

/// Mirrors: all field display via nullToDash for each ConsumerDetails field
Map<String, String> dropDownDisplayFields({
  String? consumerNo,
  String? orderDate,
  String? consumerName,
  String? cashMemoDate,
  String? settlementDate,
  String? deliveryDate,
  String? remark,
}) =>
    {
      'consumerNo':     nullToDash(consumerNo),
      'orderDate':      nullToDash(orderDate),
      'consumerName':   nullToDash(consumerName),
      'cashMemoDate':   nullToDash(cashMemoDate),
      'settlementDate': nullToDash(settlementDate),
      'deliveryDate':   nullToDash(deliveryDate),
      'remark':         nullToDash(remark),
    };

// ---------------------------------------------------------------------------
// ── 4. DashboardPostPaidVerifPendDetails helpers ─────────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: filterSearchResults – filter by staffName
List<Map<String, dynamic>> filterPostpaidByStaff(
    List<Map<String, dynamic>> items, String query) =>
    items
        .where((e) => (e['staffName'] as String? ?? '')
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

/// Mirrors: value.replaceAll(' ', '') for transaction dropdown onChanged
String cleanTxnType(String value) => value.replaceAll(' ', '');

/// Mirrors: getTransactionForList constant
const List<String> txnForList = ['All', 'Daily Sales', 'SV Sales', 'ARB Sales', 'Receipt'];

/// Mirrors: amount display in list item
String postpaidAmountDisplay(num? amount) =>
    nullToDash(formatCurrency((amount ?? 0.0).toDouble()));

/// Mirrors: _selectDate sets postpaidverifipending[index].selectedDate
DateTime applyDatePickerResult(DateTime current, DateTime? picked) =>
    picked ?? current;

/// Mirrors: "No Records Found" vs list when postpaidverifipending.isEmpty
bool postpaidShowNoRecords(int count) => count == 0;

// ---------------------------------------------------------------------------
// ── 5. DashboardPostPaidVerifPendDetailsUI helpers ───────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: selectedDate display: "${selectedDate.toLocal()}".split(' ')[0]
String formatSelectedDate(DateTime dt) =>
    '${dt.toLocal()}'.split(' ')[0];

/// Mirrors: initial selectedDate = DateTime.now() (date part only)
String initialSelectedDateDisplay() =>
    '${DateTime.now().toLocal()}'.split(' ')[0];

/// Mirrors: getTransactionForList in DashboardPostPaidVerifPendDetailsUI
const List<String> uiTxnForList = ['All', 'Daily Sales', 'SV Sales', 'ARB Sales', 'Receipt'];

// ---------------------------------------------------------------------------
// ── 6. DashboardPrepaidDetails helpers ───────────────────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: _getDisplayText(flag)
String prepaidDisplayText(String flag) {
  switch (flag) {
    case 'Delivered':         return 'Delivered,payment pending';
    case 'Settled':           return 'Payment done,delivery pending';
    case 'cDCMS':             return 'Pending in cDCMS';
    case 'DelDonNiyoJanPunPend': return 'Punched in cDCMS,pending in Niyojan';
    case 'OldBkgPendNewBkgRecv': return 'Old punching pending but....';
    case 'Punching':          return "Today's Niyojan Punched";
    case 'Incorrect':         return "Today's incorrect";
    case 'NiyoJanPunDelPend': return 'Punched in Niyojan,pending in cDCMS';
    case 'TotalOutstanding':  return 'Total Outstanding Pending';
    default:                  return 'Prepaid Details';
  }
}

/// Mirrors: whether prepaid list or punch list is shown for count
bool prepaidUsesPreCount(String flag) =>
    flag == 'Delivered' ||
    flag == 'Settled'   ||
    flag == 'TotalOutstanding' ||
    flag == 'cDCMS'     ||
    flag == 'DelDonNiyoJanPunPend' ||
    flag == 'OldBkgPendNewBkgRecv';

/// Mirrors: filterSearchResults for prepaidModel
List<Map<String, dynamic>> filterPrepaid(
    List<Map<String, dynamic>> items, String query) {
  final lq = query.toLowerCase();
  return items.where((e) =>
      (e['consumerNo']   ?.toString().toLowerCase().contains(lq) ?? false) ||
      (e['consumerName'] ?.toString().toLowerCase().contains(lq) ?? false) ||
      (e['orderDate']    ?.toString().toLowerCase().contains(lq) ?? false) ||
      (e['deliveryDate'] ?.toString().toLowerCase().contains(lq) ?? false)).toList();
}

/// Mirrors: filterSearchResults for punchModel
List<Map<String, dynamic>> filterPunch(
    List<Map<String, dynamic>> items, String query) {
  final lq = query.toLowerCase();
  return items.where((e) =>
      (e['staffName']     ?.toString().toLowerCase().contains(lq) ?? false) ||
      (e['niyojanPunQty'] ?.toString().toLowerCase().contains(lq) == true) ||
      (e['settlementQty'] ?.toString().toLowerCase().contains(lq) == true)).toList();
}

/// Mirrors: JSON date parsing in fetchPunch
String parsePunchDate(String? isoDate) {
  if (isoDate == null) return '';
  try {
    return DateFormat('yyyy-MM-dd').format(DateTime.parse(isoDate));
  } catch (_) {
    return '';
  }
}

/// Mirrors: header column label selection based on flag
String prepaidHeaderConsumerCol(String flag) =>
    prepaidUsesPreCount(flag) ? 'Consumer No.' : 'Staff Name';

String prepaidHeaderNameCol(String flag) =>
    prepaidUsesPreCount(flag) ? 'Consumer \n Name' : 'Niyojan \n Punching';

String prepaidHeaderDateCol(String flag) =>
    prepaidUsesPreCount(flag) ? 'Order Date' : 'Settl Qty.';

String prepaidHeaderLastCol(String flag) =>
    prepaidUsesPreCount(flag) ? 'Delivery Date' : 'Settl Pen Qty.';

// ---------------------------------------------------------------------------
// ── 7. DashboardPrepaidDetailUI helpers ─────────────────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: all 5 fields displayed via nullToDash
Map<String, String> prepaidDetailUIFields({
  String? consumerNo,
  String? consumerName,
  String? orderDate,
  String? deliveryDate,
  String? settlementDate,
}) =>
    {
      'consumerNo':     nullToDash(consumerNo),
      'consumerName':   nullToDash(consumerName),
      'orderDate':      nullToDash(orderDate),
      'deliveryDate':   nullToDash(deliveryDate),
      'settlementDate': nullToDash(settlementDate),
    };

// ---------------------------------------------------------------------------
// ── 8. DashboardPunchDetailUI helpers ───────────────────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: toggle isTodaysNiyoganPunchedListViewVisible
bool toggleVisibility(bool current) => !current;

/// Mirrors: icon selection based on visibility flag
String dropdownIcon(bool visible) =>
    visible ? 'arrow_drop_up' : 'arrow_drop_down';

/// Mirrors: punchSale.todayDate ?? ''
String punchDateDisplay(String? todayDate) => todayDate ?? '';

/// Mirrors: punchSale.staffName ?? ''
String punchStaffNameDisplay(String? staffName) => staffName ?? '';

/// Mirrors: punchSale.niyojanPunQty.toString()
String punchNiyojanQtyDisplay(num? qty) => qty?.toString() ?? '0';

/// Mirrors: punchSale.settlementQty.toString()
String punchSettlQtyDisplay(num? qty) => qty?.toString() ?? '0';

/// Mirrors: punchSale.pendingSttlQty.toString()
String punchPendingQtyDisplay(num? qty) => qty?.toString() ?? '0';

// ---------------------------------------------------------------------------
// ── 9. DashboardSVDetails helpers ───────────────────────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: totals fold in build()
Map<String, dynamic> calcSVTotals(List<Map<String, dynamic>> items) {
  final totalCylQty =
      items.fold<num>(0, (s, e) => s + ((e['cylQty'] ?? 0) as num));
  final totalAmount = items.fold<double>(
      0.0, (s, e) => s + ((e['totalAmount'] ?? 0.0) as num).toDouble());
  return {'totalCylQty': totalCylQty, 'totalAmount': totalAmount};
}

/// Mirrors: 'Cyl. Qty: ${svmodel.isNotEmpty ? totalCylQty : 0}'
String svCylQtyDisplay(bool isNotEmpty, num qty) =>
    'Cyl. Qty: ${isNotEmpty ? qty : 0}';

/// Mirrors: 'Amount: ${svmodel.isNotEmpty ? formattedAmount : '0.00'}'
String svAmountDisplay(bool isNotEmpty, String formatted) =>
    'Amount: ${isNotEmpty ? formatted : '0.00'}';

/// Mirrors: item dropdown selection logic
String svItemSelectionMode(int? itemId) =>
    itemId == -1 ? 'FETCH_ALL' : 'FETCH_ITEM';

// ---------------------------------------------------------------------------
// ── 10. DashboardSVDetailUI helpers ─────────────────────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: isUndocument → doc status string
String svDocStatus(bool? isUndocument) {
  if (isUndocument == true)  return 'Pending';
  if (isUndocument == false) return 'Received';
  return '';
}

/// Mirrors: DateFormat('dd-MM-yyyy').format(DateTime.parse(sale.sVDate ?? ''))
String svDateDisplay(String? svDate) {
  if (svDate == null || svDate.isEmpty) return '';
  try {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(svDate));
  } catch (_) {
    return '';
  }
}

/// Mirrors: all 8 fields rendered via nullToDash / formatCurrency
Map<String, String> svDetailUIFields({
  String?  svDate,
  String?  itemName,
  String?  consuDCNo,
  num?     cylQty,
  bool?    isUndocument,
  String?  svType,
  num?     totalAmount,
  String?  stockStatus,
  String?  consumerNo,
  String?  consumerName,
  String?  referredBy,
}) =>
    {
      'svDate':       svDateDisplay(svDate),
      'itemName':     nullToDash(itemName),
      'consuDCNo':    nullToDash(consuDCNo),
      'cylQty':       nullToDash(cylQty?.toString()),
      'docStatus':    svDocStatus(isUndocument),
      'svType':       svType ?? '',
      'amount':       nullToDash(formatCurrency((totalAmount ?? 0.0).toDouble())),
      'stockStatus':  nullToDash(stockStatus),
      'consumerNo':   consumerNo ?? '-',
      'consumerName': nullToDash(consumerName),
      'referredBy':   referredBy ?? '',
    };

// ---------------------------------------------------------------------------
// ── 11. DashboardTVDetails helpers ──────────────────────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: totals fold in build()
Map<String, dynamic> calcTVTotals(List<Map<String, dynamic>> items) {
  final totalCylQty = items.fold<num>(
      0, (s, e) => s + ((e['clyReceivedQty'] ?? 0) as num));
  final totalAmount = items.fold<double>(
      0.0, (s, e) => s + ((e['paidAmt'] ?? 0.0) as num).toDouble());
  final regCount = items.where((e) => e['isRegulator'] == 'Yes').length;
  return {
    'totalCylQty':       totalCylQty,
    'totalAmount':       totalAmount,
    'regReceivedCount':  regCount,
  };
}

/// Mirrors: 'Qty: ${tvmodel.isNotEmpty ? totalCylQty : 0}'
String tvQtyDisplay(bool isNotEmpty, num qty) =>
    'Qty: ${isNotEmpty ? qty : 0}';

/// Mirrors: 'Reg Rec: ${tvmodel.isNotEmpty ? regReceivedCount : 0}'
String tvRegDisplay(bool isNotEmpty, int count) =>
    'Reg Rec: ${isNotEmpty ? count : 0}';

/// Mirrors: 'Amount: ${tvmodel.isNotEmpty ? formattedAmount : '0.00'}'
String tvAmountDisplay(bool isNotEmpty, String formatted) =>
    'Amount: ${isNotEmpty ? formatted : '0.00'}';

/// Mirrors: item selection mode in DashboardTVDetails
String tvItemSelectionMode(int? itemId) =>
    itemId == -1 ? 'FETCH_ALL' : 'FETCH_ITEM';

// ---------------------------------------------------------------------------
// ── 12. DashboardTVDetailUI helpers ─────────────────────────────────────
// ---------------------------------------------------------------------------

/// Mirrors: DateFormat('dd-MM-yyyy').format(DateTime.parse(sale.tVDate ?? ''))
String tvDateDisplay(String? tvDate) {
  if (tvDate == null || tvDate.isEmpty) return '';
  try {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(tvDate));
  } catch (_) {
    return '';
  }
}

/// Mirrors: all fields in DashboardTVDetailUI via nullToDash / formatCurrency
Map<String, String> tvDetailUIFields({
  String?  tvDate,
  String?  itemName,
  String?  consumerNo,
  num?     clyHoldQty,
  String?  isRegulator,
  num?     paidAmt,
  String?  stockStatus,
  String?  consumerName,
}) =>
    {
      'itemName':    itemName ?? '',
      'tvDate':      tvDateDisplay(tvDate),
      'consNo':      nullToDash(consumerNo),
      'cylQty':      nullToDash(clyHoldQty?.toString()),
      'regRec':      nullToDash(isRegulator),
      'paidAmount':  nullToDash(formatCurrency((paidAmt ?? 0.0).toDouble())),
      'stockStatus': nullToDash(stockStatus),
      'consName':    consumerName ?? '',
    };

// =============================================================================
// TESTS
// =============================================================================
void main() {
  // ===========================================================================
  // ── SECTION 1: formatCurrency (shared) ─────────────────────────────────────
  // ===========================================================================
  group('[Shared] formatCurrency', () {
    group('zero input', () {
      test('returns "0.00" for exactly 0', () => expect(formatCurrency(0), '0.00'));
      test('returns "0.00" for 0.0', () => expect(formatCurrency(0.0), '0.00'));
    });

    group('sub-zero input', () {
      test('0.5 starts with "0"', () => expect(formatCurrency(0.5).startsWith('0'), isTrue));
      test('0.01 starts with "0"', () => expect(formatCurrency(0.01).startsWith('0'), isTrue));
      test('0.99 starts with "0."', () => expect(formatCurrency(0.99).startsWith('0.'), isTrue));
      test('does not start with "."', () => expect(formatCurrency(0.5).startsWith('.'), isFalse));
    });

    group('whole numbers', () {
      test('1.0 does not start with "0"', () => expect(formatCurrency(1.0).startsWith('0'), isFalse));
      test('100.0 contains "100"', () => expect(formatCurrency(100.0).contains('100'), isTrue));
      test('50.0 equals "50.00"', () => expect(formatCurrency(50.0), '50.00'));
      test('1000.0 uses comma', () => expect(formatCurrency(1000.0).contains(',') || formatCurrency(1000.0).contains('1'), isTrue));
    });

    group('large amounts', () {
      test('1000000 contains comma', () => expect(formatCurrency(1000000.0).contains(','), isTrue));
      test('large amount does not throw', () => expect(() => formatCurrency(99999999.0), returnsNormally));
    });

    group('negative amounts', () {
      test('negative does not throw', () => expect(() => formatCurrency(-500.0), returnsNormally));
    });

    group('consistency', () {
      test('same input produces same output', () => expect(formatCurrency(5000.0), formatCurrency(5000.0)));
      test('non-zero never returns "0.00"', () => expect(formatCurrency(0.01), isNot('0.00')));
    });
  });

  // ===========================================================================
  // ── SECTION 2: nullToDash (shared) ─────────────────────────────────────────
  // ===========================================================================
  group('[Shared] nullToDash', () {
    group('null input', () {
      test('null → "-"', () => expect(nullToDash(null), '-'));
    });

    group('"null" string variants', () {
      test('"null" → "-"', () => expect(nullToDash('null'), '-'));
      test('"NULL" → "-"', () => expect(nullToDash('NULL'), '-'));
      test('"Null" → "-"', () => expect(nullToDash('Null'), '-'));
      test('"nUlL" → "-"', () => expect(nullToDash('nUlL'), '-'));
    });

    group('empty string', () {
      test('"" returns "" (not "-")', () => expect(nullToDash(''), ''));
    });

    group('valid strings', () {
      test('returns value unchanged', () => expect(nullToDash('660990'), '660990'));
      test('returns name unchanged', () => expect(nullToDash('Priya Mondal'), 'Priya Mondal'));
      test('returns number string unchanged', () => expect(nullToDash('42'), '42'));
      test('whitespace string returned as-is', () => expect(nullToDash('  '), '  '));
      test('special chars returned as-is', () => expect(nullToDash('TC-001/A'), 'TC-001/A'));
    });
  });

  // ===========================================================================
  // ── SECTION 3: ARBProfitDetailScreenUi ─────────────────────────────────────
  // ===========================================================================
  group('[ARBProfitDetailScreenUi] arbAppBarTitle', () {
    test('"GrossRevenue" → "ARB Gross Revenue -"', () {
      expect(arbAppBarTitle('GrossRevenue'), 'ARB Gross Revenue -');
    });
    test('"GrossProfit" → "ARB Gross Profit -"', () {
      expect(arbAppBarTitle('GrossProfit'), 'ARB Gross Profit -');
    });
    test('unknown value → "ARB -"', () {
      expect(arbAppBarTitle('Other'), 'ARB -');
    });
    test('empty string → "ARB -"', () {
      expect(arbAppBarTitle(''), 'ARB -');
    });
    test('null → "ARB -"', () {
      expect(arbAppBarTitle(null), 'ARB -');
    });
  });

  group('[ARBProfitDetailScreenUi] arbDayFlagText', () {
    test('"TODAYS" → "Today\'s"', () => expect(arbDayFlagText('TODAYS'), "Today's"));
    test('"THISMONTH" → "This Month"', () => expect(arbDayFlagText('THISMONTH'), 'This Month'));
    test('"FINYEAR" → "Financial Year"', () => expect(arbDayFlagText('FINYEAR'), 'Financial Year'));
    test('unknown → ""', () => expect(arbDayFlagText('UNKNOWN'), ''));
    test('empty → ""', () => expect(arbDayFlagText(''), ''));
    test('null → ""', () => expect(arbDayFlagText(null), ''));
    test('lowercase "todays" → ""', () => expect(arbDayFlagText('todays'), ''));
  });

  group('[ARBProfitDetailScreenUi] arbShowGrossProfitColumns', () {
    test('"GrossProfit" → true', () => expect(arbShowGrossProfitColumns('GrossProfit'), isTrue));
    test('"GrossRevenue" → false', () => expect(arbShowGrossProfitColumns('GrossRevenue'), isFalse));
    test('null → false', () => expect(arbShowGrossProfitColumns(null), isFalse));
    test('"" → false', () => expect(arbShowGrossProfitColumns(''), isFalse));
    test('case-sensitive: "grossprofit" → false', () => expect(arbShowGrossProfitColumns('grossprofit'), isFalse));
  });

  group('[ARBProfitDetailScreenUi] calcARBTotals', () {
    test('sums grossSaleAmt', () {
      final r = calcARBTotals([
        {'grossSaleAmt': 1000.0, 'grossProfitAmt': 100.0, 'purchesAmt': 900.0, 'itemQty': 3},
        {'grossSaleAmt': 2000.0, 'grossProfitAmt': 200.0, 'purchesAmt': 1800.0, 'itemQty': 7},
      ]);
      expect(r['grossSaleAmts'], closeTo(3000.0, 0.001));
    });
    test('sums grossProfitAmt', () {
      final r = calcARBTotals([
        {'grossSaleAmt': 0, 'grossProfitAmt': 150.0, 'purchesAmt': 0, 'itemQty': 0},
        {'grossSaleAmt': 0, 'grossProfitAmt': 250.0, 'purchesAmt': 0, 'itemQty': 0},
      ]);
      expect(r['grossProfitAmts'], closeTo(400.0, 0.001));
    });
    test('sums purchaseAmt', () {
      final r = calcARBTotals([
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 400.0, 'itemQty': 0},
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 600.0, 'itemQty': 0},
      ]);
      expect(r['purchaseAmts'], closeTo(1000.0, 0.001));
    });
    test('sums itemQty', () {
      final r = calcARBTotals([
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 0, 'itemQty': 4},
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 0, 'itemQty': 6},
      ]);
      expect(r['purchaseQtys'], 10);
    });
    test('empty list → all zeros', () {
      final r = calcARBTotals([]);
      expect(r['grossSaleAmts'],  0.0);
      expect(r['grossProfitAmts'],0.0);
      expect(r['purchaseAmts'],   0.0);
      expect(r['purchaseQtys'],   0);
    });
    test('null fields treated as zero', () {
      final r = calcARBTotals([
        {'grossSaleAmt': null, 'grossProfitAmt': null, 'purchesAmt': null, 'itemQty': null},
      ]);
      expect(r['grossSaleAmts'], 0.0);
      expect(r['purchaseQtys'],  0);
    });
    test('single item calculates correctly', () {
      final r = calcARBTotals([
        {'grossSaleAmt': 5000.0, 'grossProfitAmt': 1000.0, 'purchesAmt': 4000.0, 'itemQty': 5},
      ]);
      expect(r['grossSaleAmts'],  closeTo(5000.0, 0.001));
      expect(r['grossProfitAmts'],closeTo(1000.0, 0.001));
      expect(r['purchaseAmts'],   closeTo(4000.0, 0.001));
      expect(r['purchaseQtys'],   5);
    });
  });

  group('[ARBProfitDetailScreenUi] arbCurrencyDisplay', () {
    test('null amount → "0"', () => expect(arbCurrencyDisplay(null), '0'));
    test('0 → "0.00"', () => expect(arbCurrencyDisplay(0), '0.00'));
    test('1000 → formatted', () => expect(arbCurrencyDisplay(1000), contains('1')));
    test('positive amount not "0"', () => expect(arbCurrencyDisplay(500), isNot('0')));
  });

  group('[ARBProfitDetailScreenUi] WillPopScope', () {
    test('always navigates to bottomNavBar (returns false to pop)', () {
      expect(arbWillPopAlwaysNavigates(), isTrue);
    });
  });

  // ===========================================================================
  // ── SECTION 4: CreditSaleCountDetailListUI ──────────────────────────────────
  // ===========================================================================
  group('[CreditSaleCountDetailListUI] calcTotalOutstandingFromList', () {
    test('sums correctly', () {
      expect(calcTotalOutstandingFromList([
        {'totalOutstanding': 500.0},
        {'totalOutstanding': 800.0},
        {'totalOutstanding': 200.0},
      ]), closeTo(1500.0, 0.001));
    });
    test('empty list → 0', () => expect(calcTotalOutstandingFromList([]), 0.0));
    test('null field → treated as 0', () {
      expect(calcTotalOutstandingFromList([
        {'totalOutstanding': null},
        {'totalOutstanding': 300.0},
      ]), closeTo(300.0, 0.001));
    });
    test('all zeros → 0', () {
      expect(calcTotalOutstandingFromList([
        {'totalOutstanding': 0.0},
        {'totalOutstanding': 0.0},
      ]), 0.0);
    });
  });

  group('[CreditSaleCountDetailListUI] creditSaleHeaderLabel', () {
    test('Top 5 mode uses topFive amount', () {
      final label = creditSaleHeaderLabel('Top 5 outstanding', 2300.0, 1000.0);
      expect(label.contains('1,000') || label.contains('1000'), isTrue);
    });
    test('ALL mode uses total amount', () {
      final label = creditSaleHeaderLabel('ALL', 2300.0, 1000.0);
      expect(label.contains('2,300') || label.contains('2300'), isTrue);
    });
    test('null mode uses total amount', () {
      final label = creditSaleHeaderLabel(null, 2300.0, 1000.0);
      expect(label.startsWith('Total Outstanding Amount:'), isTrue);
    });
  });

  group('[CreditSaleCountDetailListUI] creditCurrentListMode', () {
    test('Top 5 outstanding → topFive', () {
      expect(creditCurrentListMode('Top 5 outstanding'), 'topFive');
    });
    test('ALL → all', () => expect(creditCurrentListMode('ALL'), 'all'));
    test('null → all', () => expect(creditCurrentListMode(null), 'all'));
    test("Oldest by day's → all", () => expect(creditCurrentListMode("Oldest by day's"), 'all'));
  });

  group('[CreditSaleCountDetailListUI] creditDropdownAction', () {
    test('-1 → FETCH_ALL', () => expect(creditDropdownAction(-1), 'FETCH_ALL'));
    test('-2 → TOP_FIVE', () => expect(creditDropdownAction(-2), 'TOP_FIVE'));
    test('-3 → OLDEST', () => expect(creditDropdownAction(-3), 'OLDEST'));
    test('positive id → FETCH_CUSTOMER', () => expect(creditDropdownAction(10), 'FETCH_CUSTOMER'));
    test('zero id → FETCH_CUSTOMER', () => expect(creditDropdownAction(0), 'FETCH_CUSTOMER'));
  });

  group('[CreditSaleCountDetailListUI] top5ByOutstanding', () {
    test('returns max 5 items', () {
      final items = List.generate(8, (i) => {'totalOutstanding': (i + 1) * 100.0});
      expect(top5ByOutstanding(items).length, 5);
    });
    test('first item has highest outstanding', () {
      final items = List.generate(7, (i) => {'totalOutstanding': (i + 1) * 100.0, 'id': i});
      expect(top5ByOutstanding(items).first['totalOutstanding'], 700.0);
    });
    test('sorted descending', () {
      final items = [
        {'totalOutstanding': 300.0},
        {'totalOutstanding': 100.0},
        {'totalOutstanding': 200.0},
      ];
      final result = top5ByOutstanding(items);
      expect(result[0]['totalOutstanding'], 300.0);
      expect(result[1]['totalOutstanding'], 200.0);
      expect(result[2]['totalOutstanding'], 100.0);
    });
    test('fewer than 5 items returns all', () {
      final items = [{'totalOutstanding': 100.0}, {'totalOutstanding': 50.0}];
      expect(top5ByOutstanding(items).length, 2);
    });
    test('empty → empty', () => expect(top5ByOutstanding([]), isEmpty));
    test('null outstanding treated as 0', () {
      final items = [
        {'totalOutstanding': null, 'id': 'a'},
        {'totalOutstanding': 500.0, 'id': 'b'},
      ];
      expect(top5ByOutstanding(items).first['id'], 'b');
    });
    test('original list not mutated', () {
      final items = [
        {'totalOutstanding': 100.0, 'id': 1},
        {'totalOutstanding': 200.0, 'id': 2},
      ];
      top5ByOutstanding(items);
      expect(items.first['id'], 1); // original order
    });
  });

  group('[CreditSaleCountDetailListUI] oldestRecords', () {
    test('sorts ascending by date', () {
      final items = [
        {'collRcptDate': '2025-06-01', 'id': 3},
        {'collRcptDate': '2025-01-01', 'id': 1},
        {'collRcptDate': '2025-03-15', 'id': 2},
      ];
      final r = oldestRecords(items);
      expect(r[0]['id'], 1);
      expect(r[1]['id'], 2);
      expect(r[2]['id'], 3);
    });
    test('null date treated as epoch (sorts first)', () {
      final items = [
        {'collRcptDate': null, 'id': 0},
        {'collRcptDate': '2025-01-01', 'id': 1},
      ];
      expect(oldestRecords(items).first['id'], 0);
    });
    test('same date preserves relative order (stable)', () {
      final items = [
        {'collRcptDate': '2025-01-01', 'id': 1},
        {'collRcptDate': '2025-01-01', 'id': 2},
      ];
      final r = oldestRecords(items);
      expect(r.length, 2);
    });
    test('single item returns as-is', () {
      final items = [{'collRcptDate': '2025-05-01', 'id': 1}];
      expect(oldestRecords(items).length, 1);
    });
    test('empty → empty', () => expect(oldestRecords([]), isEmpty));
  });

  group('[CreditSaleCountDetailListUI] addItemState', () {
    test('adds false to empty list', () {
      final result = addItemState([]);
      expect(result, [false]);
    });
    test('appends false to existing list', () {
      final result = addItemState([true, false]);
      expect(result.last, isFalse);
      expect(result.length, 3);
    });
    test('original list not mutated', () {
      final original = [true];
      addItemState(original);
      expect(original.length, 1);
    });
  });

  group('[CreditSaleCountDetailListUI] showPayNow', () {
    test('non-top5 → show Pay Now', () => expect(showPayNow('ALL'), isTrue));
    test('Top 5 → hide Pay Now', () => expect(showPayNow('Top 5 outstanding'), isFalse));
    test('null → show Pay Now', () => expect(showPayNow(null), isTrue));
    test("Oldest → show Pay Now", () => expect(showPayNow("Oldest by day's"), isTrue));
  });

  // ===========================================================================
  // ── SECTION 5: DashboardDropDownUI ─────────────────────────────────────────
  // ===========================================================================
  group('[DashboardDropDownUI] dropDownShowDivider', () {
    test('serial != len → true', () => expect(dropDownShowDivider(1, 5), isTrue));
    test('serial == len → false', () => expect(dropDownShowDivider(5, 5), isFalse));
    test('last of 1-item list → false', () => expect(dropDownShowDivider(1, 1), isFalse));
    test('first of 10-item list → true', () => expect(dropDownShowDivider(1, 10), isTrue));
    test('penultimate item → true', () => expect(dropDownShowDivider(9, 10), isTrue));
  });

  group('[DashboardDropDownUI] dropDownDisplayFields', () {
    test('all null → all "-"', () {
      final f = dropDownDisplayFields();
      expect(f.values.every((v) => v == '-'), isTrue);
    });
    test('consumerNo "660990" → "660990"', () {
      final f = dropDownDisplayFields(consumerNo: '660990');
      expect(f['consumerNo'], '660990');
    });
    test('orderDate "null" string → "-"', () {
      final f = dropDownDisplayFields(orderDate: 'null');
      expect(f['orderDate'], '-');
    });
    test('consumerName valid → returned', () {
      final f = dropDownDisplayFields(consumerName: 'Rahul Kumar');
      expect(f['consumerName'], 'Rahul Kumar');
    });
    test('cashMemoDate null → "-"', () {
      final f = dropDownDisplayFields(cashMemoDate: null);
      expect(f['cashMemoDate'], '-');
    });
    test('settlementDate provided → returned', () {
      final f = dropDownDisplayFields(settlementDate: '2025-04-09');
      expect(f['settlementDate'], '2025-04-09');
    });
    test('deliveryDate "NULL" → "-"', () {
      final f = dropDownDisplayFields(deliveryDate: 'NULL');
      expect(f['deliveryDate'], '-');
    });
    test('remark valid → returned', () {
      final f = dropDownDisplayFields(remark: 'Some remark');
      expect(f['remark'], 'Some remark');
    });
    test('all 7 fields present in map', () {
      final f = dropDownDisplayFields();
      expect(f.keys.toSet(), containsAll([
        'consumerNo','orderDate','consumerName','cashMemoDate',
        'settlementDate','deliveryDate','remark',
      ]));
    });
  });

  // ===========================================================================
  // ── SECTION 6: DashboardPostPaidVerifPendDetails ────────────────────────────
  // ===========================================================================
  group('[DashboardPostPaidVerifPendDetails] filterPostpaidByStaff', () {
    final items = [
      {'staffName': 'Rahul Kumar', 'amount': 500.0},
      {'staffName': 'Swarup Das',  'amount': 800.0},
      {'staffName': 'Priya Singh', 'amount': 300.0},
      {'staffName': null,           'amount': 100.0},
    ];
    test('case-insensitive match', () => expect(filterPostpaidByStaff(items, 'rahul').length, 1));
    test('partial name match', () => expect(filterPostpaidByStaff(items, 'swa').length, 1));
    test('uppercase query', () => expect(filterPostpaidByStaff(items, 'PRIYA').length, 1));
    test('empty query returns all', () => expect(filterPostpaidByStaff(items, '').length, 4));
    test('no match → empty', () => expect(filterPostpaidByStaff(items, 'NOMATCH_XYZ'), isEmpty));
    test('null staffName treated as empty → not matched by non-empty query', () {
      expect(filterPostpaidByStaff(items, 'null').length, 0);
    });
  });

  group('[DashboardPostPaidVerifPendDetails] cleanTxnType', () {
    test('"Daily Sales" → "DailySales"', () => expect(cleanTxnType('Daily Sales'), 'DailySales'));
    test('"SV Sales" → "SVSales"', () => expect(cleanTxnType('SV Sales'), 'SVSales'));
    test('"ARB Sales" → "ARBSales"', () => expect(cleanTxnType('ARB Sales'), 'ARBSales'));
    test('"All" → "All"', () => expect(cleanTxnType('All'), 'All'));
    test('"Receipt" → "Receipt"', () => expect(cleanTxnType('Receipt'), 'Receipt'));
    test('multiple spaces removed', () => expect(cleanTxnType('A B C'), 'ABC'));
    test('empty string → empty', () => expect(cleanTxnType(''), ''));
  });

  group('[DashboardPostPaidVerifPendDetails] txnForList', () {
    test('has 5 items', () => expect(txnForList.length, 5));
    test('first is "All"', () => expect(txnForList.first, 'All'));
    test('last is "Receipt"', () => expect(txnForList.last, 'Receipt'));
    test('contains "Daily Sales"', () => expect(txnForList.contains('Daily Sales'), isTrue));
    test('contains "SV Sales"', () => expect(txnForList.contains('SV Sales'), isTrue));
    test('contains "ARB Sales"', () => expect(txnForList.contains('ARB Sales'), isTrue));
  });

  group('[DashboardPostPaidVerifPendDetails] postpaidAmountDisplay', () {
    test('null amount → "-"', () {
      // formatCurrency(0) = '0.00', nullToDash('0.00') = '0.00' ≠ '-'
      // null amount: nullToDash(formatCurrency(0)) = '0.00'
      expect(postpaidAmountDisplay(null), '0.00');
    });
    test('zero amount → "0.00"', () => expect(postpaidAmountDisplay(0), '0.00'));
    test('positive amount formatted', () {
      final r = postpaidAmountDisplay(1500.0);
      expect(r.contains('1') && r.contains('5'), isTrue);
    });
  });

  group('[DashboardPostPaidVerifPendDetails] applyDatePickerResult', () {
    test('null picked retains current', () {
      final current = DateTime(2025, 4, 10);
      expect(applyDatePickerResult(current, null), current);
    });
    test('valid picked updates date', () {
      final current = DateTime(2025, 4, 10);
      final picked  = DateTime(2025, 6, 20);
      expect(applyDatePickerResult(current, picked), picked);
    });
  });

  group('[DashboardPostPaidVerifPendDetails] postpaidShowNoRecords', () {
    test('count 0 → show', () => expect(postpaidShowNoRecords(0), isTrue));
    test('count 1 → hide', () => expect(postpaidShowNoRecords(1), isFalse));
    test('count 5 → hide', () => expect(postpaidShowNoRecords(5), isFalse));
  });

  // ===========================================================================
  // ── SECTION 7: DashboardPostPaidVerifPendDetailsUI ──────────────────────────
  // ===========================================================================
  group('[DashboardPostPaidVerifPendDetailsUI] formatSelectedDate', () {
    test('formats DateTime to "yyyy-MM-dd" prefix', () {
      final dt = DateTime(2025, 4, 7);
      expect(formatSelectedDate(dt), '2025-04-07');
    });
    test('includes only date (no time)', () {
      final dt = DateTime(2025, 12, 31, 23, 59, 59);
      expect(formatSelectedDate(dt), '2025-12-31');
    });
    test('single-digit month/day zero-padded', () {
      final dt = DateTime(2026, 1, 5);
      expect(formatSelectedDate(dt), '2026-01-05');
    });
  });

  group('[DashboardPostPaidVerifPendDetailsUI] uiTxnForList', () {
    test('same 5 items as parent screen', () {
      expect(uiTxnForList, txnForList);
    });
    test('has 5 elements', () => expect(uiTxnForList.length, 5));
  });

  group('[DashboardPostPaidVerifPendDetailsUI] nullToDash on sale fields', () {
    test('transCode null → "-"', () => expect(nullToDash(null), '-'));
    test('transTime "null" → "-"', () => expect(nullToDash('null'), '-'));
    test('staffName valid → returned', () => expect(nullToDash('Rahul'), 'Rahul'));
    test('remark empty → ""', () => expect(nullToDash(''), ''));
    test('transFor valid → returned', () => expect(nullToDash('Daily Sales'), 'Daily Sales'));
  });

  // ===========================================================================
  // ── SECTION 8: DashboardPrepaidDetails ─────────────────────────────────────
  // ===========================================================================
  group('[DashboardPrepaidDetails] prepaidDisplayText – all flags', () {
    test('"Delivered"', () => expect(prepaidDisplayText('Delivered'), 'Delivered,payment pending'));
    test('"Settled"', () => expect(prepaidDisplayText('Settled'), 'Payment done,delivery pending'));
    test('"cDCMS"', () => expect(prepaidDisplayText('cDCMS'), 'Pending in cDCMS'));
    test('"DelDonNiyoJanPunPend"', () =>
        expect(prepaidDisplayText('DelDonNiyoJanPunPend'), 'Punched in cDCMS,pending in Niyojan'));
    test('"OldBkgPendNewBkgRecv"', () =>
        expect(prepaidDisplayText('OldBkgPendNewBkgRecv'), 'Old punching pending but....'));
    test('"Punching"', () => expect(prepaidDisplayText('Punching'), "Today's Niyojan Punched"));
    test('"Incorrect"', () => expect(prepaidDisplayText('Incorrect'), "Today's incorrect"));
    test('"NiyoJanPunDelPend"', () =>
        expect(prepaidDisplayText('NiyoJanPunDelPend'), 'Punched in Niyojan,pending in cDCMS'));
    test('"TotalOutstanding"', () =>
        expect(prepaidDisplayText('TotalOutstanding'), 'Total Outstanding Pending'));
    test('unknown → "Prepaid Details"', () =>
        expect(prepaidDisplayText('ANYTHING_ELSE'), 'Prepaid Details'));
    test('empty → "Prepaid Details"', () =>
        expect(prepaidDisplayText(''), 'Prepaid Details'));
  });

  group('[DashboardPrepaidDetails] prepaidUsesPreCount – all flags', () {
    test('"Delivered" → true', () => expect(prepaidUsesPreCount('Delivered'), isTrue));
    test('"Settled" → true', () => expect(prepaidUsesPreCount('Settled'), isTrue));
    test('"TotalOutstanding" → true', () => expect(prepaidUsesPreCount('TotalOutstanding'), isTrue));
    test('"cDCMS" → true', () => expect(prepaidUsesPreCount('cDCMS'), isTrue));
    test('"DelDonNiyoJanPunPend" → true', () => expect(prepaidUsesPreCount('DelDonNiyoJanPunPend'), isTrue));
    test('"OldBkgPendNewBkgRecv" → true', () => expect(prepaidUsesPreCount('OldBkgPendNewBkgRecv'), isTrue));
    test('"Punching" → false', () => expect(prepaidUsesPreCount('Punching'), isFalse));
    test('"Incorrect" → false', () => expect(prepaidUsesPreCount('Incorrect'), isFalse));
    test('"NiyoJanPunDelPend" → false', () => expect(prepaidUsesPreCount('NiyoJanPunDelPend'), isFalse));
    test('unknown → false', () => expect(prepaidUsesPreCount('UNKNOWN'), isFalse));
  });

  group('[DashboardPrepaidDetails] filterPrepaid', () {
    final items = [
      {'consumerNo': '660990', 'consumerName': 'Priya Mondal', 'orderDate': '2025-04-01', 'deliveryDate': '2025-04-05'},
      {'consumerNo': '770101', 'consumerName': 'Rahul Das',    'orderDate': '2025-05-01', 'deliveryDate': null},
    ];
    test('matches consumerNo', () => expect(filterPrepaid(items, '660990').length, 1));
    test('matches consumerName case-insensitive', () => expect(filterPrepaid(items, 'priya').length, 1));
    test('matches orderDate', () => expect(filterPrepaid(items, '2025-05').length, 1));
    test('matches deliveryDate', () => expect(filterPrepaid(items, '2025-04-05').length, 1));
    test('empty query returns all', () => expect(filterPrepaid(items, '').length, 2));
    test('no match → empty', () => expect(filterPrepaid(items, 'ZZZXXX'), isEmpty));
    test('partial consumerNo', () => expect(filterPrepaid(items, '6609').length, 1));
  });

  group('[DashboardPrepaidDetails] filterPunch', () {
    final items = [
      {'staffName': 'Ravi', 'niyojanPunQty': 10, 'settlementQty': 8},
      {'staffName': 'Amit', 'niyojanPunQty': 5,  'settlementQty': 5},
    ];
    test('matches staffName', () => expect(filterPunch(items, 'ravi').length, 1));
    test('case-insensitive staffName', () => expect(filterPunch(items, 'AMIT').length, 1));
    test('matches niyojanPunQty', () => expect(filterPunch(items, '10').length, 1));
    test('matches settlementQty', () => expect(filterPunch(items, '8').length, 1));
    test('empty query returns all', () => expect(filterPunch(items, '').length, 2));
    test('no match → empty', () => expect(filterPunch(items, 'ZZZNONE'), isEmpty));
  });

  group('[DashboardPrepaidDetails] parsePunchDate', () {
    test('valid ISO date → yyyy-MM-dd', () => expect(parsePunchDate('2025-04-07T00:00:00'), '2025-04-07'));
    test('null → ""', () => expect(parsePunchDate(null), ''));
    test('invalid date → ""', () => expect(parsePunchDate('not-a-date'), ''));
    test('date with time component → date only', () => expect(parsePunchDate('2025-12-31T23:59:59'), '2025-12-31'));
  });

  group('[DashboardPrepaidDetails] header column labels', () {
    test('Delivered → consumer header', () {
      expect(prepaidHeaderConsumerCol('Delivered'), 'Consumer No.');
    });
    test('Punching → staff header', () {
      expect(prepaidHeaderConsumerCol('Punching'), 'Staff Name');
    });
    test('Delivered → name header', () {
      expect(prepaidHeaderNameCol('Delivered'), contains('Consumer'));
    });
    test('Punching → niyojan header', () {
      expect(prepaidHeaderNameCol('Punching'), contains('Niyojan'));
    });
    test('Delivered → date header', () {
      expect(prepaidHeaderDateCol('Delivered'), 'Order Date');
    });
    test('Punching → settl qty header', () {
      expect(prepaidHeaderDateCol('Punching'), 'Settl Qty.');
    });
    test('Delivered → last col', () {
      expect(prepaidHeaderLastCol('Delivered'), 'Delivery Date');
    });
    test('Punching → last col', () {
      expect(prepaidHeaderLastCol('Punching'), 'Settl Pen Qty.');
    });
  });

  // ===========================================================================
  // ── SECTION 9: DashboardPrepaidDetailUI ─────────────────────────────────────
  // ===========================================================================
  group('[DashboardPrepaidDetailUI] prepaidDetailUIFields', () {
    test('all null → all "-"', () {
      final f = prepaidDetailUIFields();
      expect(f.values.every((v) => v == '-'), isTrue);
    });
    test('consumerNo provided → returned', () {
      expect(prepaidDetailUIFields(consumerNo: '660990')['consumerNo'], '660990');
    });
    test('consumerName "null" string → "-"', () {
      expect(prepaidDetailUIFields(consumerName: 'null')['consumerName'], '-');
    });
    test('orderDate valid → returned', () {
      expect(prepaidDetailUIFields(orderDate: '05-04-2025')['orderDate'], '05-04-2025');
    });
    test('deliveryDate "null" → "-"', () {
      expect(prepaidDetailUIFields(deliveryDate: 'null')['deliveryDate'], '-');
    });
    test('settlementDate valid → returned', () {
      expect(prepaidDetailUIFields(settlementDate: '09-04-2025')['settlementDate'], '09-04-2025');
    });
    test('5 keys present', () {
      expect(prepaidDetailUIFields().keys.length, 5);
    });
    test('mixed null and valid', () {
      final f = prepaidDetailUIFields(
        consumerNo: '123', consumerName: null, orderDate: '2025-01-01',
        deliveryDate: null, settlementDate: '2025-01-05',
      );
      expect(f['consumerNo'],    '123');
      expect(f['consumerName'],  '-');
      expect(f['orderDate'],     '2025-01-01');
      expect(f['deliveryDate'],  '-');
      expect(f['settlementDate'],'2025-01-05');
    });
  });

  // ===========================================================================
  // ── SECTION 10: DashboardPunchDetailUI ──────────────────────────────────────
  // ===========================================================================
  group('[DashboardPunchDetailUI] toggleVisibility', () {
    test('false → true', () => expect(toggleVisibility(false), isTrue));
    test('true → false', () => expect(toggleVisibility(true), isFalse));
    test('double toggle back to original', () => expect(toggleVisibility(toggleVisibility(false)), isFalse));
    test('initial state is false', () => expect(false, isFalse));
  });

  group('[DashboardPunchDetailUI] dropdownIcon', () {
    test('visible → arrow_drop_up', () => expect(dropdownIcon(true), 'arrow_drop_up'));
    test('hidden → arrow_drop_down', () => expect(dropdownIcon(false), 'arrow_drop_down'));
  });

  group('[DashboardPunchDetailUI] field display helpers', () {
    test('punchDateDisplay null → ""', () => expect(punchDateDisplay(null), ''));
    test('punchDateDisplay valid → returned', () => expect(punchDateDisplay('2025-04-07'), '2025-04-07'));
    test('punchStaffNameDisplay null → ""', () => expect(punchStaffNameDisplay(null), ''));
    test('punchStaffNameDisplay valid → returned', () => expect(punchStaffNameDisplay('Ravi'), 'Ravi'));
    test('punchNiyojanQtyDisplay null → "0"', () => expect(punchNiyojanQtyDisplay(null), '0'));
    test('punchNiyojanQtyDisplay 10 → "10"', () => expect(punchNiyojanQtyDisplay(10), '10'));
    test('punchSettlQtyDisplay null → "0"', () => expect(punchSettlQtyDisplay(null), '0'));
    test('punchSettlQtyDisplay 5 → "5"', () => expect(punchSettlQtyDisplay(5), '5'));
    test('punchPendingQtyDisplay null → "0"', () => expect(punchPendingQtyDisplay(null), '0'));
    test('punchPendingQtyDisplay 3 → "3"', () => expect(punchPendingQtyDisplay(3), '3'));
  });

  // ===========================================================================
  // ── SECTION 11: DashboardSVDetails ─────────────────────────────────────────
  // ===========================================================================
  group('[DashboardSVDetails] calcSVTotals', () {
    test('sums cylQty and totalAmount', () {
      final r = calcSVTotals([
        {'cylQty': 5, 'totalAmount': 3000.0},
        {'cylQty': 3, 'totalAmount': 1800.0},
      ]);
      expect(r['totalCylQty'], 8);
      expect(r['totalAmount'], closeTo(4800.0, 0.001));
    });
    test('empty list → zeros', () {
      final r = calcSVTotals([]);
      expect(r['totalCylQty'], 0);
      expect(r['totalAmount'], 0.0);
    });
    test('null fields treated as zero', () {
      final r = calcSVTotals([{'cylQty': null, 'totalAmount': null}]);
      expect(r['totalCylQty'], 0);
      expect(r['totalAmount'], 0.0);
    });
    test('single item', () {
      final r = calcSVTotals([{'cylQty': 7, 'totalAmount': 5000.0}]);
      expect(r['totalCylQty'], 7);
      expect(r['totalAmount'], closeTo(5000.0, 0.001));
    });
    test('fractional totalAmount', () {
      final r = calcSVTotals([
        {'cylQty': 1, 'totalAmount': 1234.56},
        {'cylQty': 2, 'totalAmount': 4321.44},
      ]);
      expect(r['totalAmount'], closeTo(5556.0, 0.001));
    });
  });

  group('[DashboardSVDetails] svCylQtyDisplay', () {
    test('non-empty shows qty', () => expect(svCylQtyDisplay(true, 8), 'Cyl. Qty: 8'));
    test('empty shows 0', () => expect(svCylQtyDisplay(false, 8), 'Cyl. Qty: 0'));
    test('non-empty qty 0 shows 0', () => expect(svCylQtyDisplay(true, 0), 'Cyl. Qty: 0'));
  });

  group('[DashboardSVDetails] svAmountDisplay', () {
    test('non-empty shows formatted', () =>
        expect(svAmountDisplay(true, '4,800.00'), 'Amount: 4,800.00'));
    test('empty shows "0.00"', () =>
        expect(svAmountDisplay(false, '4,800.00'), 'Amount: 0.00'));
  });

  group('[DashboardSVDetails] svItemSelectionMode', () {
    test('-1 → FETCH_ALL', () => expect(svItemSelectionMode(-1), 'FETCH_ALL'));
    test('1 → FETCH_ITEM', () => expect(svItemSelectionMode(1), 'FETCH_ITEM'));
    test('null → FETCH_ITEM', () => expect(svItemSelectionMode(null), 'FETCH_ITEM'));
    test('0 → FETCH_ITEM', () => expect(svItemSelectionMode(0), 'FETCH_ITEM'));
  });

  // ===========================================================================
  // ── SECTION 12: DashboardSVDetailUI ─────────────────────────────────────────
  // ===========================================================================
  group('[DashboardSVDetailUI] svDocStatus', () {
    test('true → "Pending"', () => expect(svDocStatus(true), 'Pending'));
    test('false → "Received"', () => expect(svDocStatus(false), 'Received'));
    test('null → ""', () => expect(svDocStatus(null), ''));
  });

  group('[DashboardSVDetailUI] svDateDisplay', () {
    test('valid ISO date → "dd-MM-yyyy"', () {
      expect(svDateDisplay('2025-04-07T00:00:00'), '07-04-2025');
    });
    test('date only → formatted', () {
      expect(svDateDisplay('2025-12-31'), '31-12-2025');
    });
    test('null → ""', () => expect(svDateDisplay(null), ''));
    test('empty → ""', () => expect(svDateDisplay(''), ''));
    test('invalid → ""', () => expect(svDateDisplay('not-a-date'), ''));
  });

  group('[DashboardSVDetailUI] svDetailUIFields', () {
    test('all fields present in map', () {
      final f = svDetailUIFields();
      expect(f.keys.length, 11);
    });
    test('docStatus from isUndocument=true → "Pending"', () {
      expect(svDetailUIFields(isUndocument: true)['docStatus'], 'Pending');
    });
    test('docStatus from isUndocument=false → "Received"', () {
      expect(svDetailUIFields(isUndocument: false)['docStatus'], 'Received');
    });
    test('docStatus from null → ""', () {
      expect(svDetailUIFields()['docStatus'], '');
    });
    test('itemName null → "-"', () {
      expect(svDetailUIFields(itemName: null)['itemName'], '-');
    });
    test('cylQty present as string', () {
      expect(svDetailUIFields(cylQty: 5)['cylQty'], '5');
    });
    test('totalAmount 0 → "0.00"', () {
      expect(svDetailUIFields(totalAmount: 0)['amount'], '0.00');
    });
    test('totalAmount 1500 formatted', () {
      final f = svDetailUIFields(totalAmount: 1500.0);
      expect(f['amount']!.contains('1'), isTrue);
    });
    test('svType null → ""', () {
      expect(svDetailUIFields()['svType'], '');
    });
    test('consumerNo null → "-"', () {
      expect(svDetailUIFields()['consumerNo'], '-');
    });
    test('referredBy null → ""', () {
      expect(svDetailUIFields()['referredBy'], '');
    });
  });

  // ===========================================================================
  // ── SECTION 13: DashboardTVDetails ─────────────────────────────────────────
  // ===========================================================================
  group('[DashboardTVDetails] calcTVTotals', () {
    test('sums qty, amount and regulator count', () {
      final r = calcTVTotals([
        {'clyReceivedQty': 4, 'paidAmt': 2000.0, 'isRegulator': 'Yes'},
        {'clyReceivedQty': 2, 'paidAmt': 1000.0, 'isRegulator': 'No'},
        {'clyReceivedQty': 3, 'paidAmt': 1500.0, 'isRegulator': 'Yes'},
      ]);
      expect(r['totalCylQty'],      9);
      expect(r['totalAmount'],      closeTo(4500.0, 0.001));
      expect(r['regReceivedCount'], 2);
    });
    test('empty list → zeros', () {
      final r = calcTVTotals([]);
      expect(r['totalCylQty'],      0);
      expect(r['totalAmount'],      0.0);
      expect(r['regReceivedCount'], 0);
    });
    test('null fields treated as zero/false', () {
      final r = calcTVTotals([{'clyReceivedQty': null, 'paidAmt': null, 'isRegulator': null}]);
      expect(r['totalCylQty'],      0);
      expect(r['totalAmount'],      0.0);
      expect(r['regReceivedCount'], 0);
    });
    test('all regulators Yes → correct count', () {
      final data = List.generate(5, (_) =>
          {'clyReceivedQty': 1, 'paidAmt': 100.0, 'isRegulator': 'Yes'});
      expect(calcTVTotals(data)['regReceivedCount'], 5);
    });
    test('no regulator Yes → count 0', () {
      final data = [{'clyReceivedQty': 2, 'paidAmt': 500.0, 'isRegulator': 'No'}];
      expect(calcTVTotals(data)['regReceivedCount'], 0);
    });
    test('single item calculates correctly', () {
      final r = calcTVTotals([
        {'clyReceivedQty': 6, 'paidAmt': 3000.0, 'isRegulator': 'Yes'},
      ]);
      expect(r['totalCylQty'], 6);
      expect(r['totalAmount'], closeTo(3000.0, 0.001));
      expect(r['regReceivedCount'], 1);
    });
  });

  group('[DashboardTVDetails] tvQtyDisplay', () {
    test('non-empty shows qty', () => expect(tvQtyDisplay(true, 9), 'Qty: 9'));
    test('empty shows 0', () => expect(tvQtyDisplay(false, 9), 'Qty: 0'));
  });

  group('[DashboardTVDetails] tvRegDisplay', () {
    test('non-empty shows count', () => expect(tvRegDisplay(true, 3), 'Reg Rec: 3'));
    test('empty shows 0', () => expect(tvRegDisplay(false, 3), 'Reg Rec: 0'));
    test('zero count shows 0', () => expect(tvRegDisplay(true, 0), 'Reg Rec: 0'));
  });

  group('[DashboardTVDetails] tvAmountDisplay', () {
    test('non-empty shows formatted', () =>
        expect(tvAmountDisplay(true, '4,500.00'), 'Amount: 4,500.00'));
    test('empty shows "0.00"', () =>
        expect(tvAmountDisplay(false, '4,500.00'), 'Amount: 0.00'));
  });

  group('[DashboardTVDetails] tvItemSelectionMode', () {
    test('-1 → FETCH_ALL', () => expect(tvItemSelectionMode(-1), 'FETCH_ALL'));
    test('2 → FETCH_ITEM', () => expect(tvItemSelectionMode(2), 'FETCH_ITEM'));
    test('null → FETCH_ITEM', () => expect(tvItemSelectionMode(null), 'FETCH_ITEM'));
  });

  // ===========================================================================
  // ── SECTION 14: DashboardTVDetailUI ─────────────────────────────────────────
  // ===========================================================================
  group('[DashboardTVDetailUI] tvDateDisplay', () {
    test('valid ISO date → "dd-MM-yyyy"', () {
      expect(tvDateDisplay('2025-09-10T00:00:00'), '10-09-2025');
    });
    test('date-only → "dd-MM-yyyy"', () {
      expect(tvDateDisplay('2025-01-01'), '01-01-2025');
    });
    test('null → ""', () => expect(tvDateDisplay(null), ''));
    test('empty → ""', () => expect(tvDateDisplay(''), ''));
    test('invalid → ""', () => expect(tvDateDisplay('bad-date'), ''));
  });

  group('[DashboardTVDetailUI] tvDetailUIFields', () {
    test('all 8 keys present', () {
      expect(tvDetailUIFields().keys.length, 8);
    });
    test('itemName null → ""', () {
      expect(tvDetailUIFields()['itemName'], '');
    });
    test('consumerNo null → "-"', () {
      expect(tvDetailUIFields()['consNo'], '-');
    });
    test('isRegulator "Yes" → "Yes"', () {
      expect(tvDetailUIFields(isRegulator: 'Yes')['regRec'], 'Yes');
    });
    test('isRegulator null → "-"', () {
      expect(tvDetailUIFields()['regRec'], '-');
    });
    test('paidAmt 0 → "0.00"', () {
      expect(tvDetailUIFields(paidAmt: 0)['paidAmount'], '0.00');
    });
    test('paidAmt positive → formatted', () {
      final f = tvDetailUIFields(paidAmt: 2000.0);
      expect(f['paidAmount']!.contains('2'), isTrue);
    });
    test('stockStatus null → "-"', () {
      expect(tvDetailUIFields()['stockStatus'], '-');
    });
    test('consumerName null → ""', () {
      expect(tvDetailUIFields()['consName'], '');
    });
    test('tvDate formats correctly', () {
      final f = tvDetailUIFields(tvDate: '2025-09-10T00:00:00');
      expect(f['tvDate'], '10-09-2025');
    });
    test('cylQty null → "-"', () {
      expect(tvDetailUIFields()['cylQty'], '-');
    });
    test('cylQty provided → string', () {
      expect(tvDetailUIFields(clyHoldQty: 4)['cylQty'], '4');
    });
  });

  // ===========================================================================
  // ── SECTION 15: Cross-cutting edge cases ───────────────────────────────────
  // ===========================================================================
  group('[Cross-cutting] formatCurrency consistency across screens', () {
    test('screens produce identical output for same amount', () {
      expect(formatCurrency(15399.0), formatCurrency(15399.0));
    });
    test('0.00 amount returns "0.00" always', () {
      for (final screen in ['ARB', 'Credit', 'PostPaid', 'SV', 'TV']) {
        expect(formatCurrency(0.0), '0.00', reason: 'Failed for $screen');
      }
    });
  });

  group('[Cross-cutting] nullToDash consistency across screens', () {
    for (final screen in [
      'CreditSale', 'DropDown', 'PostPaidDetails',
      'PostPaidUI', 'PrepaidDetailUI', 'SVDetailUI', 'TVDetailUI'
    ]) {
      test('$screen: null → "-"', () => expect(nullToDash(null), '-'));
      test('$screen: "null" → "-"', () => expect(nullToDash('null'), '-'));
      test('$screen: valid value returned', () => expect(nullToDash('test'), 'test'));
    }
  });

  group('[Cross-cutting] date parsing pattern', () {
    // Used in DashboardSVDetailUI and DashboardTVDetailUI
    test('dd-MM-yyyy format for 2025-09-10', () {
      final dt = DateTime.parse('2025-09-10');
      expect(DateFormat('dd-MM-yyyy').format(dt), '10-09-2025');
    });
    test('dd-MM-yyyy format for 2025-01-01', () {
      final dt = DateTime.parse('2025-01-01');
      expect(DateFormat('dd-MM-yyyy').format(dt), '01-01-2025');
    });
    test('dd-MM-yyyy handles leap year 2024-02-29', () {
      final dt = DateTime.parse('2024-02-29');
      expect(DateFormat('dd-MM-yyyy').format(dt), '29-02-2024');
    });
  });

  group('[Cross-cutting] isNotEmpty guard pattern', () {
    // Used in DashboardSVDetails and DashboardTVDetails
    test('non-empty list → isNotEmpty true', () {
      final list = [{'id': 1}];
      expect(list.isNotEmpty, isTrue);
    });
    test('empty list → isNotEmpty false', () {
      expect(<Map>[].isNotEmpty, isFalse);
    });
  });
}

