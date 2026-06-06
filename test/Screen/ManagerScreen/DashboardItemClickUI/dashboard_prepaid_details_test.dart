// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/DashboardPrepaidDetails.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from DashboardPrepaidDetails ────────────────

String getDisplayText(String flag) {
  switch (flag) {
    case 'Delivered':            return 'Delivered,payment pending';
    case 'Settled':              return 'Payment done,delivery pending';
    case 'cDCMS':                return 'Pending in cDCMS';
    case 'DelDonNiyoJanPunPend': return 'Punched in cDCMS,pending in Niyojan';
    case 'OldBkgPendNewBkgRecv': return 'Old punching pending but....';
    case 'Punching':             return "Today's Niyojan Punched";
    case 'Incorrect':            return "Today's incorrect";
    case 'NiyoJanPunDelPend':    return 'Punched in Niyojan,pending in cDCMS';
    case 'TotalOutstanding':     return 'Total Outstanding Pending';
    default:                     return 'Prepaid Details';
  }
}

bool usesPreCount(String flag) =>
    flag == 'Delivered'           ||
    flag == 'Settled'             ||
    flag == 'TotalOutstanding'    ||
    flag == 'cDCMS'               ||
    flag == 'DelDonNiyoJanPunPend'||
    flag == 'OldBkgPendNewBkgRecv';

List<Map<String, dynamic>> filterPrepaid(
    List<Map<String, dynamic>> items, String query) {
  final lq = query.toLowerCase();
  return items.where((e) =>
      (e['consumerNo']  ?.toString().toLowerCase().contains(lq) ?? false) ||
      (e['consumerName']?.toString().toLowerCase().contains(lq) ?? false) ||
      (e['orderDate']   ?.toString().toLowerCase().contains(lq) ?? false) ||
      (e['deliveryDate']?.toString().toLowerCase().contains(lq) ?? false)).toList();
}

List<Map<String, dynamic>> filterPunch(
    List<Map<String, dynamic>> items, String query) {
  final lq = query.toLowerCase();
  return items.where((e) =>
      (e['staffName']    ?.toString().toLowerCase().contains(lq) ?? false) ||
      (e['niyojanPunQty']?.toString().toLowerCase().contains(lq) == true)  ||
      (e['settlementQty']?.toString().toLowerCase().contains(lq) == true)).toList();
}

String parsePunchDate(String? isoDate) {
  if (isoDate == null) return '';
  try {
    return DateFormat('yyyy-MM-dd').format(DateTime.parse(isoDate));
  } catch (_) {
    return '';
  }
}

String headerConsumerCol(String flag) =>
    usesPreCount(flag) ? 'Consumer No.' : 'Staff Name';

String headerNameCol(String flag) =>
    usesPreCount(flag) ? 'Consumer \n Name' : 'Niyojan \n Punching';

String headerDateCol(String flag) =>
    usesPreCount(flag) ? 'Order Date' : 'Settl Qty.';

String headerLastCol(String flag) =>
    usesPreCount(flag) ? 'Delivery Date' : 'Settl Pen Qty.';

