import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/DailySaleSaummaryListModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/DilySaleSummaryDeliveryBoyWiseListModel.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pure-logic helpers extracted from the attached screens for isolated testing
// ─────────────────────────────────────────────────────────────────────────────

// ── ManagerUpdateSaleCashUpdation helpers ────────────────────────────────────

/// Mirrors formatCurrency() in ManagerUpdateSaleCashUpdation
String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final format = NumberFormat('#,##,###.00', 'en_IN');
  String formatted = format.format(amount);
  if (amount < 1 && formatted.startsWith('.')) formatted = '0$formatted';
  return formatted;
}

/// Mirrors denomination calculation: qty * noteValue
double calcDenomResult(int qty, double noteValue) => qty * noteValue;

/// Mirrors total denomination sum
double calcDenomTotal(Map<double, int> denomMap) {
  return denomMap.entries.fold(0.0, (sum, e) => sum + e.key * e.value);
}

/// Mirrors isLumsumAmountAdd flag logic (EDIT mode)
/// isLumsumAmountAdd = false when (postpaidAmt > 0 && postpaidQty <= 0) OR (cashAmt > 0 && cashQty <= 0)
bool calcIsLumsumAmountAdd(
    {required double postpaidAmountApi,
    required int postpaidQtyApi,
    required double cashAmountApi,
    required int cashQtyApi}) {
  if ((postpaidAmountApi > 0 && postpaidQtyApi <= 0) ||
      (cashAmountApi > 0 && cashQtyApi <= 0)) {
    return false;
  }
  return true;
}

/// Mirrors isItemSubtypeND = itemSubtypes == 'ND'
bool calcIsItemSubtypeND(String? itemSubtype) => itemSubtype == 'ND';

/// Mirrors valid/invalid consumer count from consumer list
Map<String, int> calcConsumerCounts(List<Map<String, dynamic>> consumerList) {
  int valid = 0, invalid = 0;
  for (final item in consumerList) {
    if (item['InCorrectStatus'] == 1) {
      valid++;
    } else {
      invalid++;
    }
  }
  return {'valid': valid, 'invalid': invalid};
}

/// Mirrors cash denomination mandatory flag check
bool calcCashDenominationMandatory(
    List<Map<String, dynamic>> flagList, String distributorId) {
  for (final item in flagList) {
    if (item['distributorId'].toString() == distributorId &&
        item['permissionFor'] == 'Cash Denomination' &&
        item['isActive'] == 1) {
      return true;
    }
  }
  return false;
}

// ── ManagerUpdateSaleScreen helpers ──────────────────────────────────────────

/// Mirrors formattedDate calculation in ManagerUpdateSaleScreen
String formatReceiptDate(String isoDate) {
  final dt = DateTime.parse(isoDate);
  return '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';
}

/// Mirrors expenseTotalAmount calculation in fetchExpenseDetailList
double calcExpenseTotalAmount(List<double> expAmounts) {
  return expAmounts.fold(0.0, (sum, a) => sum + a);
}

// ── DeliveryBoyWiseListShow helpers ──────────────────────────────────────────

/// Mirrors _greeting() in DeliveryBoyWiseListShow
String greeting(int hour) {
  if (hour < 12) return 'Morning';
  if (hour < 17) return 'Afternoon';
  return 'Evening';
}

/// Mirrors filterSearchResults() in DeliveryBoyWiseListShow
List<DailySaleSaummaryListModel> filterSearchResults(
    List<DailySaleSaummaryListModel> sales, String query) {
  if (query.isEmpty) return List.from(sales);
  return sales
      .where((sale) =>
          (sale.staffName?.toLowerCase().contains(query.toLowerCase()) ??
              false) ||
          sale.totalAmt.toString().contains(query) ||
          sale.totalFilledQty.toString().contains(query) ||
          sale.totalTVQty.toString().contains(query) ||
          sale.totalSVQty.toString().contains(query))
      .toList();
}

/// Mirrors avatar initials logic in DeliveryBoyWiseListShow
String calcInitials(String staffName) {
  final parts = staffName.trim().split(RegExp(r'\s+'));
  if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  if (parts.isNotEmpty && parts[0].length >= 2) {
    return parts[0].substring(0, 2).toUpperCase();
  }
  return 'M';
}

