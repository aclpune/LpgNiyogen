import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDsrReportIncomeSalesModel.dart';

void main() {
  group('ManagerDsrReportIncomeSalesModel', () {
    final sampleJson = {
      'DistributorId': 0,
      'IncomeId': 0,
      'TransCate': 'ARB-SV',
      'Quantity': 6.0,
      'UnsettQty': 0,
      'SettQty': 0,
      'Mode': null,
      'Amount': 5133.00,
      'ItemName': '14.2 Kg - Refill',
      'ItemId': 1,
      'Date': '0001-01-01T00:00:00',
      'Seq': 1,
    };

    test('fromJson parses all fields correctly', () {
      final model = ManagerDsrReportIncomeSalesModel.fromJson(sampleJson);
      expect(model.distributorId, 0);
      expect(model.transCate, 'ARB-SV');
      expect(model.quantity, 6.0);
      expect(model.unsettQty, 0);
      expect(model.amount, 5133.00);
      expect(model.itemName, '14.2 Kg - Refill');
      expect(model.itemId, 1);
      expect(model.seq, 1);
      expect(model.mode, isNull);
    });

    test('toJson returns correct map', () {
      final model = ManagerDsrReportIncomeSalesModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['TransCate'], 'ARB-SV');
      expect(json['Amount'], 5133.00);
      expect(json['ItemName'], '14.2 Kg - Refill');
      expect(json['Seq'], 1);
    });

    test('copyWith updates specified fields', () {
      final model = ManagerDsrReportIncomeSalesModel.fromJson(sampleJson);
      final updated = model.copyWith(amount: 10000.0, transCate: 'DailySale');
      expect(updated.amount, 10000.0);
      expect(updated.transCate, 'DailySale');
      expect(model.amount, 5133.00);
    });

    test('default constructor with null values', () {
      final model = ManagerDsrReportIncomeSalesModel();
      expect(model.amount, isNull);
      expect(model.transCate, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = ManagerDsrReportIncomeSalesModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = ManagerDsrReportIncomeSalesModel.fromJson(json);
      expect(model2.transCate, model.transCate);
      expect(model2.amount, model.amount);
      expect(model2.seq, model.seq);
    });
  });
}

