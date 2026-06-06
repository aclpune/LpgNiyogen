import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DeliveryBoyModel/GetSVTVConsumerListModel.dart';

void main() {
  group('GetSvtvConsumerListModel', () {
    test('Constructor assigns all fields correctly', () {
      final model = GetSvtvConsumerListModel(
        distributorId: 1,
        pkId: 2,
        sVTVDate: '2025-02-13T17:47:18',
        consumerNo: '675',
        consumerName: 'Chayan',
        cylQty: 2,
        staffId: 3,
        saleGKId: 4,
        saleGKItemId: 5,
        consumerNoStr: 'CNSTR',
        pSVId: 10,
        flagForSVTV: 'flag',
        addedBy: 6,
      );
      expect(model.distributorId, 1);
      expect(model.pkId, 2);
      expect(model.sVTVDate, '2025-02-13T17:47:18');
      expect(model.consumerNo, '675');
      expect(model.consumerName, 'Chayan');
      expect(model.cylQty, 2);
      expect(model.staffId, 3);
      expect(model.saleGKId, 4);
      expect(model.saleGKItemId, 5);
      expect(model.consumerNoStr, 'CNSTR');
      expect(model.pSVId, 10);
      expect(model.flagForSVTV, 'flag');
      expect(model.addedBy, 6);
    });

    test('Constructor handles nulls', () {
      final model = GetSvtvConsumerListModel();
      expect(model.distributorId, isNull);
      expect(model.pkId, isNull);
      expect(model.sVTVDate, isNull);
      expect(model.consumerNo, isNull);
      expect(model.consumerName, isNull);
      expect(model.cylQty, isNull);
      expect(model.staffId, isNull);
      expect(model.saleGKId, isNull);
      expect(model.saleGKItemId, isNull);
      expect(model.consumerNoStr, isNull);
      expect(model.pSVId, isNull);
      expect(model.flagForSVTV, isNull);
      expect(model.addedBy, isNull);
    });

    test('fromJson assigns all fields correctly', () {
      final json = {
        'DistributorId': 1,
        'pkId': 2,
        'SVTVDate': '2025-02-13T17:47:18',
        'ConsumerNo': '675',
        'ConsumerName': 'Chayan',
        'CylQty': 2,
        'StaffId': 3,
        'SaleGKId': 4,
        'SaleGKItemId': 5,
        'ConsumerNoStr': 'CNSTR',
        'PSVId': 10,
        'FlagForSVTV': 'flag',
        'AddedBy': 6,
      };
      final model = GetSvtvConsumerListModel.fromJson(json);
      expect(model.distributorId, 1);
      expect(model.pkId, 2);
      expect(model.sVTVDate, '2025-02-13T17:47:18');
      expect(model.consumerNo, '675');
      expect(model.consumerName, 'Chayan');
      expect(model.cylQty, 2);
      expect(model.staffId, 3);
      expect(model.saleGKId, 4);
      expect(model.saleGKItemId, 5);
      expect(model.consumerNoStr, 'CNSTR');
      expect(model.pSVId, 10);
      expect(model.flagForSVTV, 'flag');
      expect(model.addedBy, 6);
    });

    test('fromJson handles missing fields', () {
      final json = {'DistributorId': 1};
      final model = GetSvtvConsumerListModel.fromJson(json);
      expect(model.distributorId, 1);
      expect(model.pkId, isNull);
      expect(model.sVTVDate, isNull);
    });

    test('fromJson handles null input', () {
      final model = GetSvtvConsumerListModel.fromJson({});
      expect(model.distributorId, isNull);
      expect(model.pkId, isNull);
      expect(model.sVTVDate, isNull);
    });

    test('toJson outputs correct map', () {
      final model = GetSvtvConsumerListModel(
        distributorId: 1,
        pkId: 2,
        sVTVDate: '2025-02-13T17:47:18',
        consumerNo: '675',
        consumerName: 'Chayan',
        cylQty: 2,
        staffId: 3,
        saleGKId: 4,
        saleGKItemId: 5,
        consumerNoStr: 'CNSTR',
        pSVId: 10,
        flagForSVTV: 'flag',
        addedBy: 6,
      );
      final json = model.toJson();
      expect(json['DistributorId'], 1);
      expect(json['pkId'], 2);
      expect(json['SVTVDate'], '2025-02-13T17:47:18');
      expect(json['ConsumerNo'], '675');
      expect(json['ConsumerName'], 'Chayan');
      expect(json['CylQty'], 2);
      expect(json['StaffId'], 3);
      expect(json['SaleGKId'], 4);
      expect(json['SaleGKItemId'], 5);
      expect(json['ConsumerNoStr'], 'CNSTR');
      expect(json['PSVId'], 10);
      expect(json['FlagForSVTV'], 'flag');
      expect(json['AddedBy'], 6);
    });

    test('toJson handles nulls', () {
      final model = GetSvtvConsumerListModel();
      final json = model.toJson();
      expect(json['DistributorId'], isNull);
      expect(json['pkId'], isNull);
      expect(json['SVTVDate'], isNull);
    });

    test('copyWith copies all fields', () {
      final model = GetSvtvConsumerListModel(distributorId: 1, consumerNo: 'A');
      final copy = model.copyWith();
      expect(copy.distributorId, 1);
      expect(copy.consumerNo, 'A');
    });

    test('copyWith overrides fields', () {
      final model = GetSvtvConsumerListModel(distributorId: 1, consumerNo: 'A');
      final copy = model.copyWith(distributorId: 2, consumerNo: 'B');
      expect(copy.distributorId, 2);
      expect(copy.consumerNo, 'B');
    });

    test('fromJson with invalid types throws TypeError for numeric fields', () {
      final json = {
        'DistributorId': 'not a number',
        'ConsumerNo': 123,
        'CylQty': 'two',
        'FlagForSVTV': 1,
      };

      // numeric fields (DistributorId, CylQty) are strictly typed to num? in model
      expect(() => GetSvtvConsumerListModel.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}


