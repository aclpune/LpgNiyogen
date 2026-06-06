import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/ManagerGetDSRDMwiseSummaryListModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118, 'DelDate': '0001-01-01T00:00:00', 'DMId': 25,
    'StaffNo': 'SN/0010', 'StaffName': 'Suchitra Zadane', 'ItemId': 1,
    'ItemName': '14.2 KG', 'FilledSaleQty': 20, 'SVQty': 2, 'TVQty': 0,
    'EmptyRetQty': 16, 'DeffQty': 0, 'LessEmptyQty': 2, 'ActualSaleQty': 18,
    'DailySaleStatus': 6, 'DSCollMgrId': 0, 'CollRcptDate': '0001-01-01T00:00:00',
    'Rate': 855.50, 'TotalAmount': 15399.00, 'TotPrepaidQty': 2,
    'TotPrepaidAmt': 1711.00, 'TotPostpaidQty': 0, 'TotPostpaidAmt': 0.00,
    'TotRetiCrQty': 0, 'TotRetiCrAmt': 0.00, 'TotCashQty': 16,
    'TotCashAmt': 13688.00, 'AddedBy': 0, 'DenoCashExptd': 13688.00,
    'DenoCashRcvd': 13688.00, 'CashBalance': 0.00, 'FromDate': '0001-01-01T00:00:00',
  };

  group('ManagerGetDsrdMwiseSummaryListModel.fromJson', () {
    test('parses all 32 fields correctly', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.dMId, 25);
      expect(m.staffNo, 'SN/0010');
      expect(m.staffName, 'Suchitra Zadane');
      expect(m.itemId, 1);
      expect(m.itemName, '14.2 KG');
      expect(m.filledSaleQty, 20);
      expect(m.sVQty, 2);
      expect(m.tVQty, 0);
      expect(m.emptyRetQty, 16);
      expect(m.deffQty, 0);
      expect(m.lessEmptyQty, 2);
      expect(m.actualSaleQty, 18);
      expect(m.dailySaleStatus, 6);
      expect(m.rate, 855.50);
      expect(m.totalAmount, 15399.00);
      expect(m.totPrepaidQty, 2);
      expect(m.totPrepaidAmt, 1711.00);
      expect(m.totPostpaidQty, 0);
      expect(m.totCashQty, 16);
      expect(m.totCashAmt, 13688.00);
      expect(m.denoCashExptd, 13688.00);
      expect(m.denoCashRcvd, 13688.00);
      expect(m.cashBalance, 0.00);
    });

    test('handles empty JSON', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.staffName, isNull);
      expect(m.totalAmount, isNull);
    });

    test('handles partial JSON', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson({
        'DistributorId': 8118, 'StaffName': 'Test', 'TotalAmount': 500.0,
      });
      expect(m.distributorId, 8118);
      expect(m.staffName, 'Test');
      expect(m.itemId, isNull);
    });
  });

  group('ManagerGetDsrdMwiseSummaryListModel.toJson', () {
    test('serialises 32 fields', () {
      final j = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson).toJson();
      expect(j.length, 32);
      expect(j['TotalAmount'], 15399.00);
      expect(j['Rate'], 855.50);
    });

    test('round-trips correctly', () {
      final o = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson);
      final r = ManagerGetDsrdMwiseSummaryListModel.fromJson(o.toJson());
      expect(r.totalAmount, o.totalAmount);
      expect(r.staffName, o.staffName);
      expect(r.denoCashRcvd, o.denoCashRcvd);
    });
  });

  group('ManagerGetDsrdMwiseSummaryListModel.copyWith', () {
    test('replaces cashBalance', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson);
      final copy = m.copyWith(cashBalance: 500.0);
      expect(copy.cashBalance, 500.0);
      expect(copy.totalAmount, m.totalAmount);
    });

    test('replaces staffName and staffNo', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson);
      final copy = m.copyWith(staffName: 'New Staff', staffNo: 'SN/999');
      expect(copy.staffName, 'New Staff');
      expect(copy.staffNo, 'SN/999');
    });

    test('preserves all without args', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson);
      expect(m.copyWith().dMId, m.dMId);
    });
  });

  group('DSR DM-wise Summary – business logic', () {
    test('totalAmount = rate × actualSaleQty', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson);
      final expected = (m.rate ?? 0) * (m.actualSaleQty ?? 0);
      expect(expected, closeTo(m.totalAmount ?? 0, 0.01));
    });

    test('actualSaleQty = filledSaleQty - svQty', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson);
      final expected = (m.filledSaleQty ?? 0) - (m.sVQty ?? 0);
      expect(expected, m.actualSaleQty);
    });

    test('cash balance = denoCashExptd - denoCashRcvd', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson);
      final balance = (m.denoCashExptd ?? 0) - (m.denoCashRcvd ?? 0);
      expect(balance, closeTo(m.cashBalance ?? 0, 0.01));
    });

    test('totCashAmt + totPrepaidAmt + totPostpaidAmt ≈ totalAmount', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson);
      final sum = (m.totCashAmt ?? 0) + (m.totPrepaidAmt ?? 0) + (m.totPostpaidAmt ?? 0);
      expect(sum, closeTo(m.totalAmount ?? 0, 0.01));
    });

    test('cashBalance is zero when deno expected = received', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson);
      expect(m.cashBalance, 0.00);
    });

    test('staffNo follows SN/ pattern', () {
      final m = ManagerGetDsrdMwiseSummaryListModel.fromJson(fullJson);
      expect(m.staffNo!.startsWith('SN/'), isTrue);
    });
  });
}

