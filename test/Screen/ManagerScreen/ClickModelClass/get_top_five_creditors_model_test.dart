import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetTopFiveCreditorsModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118,
    'CustomerId': 4,
    'CustomerName': 'Ram Traders',
    'CollRcptDate': '0001-01-01T00:00:00',
    'TotalCredit': 3281490.00,
    'TotalReceipt': 281410.00,
    'TotalOutstanding': 3000080.00,
    'PendingSinceDays': 120.0,
    'CustTypeId': 2,
    'CustomerType': 'Commercial',
  };

  // ── fromJson ─────────────────────────────────────────────────────────────
  group('GetTopFiveCreditorsModel.fromJson', () {
    test('parses all fields correctly', () {
      final m = GetTopFiveCreditorsModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.customerId, 4);
      expect(m.customerName, 'Ram Traders');
      expect(m.collRcptDate, '0001-01-01T00:00:00');
      expect(m.totalCredit, 3281490.00);
      expect(m.totalReceipt, 281410.00);
      expect(m.totalOutstanding, 3000080.00);
      expect(m.pendingSinceDays, 120.0);
      expect(m.custTypeId, 2);
      expect(m.customerType, 'Commercial');
    });

    test('handles null CustomerName and CustomerType', () {
      final m = GetTopFiveCreditorsModel.fromJson({
        'DistributorId': 8118,
        'CustomerId': 4,
        'CustomerName': null,
        'CollRcptDate': '0001-01-01T00:00:00',
        'TotalCredit': 0.0,
        'TotalReceipt': 0.0,
        'TotalOutstanding': 0.0,
        'PendingSinceDays': 0.0,
        'CustTypeId': 0,
        'CustomerType': null,
      });
      expect(m.customerName, isNull);
      expect(m.customerType, isNull);
    });

    test('handles empty JSON', () {
      final m = GetTopFiveCreditorsModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.totalCredit, isNull);
      expect(m.totalOutstanding, isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('GetTopFiveCreditorsModel.toJson', () {
    test('serialises all 10 fields', () {
      final j = GetTopFiveCreditorsModel.fromJson(fullJson).toJson();
      expect(j.length, 10);
      expect(j['TotalCredit'], 3281490.00);
      expect(j['TotalOutstanding'], 3000080.00);
    });

    test('round-trips correctly', () {
      final original = GetTopFiveCreditorsModel.fromJson(fullJson);
      final restored = GetTopFiveCreditorsModel.fromJson(original.toJson());
      expect(restored.totalCredit, original.totalCredit);
      expect(restored.totalOutstanding, original.totalOutstanding);
      expect(restored.customerName, original.customerName);
    });
  });

  // ── copyWith ─────────────────────────────────────────────────────────────
  group('GetTopFiveCreditorsModel.copyWith', () {
    test('replaces totalOutstanding only', () {
      final m = GetTopFiveCreditorsModel.fromJson(fullJson);
      final copy = m.copyWith(totalOutstanding: 0.0);
      expect(copy.totalOutstanding, 0.0);
      expect(copy.totalCredit, m.totalCredit);
    });

    test('replaces customerName', () {
      final m = GetTopFiveCreditorsModel.fromJson(fullJson);
      final copy = m.copyWith(customerName: 'New Name');
      expect(copy.customerName, 'New Name');
      expect(copy.customerId, m.customerId);
    });

    test('copyWith without args preserves all', () {
      final m = GetTopFiveCreditorsModel.fromJson(fullJson);
      final copy = m.copyWith();
      expect(copy.totalReceipt, m.totalReceipt);
      expect(copy.pendingSinceDays, m.pendingSinceDays);
    });
  });

  // ── Business logic ────────────────────────────────────────────────────────
  group('Top creditor – business logic', () {
    test('outstanding = credit - receipt', () {
      final m = GetTopFiveCreditorsModel.fromJson(fullJson);
      final expected = (m.totalCredit ?? 0) - (m.totalReceipt ?? 0);
      expect(expected, closeTo(m.totalOutstanding ?? 0, 0.01));
    });

    test('total credit must be >= total receipt', () {
      final m = GetTopFiveCreditorsModel.fromJson(fullJson);
      expect((m.totalCredit ?? 0) >= (m.totalReceipt ?? 0), isTrue);
    });

    test('total outstanding must be non-negative', () {
      final m = GetTopFiveCreditorsModel.fromJson(fullJson);
      expect((m.totalOutstanding ?? 0) >= 0, isTrue);
    });

    test('pendingSinceDays non-negative', () {
      final m = GetTopFiveCreditorsModel.fromJson(fullJson);
      expect((m.pendingSinceDays ?? 0) >= 0, isTrue);
    });
  });
}

