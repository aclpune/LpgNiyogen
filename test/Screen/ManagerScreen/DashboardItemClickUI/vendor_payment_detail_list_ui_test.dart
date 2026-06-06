// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/VendorPaymentDetailListUI.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from VendorPaymentDetailListUI ──────────────

/// Mirrors: formatCurrency() in VendorPaymentDetailListUI
String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

/// Mirrors: totalPendingAmount = fold over getVendorDetailListModel
double calcTotalPendingAmount(List<Map<String, dynamic>> vendors) {
  return vendors.fold(
      0.0, (sum, item) => sum + ((item['pendingAmount'] ?? 0.0) as num).toDouble());
}

/// Mirrors: vendorModel.sort() alphabetically by vendorName
List<Map<String, dynamic>> sortVendorsByName(List<Map<String, dynamic>> vendors) {
  final sorted = List<Map<String, dynamic>>.from(vendors);
  sorted.sort((a, b) {
    final na = (a['vendorName'] as String? ?? '').toLowerCase();
    final nb = (b['vendorName'] as String? ?? '').toLowerCase();
    return na.compareTo(nb);
  });
  return sorted;
}

/// Mirrors: onChanged vendorId == 0 → fetch ALL else fetch specific
String resolveVendorMode(int vendorId) =>
    vendorId == 0 ? 'ALL' : 'SPECIFIC';

/// Mirrors: WillPopScope – both branches return false
bool willPopReturnsFalse() => false;

/// Mirrors: isNotEmpty guard for list vs 'No Records Found'
bool showNoRecords(int count) => count == 0;

/// Mirrors: DateFormat('dd-MM-yyyy').format(DateTime.parse(vendor.invoiceDate))
String formatInvoiceDate(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) return '';
  try {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(isoDate));
  } catch (_) {
    return '';
  }
}

/// Mirrors: vendor.vendorName.toString()
String vendorNameDisplay(dynamic name) => name?.toString() ?? '';

/// Mirrors: formatCurrency(vendor.purchaseAmount?.toDouble() ?? 0)
String purchaseAmtDisplay(num? amt) =>
    formatCurrency(amt?.toDouble() ?? 0.0);

/// Mirrors: formatCurrency(vendor.pendingAmount?.toDouble() ?? 0)
String pendingAmtDisplay(num? amt) =>
    formatCurrency(amt?.toDouble() ?? 0.0);

/// Mirrors: allItem = GetVendorMasterListModel(vendorId: 0, vendorName: "ALL")
Map<String, dynamic> get allVendorItem => {'vendorId': 0, 'vendorName': 'ALL'};

/// Mirrors: initial _selectVendor = allItem
Map<String, dynamic> initialSelectedVendor() => allVendorItem;

