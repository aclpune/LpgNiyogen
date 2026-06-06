import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/RSPAmountOFItemListModel.dart';

void main() {
  group('RspAmountOfItemListModel', () {
    final sampleJson = {
      'RSPId': 12,
      'DistributorId': 8118,
      'ItemId': 5,
      'ItemName': 'Regulator',
      'RSP_Price': 0.00,
      'DepositAmt': 2200,
      'EffectiveDate': '0001-01-01T00:00:00',
      'EffectiveDate1': '20-12-2024',
      'AddedBy': 0,
      'Action': null,
    };

    test('fromJson parses all fields correctly', () {
      final model = RspAmountOfItemListModel.fromJson(sampleJson);
      expect(model.rSPId, 12);
      expect(model.distributorId, 8118);
      expect(model.itemId, 5);
      expect(model.itemName, 'Regulator');
      expect(model.rSPPrice, 0.00);
      expect(model.depositAmt, 2200);
      expect(model.effectiveDate1, '20-12-2024');
      expect(model.action, isNull);
    });

    test('toJson returns correct map', () {
      final model = RspAmountOfItemListModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['RSPId'], 12);
      expect(json['ItemName'], 'Regulator');
      expect(json['DepositAmt'], 2200);
      expect(json['Action'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = RspAmountOfItemListModel.fromJson(sampleJson);
      final updated = model.copyWith(depositAmt: 3000, itemName: 'Updated');
      expect(updated.depositAmt, 3000);
      expect(updated.itemName, 'Updated');
      expect(model.depositAmt, 2200);
    });

    test('default constructor with null values', () {
      final model = RspAmountOfItemListModel();
      expect(model.rSPId, isNull);
      expect(model.depositAmt, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = RspAmountOfItemListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = RspAmountOfItemListModel.fromJson(json);
      expect(model2.rSPId, model.rSPId);
      expect(model2.itemName, model.itemName);
      expect(model2.depositAmt, model.depositAmt);
    });
  });
}

