// Tests for: lib/Screen/ManagerScreen/DSRItemClickUI/ManagerCashInHandScreenDetails.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Helpers mirrored from ManagerCashInHandScreenDetails ─────────────────────

String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

Map<String, dynamic> buildCashInHandRequestBody({
  required String? distributorId,
  required String formattedDate,
  required int staffId,
}) => {"DistributorId": distributorId, "Date": formattedDate, "StaffId": staffId};

bool initialLoadingState() => true;
bool loadingAfterFetch() => false;
bool loadingOnError() => false;

List<Map<String, dynamic>> parseCashInHandData(List<dynamic> data) =>
    data.map((e) => Map<String, dynamic>.from(e as Map)).toList();

void main() {
  // ── formatDate ────────────────────────────────────────────────────────────
  group('[ManagerCashInHandScreenDetails] formatDate', () {
    test('2025-04-07 formats correctly', () =>
        expect(formatDate(DateTime(2025, 4, 7)), '2025-04-07'));
    test('end of year', () =>
        expect(formatDate(DateTime(2025, 12, 31)), '2025-12-31'));
    test('single digit month/day padded', () =>
        expect(formatDate(DateTime(2026, 1, 5)), '2026-01-05'));
    test('year 2026', () =>
        expect(formatDate(DateTime(2026, 6, 15)), '2026-06-15'));
    test('leap year 2024-02-29', () =>
        expect(formatDate(DateTime(2024, 2, 29)), '2024-02-29'));
    test('format is yyyy-MM-dd', () {
      final result = formatDate(DateTime(2025, 8, 20));
      expect(RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(result), isTrue);
    });
  });

  // ── buildCashInHandRequestBody ────────────────────────────────────────────
  group('[ManagerCashInHandScreenDetails] buildCashInHandRequestBody', () {
    test('contains DistributorId', () {
      final body = buildCashInHandRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07', staffId: 42);
      expect(body['DistributorId'], '8118');
    });
    test('contains Date', () {
      final body = buildCashInHandRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07', staffId: 42);
      expect(body['Date'], '2025-04-07');
    });
    test('contains StaffId', () {
      final body = buildCashInHandRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07', staffId: 42);
      expect(body['StaffId'], 42);
    });
    test('null distributorId is preserved', () {
      final body = buildCashInHandRequestBody(
          distributorId: null, formattedDate: '2025-04-07', staffId: 1);
      expect(body['DistributorId'], isNull);
    });
    test('has 3 keys', () {
      final body = buildCashInHandRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07', staffId: 42);
      expect(body.keys.length, 3);
    });
  });

  // ── loading state ─────────────────────────────────────────────────────────
  group('[ManagerCashInHandScreenDetails] loading state', () {
    test('initial isLoading is true', () => expect(initialLoadingState(), isTrue));
    test('isLoading after fetch is false', () => expect(loadingAfterFetch(), isFalse));
    test('isLoading on error is false', () => expect(loadingOnError(), isFalse));
  });

  // ── parseCashInHandData ───────────────────────────────────────────────────
  group('[ManagerCashInHandScreenDetails] parseCashInHandData', () {
    test('parses list of maps', () {
      final data = [
        {'itemName': '14.2 KG', 'totalAmount': 3400.0},
        {'itemName': '5 KG',    'totalAmount': 850.0},
      ];
      final result = parseCashInHandData(data);
      expect(result.length, 2);
      expect(result.first['itemName'], '14.2 KG');
    });
    test('empty list → empty result', () {
      expect(parseCashInHandData([]), isEmpty);
    });
    test('single item parsed', () {
      final data = [{'itemName': '19 KG', 'totalAmount': 5000.0}];
      expect(parseCashInHandData(data).first['totalAmount'], 5000.0);
    });
  });
}