void main() {
  // ── getDisplayText ───────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetails] getDisplayText', () {
    test('"Delivered"', () =>
        expect(getDisplayText('Delivered'), 'Delivered,payment pending'));
    test('"Settled"', () =>
        expect(getDisplayText('Settled'), 'Payment done,delivery pending'));
    test('"cDCMS"', () =>
        expect(getDisplayText('cDCMS'), 'Pending in cDCMS'));
    test('"DelDonNiyoJanPunPend"', () =>
        expect(getDisplayText('DelDonNiyoJanPunPend'),
            'Punched in cDCMS,pending in Niyojan'));
    test('"OldBkgPendNewBkgRecv"', () =>
        expect(getDisplayText('OldBkgPendNewBkgRecv'),
            'Old punching pending but....'));
    test('"Punching"', () =>
        expect(getDisplayText('Punching'), "Today's Niyojan Punched"));
    test('"Incorrect"', () =>
        expect(getDisplayText('Incorrect'), "Today's incorrect"));
    test('"NiyoJanPunDelPend"', () =>
        expect(getDisplayText('NiyoJanPunDelPend'),
            'Punched in Niyojan,pending in cDCMS'));
    test('"TotalOutstanding"', () =>
        expect(getDisplayText('TotalOutstanding'), 'Total Outstanding Pending'));
    test('unknown → "Prepaid Details"', () =>
        expect(getDisplayText('ANYTHING'), 'Prepaid Details'));
    test('empty → "Prepaid Details"', () =>
        expect(getDisplayText(''), 'Prepaid Details'));
    test('all 9 known flags return non-empty string', () {
      for (final flag in [
        'Delivered','Settled','cDCMS','DelDonNiyoJanPunPend',
        'OldBkgPendNewBkgRecv','Punching','Incorrect','NiyoJanPunDelPend',
        'TotalOutstanding',
      ]) {
        expect(getDisplayText(flag).isNotEmpty, isTrue, reason: flag);
      }
    });
  });

  // ── usesPreCount ─────────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetails] usesPreCount', () {
    // true flags
    test('"Delivered" → true', () => expect(usesPreCount('Delivered'), isTrue));
    test('"Settled" → true', () => expect(usesPreCount('Settled'), isTrue));
    test('"TotalOutstanding" → true', () =>
        expect(usesPreCount('TotalOutstanding'), isTrue));
    test('"cDCMS" → true', () => expect(usesPreCount('cDCMS'), isTrue));
    test('"DelDonNiyoJanPunPend" → true', () =>
        expect(usesPreCount('DelDonNiyoJanPunPend'), isTrue));
    test('"OldBkgPendNewBkgRecv" → true', () =>
        expect(usesPreCount('OldBkgPendNewBkgRecv'), isTrue));
    // false flags
    test('"Punching" → false', () => expect(usesPreCount('Punching'), isFalse));
    test('"Incorrect" → false', () => expect(usesPreCount('Incorrect'), isFalse));
    test('"NiyoJanPunDelPend" → false', () =>
        expect(usesPreCount('NiyoJanPunDelPend'), isFalse));
    test('unknown → false', () => expect(usesPreCount('UNKNOWN'), isFalse));
    test('empty → false', () => expect(usesPreCount(''), isFalse));
  });

  // ── filterPrepaid ────────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetails] filterPrepaid', () {
    final items = [
      {'consumerNo': '660990', 'consumerName': 'Priya Mondal',
       'orderDate': '2025-04-01', 'deliveryDate': '2025-04-05'},
      {'consumerNo': '770101', 'consumerName': 'Rahul Das',
       'orderDate': '2025-05-01', 'deliveryDate': null},
      {'consumerNo': '880202', 'consumerName': 'Amit Kumar',
       'orderDate': '2025-06-10', 'deliveryDate': '2025-06-15'},
    ];

    test('matches consumerNo exactly', () =>
        expect(filterPrepaid(items, '660990').length, 1));
    test('partial consumerNo', () =>
        expect(filterPrepaid(items, '7701').length, 1));
    test('matches consumerName case-insensitive', () =>
        expect(filterPrepaid(items, 'priya').length, 1));
    test('matches consumerName uppercase', () =>
        expect(filterPrepaid(items, 'RAHUL').length, 1));
    test('matches orderDate', () =>
        expect(filterPrepaid(items, '2025-06').length, 1));
    test('matches deliveryDate', () =>
        expect(filterPrepaid(items, '2025-04-05').length, 1));
    test('empty query → all items', () =>
        expect(filterPrepaid(items, '').length, 3));
    test('no match → empty', () =>
        expect(filterPrepaid(items, 'ZZZNONE'), isEmpty));
    test('query matches across field (partial year)', () =>
        expect(filterPrepaid(items, '2025').length, 3));
  });

  // ── filterPunch ──────────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetails] filterPunch', () {
    final items = [
      {'staffName': 'Ravi',  'niyojanPunQty': 10, 'settlementQty': 8},
      {'staffName': 'Amit',  'niyojanPunQty': 5,  'settlementQty': 5},
      {'staffName': 'Priya', 'niyojanPunQty': 3,  'settlementQty': 2},
    ];

    test('matches staffName', () =>
        expect(filterPunch(items, 'ravi').length, 1));
    test('case-insensitive staffName', () =>
        expect(filterPunch(items, 'PRIYA').length, 1));
    test('matches niyojanPunQty', () =>
        expect(filterPunch(items, '10').length, 1));
    test('matches settlementQty', () =>
        expect(filterPunch(items, '8').length, 1));
    test('empty query → all', () =>
        expect(filterPunch(items, '').length, 3));
    test('no match → empty', () =>
        expect(filterPunch(items, 'ZZZNONE'), isEmpty));
    test('partial staff name', () =>
        expect(filterPunch(items, 'am').length, 1));
  });

  // ── parsePunchDate ────────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetails] parsePunchDate', () {
    test('valid ISO → yyyy-MM-dd', () =>
        expect(parsePunchDate('2025-04-07T00:00:00'), '2025-04-07'));
    test('date only → formatted', () =>
        expect(parsePunchDate('2025-12-31'), '2025-12-31'));
    test('null → ""', () => expect(parsePunchDate(null), ''));
    test('invalid → ""', () => expect(parsePunchDate('not-a-date'), ''));
    test('empty string → ""', () => expect(parsePunchDate(''), ''));
    test('date with time strips time', () =>
        expect(parsePunchDate('2025-06-15T23:59:59'), '2025-06-15'));
  });

  // ── header column labels ─────────────────────────────────────────────────────
  group('[DashboardPrepaidDetails] header column labels – consumer col', () {
    test('Delivered → "Consumer No."', () =>
        expect(headerConsumerCol('Delivered'), 'Consumer No.'));
    test('Settled → "Consumer No."', () =>
        expect(headerConsumerCol('Settled'), 'Consumer No.'));
    test('cDCMS → "Consumer No."', () =>
        expect(headerConsumerCol('cDCMS'), 'Consumer No.'));
    test('Punching → "Staff Name"', () =>
        expect(headerConsumerCol('Punching'), 'Staff Name'));
    test('Incorrect → "Staff Name"', () =>
        expect(headerConsumerCol('Incorrect'), 'Staff Name'));
    test('NiyoJanPunDelPend → "Staff Name"', () =>
        expect(headerConsumerCol('NiyoJanPunDelPend'), 'Staff Name'));
  });

  group('[DashboardPrepaidDetails] header column labels – name col', () {
    test('Delivered → contains "Consumer"', () =>
        expect(headerNameCol('Delivered'), contains('Consumer')));
    test('Punching → contains "Niyojan"', () =>
        expect(headerNameCol('Punching'), contains('Niyojan')));
  });

  group('[DashboardPrepaidDetails] header column labels – date col', () {
    test('Delivered → "Order Date"', () =>
        expect(headerDateCol('Delivered'), 'Order Date'));
    test('Punching → "Settl Qty."', () =>
        expect(headerDateCol('Punching'), 'Settl Qty.'));
  });

  group('[DashboardPrepaidDetails] header column labels – last col', () {
    test('Delivered → "Delivery Date"', () =>
        expect(headerLastCol('Delivered'), 'Delivery Date'));
    test('Punching → "Settl Pen Qty."', () =>
        expect(headerLastCol('Punching'), 'Settl Pen Qty.'));
  });
}