/// Mirrors ManagerUpdateSaleListItem action routing (edit vs new vs settle dialog).
String resolveUpdateSaleActionMode({
  required int actualSaleQty,
  required int dailySaleStatus,
  required int cashQty,
  required int prepaidQty,
  required int postQty,
  required int creditQty,
  required double cashAmt,
  required double postAmt,
}) {
  final noPayments = cashQty == 0 &&
      prepaidQty == 0 &&
      postQty == 0 &&
      creditQty == 0 &&
      cashAmt == 0 &&
      postAmt == 0;
  if (noPayments && actualSaleQty != 0) return 'NEW';
  final hasPayments = cashQty != 0 ||
      prepaidQty != 0 ||
      postQty != 0 ||
      creditQty != 0 ||
      cashAmt != 0 ||
      postAmt != 0;
  if (hasPayments && actualSaleQty != 0) return 'EDIT';
  if (actualSaleQty == 0 || dailySaleStatus != 13) return 'SETTLE_DIALOG';
  return 'NONE';
}

/// Mirrors DeliveryBoyWiseListItem action label for update/accept link.
String resolvePrimaryActionLabel(int? dailySaleStatus) {
  if (dailySaleStatus == 1 || dailySaleStatus == 4) return 'Accept';
  if (dailySaleStatus == 2 ||
      (dailySaleStatus != 3 &&
          dailySaleStatus != 1 &&
          dailySaleStatus != 4 &&
          dailySaleStatus != 7)) {
    return 'Update';
  }
  return '';
}

/// Mirrors DeliveryBoyWiseListItem correction link visibility.
bool shouldShowCorrection(int? dailySaleStatus) {
  return dailySaleStatus != 3 &&
      dailySaleStatus != 5 &&
      dailySaleStatus != 6 &&
      dailySaleStatus != 7 &&
      dailySaleStatus != 8;
}

