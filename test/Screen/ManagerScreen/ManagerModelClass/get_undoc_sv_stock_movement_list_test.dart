import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetUndocSVStockMovementList.dart';

void main() {
  group('GetUndocSvStockMovementList', () {
    final sampleJson = {
      'PSVId': 515,
      'DistributorId': 8118,
      'SVDate': '2025-04-04T15:51:34',
      'SVType': 'NC',
      'ProductId': 1,
      'ItemName': '14.2 KG',
      'ItemId': 0,
      'IsUndocument': true,
      'ConsuDCNo': '648',
      'ConsumerName': 'Pete Shrikant',
      'CylQty': 2,
      'SCRegulator': 1,
      'TotalAmount': 7040.00,
      'AmtCharges': 0.00,
      'AddedOn': '2025-04-04T16:06:51.557',
      'DMId': 0,
      'StockStatus': null,
      'GodownId': 0,
      'GodownNo': null,
      'ReceiptDate': null,
      'UndocSVDetails': null,
      'InvoiceNo': null,
    };

    test('fromJson parses all fields correctly', () {
      final model = GetUndocSvStockMovementList.fromJson(sampleJson);
      expect(model.pSVId, 515);
      expect(model.distributorId, 8118);
      expect(model.sVDate, '2025-04-04T15:51:34');
      expect(model.sVType, 'NC');
      expect(model.itemName, '14.2 KG');
      expect(model.isUndocument, true);
      expect(model.consumerName, 'Pete Shrikant');
      expect(model.cylQty, 2);
      expect(model.totalAmount, 7040.00);
      expect(model.stockStatus, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetUndocSvStockMovementList.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['PSVId'], 515);
      expect(json['SVType'], 'NC');
      expect(json['IsUndocument'], true);
      expect(json['TotalAmount'], 7040.00);
      expect(json['StockStatus'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = GetUndocSvStockMovementList.fromJson(sampleJson);
      final updated = model.copyWith(consumerName: 'New Name', cylQty: 5);
      expect(updated.consumerName, 'New Name');
      expect(updated.cylQty, 5);
      expect(model.consumerName, 'Pete Shrikant');
    });

    test('isUndocument bool field is preserved', () {
      final model = GetUndocSvStockMovementList.fromJson(sampleJson);
      expect(model.isUndocument, isA<bool>());
      expect(model.isUndocument, isTrue);
    });

    test('default constructor with null values', () {
      final model = GetUndocSvStockMovementList();
      expect(model.pSVId, isNull);
      expect(model.isUndocument, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetUndocSvStockMovementList.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetUndocSvStockMovementList.fromJson(json);
      expect(model2.pSVId, model.pSVId);
      expect(model2.sVType, model.sVType);
      expect(model2.totalAmount, model.totalAmount);
      expect(model2.isUndocument, model.isUndocument);
    });
  });
}

