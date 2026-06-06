import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDSRReportCashHandOverModel.dart';

void main() {
  group('ManagerDsrReportCashHandOverModel', () {
    final sampleJson = {
      'CashHandoverId': 0,
      'DistributorId': 8118,
      'TotalAmt': 189666.50,
      'StaffIds': null,
      'CashHandoverTo_ID': 0,
      'IsCashHandover': 0,
      'AddedBy': 0,
      'CashCollDate': '2025-02-11T00:00:00',
      'StaffId': 4,
      'StaffName': 'LPG Gas Dealer',
      'CashInHand': 0.0,
      'CollAmt': 202666.50,
      'PaidAmt': 13000.00,
      'Date': '0001-01-01T00:00:00',
    };

    test('fromJson parses all fields correctly', () {
      final model = ManagerDsrReportCashHandOverModel.fromJson(sampleJson);
      expect(model.cashHandoverId, 0);
      expect(model.distributorId, 8118);
      expect(model.totalAmt, 189666.50);
      expect(model.staffIds, isNull);
      expect(model.staffId, 4);
      expect(model.staffName, 'LPG Gas Dealer');
      expect(model.collAmt, 202666.50);
      expect(model.paidAmt, 13000.00);
    });

    test('toJson returns correct map', () {
      final model = ManagerDsrReportCashHandOverModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['TotalAmt'], 189666.50);
      expect(json['StaffName'], 'LPG Gas Dealer');
      expect(json['CollAmt'], 202666.50);
      expect(json['StaffIds'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = ManagerDsrReportCashHandOverModel.fromJson(sampleJson);
      final updated = model.copyWith(paidAmt: 20000.0);
      expect(updated.paidAmt, 20000.0);
      expect(model.paidAmt, 13000.00);
    });

    test('default constructor with null values', () {
      final model = ManagerDsrReportCashHandOverModel();
      expect(model.totalAmt, isNull);
      expect(model.staffName, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = ManagerDsrReportCashHandOverModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = ManagerDsrReportCashHandOverModel.fromJson(json);
      expect(model2.totalAmt, model.totalAmt);
      expect(model2.collAmt, model.collAmt);
      expect(model2.paidAmt, model.paidAmt);
    });

    test('totalAmt = collAmt - paidAmt', () {
      final model = ManagerDsrReportCashHandOverModel.fromJson(sampleJson);
      expect(model.totalAmt, model.collAmt! - model.paidAmt!);
    });
  });
}

