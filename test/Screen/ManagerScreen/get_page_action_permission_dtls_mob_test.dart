import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/GetPageActionPermissionDtlsMob.dart';

void main() {
  group('GetPageActionPermissionDtlsMob', () {
    final sampleJson = {
      'pkId': 15,
      'DistributorId': 8118,
      'PageName': '',
      'PermissionFor': 'InvoicePrint',
      'DescriptionText': null,
      'IsActive': 0,
      'ActiveDate': '2026-02-16T12:34:50.21',
      'Action': null,
      'AddedOn': '2026-02-16T12:34:50.21',
      'LastUpdatedOn': '0001-01-01T00:00:00',
      'ItemId': 0,
      'ItemName': '',
      'Discount': 0.00,
      'InvoiceType': '',
      'FromInvoiceNo': '',
    };

    test('constructor sets all fields correctly', () {
      final model = GetPageActionPermissionDtlsMob(
        pkId: 15,
        distributorId: 8118,
        pageName: '',
        permissionFor: 'InvoicePrint',
        descriptionText: null,
        isActive: 0,
        activeDate: '2026-02-16T12:34:50.21',
        action: null,
        addedOn: '2026-02-16T12:34:50.21',
        lastUpdatedOn: '0001-01-01T00:00:00',
        itemId: 0,
        itemName: '',
        discount: 0.0,
        invoiceType: '',
        fromInvoiceNo: '',
      );

      expect(model.pkId, 15);
      expect(model.distributorId, 8118);
      expect(model.permissionFor, 'InvoicePrint');
      expect(model.isActive, 0);
      expect(model.discount, 0.0);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetPageActionPermissionDtlsMob.fromJson(sampleJson);

      expect(model.pkId, 15);
      expect(model.distributorId, 8118);
      expect(model.pageName, '');
      expect(model.permissionFor, 'InvoicePrint');
      expect(model.descriptionText, isNull);
      expect(model.isActive, 0);
      expect(model.activeDate, '2026-02-16T12:34:50.21');
      expect(model.action, isNull);
      expect(model.addedOn, '2026-02-16T12:34:50.21');
      expect(model.lastUpdatedOn, '0001-01-01T00:00:00');
      expect(model.itemId, 0);
      expect(model.itemName, '');
      expect(model.discount, 0.00);
      expect(model.invoiceType, '');
      expect(model.fromInvoiceNo, '');
    });

    test('toJson returns correct map', () {
      final model = GetPageActionPermissionDtlsMob.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['pkId'], 15);
      expect(json['DistributorId'], 8118);
      expect(json['PermissionFor'], 'InvoicePrint');
      expect(json['IsActive'], 0);
      expect(json['Discount'], 0.00);
      expect(json['DescriptionText'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = GetPageActionPermissionDtlsMob.fromJson(sampleJson);
      final updated = model.copyWith(permissionFor: 'InvoiceManual', isActive: 1);

      expect(updated.permissionFor, 'InvoiceManual');
      expect(updated.isActive, 1);
      expect(updated.distributorId, model.distributorId);
      expect(model.permissionFor, 'InvoicePrint');
    });

    test('copyWith preserves values when not overridden', () {
      final model = GetPageActionPermissionDtlsMob.fromJson(sampleJson);
      final updated = model.copyWith();

      expect(updated.pkId, model.pkId);
      expect(updated.permissionFor, model.permissionFor);
      expect(updated.discount, model.discount);
    });

    test('default constructor leaves values null', () {
      final model = GetPageActionPermissionDtlsMob();

      expect(model.pkId, isNull);
      expect(model.permissionFor, isNull);
      expect(model.isActive, isNull);
      expect(model.discount, isNull);
    });

    test('fromJson toJson roundtrip remains consistent', () {
      final model = GetPageActionPermissionDtlsMob.fromJson(sampleJson);
      final roundTrip = GetPageActionPermissionDtlsMob.fromJson(model.toJson());

      expect(roundTrip.pkId, model.pkId);
      expect(roundTrip.permissionFor, model.permissionFor);
      expect(roundTrip.isActive, model.isActive);
      expect(roundTrip.discount, model.discount);
    });
  });
}

