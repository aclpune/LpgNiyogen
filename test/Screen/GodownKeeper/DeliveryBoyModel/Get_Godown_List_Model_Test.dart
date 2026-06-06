import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DeliveryBoyModel/GetGodownListModel.dart';

void main() {
  group('GetGodownListModel', () {

    // ─── Sample valid JSON ───────────────────────────────────────────────
    final validJson = {
      'GodownId': 24,
      'DistributorId': 8118,
      'DistributorCode': 0,
      'DistributorName': null,
      'GodownNo': 'GN124',
      'GodownCapacity': 5000,
      'GodownAddress': 'Pune',
      'GodownKeeperId': 0,
      'GodownKeeperName': null,
      'isActive': 1,
      'AddedBy': 0,
      'Action': null,
      'LatsUpdatedOn': '2025-02-01T05:19:12.597',
    };

    // ════════════════════════════════════════════════════════════════════
    // POSITIVE TEST CASES
    // ════════════════════════════════════════════════════════════════════

    group('Positive Tests', () {

      test('fromJson parses all fields correctly', () {
        final model = GetGodownListModel.fromJson(validJson);

        expect(model.godownId, equals(24));
        expect(model.distributorId, equals(8118));
        expect(model.distributorCode, equals(0));
        expect(model.distributorName, isNull);
        expect(model.godownNo, equals('GN124'));
        expect(model.godownCapacity, equals(5000));
        expect(model.godownAddress, equals('Pune'));
        expect(model.godownKeeperId, equals(0));
        expect(model.godownKeeperName, isNull);
        expect(model.isActive, equals(1));
        expect(model.addedBy, equals(0));
        expect(model.action, isNull);
        expect(model.latsUpdatedOn, equals('2025-02-01T05:19:12.597'));
      });

      test('constructor creates model with all provided fields', () {
        final model = GetGodownListModel(
          godownId: 24,
          distributorId: 8118,
          distributorCode: 0,
          distributorName: null,
          godownNo: 'GN124',
          godownCapacity: 5000,
          godownAddress: 'Pune',
          godownKeeperId: 0,
          godownKeeperName: null,
          isActive: 1,
          addedBy: 0,
          action: null,
          latsUpdatedOn: '2025-02-01T05:19:12.597',
        );

        expect(model.godownId, equals(24));
        expect(model.godownNo, equals('GN124'));
        expect(model.godownCapacity, equals(5000));
      });

      test('toJson produces correct map with all 13 keys', () {
        final model = GetGodownListModel.fromJson(validJson);
        final json = model.toJson();

        expect(json.keys.length, equals(13));
        expect(json['GodownId'], equals(24));
        expect(json['DistributorId'], equals(8118));
        expect(json['DistributorCode'], equals(0));
        expect(json['DistributorName'], isNull);
        expect(json['GodownNo'], equals('GN124'));
        expect(json['GodownCapacity'], equals(5000));
        expect(json['GodownAddress'], equals('Pune'));
        expect(json['GodownKeeperId'], equals(0));
        expect(json['GodownKeeperName'], isNull);
        expect(json['isActive'], equals(1));
        expect(json['AddedBy'], equals(0));
        expect(json['Action'], isNull);
        expect(json['LatsUpdatedOn'], equals('2025-02-01T05:19:12.597'));
      });

      test('copyWith updates only specified fields', () {
        final original = GetGodownListModel.fromJson(validJson);
        final updated = original.copyWith(
          godownAddress: 'Mumbai',
          godownCapacity: 10000,
          isActive: 0,
        );

        expect(updated.godownAddress, equals('Mumbai'));
        expect(updated.godownCapacity, equals(10000));
        expect(updated.isActive, equals(0));
        // unchanged
        expect(updated.godownId, equals(24));
        expect(updated.godownNo, equals('GN124'));
        expect(updated.distributorId, equals(8118));
      });

      test('copyWith with no arguments returns equivalent object', () {
        final original = GetGodownListModel.fromJson(validJson);
        final copy = original.copyWith();

        expect(copy.godownId, equals(original.godownId));
        expect(copy.godownNo, equals(original.godownNo));
        expect(copy.godownCapacity, equals(original.godownCapacity));
      });

      test('fromJson then toJson round-trip preserves values', () {
        final model = GetGodownListModel.fromJson(validJson);
        final json = model.toJson();

        expect(json['GodownId'], equals(validJson['GodownId']));
        expect(json['GodownNo'], equals(validJson['GodownNo']));
        expect(json['GodownCapacity'], equals(validJson['GodownCapacity']));
        expect(json['LatsUpdatedOn'], equals(validJson['LatsUpdatedOn']));
        expect(json['DistributorName'], equals(validJson['DistributorName']));
      });

      test('default constructor creates model with all null fields', () {
        final model = GetGodownListModel();
        expect(model.godownId, isNull);
        expect(model.distributorId, isNull);
        expect(model.distributorCode, isNull);
        expect(model.distributorName, isNull);
        expect(model.godownNo, isNull);
        expect(model.godownCapacity, isNull);
        expect(model.godownAddress, isNull);
        expect(model.godownKeeperId, isNull);
        expect(model.godownKeeperName, isNull);
        expect(model.isActive, isNull);
        expect(model.addedBy, isNull);
        expect(model.action, isNull);
        expect(model.latsUpdatedOn, isNull);
      });

      test('fromJson handles distributorName as non-null string', () {
        final json = Map<String, dynamic>.from(validJson);
        json['DistributorName'] = 'ABC Distributors';

        final model = GetGodownListModel.fromJson(json);
        expect(model.distributorName, equals('ABC Distributors'));
      });

      test('fromJson handles godownKeeperName as non-null string', () {
        final json = Map<String, dynamic>.from(validJson);
        json['GodownKeeperName'] = 'Ramesh Kumar';

        final model = GetGodownListModel.fromJson(json);
        expect(model.godownKeeperName, equals('Ramesh Kumar'));
      });

      test('fromJson handles active (1) and inactive (0) isActive', () {
        final activeJson = Map<String, dynamic>.from(validJson)
          ..['isActive'] = 1;
        final inactiveJson = Map<String, dynamic>.from(validJson)
          ..['isActive'] = 0;

        expect(GetGodownListModel.fromJson(activeJson).isActive, equals(1));
        expect(GetGodownListModel.fromJson(inactiveJson).isActive, equals(0));
      });

      test('fromJson handles large godownCapacity', () {
        final json = Map<String, dynamic>.from(validJson);
        json['GodownCapacity'] = 1000000;

        final model = GetGodownListModel.fromJson(json);
        expect(model.godownCapacity, equals(1000000));
      });

      test('copyWith can set distributorName from null to non-null', () {
        final original = GetGodownListModel.fromJson(validJson);
        final updated = original.copyWith(distributorName: 'New Distributor');

        expect(updated.distributorName, equals('New Distributor'));
        expect(original.distributorName, isNull);
      });

      // Note: 'isActive' JSON key uses lowercase 'i' — verify correct serialization
      test('toJson preserves lowercase isActive key', () {
        final model = GetGodownListModel.fromJson(validJson);
        final json = model.toJson();

        expect(json.containsKey('isActive'), isTrue);
        expect(json['isActive'], equals(1));
      });
    });

    // ════════════════════════════════════════════════════════════════════
    // NEGATIVE TEST CASES
    // ════════════════════════════════════════════════════════════════════

    group('Negative Tests', () {

      test('fromJson with all null values does not throw', () {
        final nullJson = {
          'GodownId': null, 'DistributorId': null, 'DistributorCode': null,
          'DistributorName': null, 'GodownNo': null, 'GodownCapacity': null,
          'GodownAddress': null, 'GodownKeeperId': null, 'GodownKeeperName': null,
          'isActive': null, 'AddedBy': null, 'Action': null, 'LatsUpdatedOn': null,
        };

        expect(() => GetGodownListModel.fromJson(nullJson), returnsNormally);
        final model = GetGodownListModel.fromJson(nullJson);
        expect(model.godownId, isNull);
        expect(model.isActive, isNull);
      });

      test('fromJson with empty map results in all null fields', () {
        final model = GetGodownListModel.fromJson({});
        expect(model.godownId, isNull);
        expect(model.godownNo, isNull);
        expect(model.godownCapacity, isNull);
      });

      test('toJson includes null values when fields are null', () {
        final model = GetGodownListModel();
        final json = model.toJson();

        expect(json['GodownId'], isNull);
        expect(json['DistributorName'], isNull);
        expect(json['Action'], isNull);
        expect(json['GodownKeeperName'], isNull);
      });

      test('copyWith does not mutate original instance', () {
        final original = GetGodownListModel.fromJson(validJson);
        original.copyWith(godownAddress: 'Changed', godownCapacity: 1);

        expect(original.godownAddress, equals('Pune'));
        expect(original.godownCapacity, equals(5000));
      });

      test('fromJson with negative godownCapacity stores value as-is', () {
        final json = Map<String, dynamic>.from(validJson);
        json['GodownCapacity'] = -100;

        final model = GetGodownListModel.fromJson(json);
        expect(model.godownCapacity, equals(-100));
      });

      test('fromJson with empty godownNo string', () {
        final json = Map<String, dynamic>.from(validJson);
        json['GodownNo'] = '';

        final model = GetGodownListModel.fromJson(json);
        expect(model.godownNo, equals(''));
      });

      test('fromJson with empty godownAddress string', () {
        final json = Map<String, dynamic>.from(validJson);
        json['GodownAddress'] = '';

        final model = GetGodownListModel.fromJson(json);
        expect(model.godownAddress, equals(''));
      });

      test('fromJson with invalid latsUpdatedOn date string does not throw', () {
        final json = Map<String, dynamic>.from(validJson);
        json['LatsUpdatedOn'] = 'not-a-valid-date';

        expect(() => GetGodownListModel.fromJson(json), returnsNormally);
        final model = GetGodownListModel.fromJson(json);
        expect(model.latsUpdatedOn, equals('not-a-valid-date'));
      });

      test('fromJson with string GodownId throws TypeError (invalid type)', () {
        final json = Map<String, dynamic>.from(validJson);
        json['GodownId'] = '24'; // string instead of number

        expect(() => GetGodownListModel.fromJson(json), throwsA(isA<TypeError>()));
      });

      test('fromJson with isActive as boolean throws TypeError (invalid type)', () {
        final json = Map<String, dynamic>.from(validJson);
        json['isActive'] = true;

        expect(() => GetGodownListModel.fromJson(json), throwsA(isA<TypeError>()));
      });
    });
  });
}