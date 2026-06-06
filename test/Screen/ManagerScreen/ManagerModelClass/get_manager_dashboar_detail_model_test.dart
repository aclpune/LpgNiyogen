import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetManagerDashboarDetailModel.dart';

void main() {
  group('GetManagerDashboarDetailModel', () {
    final sampleJson = {
      'DistributorId': 8118,
      'ItemId': 1,
      'ItemName': '14.2 KG',
      'FilledDiff': 0,
      'EmptyDiff': 0,
      'DefectiveDiff': 0,
      'TodayImbQty': 0,
      'AsOfDateImbQty': 135,
      'DMCount': 12,
      'TotalAmount': 263874.00,
      'TotalIncome': 0.00,
      'TotalExp': 3433.00,
      'StaffOnAccToday': 0.00,
      'StaffOnAccAsOf': 6838996.00,
      'cDCMSPunPend': 103,
      'PaymtDoneBtDelPend': 40,
      'DelDoneBtPaymtPend': 106,
      'NiyojanPun': 0,
      'NiyojanDuplicate': 0,
      'DelDonNiyoJanPunPend': 1715,
      'NiyoJanPunDelPend': 0,
      'OldBkgPendNewBkgRecv': 383,
      'SettlementPendSince': '2025-04-29T01:00:00',
      'cDCMDPendSince': '2025-05-27T01:00:00',
      'PostPaidVerifPend': 260,
      'SVPendingStk': 61,
      'TVPendingStk': 1,
      'PaymtDoneBtDelPendAmt': 34220.00,
      'DelDoneBtPaymtPendAmt': 90683.00,
      'PostPaidVerifPendAmt': 2982453.50,
      'TotalPendingSettCnt': 169,
      'TotalPendingSettAmt': 144579.50,
      'TotalPendingSettSince': '2025-04-29T01:00:00',
      'UndocumentedSV': 78,
      'TotalCrdtOutstd': 44088453.00,
    };

    test('fromJson parses key fields correctly', () {
      final model = GetManagerDashboarDetailModel.fromJson(sampleJson);
      expect(model.distributorId, 8118);
      expect(model.itemId, 1);
      expect(model.itemName, '14.2 KG');
      expect(model.dMCount, 12);
      expect(model.totalAmount, 263874.00);
      expect(model.postPaidVerifPend, 260);
      expect(model.sVPendingStk, 61);
    });

    test('toJson returns correct map', () {
      final model = GetManagerDashboarDetailModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['DistributorId'], 8118);
      expect(json['ItemName'], '14.2 KG');
      expect(json['TotalAmount'], 263874.00);
      expect(json['DMCount'], 12);
    });

    test('copyWith updates specified fields', () {
      final model = GetManagerDashboarDetailModel.fromJson(sampleJson);
      final updated = model.copyWith(itemName: '19 KG', dMCount: 5);
      expect(updated.itemName, '19 KG');
      expect(updated.dMCount, 5);
      expect(model.itemName, '14.2 KG');
    });

    test('default constructor with null values', () {
      final model = GetManagerDashboarDetailModel();
      expect(model.distributorId, isNull);
      expect(model.itemName, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetManagerDashboarDetailModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetManagerDashboarDetailModel.fromJson(json);
      expect(model2.distributorId, model.distributorId);
      expect(model2.itemName, model.itemName);
      expect(model2.totalAmount, model.totalAmount);
    });
  });
}

