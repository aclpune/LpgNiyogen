import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetCurrentStockDetailManagerModel.dart';

void main() {
  group('GetCurrentStockDetailManagerModel', () {
    final sampleJson = {
      'DistributorId': 0,
      'ItemId': 1,
      'ItemName': '14.2 KG',
      'CurrentStkFilled': 0,
      'CurrentStkEmpty': 0,
      'FilledCnt': 324,
      'TotalInvoiceCnt': 324,
      'FilledEMRCnt': 0,
      'EmptyTVCnt': 0,
      'DefectivCnt': 101,
      'DefectivFromDate': '2025-03-24T00:00:00',
      'EmptyCRDCnt': 324,
      'EmptyDefectivCnt': 0,
      'NCCnt': 0,
      'DBCCnt': 0,
      'RCCnt': 0,
      'RefillSaleCnt': 826,
      'ImbalanceCnt': 0,
      'EmptyCnt': 0,
      'TVQty': 0,
      'SVQty': 6,
      'DeffQty': 101,
      'FilledOpeningStk': 2000,
      'EmptyOpeningStk': 1200,
      'DeffOpeningStk': 0,
      'FilledCurrentStk': 2112,
      'EmptyCurrentStk': 2676,
      'DeffCurrentStk': 101,
    };

    test('fromJson parses all fields correctly', () {
      final model = GetCurrentStockDetailManagerModel.fromJson(sampleJson);
      expect(model.itemId, 1);
      expect(model.itemName, '14.2 KG');
      expect(model.filledCnt, 324);
      expect(model.defectivCnt, 101);
      expect(model.sVQty, 6);
      expect(model.filledCurrentStk, 2112);
      expect(model.deffCurrentStk, 101);
    });

    test('toJson returns correct map', () {
      final model = GetCurrentStockDetailManagerModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['ItemId'], 1);
      expect(json['ItemName'], '14.2 KG');
      expect(json['FilledCnt'], 324);
      expect(json['FilledCurrentStk'], 2112);
    });

    test('copyWith updates specified fields', () {
      final model = GetCurrentStockDetailManagerModel.fromJson(sampleJson);
      final updated = model.copyWith(itemName: '19 KG', filledCurrentStk: 3000);
      expect(updated.itemName, '19 KG');
      expect(updated.filledCurrentStk, 3000);
      expect(model.itemName, '14.2 KG');
    });

    test('default constructor with null values', () {
      final model = GetCurrentStockDetailManagerModel();
      expect(model.itemId, isNull);
      expect(model.itemName, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetCurrentStockDetailManagerModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetCurrentStockDetailManagerModel.fromJson(json);
      expect(model2.itemId, model.itemId);
      expect(model2.filledCnt, model.filledCnt);
      expect(model2.filledCurrentStk, model.filledCurrentStk);
    });
  });
}

