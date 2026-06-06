import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SVSaleModel/GetSVConsumerListForCashCollectionMode.dart';

void main() {
  group('GetSvConsumerListForCashCollectionMode', () {
    final sampleJson = {
      'DistributorId': 0,
      'pkId': 0,
      'SVTVDate': '2025-03-15T15:50:13',
      'ConsumerNo': null,
      'DCChallanNo': '3929',
      'ConsumerName': 'SUNITA SONZARI',
      'CylQty': 1,
      'StaffId': 0,
      'SaleGKId': 0,
      'SaleGKItemId': 0,
      'ConsumerNoStr': null,
      'FlagForSVTV': null,
      'AddedBy': 0,
    };

    test('constructor sets all fields correctly', () {
      final model = GetSvConsumerListForCashCollectionMode(
        distributorId: 0,
        pkId: 0,
        sVTVDate: '2025-03-15T15:50:13',
        dCChallanNo: '3929',
        consumerName: 'SUNITA SONZARI',
        cylQty: 1,
        staffId: 0,
        saleGKId: 0,
        saleGKItemId: 0,
        addedBy: 0,
      );

      expect(model.distributorId, 0);
      expect(model.pkId, 0);
      expect(model.sVTVDate, '2025-03-15T15:50:13');
      expect(model.dCChallanNo, '3929');
      expect(model.consumerName, 'SUNITA SONZARI');
      expect(model.cylQty, 1);
      expect(model.staffId, 0);
      expect(model.saleGKId, 0);
      expect(model.saleGKItemId, 0);
      expect(model.addedBy, 0);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetSvConsumerListForCashCollectionMode.fromJson(sampleJson);

      expect(model.distributorId, 0);
      expect(model.pkId, 0);
      expect(model.sVTVDate, '2025-03-15T15:50:13');
      expect(model.consumerNo, isNull);
      expect(model.dCChallanNo, '3929');
      expect(model.consumerName, 'SUNITA SONZARI');
      expect(model.cylQty, 1);
      expect(model.staffId, 0);
      expect(model.saleGKId, 0);
      expect(model.saleGKItemId, 0);
      expect(model.consumerNoStr, isNull);
      expect(model.flagForSVTV, isNull);
      expect(model.addedBy, 0);
    });

    test('toJson returns correct map', () {
      final model = GetSvConsumerListForCashCollectionMode.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['DistributorId'], 0);
      expect(json['pkId'], 0);
      expect(json['SVTVDate'], '2025-03-15T15:50:13');
      expect(json['ConsumerNo'], isNull);
      expect(json['DCChallanNo'], '3929');
      expect(json['ConsumerName'], 'SUNITA SONZARI');
      expect(json['CylQty'], 1);
      expect(json['StaffId'], 0);
      expect(json['FlagForSVTV'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = GetSvConsumerListForCashCollectionMode.fromJson(sampleJson);
      final updated = model.copyWith(consumerName: 'New Consumer', cylQty: 3);

      expect(updated.consumerName, 'New Consumer');
      expect(updated.cylQty, 3);
      expect(model.consumerName, 'SUNITA SONZARI');
      expect(model.cylQty, 1);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetSvConsumerListForCashCollectionMode.fromJson(sampleJson);
      final updated = model.copyWith(dCChallanNo: '0000');

      expect(updated.distributorId, model.distributorId);
      expect(updated.pkId, model.pkId);
      expect(updated.staffId, model.staffId);
    });

    test('constructor with null values', () {
      final model = GetSvConsumerListForCashCollectionMode();
      expect(model.distributorId, isNull);
      expect(model.consumerName, isNull);
      expect(model.cylQty, isNull);
    });
  });
}

