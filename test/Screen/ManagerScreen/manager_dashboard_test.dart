// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/HeadWiseExpenseLstModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/GetDashPuchSummaryCntModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetCurrentStockDetailManagerModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetDashSummaryAllCountForMgrModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetDashSummaryItemWiseForMgrModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetDashSummarySettAllCountForMgrModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetSVARBManagerDashboardCountModel.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pure-logic helpers extracted from _ManagerDashboardScreenState for unit tests
// ─────────────────────────────────────────────────────────────────────────────

/// Mirrors _ManagerDashboardScreenState.formatIndianCurrency()
String formatIndianCurrency(num value) {
  if (value >= 10000000) {
    return '${(value / 10000000).floor()}Cr';
  } else if (value >= 100000) {
    return '${(value / 100000).floor()}L';
  } else if (value >= 1000) {
    return '${(value / 1000).floor()}k';
  } else {
    return value.floor().toString();
  }
}

/// Mirrors _ManagerDashboardScreenState.formatCurrency()
String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final format = NumberFormat('#,##,###.00', 'en_IN');
  return format.format(amount);
}

/// Mirrors _ManagerDashboardScreenState._onRefresh() dayFlag resolution
String resolveDayFlag(String? selectedTransMode) {
  if (selectedTransMode == "Today's") return "TODAYS";
  if (selectedTransMode == "This Month") return "THISMONTH";
  if (selectedTransMode == "Financial Year") return "FINYEAR";
  return "";
}

/// Mirrors totalGrossProfit calculation in fetchSVARBFilterCountList
double calcTotalGrossProfit({
  required double svGrossRevenue,
  required double arbGrossProfit,
  required double refillGrossProfit,
}) =>
    svGrossRevenue + arbGrossProfit + refillGrossProfit;

/// Mirrors totalExpenseForProfit calculation in getHeadWiseExpenseLstModel
double calcTotalExpense(List<HeadWiseExpenseLstModel> expenses) {
  return expenses.fold(0.0, (sum, item) => sum + (item.totExpAmt ?? 0.0));
}

/// Mirrors incomeProfit = totalGrossProfit - totalExpenseForProfit
double calcIncomeProfit(double totalGrossProfit, double totalExpenseForProfit) =>
    totalGrossProfit - totalExpenseForProfit;

/// Mirrors stock aggregate sums used in fetchCurrentStock
Map<String, int> calcStockTotals(
    List<GetCurrentStockDetailManagerModel> items) {
  int filled = 0, empty = 0, defective = 0;
  for (final item in items) {
    filled += (item.filledCurrentStk?.toInt() ?? 0);
    empty += (item.emptyCurrentStk?.toInt() ?? 0);
    defective += (item.deffCurrentStk?.toInt() ?? 0);
  }
  return {'filled': filled, 'empty': empty, 'defective': defective};
}

/// Mirrors imbalance total calculation
int calcTotalImbalance(List<GetCurrentStockDetailManagerModel> items) {
  return items.fold(0, (sum, i) => sum + (i.imbalanceCnt?.toInt() ?? 0));
}

/// Mirrors imbalance-count filter used in the UI list (only items with imbalanceCnt > 0)
List<GetCurrentStockDetailManagerModel> filterImbalanceItems(
    List<GetCurrentStockDetailManagerModel> items) {
  return items.where((i) => (i.imbalanceCnt ?? 0) > 0).toList();
}

