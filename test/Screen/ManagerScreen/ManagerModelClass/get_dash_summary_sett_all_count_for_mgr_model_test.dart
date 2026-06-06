import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetDashSummarySettAllCountForMgrModel.dart';

void main() {
  group('GetDashSummarySettAllCountForMgrModel', () {
    final sampleJson = {
      'DistributorId': 8118,
      'cDCMSPunPend': 54,
      'PaymtDoneBtDelPend': 38,
      'DelDoneBtPaymtPend': 1973,
      'NiyojanPun': 0,
      'NiyojanDuplicate': 0,
      'DelDonNiyoJanPunPend': 1192,
      'NiyoJanPunDelPend': 5,
      'OldBkgPendNewBkgRecv': 229,
      'SettlementPendSince': '2025-04-29T01:00:00',
      'cDCMDPendSince': '2025-09-07T15:10:15',
      'PaymtDoneBtDelPendAmt': 32509.00,
      'DelDoneBtPaymtPendAmt': 1687901.50,
      'TotalPendingSettCnt': 1989,
      'TotalPendingSettAmt': 1701589.50,
      'TotalPendingSettSince': '2025-04-29T01:00:00',
    };

    test('fromJson parses all fields correctly', () {
      final model = GetDashSummarySettAllCountForMgrModel.fromJson(sampleJson);
      expect(model.distributorId, 8118);
      expect(model.cDCMSPunPend, 54);
      expect(model.paymtDoneBtDelPend, 38);
      expect(model.delDoneBtPaymtPend, 1973);
      expect(model.totalPendingSettCnt, 1989);
      expect(model.totalPendingSettAmt, 1701589.50);
    });

    test('toJson returns correct map', () {
      final model = GetDashSummarySettAllCountForMgrModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['DistributorId'], 8118);
      expect(json['cDCMSPunPend'], 54);
      expect(json['TotalPendingSettCnt'], 1989);
    });

    test('copyWith updates specified fields', () {
      final model = GetDashSummarySettAllCountForMgrModel.fromJson(sampleJson);
      final updated = model.copyWith(cDCMSPunPend: 10, totalPendingSettCnt: 100);
      expect(updated.cDCMSPunPend, 10);
      expect(updated.totalPendingSettCnt, 100);
      expect(model.cDCMSPunPend, 54);
    });

    test('default constructor with null values', () {
      final model = GetDashSummarySettAllCountForMgrModel();
      expect(model.distributorId, isNull);
      expect(model.cDCMSPunPend, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetDashSummarySettAllCountForMgrModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetDashSummarySettAllCountForMgrModel.fromJson(json);
      expect(model2.cDCMSPunPend, model.cDCMSPunPend);
      expect(model2.totalPendingSettAmt, model.totalPendingSettAmt);
    });
  });
}

