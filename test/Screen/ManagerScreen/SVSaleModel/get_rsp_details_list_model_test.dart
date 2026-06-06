import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SVSaleModel/GetRSPDetailsListModel.dart';

void main() {
  group('GetRspDetailsListModel', () {
    final sampleJson = {
      'RSPId': 121,
      'DistributorId': 8118,
      'ItemId': 4,
      'ItemName': '5 KG FTL',
      'RSP_Price': 536.0,
      'DepositAmt': 1100.0,
      'EffectiveDate': '0001-01-01T00:00:00',
      'EffectiveDate1': '16-04-2025',
      'AddedBy': 0,
      'Action': null,
    };

    test('constructor sets all fields correctly', () {
      final model = GetRspDetailsListModel(
        rSPId: 121,
        distributorId: 8118,
        itemId: 4,
        itemName: '5 KG FTL',
        rSPPrice: 536.0,
        depositAmt: 1100.0,
        effectiveDate: '0001-01-01T00:00:00',
        effectiveDate1: '16-04-2025',
        addedBy: 0,
      );

      expect(model.rSPId, 121);
      expect(model.distributorId, 8118);
      expect(model.itemId, 4);
      expect(model.itemName, '5 KG FTL');
      expect(model.rSPPrice, 536.0);
      expect(model.depositAmt, 1100.0);
      expect(model.effectiveDate, '0001-01-01T00:00:00');
      expect(model.effectiveDate1, '16-04-2025');
      expect(model.addedBy, 0);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetRspDetailsListModel.fromJson(sampleJson);

      expect(model.rSPId, 121);
      expect(model.distributorId, 8118);
      expect(model.itemId, 4);
      expect(model.itemName, '5 KG FTL');
      expect(model.rSPPrice, 536.0);
      expect(model.depositAmt, 1100.0);
      expect(model.effectiveDate, '0001-01-01T00:00:00');
      expect(model.effectiveDate1, '16-04-2025');
      expect(model.addedBy, 0);
      expect(model.action, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetRspDetailsListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['RSPId'], 121);
      expect(json['DistributorId'], 8118);
      expect(json['ItemId'], 4);
      expect(json['ItemName'], '5 KG FTL');
      expect(json['RSP_Price'], 536.0);
      expect(json['DepositAmt'], 1100.0);
      expect(json['EffectiveDate'], '0001-01-01T00:00:00');
      expect(json['EffectiveDate1'], '16-04-2025');
      expect(json['AddedBy'], 0);
      expect(json['Action'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = GetRspDetailsListModel.fromJson(sampleJson);
      final updated = model.copyWith(rSPPrice: 600.0, depositAmt: 1200.0);

      expect(updated.rSPPrice, 600.0);
      expect(updated.depositAmt, 1200.0);
      expect(model.rSPPrice, 536.0);
      expect(model.depositAmt, 1100.0);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetRspDetailsListModel.fromJson(sampleJson);
      final updated = model.copyWith(itemName: 'New Item');

      expect(updated.rSPId, model.rSPId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.effectiveDate1, model.effectiveDate1);
    });

    test('constructor with null values', () {
      final model = GetRspDetailsListModel();
      expect(model.rSPId, isNull);
      expect(model.itemName, isNull);
      expect(model.rSPPrice, isNull);
    });
  });
}

