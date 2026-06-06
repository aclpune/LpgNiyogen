import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetDashSummaryAllCountForMgrModel.dart';

void main() {
  group('GetDashSummaryAllCountForMgrModel', () {
    final sampleJson = {
      'DistributorId': 8118,
      'DMCount': 3,
      'TotalAmount': 31450.00,
      'TotalIncome': 0.00,
      'TotalExp': 0.00,
      'StaffOnAccToday': 0.00,
      'StaffOnAccAsOf': 120261.00,
      'PostPaidVerifPend': 377,
      'SVPendingStk': 149,
      'TVPendingStk': 12,
      'PostPaidVerifPendAmt': 3386703.00,
      'UndocumentedSV': 78,
      'TotalCrdtOutstd': 44088453.00,
      'TotalVendorDueAmt': 145249.00,
    };

    test('fromJson parses all fields correctly', () {
      final model = GetDashSummaryAllCountForMgrModel.fromJson(sampleJson);
      expect(model.distributorId, 8118);
      expect(model.dMCount, 3);
      expect(model.totalAmount, 31450.00);
      expect(model.postPaidVerifPend, 377);
      expect(model.sVPendingStk, 149);
      expect(model.tVPendingStk, 12);
      expect(model.undocumentedSV, 78);
    });

    test('toJson returns correct map', () {
      final model = GetDashSummaryAllCountForMgrModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['DistributorId'], 8118);
      expect(json['DMCount'], 3);
      expect(json['TotalAmount'], 31450.00);
      expect(json['SVPendingStk'], 149);
    });

    test('copyWith updates specified fields', () {
      final model = GetDashSummaryAllCountForMgrModel.fromJson(sampleJson);
      final updated = model.copyWith(dMCount: 5, totalAmount: 50000.0);
      expect(updated.dMCount, 5);
      expect(updated.totalAmount, 50000.0);
      expect(model.dMCount, 3);
    });

    test('default constructor with null values', () {
      final model = GetDashSummaryAllCountForMgrModel();
      expect(model.distributorId, isNull);
      expect(model.dMCount, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetDashSummaryAllCountForMgrModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetDashSummaryAllCountForMgrModel.fromJson(json);
      expect(model2.distributorId, model.distributorId);
      expect(model2.dMCount, model.dMCount);
      expect(model2.totalAmount, model.totalAmount);
    });
  });
}

