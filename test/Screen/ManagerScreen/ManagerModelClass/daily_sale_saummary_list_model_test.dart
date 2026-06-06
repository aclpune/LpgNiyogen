import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/DailySaleSaummaryListModel.dart';

void main() {
  group('DailySaleSaummaryListModel', () {
    final sampleJson = {
      'pkId': 0,
      'DMId': 22,
      'DistributorId': 8118,
      'SaleGKId': 171,
      'VehicleId': 10,
      'VehicleNo': 'MH49KL7474',
      'ItemCount': 1,
      'StaffName': 'Rahul',
      'TotalSVQty': 0,
      'TotalSVAmt': 0.0,
      'TotalTVQty': 0,
      'TotalTVAmt': 0,
      'TotalFilledQty': 43,
      'TotalActualSaleQty': 43,
      'TotalFilledAmt': 0,
      'TotalDefQty': 0,
      'TotalAmt': 34636.50,
      'PrepaidAmt': 0.00,
      'PrepaidQty': 0,
      'PostPaidAmt': 0.00,
      'PostPaidQty': 0,
      'RetiCrAmt': 0.00,
      'RetiCrQty': 0,
      'CashAmt': 0.00,
      'CashQty': 0,
      'Status': null,
      'StatusStr': 'Accepted',
      'DailySaleStatus': 2,
      'TotRecievedcAmt': 0.00,
      'DelDate': '2025-04-07T00:00:00',
      'Action': null,
      'AddedBy': 0,
      'DSCollMgrId': 0,
    };

    test('fromJson parses all fields correctly', () {
      final model = DailySaleSaummaryListModel.fromJson(sampleJson);
      expect(model.dMId, 22);
      expect(model.distributorId, 8118);
      expect(model.staffName, 'Rahul');
      expect(model.totalFilledQty, 43);
      expect(model.totalAmt, 34636.50);
      expect(model.statusStr, 'Accepted');
      expect(model.dailySaleStatus, 2);
      expect(model.status, isNull);
    });

    test('toJson returns correct map', () {
      final model = DailySaleSaummaryListModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['DMId'], 22);
      expect(json['StaffName'], 'Rahul');
      expect(json['TotalFilledQty'], 43);
      expect(json['TotalAmt'], 34636.50);
      expect(json['StatusStr'], 'Accepted');
    });

    test('copyWith updates specified fields', () {
      final model = DailySaleSaummaryListModel.fromJson(sampleJson);
      final updated = model.copyWith(staffName: 'New Staff', totalAmt: 50000.0);
      expect(updated.staffName, 'New Staff');
      expect(updated.totalAmt, 50000.0);
      expect(model.staffName, 'Rahul');
    });

    test('copyWith preserves non-updated fields', () {
      final model = DailySaleSaummaryListModel.fromJson(sampleJson);
      final updated = model.copyWith(dailySaleStatus: 3);
      expect(updated.dMId, model.dMId);
      expect(updated.distributorId, model.distributorId);
    });

    test('default constructor with null values', () {
      final model = DailySaleSaummaryListModel();
      expect(model.dMId, isNull);
      expect(model.staffName, isNull);
      expect(model.totalAmt, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = DailySaleSaummaryListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = DailySaleSaummaryListModel.fromJson(json);
      expect(model2.dMId, model.dMId);
      expect(model2.staffName, model.staffName);
      expect(model2.totalAmt, model.totalAmt);
      expect(model2.dailySaleStatus, model.dailySaleStatus);
    });
  });
}

