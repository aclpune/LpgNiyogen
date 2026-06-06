import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/CashDenominationMandatoryFlag/CahsDenominationMandatoryFlagModel.dart';

void main() {
  final fullJson = {
    'pkId': 14, 'DistributorId': 8118, 'PageName': '',
    'PermissionFor': 'Invoice Number', 'DescriptionText': null,
    'IsActive': 0, 'ActiveDate': '2026-01-30T16:10:04.84',
    'Action': null, 'AddedOn': '2026-01-30T16:10:04.84',
    'LastUpdatedOn': '2026-02-02T15:45:10.617',
    'ItemId': 0, 'ItemName': '', 'Discount': 0.00,
    'InvoiceType': 'Auto', 'FromInvoiceNo': '11',
  };

  group('CahsDenominationMandatoryFlagModel.fromJson', () {
    test('parses all fields', () {
      final m = CahsDenominationMandatoryFlagModel.fromJson(fullJson);
      expect(m.pkId, 14); expect(m.distributorId, 8118);
      expect(m.permissionFor, 'Invoice Number');
      expect(m.isActive, 0); expect(m.invoiceType, 'Auto');
      expect(m.fromInvoiceNo, '11'); expect(m.discount, 0.00);
    });
    test('handles empty JSON', () {
      final m = CahsDenominationMandatoryFlagModel.fromJson({});
      expect(m.pkId, isNull); expect(m.invoiceType, isNull);
    });
  });

  group('CahsDenominationMandatoryFlagModel.toJson', () {
    test('serialises 15 fields', () {
      expect(CahsDenominationMandatoryFlagModel.fromJson(fullJson).toJson().length, 15);
    });
    test('round-trips correctly', () {
      final o = CahsDenominationMandatoryFlagModel.fromJson(fullJson);
      final r = CahsDenominationMandatoryFlagModel.fromJson(o.toJson());
      expect(r.pkId, o.pkId); expect(r.invoiceType, o.invoiceType);
    });
  });

  group('CahsDenominationMandatoryFlagModel.copyWith', () {
    test('replaces isActive', () {
      final m = CahsDenominationMandatoryFlagModel.fromJson(fullJson);
      expect(m.copyWith(isActive: 1).isActive, 1);
    });
    test('replaces invoiceType', () {
      final m = CahsDenominationMandatoryFlagModel.fromJson(fullJson);
      expect(m.copyWith(invoiceType: 'Manual').invoiceType, 'Manual');
    });
    test('preserves all without args', () {
      final m = CahsDenominationMandatoryFlagModel.fromJson(fullJson);
      expect(m.copyWith().permissionFor, m.permissionFor);
    });
  });

  group('DenominationFlag – business logic', () {
    test('isActive 0 means feature inactive', () {
      expect(CahsDenominationMandatoryFlagModel.fromJson(fullJson).isActive, 0);
    });
    test('discount is non-negative', () {
      final m = CahsDenominationMandatoryFlagModel.fromJson(fullJson);
      expect((m.discount ?? 0) >= 0, isTrue);
    });
    test('invoiceType is Auto or Manual', () {
      final m = CahsDenominationMandatoryFlagModel.fromJson(fullJson);
      expect(['Auto', 'Manual'].contains(m.invoiceType), isTrue);
    });
    test('fromInvoiceNo is numeric', () {
      final m = CahsDenominationMandatoryFlagModel.fromJson(fullJson);
      expect(int.tryParse(m.fromInvoiceNo ?? ''), isNotNull);
    });
  });
}

