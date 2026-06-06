import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/UpdatePaymentsScreen/GetVendorMasterListModel.dart';

void main() {
  group('GetVendorMasterListModel', () {
    final sampleJson = {
      'DistributorId': 8118,
      'VendorId': 27,
      'VendorName': 'vendor1',
      'ContactNumber': '9999999999',
      'IsActive': 1,
      'AddedBy': 0,
      'Action': null,
    };

    test('constructor sets all fields correctly', () {
      final model = GetVendorMasterListModel(
        distributorId: 8118,
        vendorId: 27,
        vendorName: 'vendor1',
        contactNumber: '9999999999',
        isActive: 1,
        addedBy: 0,
        action: null,
      );

      expect(model.distributorId, 8118);
      expect(model.vendorId, 27);
      expect(model.vendorName, 'vendor1');
      expect(model.contactNumber, '9999999999');
      expect(model.isActive, 1);
      expect(model.addedBy, 0);
      expect(model.action, isNull);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetVendorMasterListModel.fromJson(sampleJson);

      expect(model.distributorId, 8118);
      expect(model.vendorId, 27);
      expect(model.vendorName, 'vendor1');
      expect(model.contactNumber, '9999999999');
      expect(model.isActive, 1);
      expect(model.addedBy, 0);
      expect(model.action, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetVendorMasterListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['DistributorId'], 8118);
      expect(json['VendorId'], 27);
      expect(json['VendorName'], 'vendor1');
      expect(json['ContactNumber'], '9999999999');
      expect(json['IsActive'], 1);
      expect(json['AddedBy'], 0);
      expect(json['Action'], isNull);
    });

    test('toJson includes all keys', () {
      final model = GetVendorMasterListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json.containsKey('DistributorId'), isTrue);
      expect(json.containsKey('VendorId'), isTrue);
      expect(json.containsKey('VendorName'), isTrue);
      expect(json.containsKey('ContactNumber'), isTrue);
      expect(json.containsKey('IsActive'), isTrue);
      expect(json.containsKey('AddedBy'), isTrue);
      expect(json.containsKey('Action'), isTrue);
    });

    test('copyWith updates specified fields', () {
      final model = GetVendorMasterListModel.fromJson(sampleJson);
      final updated = model.copyWith(vendorName: 'Updated Vendor', isActive: 0);

      expect(updated.vendorName, 'Updated Vendor');
      expect(updated.isActive, 0);
      expect(model.vendorName, 'vendor1');
      expect(model.isActive, 1);
    });

    test('copyWith preserves non-updated fields', () {
      final model = GetVendorMasterListModel.fromJson(sampleJson);
      final updated = model.copyWith(contactNumber: '8888888888');

      expect(updated.distributorId, model.distributorId);
      expect(updated.vendorId, model.vendorId);
      expect(updated.vendorName, model.vendorName);
      expect(updated.contactNumber, '8888888888');
    });

    test('default constructor with null values', () {
      final model = GetVendorMasterListModel();

      expect(model.vendorId, isNull);
      expect(model.vendorName, isNull);
      expect(model.contactNumber, isNull);
      expect(model.isActive, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetVendorMasterListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetVendorMasterListModel.fromJson(json);

      expect(model2.distributorId, model.distributorId);
      expect(model2.vendorId, model.vendorId);
      expect(model2.vendorName, model.vendorName);
      expect(model2.contactNumber, model.contactNumber);
      expect(model2.isActive, model.isActive);
    });

    test('isActive flag correctly reflects status', () {
      final activeModel = GetVendorMasterListModel.fromJson(sampleJson);
      expect(activeModel.isActive, 1);

      final inactiveModel = GetVendorMasterListModel.fromJson({
        ...sampleJson,
        'IsActive': 0,
      });
      expect(inactiveModel.isActive, 0);
    });

    test('contactNumber is stored as string', () {
      final model = GetVendorMasterListModel.fromJson(sampleJson);
      expect(model.contactNumber, isA<String>());
      expect(model.contactNumber!.length, 10);
    });
  });
}