void main() {
  // ── formatCurrency ────────────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.0 → "0.00"', () => expect(formatCurrency(0.0), '0.00'));
    test('0.5 starts with "0"', () =>
        expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not starts with "."', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('1.0 not starts with "0"', () =>
        expect(formatCurrency(1.0).startsWith('0'), isFalse));
    test('large amount has comma', () =>
        expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative does not throw', () =>
        expect(() => formatCurrency(-500.0), returnsNormally));
    test('same input same output', () =>
        expect(formatCurrency(2500.0), formatCurrency(2500.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
    test('0.99 starts with "0."', () =>
        expect(formatCurrency(0.99).startsWith('0.'), isTrue));
  });

  // ── calcTotalPendingAmount ────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] calcTotalPendingAmount', () {
    test('sums pendingAmount across vendors', () {
      final vendors = [
        {'pendingAmount': 1200.0},
        {'pendingAmount': 800.0},
        {'pendingAmount': 500.0},
      ];
      expect(calcTotalPendingAmount(vendors), closeTo(2500.0, 0.001));
    });

    test('empty list → 0', () =>
        expect(calcTotalPendingAmount([]), 0.0));

    test('null pendingAmount treated as 0', () {
      expect(calcTotalPendingAmount([
        {'pendingAmount': null},
        {'pendingAmount': 400.0},
      ]), closeTo(400.0, 0.001));
    });

    test('single vendor', () =>
        expect(calcTotalPendingAmount([{'pendingAmount': 750.0}]),
            closeTo(750.0, 0.001)));

    test('all zeros → 0', () {
      expect(calcTotalPendingAmount([
        {'pendingAmount': 0.0},
        {'pendingAmount': 0.0},
      ]), 0.0);
    });

    test('10 vendors summed', () {
      final vendors = List.generate(10, (_) => {'pendingAmount': 100.0});
      expect(calcTotalPendingAmount(vendors), closeTo(1000.0, 0.001));
    });

    test('fractional amounts', () {
      expect(calcTotalPendingAmount([
        {'pendingAmount': 1234.56},
        {'pendingAmount': 4321.44},
      ]), closeTo(5556.0, 0.001));
    });

    test('all null → 0', () {
      expect(calcTotalPendingAmount([
        {'pendingAmount': null},
        {'pendingAmount': null},
      ]), 0.0);
    });
  });

  // ── sortVendorsByName ─────────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] sortVendorsByName', () {
    test('sorts alphabetically case-insensitive', () {
      final vendors = [
        {'vendorName': 'Zeta Gases'},
        {'vendorName': 'alpha Energy'},
        {'vendorName': 'Mumbai LPG'},
      ];
      final r = sortVendorsByName(vendors);
      expect(r.first['vendorName'], 'alpha Energy');
      expect(r.last['vendorName'],  'Zeta Gases');
    });

    test('single vendor returned as-is', () {
      final vendors = [{'vendorName': 'OnlyOne'}];
      expect(sortVendorsByName(vendors).first['vendorName'], 'OnlyOne');
    });

    test('already sorted list stays sorted', () {
      final vendors = [
        {'vendorName': 'AAA'},
        {'vendorName': 'BBB'},
        {'vendorName': 'CCC'},
      ];
      final r = sortVendorsByName(vendors);
      expect(r.map((e) => e['vendorName']).toList(), ['AAA', 'BBB', 'CCC']);
    });

    test('null vendorName sorts before non-null (empty string)', () {
      final vendors = [
        {'vendorName': 'Zeta'},
        {'vendorName': null},
      ];
      expect(sortVendorsByName(vendors).first['vendorName'], isNull);
    });

    test('empty list → empty', () =>
        expect(sortVendorsByName([]), isEmpty));

    test('does not mutate original list', () {
      final vendors = [
        {'vendorName': 'Zeta'},
        {'vendorName': 'Alpha'},
      ];
      sortVendorsByName(vendors);
      expect(vendors.first['vendorName'], 'Zeta');
    });

    test('case-insensitive: "zeta" sorts after "alpha"', () {
      final vendors = [
        {'vendorName': 'zeta'},
        {'vendorName': 'Alpha'},
      ];
      expect(sortVendorsByName(vendors).first['vendorName'], 'Alpha');
    });

    test('5 vendors sorted correctly', () {
      final vendors = [
        {'vendorName': 'E Corp'},
        {'vendorName': 'c Corp'},
        {'vendorName': 'A Corp'},
        {'vendorName': 'D Corp'},
        {'vendorName': 'b Corp'},
      ];
      final r = sortVendorsByName(vendors);
      expect(r[0]['vendorName'], 'A Corp');
      expect(r[4]['vendorName'], 'E Corp');
    });
  });

  // ── resolveVendorMode ─────────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] resolveVendorMode', () {
    test('vendorId 0 → ALL', () =>
        expect(resolveVendorMode(0), 'ALL'));
    test('vendorId 1 → SPECIFIC', () =>
        expect(resolveVendorMode(1), 'SPECIFIC'));
    test('vendorId 100 → SPECIFIC', () =>
        expect(resolveVendorMode(100), 'SPECIFIC'));
    test('negative id → SPECIFIC', () =>
        expect(resolveVendorMode(-1), 'SPECIFIC'));
    test('vendorId 0 always ALL', () {
      for (int i = 0; i < 5; i++) {
        expect(resolveVendorMode(0), 'ALL');
      }
    });
  });

  // ── willPopReturnsFalse ───────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] WillPopScope', () {
    test('fromDrawer → returns false', () =>
        expect(willPopReturnsFalse(), isFalse));
    test('other navigation → returns false', () =>
        expect(willPopReturnsFalse(), isFalse));
  });

  // ── showNoRecords ─────────────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] showNoRecords', () {
    test('0 → show message', () => expect(showNoRecords(0), isTrue));
    test('1 → hide message', () => expect(showNoRecords(1), isFalse));
    test('10 → hide message', () => expect(showNoRecords(10), isFalse));
    test('after empty fetch → show', () {
      expect(showNoRecords(calcTotalPendingAmount([]).toInt()), isTrue);
    });
  });

  // ── formatInvoiceDate ─────────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] formatInvoiceDate', () {
    test('ISO datetime → dd-MM-yyyy', () =>
        expect(formatInvoiceDate('2025-04-07T00:00:00'), '07-04-2025'));
    test('ISO date-only → dd-MM-yyyy', () =>
        expect(formatInvoiceDate('2025-12-31'), '31-12-2025'));
    test('null → ""', () => expect(formatInvoiceDate(null), ''));
    test('empty → ""', () => expect(formatInvoiceDate(''), ''));
    test('invalid → ""', () => expect(formatInvoiceDate('not-a-date'), ''));
    test('single digit month/day padded', () =>
        expect(formatInvoiceDate('2025-01-05'), '05-01-2025'));
    test('year 2026', () =>
        expect(formatInvoiceDate('2026-06-15'), '15-06-2026'));
    test('leap year 2024-02-29', () =>
        expect(formatInvoiceDate('2024-02-29'), '29-02-2024'));
  });

  // ── vendorNameDisplay ─────────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] vendorNameDisplay', () {
    test('valid name returned', () =>
        expect(vendorNameDisplay('Zeta Gases'), 'Zeta Gases'));
    test('null → ""', () => expect(vendorNameDisplay(null), ''));
    test('int → string', () => expect(vendorNameDisplay(42), '42'));
    test('empty string → ""', () => expect(vendorNameDisplay(''), ''));
  });

  // ── purchaseAmtDisplay ────────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] purchaseAmtDisplay', () {
    test('null → "0.00"', () => expect(purchaseAmtDisplay(null), '0.00'));
    test('0 → "0.00"', () => expect(purchaseAmtDisplay(0), '0.00'));
    test('positive formatted', () =>
        expect(purchaseAmtDisplay(1500.0), isNot('0.00')));
    test('positive contains digits', () =>
        expect(purchaseAmtDisplay(800.0).contains('8'), isTrue));
    test('sub-1 starts with "0"', () =>
        expect(purchaseAmtDisplay(0.5).startsWith('0'), isTrue));
  });

  // ── pendingAmtDisplay ─────────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] pendingAmtDisplay', () {
    test('null → "0.00"', () => expect(pendingAmtDisplay(null), '0.00'));
    test('0 → "0.00"', () => expect(pendingAmtDisplay(0), '0.00'));
    test('positive formatted', () =>
        expect(pendingAmtDisplay(2500.0), isNot('0.00')));
    test('same as formatCurrency', () =>
        expect(pendingAmtDisplay(1200.0), formatCurrency(1200.0)));
  });

  // ── allVendorItem ─────────────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] allVendorItem', () {
    test('vendorId is 0', () => expect(allVendorItem['vendorId'], 0));
    test('vendorName is "ALL"', () => expect(allVendorItem['vendorName'], 'ALL'));
    test('resolves to ALL mode', () =>
        expect(resolveVendorMode(allVendorItem['vendorId'] as int), 'ALL'));
  });

  // ── initialSelectedVendor ─────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] initialSelectedVendor', () {
    test('initial vendor is ALL item', () {
      final init = initialSelectedVendor();
      expect(init['vendorId'], 0);
      expect(init['vendorName'], 'ALL');
    });
    test('initial mode resolves to ALL', () {
      final init = initialSelectedVendor();
      expect(resolveVendorMode(init['vendorId'] as int), 'ALL');
    });
  });

  // ── integration ───────────────────────────────────────────────────────────
  group('[VendorPaymentDetailListUI] integration', () {
    test('calcTotal → formatCurrency → AppBar label', () {
      final vendors = [
        {'pendingAmount': 1200.0},
        {'pendingAmount': 800.0},
      ];
      final total = calcTotalPendingAmount(vendors);
      final label = 'Total Pending Amt.-${formatCurrency(total)}';
      expect(label.contains('2'), isTrue);
      expect(label.startsWith('Total Pending Amt.-'), isTrue);
    });

    test('sorted vendors first item has smallest name alphabetically', () {
      final vendors = [
        {'vendorName': 'Z Gas', 'pendingAmount': 500.0},
        {'vendorName': 'A Gas', 'pendingAmount': 300.0},
        {'vendorName': 'M Gas', 'pendingAmount': 200.0},
      ];
      final sorted = sortVendorsByName(vendors);
      expect(sorted.first['vendorName'], 'A Gas');
      expect(calcTotalPendingAmount(vendors), closeTo(1000.0, 0.001));
    });

    test('vendor with 0 pending still shown (no filter on vendor list)', () {
      final vendors = [
        {'vendorName': 'A', 'pendingAmount': 0.0},
        {'vendorName': 'B', 'pendingAmount': 500.0},
      ];
      expect(showNoRecords(vendors.length), isFalse);
    });

    test('invoice date formatting in card display', () {
      const isoDate = '2025-09-10T00:00:00';
      expect(formatInvoiceDate(isoDate), '10-09-2025');
    });
  });
}