// ─────────────────────────────────────────────────────────────────────────────
// TESTS
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION A – ManagerUpdateSaleCashUpdation
  // ═══════════════════════════════════════════════════════════════════════════

  group('[ManagerUpdateSaleCashUpdation] formatCurrency', () {
    test('zero returns "0.00"', () {
      expect(formatCurrency(0), '0.00');
    });

    test('positive whole amount formats correctly', () {
      final r = formatCurrency(15399.0);
      expect(r.contains('15399') || r.contains('15,399'), isTrue);
    });

    test('sub-zero amount gets leading zero', () {
      final r = formatCurrency(0.5);
      expect(r.startsWith('0'), isTrue);
    });

    test('large amount does not throw', () {
      expect(() => formatCurrency(1234567.89), returnsNormally);
    });

    test('negative amount does not throw', () {
      expect(() => formatCurrency(-1000.0), returnsNormally);
    });

    test('exact boundary 1.0 returns formatted value', () {
      expect(formatCurrency(1.0).contains('1'), isTrue);
    });
  });

  group('[ManagerUpdateSaleCashUpdation] calcDenomResult', () {
    test('500 note × 2 = 1000.0', () {
      expect(calcDenomResult(2, 500.0), 1000.0);
    });

    test('100 note × 5 = 500.0', () {
      expect(calcDenomResult(5, 100.0), 500.0);
    });

    test('zero qty returns 0.0', () {
      expect(calcDenomResult(0, 500.0), 0.0);
    });

    test('0.50 note × 4 = 2.0', () {
      expect(calcDenomResult(4, 0.50), closeTo(2.0, 0.001));
    });
  });

  group('[ManagerUpdateSaleCashUpdation] calcDenomTotal', () {
    test('sums multiple denomination entries correctly', () {
      final denomMap = {500.0: 2, 200.0: 1, 100.0: 3};
      // 1000 + 200 + 300 = 1500
      expect(calcDenomTotal(denomMap), closeTo(1500.0, 0.001));
    });

    test('empty map returns 0.0', () {
      expect(calcDenomTotal({}), 0.0);
    });

    test('all zero qty returns 0.0', () {
      expect(calcDenomTotal({500.0: 0, 100.0: 0}), 0.0);
    });

    test('single entry calculates correctly', () {
      expect(calcDenomTotal({50.0: 10}), closeTo(500.0, 0.001));
    });
  });

  group('[ManagerUpdateSaleCashUpdation] calcIsLumsumAmountAdd', () {
    test('returns false when postpaidAmt > 0 and postpaidQty == 0', () {
      expect(
          calcIsLumsumAmountAdd(
              postpaidAmountApi: 500.0,
              postpaidQtyApi: 0,
              cashAmountApi: 0.0,
              cashQtyApi: 5),
          isFalse);
    });

    test('returns false when cashAmt > 0 and cashQty == 0', () {
      expect(
          calcIsLumsumAmountAdd(
              postpaidAmountApi: 0.0,
              postpaidQtyApi: 5,
              cashAmountApi: 300.0,
              cashQtyApi: 0),
          isFalse);
    });

    test('returns true when both postpaid and cash are valid', () {
      expect(
          calcIsLumsumAmountAdd(
              postpaidAmountApi: 500.0,
              postpaidQtyApi: 2,
              cashAmountApi: 300.0,
              cashQtyApi: 3),
          isTrue);
    });

    test('returns true when all amounts are zero', () {
      expect(
          calcIsLumsumAmountAdd(
              postpaidAmountApi: 0.0,
              postpaidQtyApi: 0,
              cashAmountApi: 0.0,
              cashQtyApi: 0),
          isTrue);
    });

    test('returns false when postpaidQty is negative', () {
      expect(
          calcIsLumsumAmountAdd(
              postpaidAmountApi: 100.0,
              postpaidQtyApi: -1,
              cashAmountApi: 0.0,
              cashQtyApi: 1),
          isFalse);
    });
  });

  group('[ManagerUpdateSaleCashUpdation] calcIsItemSubtypeND', () {
    test('"ND" returns true', () {
      expect(calcIsItemSubtypeND('ND'), isTrue);
    });

    test('"DOM" returns false', () {
      expect(calcIsItemSubtypeND('DOM'), isFalse);
    });

    test('null returns false', () {
      expect(calcIsItemSubtypeND(null), isFalse);
    });

    test('empty string returns false', () {
      expect(calcIsItemSubtypeND(''), isFalse);
    });

    test('case-sensitive: "nd" returns false', () {
      expect(calcIsItemSubtypeND('nd'), isFalse);
    });
  });

  group('[ManagerUpdateSaleCashUpdation] calcConsumerCounts', () {
    test('counts valid (InCorrectStatus==1) and invalid correctly', () {
      final consumers = [
        {'InCorrectStatus': 1},
        {'InCorrectStatus': 0},
        {'InCorrectStatus': 1},
        {'InCorrectStatus': 0},
        {'InCorrectStatus': 0},
      ];
      final result = calcConsumerCounts(consumers);
      expect(result['valid'], 2);
      expect(result['invalid'], 3);
    });

    test('empty list returns zeros', () {
      final result = calcConsumerCounts([]);
      expect(result['valid'], 0);
      expect(result['invalid'], 0);
    });

    test('all valid returns correct count', () {
      final consumers = List.generate(5, (_) => {'InCorrectStatus': 1});
      final result = calcConsumerCounts(consumers);
      expect(result['valid'], 5);
      expect(result['invalid'], 0);
    });

    test('all invalid returns correct count', () {
      final consumers = List.generate(3, (_) => {'InCorrectStatus': 0});
      final result = calcConsumerCounts(consumers);
      expect(result['valid'], 0);
      expect(result['invalid'], 3);
    });
  });

  group('[ManagerUpdateSaleCashUpdation] calcCashDenominationMandatory', () {
    test('returns true when matching active record exists', () {
      final list = [
        {
          'distributorId': 8118,
          'permissionFor': 'Cash Denomination',
          'isActive': 1
        },
      ];
      expect(calcCashDenominationMandatory(list, '8118'), isTrue);
    });

    test('returns false when isActive == 0', () {
      final list = [
        {
          'distributorId': 8118,
          'permissionFor': 'Cash Denomination',
          'isActive': 0
        },
      ];
      expect(calcCashDenominationMandatory(list, '8118'), isFalse);
    });

    test('returns false when permissionFor does not match', () {
      final list = [
        {
          'distributorId': 8118,
          'permissionFor': 'Other Permission',
          'isActive': 1
        },
      ];
      expect(calcCashDenominationMandatory(list, '8118'), isFalse);
    });

    test('returns false when distributorId does not match', () {
      final list = [
        {
          'distributorId': 9999,
          'permissionFor': 'Cash Denomination',
          'isActive': 1
        },
      ];
      expect(calcCashDenominationMandatory(list, '8118'), isFalse);
    });

    test('returns false for empty list', () {
      expect(calcCashDenominationMandatory([], '8118'), isFalse);
    });

    test('returns true for second matching item in list', () {
      final list = [
        {
          'distributorId': 8118,
          'permissionFor': 'Other',
          'isActive': 1
        },
        {
          'distributorId': 8118,
          'permissionFor': 'Cash Denomination',
          'isActive': 1
        },
      ];
      expect(calcCashDenominationMandatory(list, '8118'), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION B – ManagerUpdateSaleScreen
  // ═══════════════════════════════════════════════════════════════════════════

  group('[ManagerUpdateSaleScreen] formatReceiptDate', () {
    test('formats ISO date to yyyy-MM-dd', () {
      expect(formatReceiptDate('2025-09-10T00:00:00'), '2025-09-10');
    });

    test('pads single-digit month and day with zeros', () {
      expect(formatReceiptDate('2025-04-07T00:00:00'), '2025-04-07');
    });

    test('handles end-of-year date', () {
      expect(formatReceiptDate('2025-12-31T00:00:00'), '2025-12-31');
    });

    test('handles start-of-year date', () {
      expect(formatReceiptDate('2026-01-01T00:00:00'), '2026-01-01');
    });

    test('year is padded to 4 digits', () {
      final result = formatReceiptDate('2025-06-15T12:30:00');
      expect(result.startsWith('2025'), isTrue);
    });
  });

  group('[ManagerUpdateSaleScreen] calcExpenseTotalAmount', () {
    test('sums expense amounts correctly', () {
      expect(calcExpenseTotalAmount([100.0, 250.0, 75.5]), closeTo(425.5, 0.001));
    });

    test('empty list returns 0.0', () {
      expect(calcExpenseTotalAmount([]), 0.0);
    });

    test('single item returns its value', () {
      expect(calcExpenseTotalAmount([999.99]), closeTo(999.99, 0.001));
    });

    test('null-safe via empty list', () {
      expect(calcExpenseTotalAmount([0.0, 0.0]), 0.0);
    });

    test('large amounts sum without overflow', () {
      expect(
          calcExpenseTotalAmount([100000.0, 200000.0, 300000.0]),
          closeTo(600000.0, 0.001));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION C – DeliveryBoyWiseListShow
  // ═══════════════════════════════════════════════════════════════════════════

  group('[DeliveryBoyWiseListShow] greeting', () {
    test('0–11 → Morning', () {
      for (int h = 0; h < 12; h++) {
        expect(greeting(h), 'Morning', reason: 'hour $h');
      }
    });

    test('12–16 → Afternoon', () {
      for (int h = 12; h < 17; h++) {
        expect(greeting(h), 'Afternoon', reason: 'hour $h');
      }
    });

    test('17–23 → Evening', () {
      for (int h = 17; h < 24; h++) {
        expect(greeting(h), 'Evening', reason: 'hour $h');
      }
    });
  });

  group('[DeliveryBoyWiseListShow] calcInitials', () {
    test('two-word name → two uppercase initials', () {
      expect(calcInitials('Rahul Kumar'), 'RK');
    });

    test('single word ≥ 2 chars → first two chars uppercase', () {
      expect(calcInitials('Admin'), 'AD');
    });

    test('single char → "M"', () {
      expect(calcInitials('A'), 'M');
    });

    test('three-word name → first two initials', () {
      expect(calcInitials('Amit Kumar Singh'), 'AK');
    });

    test('empty string → "M"', () {
      expect(calcInitials(''), 'M');
    });

    test('extra whitespace trimmed', () {
      expect(calcInitials('  Rajesh  More  '), 'RM');
    });
  });

  group('[DeliveryBoyWiseListShow] filterSearchResults', () {
    final sales = [
      DailySaleSaummaryListModel(
          staffName: 'Rahul', totalAmt: 34636.50, totalFilledQty: 43,
          totalTVQty: 0, totalSVQty: 0),
      DailySaleSaummaryListModel(
          staffName: 'Swarup Das', totalAmt: 15399.0, totalFilledQty: 20,
          totalTVQty: 1, totalSVQty: 2),
      DailySaleSaummaryListModel(
          staffName: 'Priya', totalAmt: 8200.0, totalFilledQty: 10,
          totalTVQty: 0, totalSVQty: 1),
    ];

    test('empty query returns all records', () {
      final result = filterSearchResults(sales, '');
      expect(result.length, 3);
    });

    test('query matches staffName case-insensitively', () {
      final result = filterSearchResults(sales, 'rahul');
      expect(result.length, 1);
      expect(result.first.staffName, 'Rahul');
    });

    test('query matches partial staffName', () {
      final result = filterSearchResults(sales, 'swa');
      expect(result.length, 1);
      expect(result.first.staffName, 'Swarup Das');
    });

    test('query matches totalAmt', () {
      final result = filterSearchResults(sales, '8200');
      expect(result.length, 1);
      expect(result.first.staffName, 'Priya');
    });

    test('query matches totalFilledQty', () {
      final result = filterSearchResults(sales, '43');
      expect(result.length, 1);
      expect(result.first.staffName, 'Rahul');
    });

    test('query matches totalSVQty', () {
      final result = filterSearchResults(sales, '2');
      // Swarup has totalSVQty=2; also totalAmt 15399.0 doesn't contain '2' but totalFilledQty=20 does
      expect(result.isNotEmpty, isTrue);
    });

    test('query with no match returns empty list', () {
      final result = filterSearchResults(sales, 'XYZNOTFOUND99999');
      expect(result, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION D – DailySaleSaummaryListModel
  // ═══════════════════════════════════════════════════════════════════════════

  group('[DailySaleSaummaryListModel] fromJson', () {
    final json = {
      'pkId': 0,
      'DMId': 22,
      'DistributorId': 8118,
      'SaleGKId': 171,
      'VehicleId': 10,
      'VehicleNo': 'MH49KL7474',
      'ItemCount': 1,
      'StaffName': 'Rahul',
      'TotalSVQty': 0,
      'TotalSVAmt': 0.0,
      'TotalTVQty': 0,
      'TotalTVAmt': 0,
      'TotalFilledQty': 43,
      'TotalActualSaleQty': 43,
      'TotalFilledAmt': 0,
      'TotalDefQty': 0,
      'TotalAmt': 34636.50,
      'PrepaidAmt': 0.00,
      'PrepaidQty': 0,
      'PostPaidAmt': 0.00,
      'PostPaidQty': 0,
      'RetiCrAmt': 0.00,
      'RetiCrQty': 0,
      'CashAmt': 0.00,
      'CashQty': 0,
      'Status': null,
      'StatusStr': 'Accepted',
      'DailySaleStatus': 2,
      'TotRecievedcAmt': 0.00,
      'DelDate': '2025-04-07T00:00:00',
      'Action': null,
      'AddedBy': 0,
      'DSCollMgrId': 0,
    };

    test('parses staffName correctly', () {
      final m = DailySaleSaummaryListModel.fromJson(json);
      expect(m.staffName, 'Rahul');
    });

    test('parses totalAmt correctly', () {
      final m = DailySaleSaummaryListModel.fromJson(json);
      expect(m.totalAmt, 34636.50);
    });

    test('parses totalFilledQty correctly', () {
      final m = DailySaleSaummaryListModel.fromJson(json);
      expect(m.totalFilledQty, 43);
    });

    test('parses vehicleNo correctly', () {
      final m = DailySaleSaummaryListModel.fromJson(json);
      expect(m.vehicleNo, 'MH49KL7474');
    });

    test('parses statusStr correctly', () {
      final m = DailySaleSaummaryListModel.fromJson(json);
      expect(m.statusStr, 'Accepted');
    });

    test('parses dailySaleStatus correctly', () {
      final m = DailySaleSaummaryListModel.fromJson(json);
      expect(m.dailySaleStatus, 2);
    });

    test('null status field is null', () {
      final m = DailySaleSaummaryListModel.fromJson(json);
      expect(m.status, isNull);
    });
  });

  group('[DailySaleSaummaryListModel] toJson', () {
    test('round-trips staffName', () {
      final m = DailySaleSaummaryListModel(staffName: 'Swarup', totalAmt: 1000);
      expect(m.toJson()['StaffName'], 'Swarup');
      expect(m.toJson()['TotalAmt'], 1000);
    });

    test('round-trips vehicleNo', () {
      final m = DailySaleSaummaryListModel(vehicleNo: 'MH12AB1234');
      expect(m.toJson()['VehicleNo'], 'MH12AB1234');
    });
  });

  group('[DailySaleSaummaryListModel] copyWith', () {
    test('overrides only specified fields', () {
      final m = DailySaleSaummaryListModel(
          staffName: 'Rahul', totalAmt: 5000, statusStr: 'Pending');
      final copy = m.copyWith(totalAmt: 9999);
      expect(copy.staffName, 'Rahul');
      expect(copy.totalAmt, 9999);
      expect(copy.statusStr, 'Pending');
    });
  });

  group('[DailySaleSaummaryListModel] default constructor', () {
    test('all fields are null by default', () {
      final m = DailySaleSaummaryListModel();
      expect(m.staffName, isNull);
      expect(m.totalAmt, isNull);
      expect(m.vehicleNo, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION E – DilySaleSummaryDeliveryBoyWiseListModel
  // ═══════════════════════════════════════════════════════════════════════════

  group('[DilySaleSummaryDeliveryBoyWiseListModel] fromJson', () {
    final json = {
      'SaleGKId': 4957,
      'DistributorId': 8118,
      'StaffId': 42,
      'DSCollMgrId': 0,
      'StaffNo': 'SN/027',
      'StaffName': '5kg Swarup',
      'ItemId': 1,
      'ItemName': '14.2 KG',
      'SaleGKItemId': 5257,
      'GDFilledSale': 20,
      'ActualSaleQty': 18,
      'SVQty': 2,
      'TVQty': 0,
      'Amount': 15399.00,
      'CashQty': 0,
      'CashAmt': 0.00,
      'PrepaidQty': 0,
      'PrepaidAmt': 0.00,
      'PostQty': 0,
      'PostAmt': 0.00,
      'CreditQty': 0,
      'CreditAmt': 0.00,
      'EmptyRetQty': 16,
      'DeffQty': 0,
      'LessEmptyQty': 2,
      'DailySaleStatus': 2,
      'DenoCashExptd': 0.0,
      'DenoCashRcvd': 0.0,
      'CashBalance': 0.0,
      'UserName': '',
      'StatusStr': 'Accepted',
      'AddedBy': 0,
      'IsActive': 0,
      'AddedOn': '0001-01-01T00:00:00',
      'DelDate': '2025-09-10T00:00:00',
      'ItemSubType': 'DOM',
    };

    test('parses staffName correctly', () {
      expect(DilySaleSummaryDeliveryBoyWiseListModel.fromJson(json).staffName,
          '5kg Swarup');
    });

    test('parses itemName correctly', () {
      expect(DilySaleSummaryDeliveryBoyWiseListModel.fromJson(json).itemName,
          '14.2 KG');
    });

    test('parses amount correctly', () {
      expect(DilySaleSummaryDeliveryBoyWiseListModel.fromJson(json).amount,
          15399.00);
    });

    test('parses actualSaleQty correctly', () {
      expect(
          DilySaleSummaryDeliveryBoyWiseListModel.fromJson(json).actualSaleQty,
          18);
    });

    test('parses sVQty correctly', () {
      expect(DilySaleSummaryDeliveryBoyWiseListModel.fromJson(json).sVQty, 2);
    });

    test('parses itemSubType correctly', () {
      expect(
          DilySaleSummaryDeliveryBoyWiseListModel.fromJson(json).itemSubType,
          'DOM');
    });

    test('parses dailySaleStatus correctly', () {
      expect(
          DilySaleSummaryDeliveryBoyWiseListModel.fromJson(json).dailySaleStatus,
          2);
    });

    test('parses emptyRetQty correctly', () {
      expect(
          DilySaleSummaryDeliveryBoyWiseListModel.fromJson(json).emptyRetQty,
          16);
    });
  });

  group('[DilySaleSummaryDeliveryBoyWiseListModel] toJson', () {
    test('round-trips itemName and amount', () {
      final m = DilySaleSummaryDeliveryBoyWiseListModel(
          itemName: '5 KG', amount: 8200.0);
      final map = m.toJson();
      expect(map['ItemName'], '5 KG');
      expect(map['Amount'], 8200.0);
    });

    test('round-trips itemSubType', () {
      final m = DilySaleSummaryDeliveryBoyWiseListModel(itemSubType: 'ND');
      expect(m.toJson()['ItemSubType'], 'ND');
    });

    test('round-trips staffNo', () {
      final m = DilySaleSummaryDeliveryBoyWiseListModel(staffNo: 'SN/027');
      expect(m.toJson()['StaffNo'], 'SN/027');
    });
  });

  group('[DilySaleSummaryDeliveryBoyWiseListModel] copyWith', () {
    test('overrides only specified fields', () {
      final m = DilySaleSummaryDeliveryBoyWiseListModel(
          staffName: 'Swarup', amount: 1000.0, itemSubType: 'DOM');
      final copy = m.copyWith(amount: 9999.0);
      expect(copy.staffName, 'Swarup');
      expect(copy.amount, 9999.0);
      expect(copy.itemSubType, 'DOM');
    });
  });

  group('[DilySaleSummaryDeliveryBoyWiseListModel] default constructor', () {
    test('all fields null by default', () {
      final m = DilySaleSummaryDeliveryBoyWiseListModel();
      expect(m.staffName, isNull);
      expect(m.amount, isNull);
      expect(m.itemSubType, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION F – Business Logic
  // ═══════════════════════════════════════════════════════════════════════════

  group('[Business Logic] dailySaleStatus display', () {
    // DailySaleStatus meanings: 0=Pending, 1=Partial, 2=Accepted
    String statusLabel(int status) {
      switch (status) {
        case 0:
          return 'Pending';
        case 1:
          return 'Partial';
        case 2:
          return 'Accepted';
        default:
          return 'Unknown';
      }
    }

    test('status 0 → Pending', () => expect(statusLabel(0), 'Pending'));
    test('status 1 → Partial', () => expect(statusLabel(1), 'Partial'));
    test('status 2 → Accepted', () => expect(statusLabel(2), 'Accepted'));
    test('unknown status → Unknown', () => expect(statusLabel(99), 'Unknown'));
  });

  group('[Business Logic] receipt number cleanup', () {
    // Mirrors: receiptNo = response.body.trim().replaceAll('"', '')
    String cleanReceiptNo(String raw) => raw.trim().replaceAll('"', '');

    test('strips quotes', () {
      expect(cleanReceiptNo('"RC-0042"'), 'RC-0042');
    });

    test('trims whitespace', () {
      expect(cleanReceiptNo('  RC-0042  '), 'RC-0042');
    });

    test('handles already clean value', () {
      expect(cleanReceiptNo('RC-0042'), 'RC-0042');
    });

    test('empty string stays empty', () {
      expect(cleanReceiptNo(''), '');
    });

    test('only quotes returns empty string', () {
      expect(cleanReceiptNo('""'), '');
    });
  });

  group('[Business Logic] date formatting (DateFormat EEEE, dd MMM yyyy)', () {
    // Mirrors DeliveryBoyWiseListShow date display
    String formatDate(DateTime dt) =>
        DateFormat('EEEE, dd MMM yyyy').format(dt);

    test('formats a known Thursday correctly', () {
      final dt = DateTime(2025, 4, 3); // April 3, 2025 = Thursday
      expect(formatDate(dt), 'Thursday, 03 Apr 2025');
    });

    test('formats a Monday correctly', () {
      final dt = DateTime(2025, 9, 1); // Sept 1, 2025 = Monday
      expect(formatDate(dt), 'Monday, 01 Sep 2025');
    });
  });

  group('[Business Logic] expense total calculation', () {
    test('handles mixed list', () {
      expect(calcExpenseTotalAmount([100.0, 50.5, 200.0]), closeTo(350.5, 0.001));
    });

    test('single zero returns 0.0', () {
      expect(calcExpenseTotalAmount([0.0]), 0.0);
    });
  });

  group('[Business Logic] isND itemSubtype validation', () {
    test('"ND" is non-domestic', () {
      expect(calcIsItemSubtypeND('ND'), isTrue);
    });

    test('"DOM" is domestic', () {
      expect(calcIsItemSubtypeND('DOM'), isFalse);
    });
  });

  group('[Business Logic] denomination balance calculation', () {
    // expected = qty * noteValue
    // balance = expected - received
    double calcBalance(double expected, double received) => expected - received;

    test('exact payment balance is 0', () {
      expect(calcBalance(1000.0, 1000.0), 0.0);
    });

    test('overpayment gives negative balance', () {
      expect(calcBalance(900.0, 1000.0), -100.0);
    });

    test('underpayment gives positive balance', () {
      expect(calcBalance(1000.0, 800.0), 200.0);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION G – ManagerUpdateSaleListItem
  // ═══════════════════════════════════════════════════════════════════════════

  group('[ManagerUpdateSaleListItem] resolveUpdateSaleActionMode', () {
    test('no payments + actualSaleQty > 0 → NEW', () {
      final result = resolveUpdateSaleActionMode(
        actualSaleQty: 10,
        dailySaleStatus: 2,
        cashQty: 0,
        prepaidQty: 0,
        postQty: 0,
        creditQty: 0,
        cashAmt: 0.0,
        postAmt: 0.0,
      );
      expect(result, 'NEW');
    });

    test('any payments + actualSaleQty > 0 → EDIT', () {
      final result = resolveUpdateSaleActionMode(
        actualSaleQty: 10,
        dailySaleStatus: 2,
        cashQty: 1,
        prepaidQty: 0,
        postQty: 0,
        creditQty: 0,
        cashAmt: 0.0,
        postAmt: 0.0,
      );
      expect(result, 'EDIT');
    });

    test('actualSaleQty == 0 → SETTLE_DIALOG', () {
      final result = resolveUpdateSaleActionMode(
        actualSaleQty: 0,
        dailySaleStatus: 2,
        cashQty: 0,
        prepaidQty: 0,
        postQty: 0,
        creditQty: 0,
        cashAmt: 0.0,
        postAmt: 0.0,
      );
      expect(result, 'SETTLE_DIALOG');
    });

    test('dailySaleStatus != 13 triggers settle dialog when no other case matches', () {
      final result = resolveUpdateSaleActionMode(
        actualSaleQty: 0,
        dailySaleStatus: 12,
        cashQty: 0,
        prepaidQty: 0,
        postQty: 0,
        creditQty: 0,
        cashAmt: 0.0,
        postAmt: 0.0,
      );
      expect(result, 'SETTLE_DIALOG');
    });

    test('payments present and actualSaleQty == 0 still → SETTLE_DIALOG', () {
      final result = resolveUpdateSaleActionMode(
        actualSaleQty: 0,
        dailySaleStatus: 2,
        cashQty: 1,
        prepaidQty: 0,
        postQty: 0,
        creditQty: 0,
        cashAmt: 100.0,
        postAmt: 0.0,
      );
      expect(result, 'SETTLE_DIALOG');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION H – DeliveryBoyWiseListItem
  // ═══════════════════════════════════════════════════════════════════════════

  group('[DeliveryBoyWiseListItem] resolvePrimaryActionLabel', () {
    test('status 1 → Accept', () {
      expect(resolvePrimaryActionLabel(1), 'Accept');
    });

    test('status 4 → Accept', () {
      expect(resolvePrimaryActionLabel(4), 'Accept');
    });

    test('status 2 → Update', () {
      expect(resolvePrimaryActionLabel(2), 'Update');
    });

    test('status 3 → empty', () {
      expect(resolvePrimaryActionLabel(3), '');
    });

    test('status 7 → empty', () {
      expect(resolvePrimaryActionLabel(7), '');
    });

    test('unknown status (e.g., 9) → Update', () {
      expect(resolvePrimaryActionLabel(9), 'Update');
    });

    test('null status → Update (matches default branch)', () {
      expect(resolvePrimaryActionLabel(null), 'Update');
    });
  });

  group('[DeliveryBoyWiseListItem] shouldShowCorrection', () {
    test('status 3 hides correction', () {
      expect(shouldShowCorrection(3), isFalse);
    });

    test('status 5 hides correction', () {
      expect(shouldShowCorrection(5), isFalse);
    });

    test('status 6 hides correction', () {
      expect(shouldShowCorrection(6), isFalse);
    });

    test('status 7 hides correction', () {
      expect(shouldShowCorrection(7), isFalse);
    });

    test('status 8 hides correction', () {
      expect(shouldShowCorrection(8), isFalse);
    });

    test('status 2 shows correction', () {
      expect(shouldShowCorrection(2), isTrue);
    });

    test('null status shows correction', () {
      expect(shouldShowCorrection(null), isTrue);
    });
  });
}


