import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DeliveryBoyModel/GetStockTransferListModel.dart';

void main() {
  group('GetStockTransferListModel', () {

    // ─── Sample valid JSON ───────────────────────────────────────────────
    final validJson = {
      'StkTransId': 3,
      'DistributorId': 8118,
      'StkTransDate': '2025-02-07T00:00:00',
      'FromGodownId': 1,
      'ToGodownId': 24,
      'ItemId': 4,
      'ItemName': '2 Kg',
      'FilledStk': 20,
      'EmptyStk': 0,
      'DefectiveStk': 0,
      'IsStkTrans': 0,
      'Remark': 'test',
      'AddedOn': '2025-02-07T09:04:32.03',
      'AddedBy': 61,
    };

    // ════════════════════════════════════════════════════════════════════
    // POSITIVE TEST CASES
    // ════════════════════════════════════════════════════════════════════

    group('Positive Tests', () {

      test('fromJson parses all fields correctly', () {
        final model = GetStockTransferListModel.fromJson(validJson);

        expect(model.stkTransId, equals(3));
        expect(model.distributorId, equals(8118));
        expect(model.stkTransDate, equals('2025-02-07T00:00:00'));
        expect(model.fromGodownId, equals(1));
        expect(model.toGodownId, equals(24));
        expect(model.itemId, equals(4));
        expect(model.itemName, equals('2 Kg'));
        expect(model.filledStk, equals(20));
        expect(model.emptyStk, equals(0));
        expect(model.defectiveStk, equals(0));
        expect(model.isStkTrans, equals(0));
        expect(model.remark, equals('test'));
        expect(model.addedOn, equals('2025-02-07T09:04:32.03'));
        expect(model.addedBy, equals(61));
      });

      test('constructor creates model with all fields', () {
        final model = GetStockTransferListModel(
          stkTransId: 3,
          distributorId: 8118,
          stkTransDate: '2025-02-07T00:00:00',
          fromGodownId: 1,
          toGodownId: 24,
          itemId: 4,
          itemName: '2 Kg',
          filledStk: 20,
          emptyStk: 0,
          defectiveStk: 0,
          isStkTrans: 0,
          remark: 'test',
          addedOn: '2025-02-07T09:04:32.03',
          addedBy: 61,
        );

        expect(model.stkTransId, equals(3));
        expect(model.itemName, equals('2 Kg'));
        expect(model.filledStk, equals(20));
      });

      test('toJson produces correct map', () {
        final model = GetStockTransferListModel.fromJson(validJson);
        final json = model.toJson();

        expect(json['StkTransId'], equals(3));
        expect(json['DistributorId'], equals(8118));
        expect(json['StkTransDate'], equals('2025-02-07T00:00:00'));
        expect(json['FromGodownId'], equals(1));
        expect(json['ToGodownId'], equals(24));
        expect(json['ItemId'], equals(4));
        expect(json['ItemName'], equals('2 Kg'));
        expect(json['FilledStk'], equals(20));
        expect(json['EmptyStk'], equals(0));
        expect(json['DefectiveStk'], equals(0));
        expect(json['IsStkTrans'], equals(0));
        expect(json['Remark'], equals('test'));
        expect(json['AddedOn'], equals('2025-02-07T09:04:32.03'));
        expect(json['AddedBy'], equals(61));
      });

      test('toJson contains all 14 expected keys', () {
        final model = GetStockTransferListModel.fromJson(validJson);
        final json = model.toJson();
        expect(json.keys.length, equals(14));
      });

      test('copyWith updates only specified fields', () {
        final original = GetStockTransferListModel.fromJson(validJson);
        final updated = original.copyWith(itemName: 'Updated Item', filledStk: 50);

        expect(updated.itemName, equals('Updated Item'));
        expect(updated.filledStk, equals(50));
        // unchanged fields
        expect(updated.stkTransId, equals(3));
        expect(updated.distributorId, equals(8118));
        expect(updated.remark, equals('test'));
      });

      test('copyWith with no arguments returns equivalent object', () {
        final original = GetStockTransferListModel.fromJson(validJson);
        final copy = original.copyWith();

        expect(copy.stkTransId, equals(original.stkTransId));
        expect(copy.itemName, equals(original.itemName));
        expect(copy.filledStk, equals(original.filledStk));
      });

      test('fromJson handles zero values correctly', () {
        final json = Map<String, dynamic>.from(validJson);
        json['EmptyStk'] = 0;
        json['DefectiveStk'] = 0;
        json['IsStkTrans'] = 0;

        final model = GetStockTransferListModel.fromJson(json);
        expect(model.emptyStk, equals(0));
        expect(model.defectiveStk, equals(0));
        expect(model.isStkTrans, equals(0));
      });

      test('fromJson handles large numeric values', () {
        final json = Map<String, dynamic>.from(validJson);
        json['FilledStk'] = 999999;
        json['DistributorId'] = 9999999;

        final model = GetStockTransferListModel.fromJson(json);
        expect(model.filledStk, equals(999999));
        expect(model.distributorId, equals(9999999));
      });

      test('fromJson handles decimal/double stock values', () {
        final json = Map<String, dynamic>.from(validJson);
        json['FilledStk'] = 20.5;

        final model = GetStockTransferListModel.fromJson(json);
        expect(model.filledStk, equals(20.5));
      });

      test('default constructor creates model with all null fields', () {
        final model = GetStockTransferListModel();
        expect(model.stkTransId, isNull);
        expect(model.distributorId, isNull);
        expect(model.stkTransDate, isNull);
        expect(model.fromGodownId, isNull);
        expect(model.toGodownId, isNull);
        expect(model.itemId, isNull);
        expect(model.itemName, isNull);
        expect(model.filledStk, isNull);
        expect(model.emptyStk, isNull);
        expect(model.defectiveStk, isNull);
        expect(model.isStkTrans, isNull);
        expect(model.remark, isNull);
        expect(model.addedOn, isNull);
        expect(model.addedBy, isNull);
      });

      test('fromJson then toJson produces identical map', () {
        final model = GetStockTransferListModel.fromJson(validJson);
        final json = model.toJson();

        expect(json['StkTransId'], equals(validJson['StkTransId']));
        expect(json['ItemName'], equals(validJson['ItemName']));
        expect(json['FilledStk'], equals(validJson['FilledStk']));
        expect(json['Remark'], equals(validJson['Remark']));
      });
    });

    // ════════════════════════════════════════════════════════════════════
    // NEGATIVE TEST CASES
    // ════════════════════════════════════════════════════════════════════

    group('Negative Tests', () {

      test('fromJson handles null values for all fields', () {
        final json = {
          'StkTransId': null,
          'DistributorId': null,
          'StkTransDate': null,
          'FromGodownId': null,
          'ToGodownId': null,
          'ItemId': null,
          'ItemName': null,
          'FilledStk': null,
          'EmptyStk': null,
          'DefectiveStk': null,
          'IsStkTrans': null,
          'Remark': null,
          'AddedOn': null,
          'AddedBy': null,
        };

        final model = GetStockTransferListModel.fromJson(json);
        expect(model.stkTransId, isNull);
        expect(model.itemName, isNull);
        expect(model.remark, isNull);
      });

      test('fromJson with missing keys results in null fields', () {
        final model = GetStockTransferListModel.fromJson({});
        expect(model.stkTransId, isNull);
        expect(model.distributorId, isNull);
        expect(model.itemName, isNull);
      });

      test('toJson includes null values when fields are null', () {
        final model = GetStockTransferListModel();
        final json = model.toJson();

        expect(json['StkTransId'], isNull);
        expect(json['ItemName'], isNull);
        expect(json['Remark'], isNull);
      });

      test('copyWith does not affect other instances', () {
        final original = GetStockTransferListModel.fromJson(validJson);
        original.copyWith(itemName: 'Changed');

        // original should remain unchanged
        expect(original.itemName, equals('2 Kg'));
      });

      test('fromJson with empty remark string', () {
        final json = Map<String, dynamic>.from(validJson);
        json['Remark'] = '';

        final model = GetStockTransferListModel.fromJson(json);
        expect(model.remark, equals(''));
      });

      test('fromJson with negative stock values', () {
        final json = Map<String, dynamic>.from(validJson);
        json['FilledStk'] = -5;
        json['EmptyStk'] = -10;

        final model = GetStockTransferListModel.fromJson(json);
        expect(model.filledStk, equals(-5));
        expect(model.emptyStk, equals(-10));
      });

      test('fromJson with invalid date string does not throw', () {
        final json = Map<String, dynamic>.from(validJson);
        json['StkTransDate'] = 'not-a-date';

        expect(() => GetStockTransferListModel.fromJson(json), returnsNormally);
        final model = GetStockTransferListModel.fromJson(json);
        expect(model.stkTransDate, equals('not-a-date'));
      });

      test('fromJson with string instead of num for IDs throws TypeError (invalid type)', () {
        final json = Map<String, dynamic>.from(validJson);
        json['StkTransId'] = '3'; // string instead of int

        expect(() => GetStockTransferListModel.fromJson(json), throwsA(isA<TypeError>()));
      });
    });
  });
}