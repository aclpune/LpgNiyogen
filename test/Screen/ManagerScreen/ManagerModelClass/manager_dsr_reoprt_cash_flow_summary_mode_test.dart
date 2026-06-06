import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDsrReoprtCashFlowSummaryMode.dart';

void main() {
  group('ManagerDsrReoprtCashFlowSummaryMode', () {
    final sampleJson = {
      'CashHandoverId': 0,
      'DistributorId': 8118,
      'TotalAmt': 416183.00,
      'StaffIds': null,
      'CashHandoverTo_ID': 0,
      'IsCashHandover': 0,
      'AddedBy': 0,
      'CashCollDate': '2025-03-28T00:00:00',
      'StaffId': 4,
      'StaffName': 'LPG Gas Dealer',
      'CashInHand': 0.0,
      'CollAmt': 0.0,
      'PaidAmt': 0.0,
      'Date': '0001-01-01T00:00:00',
      'HeaderNameStr': 'Cash In Hand',
      'BankId': 0,
      'MappingId': 0,
    };

    test('fromJson parses all fields correctly', () {
      final model = ManagerDsrReoprtCashFlowSummaryMode.fromJson(sampleJson);
      expect(model.cashHandoverId, 0);
      expect(model.distributorId, 8118);
      expect(model.totalAmt, 416183.00);
      expect(model.staffIds, isNull);
      expect(model.staffId, 4);
      expect(model.staffName, 'LPG Gas Dealer');
      expect(model.headerNameStr, 'Cash In Hand');
    });

    test('toJson returns correct map', () {
      final model = ManagerDsrReoprtCashFlowSummaryMode.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['TotalAmt'], 416183.00);
      expect(json['StaffName'], 'LPG Gas Dealer');
      expect(json['HeaderNameStr'], 'Cash In Hand');
      expect(json['StaffIds'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = ManagerDsrReoprtCashFlowSummaryMode.fromJson(sampleJson);
      final updated = model.copyWith(staffName: 'Updated', totalAmt: 500000.0);
      expect(updated.staffName, 'Updated');
      expect(updated.totalAmt, 500000.0);
      expect(model.staffName, 'LPG Gas Dealer');
    });

    test('default constructor with null values', () {
      final model = ManagerDsrReoprtCashFlowSummaryMode();
      expect(model.distributorId, isNull);
      expect(model.totalAmt, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = ManagerDsrReoprtCashFlowSummaryMode.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = ManagerDsrReoprtCashFlowSummaryMode.fromJson(json);
      expect(model2.distributorId, model.distributorId);
      expect(model2.staffName, model.staffName);
      expect(model2.totalAmt, model.totalAmt);
    });
  });
}

