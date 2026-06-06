import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDSRReportCDCMSListModel.dart';

void main() {
  group('ManagerDsrReportCdcmsListModel', () {
    final sampleJson = {
      'DistributorId': 8118,
      'GodownId': 0,
      'Date': '0001-01-01T00:00:00',
      'ItemId': 1,
      'ItemName': '14.2 KG',
      'Action': null,
      'AddedBy': 0,
      'CurrentStkFilled': 1545,
      'CurrentStkEmpty': 2146,
      'StkUpdateDate': '0001-01-01T00:00:00',
      'CurrentStkDefective': 4,
      'FilledCD': 1547,
      'EmptyCD': 1545,
      'DefectiveCD': 4,
      'FilledDiff': -2,
      'EmptyDiff': 601,
      'DefectiveDiff': 0,
      'Total': 599,
      'StockUpdatedOn': '17/02/2025 17:13',
      'StkRecoId': 0,
    };

    test('fromJson parses all fields correctly', () {
      final model = ManagerDsrReportCdcmsListModel.fromJson(sampleJson);
      expect(model.distributorId, 8118);
      expect(model.itemId, 1);
      expect(model.itemName, '14.2 KG');
      expect(model.currentStkFilled, 1545);
      expect(model.filledDiff, -2);
      expect(model.emptyDiff, 601);
      expect(model.total, 599);
      expect(model.action, isNull);
    });

    test('toJson returns correct map', () {
      final model = ManagerDsrReportCdcmsListModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['ItemName'], '14.2 KG');
      expect(json['CurrentStkFilled'], 1545);
      expect(json['FilledDiff'], -2);
      expect(json['Total'], 599);
    });

    test('copyWith updates specified fields', () {
      final model = ManagerDsrReportCdcmsListModel.fromJson(sampleJson);
      final updated = model.copyWith(itemName: '19 KG', total: 1000);
      expect(updated.itemName, '19 KG');
      expect(updated.total, 1000);
      expect(model.itemName, '14.2 KG');
    });

    test('negative diff values are preserved', () {
      final model = ManagerDsrReportCdcmsListModel.fromJson(sampleJson);
      expect(model.filledDiff, isNegative);
    });

    test('default constructor with null values', () {
      final model = ManagerDsrReportCdcmsListModel();
      expect(model.itemId, isNull);
      expect(model.total, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = ManagerDsrReportCdcmsListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = ManagerDsrReportCdcmsListModel.fromJson(json);
      expect(model2.itemId, model.itemId);
      expect(model2.filledDiff, model.filledDiff);
      expect(model2.total, model.total);
    });
  });
}

