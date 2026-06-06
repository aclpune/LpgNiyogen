import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetCreditSaleLedgerDtlsListModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118,
    'CustomerId': 5,
    'CustomerName': 'Ram Traders',
    'CollRcptDate': '2025-02-04T00:00:00',
    'TotalCredit': 177210.00,
    'TotalReceipt': 337860.00,
    'TotalOutstanding': -160650.00,
    'PendingSinceDays': 227.0,
    'CustTypeId': 1,
    'CustomerType': 'Commercial',
  };

  group('GetCreditSaleLedgerDtlsListModel.fromJson', () {
    test('parses all 10 fields', () {
      final m = GetCreditSaleLedgerDtlsListModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.customerId, 5);
      expect(m.customerName, 'Ram Traders');
      expect(m.collRcptDate, '2025-02-04T00:00:00');
      expect(m.totalCredit, 177210.00);
      expect(m.totalReceipt, 337860.00);
      expect(m.totalOutstanding, -160650.00);
      expect(m.pendingSinceDays, 227.0);
      expect(m.custTypeId, 1);
      expect(m.customerType, 'Commercial');
    });

    test('handles null customerName and customerType', () {
      final m = GetCreditSaleLedgerDtlsListModel.fromJson({
        ...fullJson, 'CustomerName': null, 'CustomerType': null,
      });
      expect(m.customerName, isNull);
      expect(m.customerType, isNull);
    });

    test('handles negative totalOutstanding (credit note)', () {
      final m = GetCreditSaleLedgerDtlsListModel.fromJson(fullJson);
      expect((m.totalOutstanding ?? 0) < 0, isTrue);
    });

    test('handles empty JSON', () {
      final m = GetCreditSaleLedgerDtlsListModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.totalCredit, isNull);
    });
  });

  group('GetCreditSaleLedgerDtlsListModel.toJson', () {
    test('serialises 10 fields', () {
      final j = GetCreditSaleLedgerDtlsListModel.fromJson(fullJson).toJson();
      expect(j.length, 10);
      expect(j['TotalCredit'], 177210.00);
      expect(j['TotalOutstanding'], -160650.00);
    });

    test('round-trips correctly', () {
      final o = GetCreditSaleLedgerDtlsListModel.fromJson(fullJson);
      final r = GetCreditSaleLedgerDtlsListModel.fromJson(o.toJson());
      expect(r.totalCredit, o.totalCredit);
      expect(r.totalOutstanding, o.totalOutstanding);
    });
  });

  group('GetCreditSaleLedgerDtlsListModel.copyWith', () {
    test('replaces totalOutstanding', () {
      final m = GetCreditSaleLedgerDtlsListModel.fromJson(fullJson);
      expect(m.copyWith(totalOutstanding: 0.0).totalOutstanding, 0.0);
    });

    test('replaces customerName', () {
      final m = GetCreditSaleLedgerDtlsListModel.fromJson(fullJson);
      expect(m.copyWith(customerName: 'New Name').customerName, 'New Name');
    });

    test('preserves all without args', () {
      final m = GetCreditSaleLedgerDtlsListModel.fromJson(fullJson);
      expect(m.copyWith().totalReceipt, m.totalReceipt);
    });
  });

  group('Credit sale ledger – business logic', () {
    test('totalOutstanding = totalCredit - totalReceipt', () {
      final m = GetCreditSaleLedgerDtlsListModel.fromJson(fullJson);
      final expected = (m.totalCredit ?? 0) - (m.totalReceipt ?? 0);
      expect(expected, closeTo(m.totalOutstanding ?? 0, 0.01));
    });

    test('negative outstanding means advance/over-receipt', () {
      final m = GetCreditSaleLedgerDtlsListModel.fromJson(fullJson);
      expect((m.totalReceipt ?? 0) > (m.totalCredit ?? 0), isTrue);
    });

    test('pendingSinceDays is non-negative', () {
      final m = GetCreditSaleLedgerDtlsListModel.fromJson(fullJson);
      expect((m.pendingSinceDays ?? 0) >= 0, isTrue);
    });

    test('customerId is positive', () {
      final m = GetCreditSaleLedgerDtlsListModel.fromJson(fullJson);
      expect((m.customerId ?? 0) > 0, isTrue);
    });
  });
}

