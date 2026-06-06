import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/UpdatePaymentsScreen/GetCashHandOverDtlsListModel.dart';

void main() {
  group('GetCashHandOverDtlsListModel', () {
    final sampleJson = {
      'HandoverId': 0,
      'DistributorId': 8118,
      'TotalAmount': 0.0,
      'HandoverFromId': null,
      'HandoverToType': 0,
      'IsCashHandover': 0,
      'AddedBy': 0,
      'DenomDtList': null,
      'HandoverDate': '0001-01-01T00:00:00',
      'Date': null,
      'StaffId': 4,
      'StaffName': 'Shamika Joshi',
      'CollAmt': 36192.00,
      'PaidAmt': 0.00,
      'CashCollDate': '2025-05-22T00:00:00',
      'HandoverToId': 0,
      'HandoverAmt': null,
      'TotalAmt': 36192.00,
      'AcceptedById': 0,
      'HandoverStatus': 0,
      'TotalHandoverAmt': 0.0,
    };

    test('constructor sets all fields correctly', () {
      final model = GetCashHandOverDtlsListModel(
        handoverId: 0,
        distributorId: 8118,
        totalAmount: 0.0,
        handoverToType: 0,
        isCashHandover: 0,
        addedBy: 0,
        handoverDate: '0001-01-01T00:00:00',
        staffId: 4,
        staffName: 'Shamika Joshi',
        collAmt: 36192.00,
        paidAmt: 0.00,
        cashCollDate: '2025-05-22T00:00:00',
        handoverToId: 0,
        totalAmt: 36192.00,
        acceptedById: 0,
        handoverStatus: 0,
        totalHandoverAmt: 0.0,
      );

      expect(model.handoverId, 0);
      expect(model.distributorId, 8118);
      expect(model.staffId, 4);
      expect(model.staffName, 'Shamika Joshi');
      expect(model.collAmt, 36192.00);
      expect(model.totalAmt, 36192.00);
      expect(model.handoverStatus, 0);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetCashHandOverDtlsListModel.fromJson(sampleJson);

      expect(model.handoverId, 0);
      expect(model.distributorId, 8118);
      expect(model.totalAmount, 0.0);
      expect(model.handoverFromId, isNull);
      expect(model.handoverToType, 0);
      expect(model.isCashHandover, 0);
      expect(model.addedBy, 0);
      expect(model.denomDtList, isNull);
      expect(model.handoverDate, '0001-01-01T00:00:00');
      expect(model.date, isNull);
      expect(model.staffId, 4);
      expect(model.staffName, 'Shamika Joshi');
      expect(model.collAmt, 36192.00);
      expect(model.paidAmt, 0.00);
      expect(model.cashCollDate, '2025-05-22T00:00:00');
      expect(model.handoverToId, 0);
      expect(model.handoverAmt, isNull);
      expect(model.totalAmt, 36192.00);
      expect(model.acceptedById, 0);
      expect(model.handoverStatus, 0);
      expect(model.totalHandoverAmt, 0.0);
    });

    test('toJson returns correct map', () {
      final model = GetCashHandOverDtlsListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['HandoverId'], 0);
      expect(json['DistributorId'], 8118);
      expect(json['StaffId'], 4);
      expect(json['StaffName'], 'Shamika Joshi');
      expect(json['CollAmt'], 36192.00);
      expect(json['TotalAmt'], 36192.00);
      expect(json['HandoverStatus'], 0);
      expect(json['HandoverFromId'], isNull);
    });

    test('toJson includes all keys', () {
      final model = GetCashHandOverDtlsListModel.fromJson(sampleJson);
      final json = model.toJson();

      final expectedKeys = [
        'HandoverId', 'DistributorId', 'TotalAmount', 'HandoverFromId',
        'HandoverToType', 'IsCashHandover', 'AddedBy', 'DenomDtList',
        'HandoverDate', 'Date', 'StaffId', 'StaffName', 'CollAmt', 'PaidAmt',
        'CashCollDate', 'HandoverToId', 'HandoverAmt', 'TotalAmt',
        'AcceptedById', 'HandoverStatus', 'TotalHandoverAmt',
      ];
      for (final key in expectedKeys) {
        expect(json.containsKey(key), isTrue, reason: 'Missing key: $key');
      }
    });

    test('copyWith updates specified fields', () {
      final model = GetCashHandOverDtlsListModel.fromJson(sampleJson);
      final updated = model.copyWith(staffName: 'New Staff', paidAmt: 5000.0);

      expect(updated.staffName, 'New Staff');
      expect(updated.paidAmt, 5000.0);
      expect(model.staffName, 'Shamika Joshi');
      expect(model.paidAmt, 0.0);
    });

    test('copyWith preserves non-updated fields', () {
      final model = GetCashHandOverDtlsListModel.fromJson(sampleJson);
      final updated = model.copyWith(handoverStatus: 1);

      expect(updated.staffId, model.staffId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.collAmt, model.collAmt);
      expect(updated.handoverStatus, 1);
    });

    test('default constructor with null values', () {
      final model = GetCashHandOverDtlsListModel();

      expect(model.handoverId, isNull);
      expect(model.staffId, isNull);
      expect(model.collAmt, isNull);
      expect(model.totalAmt, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetCashHandOverDtlsListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetCashHandOverDtlsListModel.fromJson(json);

      expect(model2.handoverId, model.handoverId);
      expect(model2.staffName, model.staffName);
      expect(model2.collAmt, model.collAmt);
      expect(model2.totalAmt, model.totalAmt);
      expect(model2.handoverStatus, model.handoverStatus);
    });
  });
}