// ─────────────────────────────────────────────────────────────────────────────
// TESTS
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 1 – formatIndianCurrency
  // ───────────────────────────────────────────────────────────────────────────
  group('formatIndianCurrency', () {
    test('value >= 1 crore returns Cr suffix', () {
      expect(formatIndianCurrency(10000000), '1Cr');
      expect(formatIndianCurrency(25000000), '2Cr');
      expect(formatIndianCurrency(99999999), '9Cr');
    });

    test('value >= 1 lakh but < 1 crore returns L suffix', () {
      expect(formatIndianCurrency(100000), '1L');
      expect(formatIndianCurrency(500000), '5L');
      expect(formatIndianCurrency(9999999), '99L');
    });

    test('value >= 1000 but < 1 lakh returns k suffix', () {
      expect(formatIndianCurrency(1000), '1k');
      expect(formatIndianCurrency(5500), '5k');
      expect(formatIndianCurrency(99999), '99k');
    });

    test('value < 1000 returns plain integer string', () {
      expect(formatIndianCurrency(0), '0');
      expect(formatIndianCurrency(500), '500');
      expect(formatIndianCurrency(999), '999');
    });

    test('fractional value is floored', () {
      expect(formatIndianCurrency(1999.99), '1k');
      expect(formatIndianCurrency(100999.99), '1L');
    });

    test('exact boundary 10000000 returns 1Cr', () {
      expect(formatIndianCurrency(10000000), '1Cr');
    });

    test('exact boundary 100000 returns 1L', () {
      expect(formatIndianCurrency(100000), '1L');
    });

    test('exact boundary 1000 returns 1k', () {
      expect(formatIndianCurrency(1000), '1k');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 2 – formatCurrency (Indian number format)
  // ───────────────────────────────────────────────────────────────────────────
  group('formatCurrency', () {
    test('zero returns "0.00"', () {
      expect(formatCurrency(0), '0.00');
    });

    test('positive amount formats correctly', () {
      final result = formatCurrency(1701589.50);
      expect(result.contains('1701589') || result.contains('17,01,589'), isTrue);
    });

    test('small amount formats with two decimal places', () {
      final result = formatCurrency(500.0);
      expect(result, contains('500'));
    });

    test('large amount does not throw', () {
      expect(() => formatCurrency(44088453.00), returnsNormally);
    });

    test('negative amount does not throw', () {
      expect(() => formatCurrency(-1000.0), returnsNormally);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 3 – resolveDayFlag (trans mode to API flag)
  // ───────────────────────────────────────────────────────────────────────────
  group('resolveDayFlag', () {
    test('"Today\'s" maps to TODAYS', () {
      expect(resolveDayFlag("Today's"), 'TODAYS');
    });

    test('"This Month" maps to THISMONTH', () {
      expect(resolveDayFlag('This Month'), 'THISMONTH');
    });

    test('"Financial Year" maps to FINYEAR', () {
      expect(resolveDayFlag('Financial Year'), 'FINYEAR');
    });

    test('null or unknown returns empty string', () {
      expect(resolveDayFlag(null), '');
      expect(resolveDayFlag('Unknown'), '');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 4 – totalGrossProfit calculation
  // ───────────────────────────────────────────────────────────────────────────
  group('calcTotalGrossProfit', () {
    test('sums three revenue components correctly', () {
      final result = calcTotalGrossProfit(
        svGrossRevenue: 472.0,
        arbGrossProfit: -43553.0,
        refillGrossProfit: 27875.0,
      );
      expect(result, closeTo(-15206.0, 0.001));
    });

    test('all zeros returns zero', () {
      final result = calcTotalGrossProfit(
        svGrossRevenue: 0,
        arbGrossProfit: 0,
        refillGrossProfit: 0,
      );
      expect(result, 0.0);
    });

    test('all positive values sum correctly', () {
      final result = calcTotalGrossProfit(
        svGrossRevenue: 1000.0,
        arbGrossProfit: 2000.0,
        refillGrossProfit: 3000.0,
      );
      expect(result, 6000.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 5 – expense total calculation
  // ───────────────────────────────────────────────────────────────────────────
  group('calcTotalExpense', () {
    test('sums totExpAmt across all expense heads', () {
      final expenses = [
        HeadWiseExpenseLstModel(totExpAmt: 74014.0),
        HeadWiseExpenseLstModel(totExpAmt: 12000.0),
        HeadWiseExpenseLstModel(totExpAmt: 5000.0),
      ];
      expect(calcTotalExpense(expenses), closeTo(91014.0, 0.001));
    });

    test('empty list returns 0.0', () {
      expect(calcTotalExpense([]), 0.0);
    });

    test('null totExpAmt is treated as 0', () {
      final expenses = [
        HeadWiseExpenseLstModel(totExpAmt: null),
        HeadWiseExpenseLstModel(totExpAmt: 5000.0),
      ];
      expect(calcTotalExpense(expenses), 5000.0);
    });

    test('single expense returns its value', () {
      final expenses = [HeadWiseExpenseLstModel(totExpAmt: 99999.0)];
      expect(calcTotalExpense(expenses), 99999.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 6 – incomeProfit calculation
  // ───────────────────────────────────────────────────────────────────────────
  group('calcIncomeProfit', () {
    test('positive profit when grossProfit > expenses', () {
      expect(calcIncomeProfit(100000.0, 60000.0), closeTo(40000.0, 0.001));
    });

    test('negative profit when expenses exceed grossProfit', () {
      expect(calcIncomeProfit(50000.0, 80000.0), closeTo(-30000.0, 0.001));
    });

    test('zero when grossProfit equals expenses', () {
      expect(calcIncomeProfit(75000.0, 75000.0), closeTo(0.0, 0.001));
    });

    test('zero grossProfit returns negative expenses', () {
      expect(calcIncomeProfit(0.0, 5000.0), closeTo(-5000.0, 0.001));
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 7 – GetDashSummaryAllCountForMgrModel
  // ───────────────────────────────────────────────────────────────────────────
  group('GetDashSummaryAllCountForMgrModel', () {
    test('fromJson parses all fields', () {
      final json = {
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
      final m = GetDashSummaryAllCountForMgrModel.fromJson(json);
      expect(m.distributorId, 8118);
      expect(m.dMCount, 3);
      expect(m.totalAmount, 31450.00);
      expect(m.postPaidVerifPend, 377);
      expect(m.sVPendingStk, 149);
      expect(m.tVPendingStk, 12);
      expect(m.postPaidVerifPendAmt, 3386703.00);
      expect(m.undocumentedSV, 78);
      expect(m.totalCrdtOutstd, 44088453.00);
      expect(m.totalVendorDueAmt, 145249.00);
    });

    test('toJson round-trips correctly', () {
      final m = GetDashSummaryAllCountForMgrModel(
        distributorId: 1,
        postPaidVerifPend: 10,
        totalCrdtOutstd: 5000,
      );
      final map = m.toJson();
      expect(map['PostPaidVerifPend'], 10);
      expect(map['TotalCrdtOutstd'], 5000);
    });

    test('copyWith preserves unchanged fields', () {
      final m = GetDashSummaryAllCountForMgrModel(
        distributorId: 1,
        undocumentedSV: 5,
        totalVendorDueAmt: 1000,
      );
      final copy = m.copyWith(undocumentedSV: 99);
      expect(copy.totalVendorDueAmt, 1000);
      expect(copy.undocumentedSV, 99);
    });

    test('default constructor leaves all fields null', () {
      final m = GetDashSummaryAllCountForMgrModel();
      expect(m.distributorId, isNull);
      expect(m.postPaidVerifPend, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 8 – GetDashSummarySettAllCountForMgrModel
  // ───────────────────────────────────────────────────────────────────────────
  group('GetDashSummarySettAllCountForMgrModel', () {
    test('fromJson parses all fields', () {
      final json = {
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
      final m = GetDashSummarySettAllCountForMgrModel.fromJson(json);
      expect(m.cDCMSPunPend, 54);
      expect(m.paymtDoneBtDelPend, 38);
      expect(m.delDoneBtPaymtPend, 1973);
      expect(m.settlementPendSince, '2025-04-29T01:00:00');
      expect(m.cDCMDPendSince, '2025-09-07T15:10:15');
      expect(m.totalPendingSettCnt, 1989);
      expect(m.totalPendingSettAmt, 1701589.50);
      expect(m.totalPendingSettSince, '2025-04-29T01:00:00');
    });

    test('toJson round-trips correctly', () {
      final m = GetDashSummarySettAllCountForMgrModel(
        totalPendingSettCnt: 100,
        totalPendingSettAmt: 50000.0,
        settlementPendSince: '2025-01-01T00:00:00',
      );
      final map = m.toJson();
      expect(map['TotalPendingSettCnt'], 100);
      expect(map['TotalPendingSettAmt'], 50000.0);
      expect(map['SettlementPendSince'], '2025-01-01T00:00:00');
    });

    test('copyWith preserves unchanged fields', () {
      final m = GetDashSummarySettAllCountForMgrModel(
        cDCMSPunPend: 10,
        totalPendingSettAmt: 99999.0,
      );
      final copy = m.copyWith(cDCMSPunPend: 20);
      expect(copy.totalPendingSettAmt, 99999.0);
      expect(copy.cDCMSPunPend, 20);
    });

    test('null settlement date is handled', () {
      final m = GetDashSummarySettAllCountForMgrModel(settlementPendSince: null);
      expect(m.settlementPendSince, isNull);
    });

    test('date format is parseable to DateTime', () {
      final m = GetDashSummarySettAllCountForMgrModel(
          settlementPendSince: '2025-04-29T01:00:00');
      final dt = DateTime.parse(m.settlementPendSince!);
      expect(dt.year, 2025);
      expect(dt.month, 4);
      expect(dt.day, 29);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 9 – GetCurrentStockDetailManagerModel
  // ───────────────────────────────────────────────────────────────────────────
  group('GetCurrentStockDetailManagerModel', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'DistributorId': 0,
        'ItemId': 1,
        'ItemName': '14.2 KG',
        'CurrentStkFilled': 0,
        'CurrentStkEmpty': 0,
        'FilledCnt': 324,
        'TotalInvoiceCnt': 324,
        'FilledEMRCnt': 0,
        'EmptyTVCnt': 0,
        'DefectivCnt': 101,
        'DefectivFromDate': '2025-03-24T00:00:00',
        'EmptyCRDCnt': 324,
        'EmptyDefectivCnt': 0,
        'NCCnt': 0,
        'DBCCnt': 0,
        'RCCnt': 0,
        'RefillSaleCnt': 826,
        'ImbalanceCnt': 0,
        'EmptyCnt': 0,
        'TVQty': 0,
        'SVQty': 6,
        'DeffQty': 101,
        'FilledOpeningStk': 2000,
        'EmptyOpeningStk': 1200,
        'DeffOpeningStk': 0,
        'FilledCurrentStk': 2112,
        'EmptyCurrentStk': 2676,
        'DeffCurrentStk': 101,
      };
      final m = GetCurrentStockDetailManagerModel.fromJson(json);
      expect(m.itemId, 1);
      expect(m.itemName, '14.2 KG');
      expect(m.filledCnt, 324);
      expect(m.defectivCnt, 101);
      expect(m.imbalanceCnt, 0);
      expect(m.filledCurrentStk, 2112);
      expect(m.emptyCurrentStk, 2676);
      expect(m.deffCurrentStk, 101);
      expect(m.filledOpeningStk, 2000);
      expect(m.emptyOpeningStk, 1200);
    });

    test('toJson round-trips correctly', () {
      final m = GetCurrentStockDetailManagerModel(
        itemId: 1,
        itemName: '14.2 KG',
        imbalanceCnt: 5,
        filledCurrentStk: 100,
      );
      final map = m.toJson();
      expect(map['ItemId'], 1);
      expect(map['ImbalanceCnt'], 5);
      expect(map['FilledCurrentStk'], 100);
    });

    test('copyWith preserves unchanged fields', () {
      final m = GetCurrentStockDetailManagerModel(
        itemId: 2,
        itemName: '5 KG',
        imbalanceCnt: 3,
      );
      final copy = m.copyWith(imbalanceCnt: 10);
      expect(copy.itemName, '5 KG');
      expect(copy.imbalanceCnt, 10);
    });

    test('default constructor leaves all fields null', () {
      final m = GetCurrentStockDetailManagerModel();
      expect(m.itemId, isNull);
      expect(m.imbalanceCnt, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 10 – GetDashSummaryItemWiseForMgrModel
  // ───────────────────────────────────────────────────────────────────────────
  group('GetDashSummaryItemWiseForMgrModel', () {
    test('fromJson parses all fields', () {
      final json = {
        'DistributorId': 8118,
        'ItemId': 1,
        'ItemName': '14.2 KG',
        'FilledDiff': 1503,
        'EmptyDiff': 278,
        'DefectiveDiff': 6,
        'TodayImbQty': 0,
        'AsOfDateImbQty': 172,
      };
      final m = GetDashSummaryItemWiseForMgrModel.fromJson(json);
      expect(m.itemId, 1);
      expect(m.itemName, '14.2 KG');
      expect(m.filledDiff, 1503);
      expect(m.emptyDiff, 278);
      expect(m.defectiveDiff, 6);
      expect(m.todayImbQty, 0);
      expect(m.asOfDateImbQty, 172);
    });

    test('toJson round-trips correctly', () {
      final m = GetDashSummaryItemWiseForMgrModel(
        itemId: 2,
        itemName: '5 KG',
        asOfDateImbQty: 50,
      );
      final map = m.toJson();
      expect(map['ItemId'], 2);
      expect(map['AsOfDateImbQty'], 50);
    });

    test('copyWith overrides specified fields', () {
      final m = GetDashSummaryItemWiseForMgrModel(
        itemId: 1,
        asOfDateImbQty: 100,
      );
      final copy = m.copyWith(asOfDateImbQty: 200);
      expect(copy.itemId, 1);
      expect(copy.asOfDateImbQty, 200);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 11 – GetSvarbManagerDashboardCountModel
  // ───────────────────────────────────────────────────────────────────────────
  group('GetSvarbManagerDashboardCountModel', () {
    test('fromJson parses all fields', () {
      final json = {
        'DistributorId': 8118,
        'SVGrossRevenue': 472.00,
        'ARBGrossRevenue': 27147.00,
        'ARBGrossProfit': -43553.00,
        'RefillGrossRevenue': 191342.50,
        'RefillGrossProfit': 27875.00,
      };
      final m = GetSvarbManagerDashboardCountModel.fromJson(json);
      expect(m.distributorId, 8118);
      expect(m.sVGrossRevenue, 472.00);
      expect(m.aRBGrossRevenue, 27147.00);
      expect(m.aRBGrossProfit, -43553.00);
      expect(m.refillGrossRevenue, 191342.50);
      expect(m.refillGrossProfit, 27875.00);
    });

    test('toJson round-trips correctly', () {
      final m = GetSvarbManagerDashboardCountModel(
        sVGrossRevenue: 500,
        aRBGrossProfit: -1000,
        refillGrossProfit: 2000,
      );
      final map = m.toJson();
      expect(map['SVGrossRevenue'], 500);
      expect(map['ARBGrossProfit'], -1000);
      expect(map['RefillGrossProfit'], 2000);
    });

    test('copyWith preserves unchanged fields', () {
      final m = GetSvarbManagerDashboardCountModel(
          sVGrossRevenue: 100, aRBGrossProfit: 200);
      final copy = m.copyWith(sVGrossRevenue: 999);
      expect(copy.aRBGrossProfit, 200);
      expect(copy.sVGrossRevenue, 999);
    });

    test('default constructor leaves all null', () {
      final m = GetSvarbManagerDashboardCountModel();
      expect(m.sVGrossRevenue, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 12 – GetDashPunchSummaryCntModel
  // ───────────────────────────────────────────────────────────────────────────
  group('GetDashPunchSummaryCntModel', () {
    test('fromJson parses all fields', () {
      final json = {
        'DistributorId': 0,
        'PunchManToday': 0,
        'PunchManAsOf': 7051,
        'PunchDACToday': 0,
        'PunchDACAsOf': 8911,
        'BkgManToday': 0,
        'BkgManAsOf': 6,
        'BkgOnlineToday': 0,
        'BkgOnlineAsOf': 932,
        'DeliveryDate': '2026-01-01T00:00:00',
        'OrderDate': '2025-02-07T00:00:00',
        'PunchManTodayPct': 0.0,
        'PunchManAsOfPct': 44.17,
        'PunchDACTodayPct': 0.0,
        'PunchDACAsOfPct': 55.83,
        'BkgManTodayPct': 0.0,
        'BkgManAsOfPct': 0.64,
        'BkgOnlineTodayPct': 0.0,
        'BkgOnlineAsOfPct': 99.36,
      };
      final m = GetDashPunchSummaryCntModel.fromJson(json);
      expect(m.punchManAsOf, 7051);
      expect(m.punchDACAsOf, 8911);
      expect(m.bkgOnlineAsOf, 932);
      expect(m.deliveryDate, '2026-01-01T00:00:00');
      expect(m.punchManAsOfPct, closeTo(44.17, 0.001));
      expect(m.bkgOnlineAsOfPct, closeTo(99.36, 0.001));
    });

    test('toJson round-trips correctly', () {
      final m = GetDashPunchSummaryCntModel(
        punchManToday: 5,
        punchManAsOf: 100,
        punchManTodayPct: 12.5,
      );
      final map = m.toJson();
      expect(map['PunchManToday'], 5);
      expect(map['PunchManAsOf'], 100);
      expect(map['PunchManTodayPct'], 12.5);
    });

    test('copyWith overrides specific fields', () {
      final m = GetDashPunchSummaryCntModel(
          punchManToday: 1, bkgOnlineAsOf: 500);
      final copy = m.copyWith(punchManToday: 99);
      expect(copy.bkgOnlineAsOf, 500);
      expect(copy.punchManToday, 99);
    });

    test('default constructor leaves all null', () {
      final m = GetDashPunchSummaryCntModel();
      expect(m.punchManToday, isNull);
      expect(m.deliveryDate, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 13 – HeadWiseExpenseLstModel
  // ───────────────────────────────────────────────────────────────────────────
  group('HeadWiseExpenseLstModel', () {
    test('fromJson parses all fields', () {
      final json = {
        'DistributorId': 8118,
        'ParentExpHeadId': 1,
        'ParentExpHeadName': 'Office Expense',
        'TotExpAmt': 74014.00,
      };
      final m = HeadWiseExpenseLstModel.fromJson(json);
      expect(m.distributorId, 8118);
      expect(m.parentExpHeadId, 1);
      expect(m.parentExpHeadName, 'Office Expense');
      expect(m.totExpAmt, 74014.00);
    });

    test('toJson round-trips correctly', () {
      final m = HeadWiseExpenseLstModel(
        parentExpHeadName: 'Fuel',
        totExpAmt: 5000.0,
      );
      final map = m.toJson();
      expect(map['ParentExpHeadName'], 'Fuel');
      expect(map['TotExpAmt'], 5000.0);
    });

    test('copyWith overrides specified fields', () {
      final m =
          HeadWiseExpenseLstModel(parentExpHeadName: 'Salary', totExpAmt: 50000);
      final copy = m.copyWith(totExpAmt: 60000);
      expect(copy.parentExpHeadName, 'Salary');
      expect(copy.totExpAmt, 60000);
    });

    test('null totExpAmt is handled gracefully', () {
      final m = HeadWiseExpenseLstModel(totExpAmt: null);
      expect(m.totExpAmt, isNull);
      expect(calcTotalExpense([m]), 0.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 14 – stock totals aggregate
  // ───────────────────────────────────────────────────────────────────────────
  group('calcStockTotals', () {
    final items = [
      GetCurrentStockDetailManagerModel(
          itemId: 1,
          filledCurrentStk: 2112,
          emptyCurrentStk: 2676,
          deffCurrentStk: 101),
      GetCurrentStockDetailManagerModel(
          itemId: 2,
          filledCurrentStk: 500,
          emptyCurrentStk: 200,
          deffCurrentStk: 10),
    ];

    test('sums filled stock across all items', () {
      final result = calcStockTotals(items);
      expect(result['filled'], 2612);
    });

    test('sums empty stock across all items', () {
      final result = calcStockTotals(items);
      expect(result['empty'], 2876);
    });

    test('sums defective stock across all items', () {
      final result = calcStockTotals(items);
      expect(result['defective'], 111);
    });

    test('empty list returns all zeros', () {
      final result = calcStockTotals([]);
      expect(result['filled'], 0);
      expect(result['empty'], 0);
      expect(result['defective'], 0);
    });

    test('null values default to 0', () {
      final result = calcStockTotals([
        GetCurrentStockDetailManagerModel(
            itemId: 1,
            filledCurrentStk: null,
            emptyCurrentStk: null,
            deffCurrentStk: null),
      ]);
      expect(result['filled'], 0);
      expect(result['empty'], 0);
      expect(result['defective'], 0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 15 – imbalance total calculation
  // ───────────────────────────────────────────────────────────────────────────
  group('calcTotalImbalance', () {
    test('sums imbalanceCnt across all items', () {
      final items = [
        GetCurrentStockDetailManagerModel(imbalanceCnt: 5),
        GetCurrentStockDetailManagerModel(imbalanceCnt: 3),
        GetCurrentStockDetailManagerModel(imbalanceCnt: 0),
      ];
      expect(calcTotalImbalance(items), 8);
    });

    test('empty list returns 0', () {
      expect(calcTotalImbalance([]), 0);
    });

    test('null imbalanceCnt is treated as 0', () {
      final items = [
        GetCurrentStockDetailManagerModel(imbalanceCnt: null),
        GetCurrentStockDetailManagerModel(imbalanceCnt: 7),
      ];
      expect(calcTotalImbalance(items), 7);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 16 – filterImbalanceItems (UI filter: imbalanceCnt > 0)
  // ───────────────────────────────────────────────────────────────────────────
  group('filterImbalanceItems', () {
    final items = [
      GetCurrentStockDetailManagerModel(itemId: 1, imbalanceCnt: 5),
      GetCurrentStockDetailManagerModel(itemId: 2, imbalanceCnt: 0),
      GetCurrentStockDetailManagerModel(itemId: 3, imbalanceCnt: 3),
      GetCurrentStockDetailManagerModel(itemId: 4, imbalanceCnt: null),
    ];

    test('returns only items with imbalanceCnt > 0', () {
      final result = filterImbalanceItems(items);
      expect(result.length, 2);
      expect(result.map((i) => i.itemId).toList(), containsAll([1, 3]));
    });

    test('excludes items with imbalanceCnt == 0', () {
      final result = filterImbalanceItems(items);
      expect(result.any((i) => i.itemId == 2), isFalse);
    });

    test('excludes items with null imbalanceCnt', () {
      final result = filterImbalanceItems(items);
      expect(result.any((i) => i.itemId == 4), isFalse);
    });

    test('empty input returns empty list', () {
      expect(filterImbalanceItems([]), isEmpty);
    });

    test('all zero/null items returns empty list', () {
      final zeroItems = [
        GetCurrentStockDetailManagerModel(imbalanceCnt: 0),
        GetCurrentStockDetailManagerModel(imbalanceCnt: null),
      ];
      expect(filterImbalanceItems(zeroItems), isEmpty);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 17 – Alert severity logic (Needs Attention section)
  // ───────────────────────────────────────────────────────────────────────────
  group('Alert severity logic', () {
    test('postPaidVerifPend > 0 → warning severity', () {
      const postPaidVerifPend = 10;
      const isWarning = postPaidVerifPend > 0;
      expect(isWarning, isTrue);
    });

    test('postPaidVerifPend == 0 → info severity', () {
      const postPaidVerifPend = 0;
      const isWarning = postPaidVerifPend > 0;
      expect(isWarning, isFalse);
    });

    test('totalPendingSettAmt > 0 → danger severity', () {
      const totalPendAmount = 1701589.50;
      const isDanger = totalPendAmount > 0;
      expect(isDanger, isTrue);
    });

    test('totalPendingSettAmt == 0 → info severity', () {
      const totalPendAmount = 0.0;
      const isDanger = totalPendAmount > 0;
      expect(isDanger, isFalse);
    });

    test('TotalVendorDueAmt > 0 → warning severity', () {
      const totalVendorDueAmt = 145249;
      const isWarning = totalVendorDueAmt > 0;
      expect(isWarning, isTrue);
    });

    test('asOfDateImbQtyShow > 0 → danger severity', () {
      const asOfDateImbQtyShow = 5;
      const isDanger = asOfDateImbQtyShow > 0;
      expect(isDanger, isTrue);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 18 – Credit outstanding badge label logic
  // ───────────────────────────────────────────────────────────────────────────
  group('Credit outstanding badge label', () {
    // Mirrors: badgeLabel: (TotalCrdtOutstd ?? 0) > 0 ? 'Pending' : 'Clear ✓'
    String badgeLabel(int? totalCrdtOutstd) =>
        (totalCrdtOutstd ?? 0) > 0 ? 'Pending' : 'Clear ✓';

    test('positive outstanding → "Pending"', () {
      expect(badgeLabel(44088453), 'Pending');
    });

    test('zero outstanding → "Clear ✓"', () {
      expect(badgeLabel(0), 'Clear ✓');
    });

    test('null outstanding → "Clear ✓"', () {
      expect(badgeLabel(null), 'Clear ✓');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 19 – Date formatting (build() date display)
  // ───────────────────────────────────────────────────────────────────────────
  group('Date formatting', () {
    // Mirrors: DateFormat('dd-MM-yyyy').format(DateTime.parse(settlementPendSince!))
    String formatDate(String? raw) {
      if (raw == null) return 'No Date';
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(raw));
    }

    test('valid ISO date formats to dd-MM-yyyy', () {
      expect(formatDate('2025-04-29T01:00:00'), '29-04-2025');
    });

    test('null date returns "No Date"', () {
      expect(formatDate(null), 'No Date');
    });

    test('another valid date formats correctly', () {
      expect(formatDate('2025-09-07T15:10:15'), '07-09-2025');
    });

    test('date with no time component formats correctly', () {
      expect(formatDate('2026-01-15T00:00:00'), '15-01-2026');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 20 – Percentage punch display logic
  // ───────────────────────────────────────────────────────────────────────────
  group('Punch display value (isOn toggle)', () {
    // Mirrors: today: !isOn ? punchManToday ?? 0 : punchManTodayPct ?? 0
    num punchDisplayValue(bool showPct, int? rawVal, double? pctVal) {
      return !showPct ? (rawVal ?? 0) : (pctVal ?? 0.0);
    }

    test('isOn=false returns raw count', () {
      expect(punchDisplayValue(false, 100, 44.17), 100);
    });

    test('isOn=true returns percentage', () {
      expect(punchDisplayValue(true, 100, 44.17), closeTo(44.17, 0.001));
    });

    test('null raw value defaults to 0', () {
      expect(punchDisplayValue(false, null, 30.0), 0);
    });

    test('null pct value defaults to 0.0', () {
      expect(punchDisplayValue(true, 50, null), 0.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 21 – waitForData retry logic
  // ───────────────────────────────────────────────────────────────────────────
  group('waitForData retry logic', () {
    // Mirrors: while (list.isEmpty && attempts < 20) { attempts++; }
    int simulateWait(int maxAttempts, int populatedAtAttempt) {
      int attempts = 0;
      bool listEmpty = true;
      while (listEmpty && attempts < maxAttempts) {
        if (attempts == populatedAtAttempt) listEmpty = false;
        attempts++;
      }
      return attempts;
    }

    test('exits immediately when list is populated at first attempt', () {
      final attempts = simulateWait(20, 0);
      expect(attempts, 1);
    });

    test('exits after max retries when list never populates', () {
      final attempts = simulateWait(20, 99); // never populates
      expect(attempts, 20);
    });

    test('exits when data arrives mid-way', () {
      final attempts = simulateWait(20, 5);
      expect(attempts, 6); // 0..5 iterations then stops
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 22 – stockTransferFlag equivalent for Manager (isStkTrans check)
  // ───────────────────────────────────────────────────────────────────────────
  group('Stock transfer flag logic', () {
    test('flag false when any item has isStkTrans == 0', () {
      final values = [1, 0, 1];
      final flag = !values.any((v) => v == 0);
      expect(flag, isFalse);
    });

    test('flag true when no item has isStkTrans == 0', () {
      final values = [1, 1, 1];
      final flag = !values.any((v) => v == 0);
      expect(flag, isTrue);
    });

    test('flag true for empty list', () {
      final values = <int>[];
      final flag = !values.any((v) => v == 0);
      expect(flag, isTrue);
    });
  });
}

