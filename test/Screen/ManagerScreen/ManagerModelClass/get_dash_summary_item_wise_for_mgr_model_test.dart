import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetDashSummaryItemWiseForMgrModel.dart';

void main() {
  group('GetDashSummaryItemWiseForMgrModel', () {
    final sampleJson = {
      'DistributorId': 8118,
      'ItemId': 1,
      'ItemName': '14.2 KG',
      'FilledDiff': 1503,
      'EmptyDiff': 278,
      'DefectiveDiff': 6,
      'TodayImbQty': 0,
      'AsOfDateImbQty': 172,
    };

    test('fromJson parses all fields correctly', () {
      final model = GetDashSummaryItemWiseForMgrModel.fromJson(sampleJson);
      expect(model.distributorId, 8118);
      expect(model.itemId, 1);
      expect(model.itemName, '14.2 KG');
      expect(model.filledDiff, 1503);
      expect(model.emptyDiff, 278);
      expect(model.defectiveDiff, 6);
      expect(model.todayImbQty, 0);
      expect(model.asOfDateImbQty, 172);
    });

    test('toJson returns correct map', () {
      final model = GetDashSummaryItemWiseForMgrModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['ItemId'], 1);
      expect(json['ItemName'], '14.2 KG');
      expect(json['FilledDiff'], 1503);
    });

    test('copyWith updates specified fields', () {
      final model = GetDashSummaryItemWiseForMgrModel.fromJson(sampleJson);
      final updated = model.copyWith(itemName: '19 KG', filledDiff: 200);
      expect(updated.itemName, '19 KG');
      expect(updated.filledDiff, 200);
      expect(model.itemName, '14.2 KG');
    });

    test('default constructor with null values', () {
      final model = GetDashSummaryItemWiseForMgrModel();
      expect(model.itemId, isNull);
      expect(model.filledDiff, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetDashSummaryItemWiseForMgrModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetDashSummaryItemWiseForMgrModel.fromJson(json);
      expect(model2.itemId, model.itemId);
      expect(model2.filledDiff, model.filledDiff);
      expect(model2.asOfDateImbQty, model.asOfDateImbQty);
    });
  });
}

