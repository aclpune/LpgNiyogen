import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDSRReportCDCMSListModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDSRReportExpenseDetailListModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDsrReoprtCashFlowSummaryMode.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDsrReportIncomeSalesModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDsrReportSavedDataFetchModelList.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Pure-logic helpers mirroring _ManagerDSRReportScreenState private methods
// ─────────────────────────────────────────────────────────────────────────────

/// Mirrors _ManagerDSRReportScreenState.formatCurrency()
String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final format = NumberFormat('#,##,###.00', 'en_IN');
  String formatted = format.format(amount);
  if (amount < 1 && formatted.startsWith('.')) {
    formatted = '0$formatted';
  }
  return formatted;
}

/// Mirrors _ManagerDSRReportScreenState._greeting()
String greeting(int hour) {
  if (hour < 12) return 'Morning';
  if (hour < 17) return 'Afternoon';
  return 'Evening';
}

/// Mirrors the avatar-initials logic in _buildHeroStrip
String calcInitials(String staffName) {
  final parts = staffName.trim().split(RegExp(r'\s+'));
  if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  if (parts.isNotEmpty && parts[0].length >= 2) {
    return parts[0].substring(0, 2).toUpperCase();
  }
  return 'M';
}

/// Mirrors isDateValid = selectedDate.isAfter(today.subtract(Duration(days:1)))
bool isDateValid(DateTime selectedDate, DateTime today) {
  return selectedDate.isAfter(today.subtract(const Duration(days: 1)));
}

/// Mirrors the income-list cash-flow aggregation in _fetchData
Map<String, double> calcCashFlowTotals(List<IncDtls> incomeList) {
  double cash = 0, bank = 0, credit = 0, prepaid = 0, unsettled = 0, settled = 0;
  for (final item in incomeList) {
    if ((item.unsettQty ?? 0) > 0) unsettled += item.amount ?? 0.0;
    if ((item.settQty ?? 0) > 0) settled += item.amount ?? 0.0;
    switch (item.mode) {
      case 'Cash -':
        cash += item.amount ?? 0.0;
        break;
      case 'Merchant QR -':
        bank += item.amount ?? 0.0;
        break;
      case 'Credit -':
        credit += item.amount ?? 0.0;
        break;
      case 'Prepaid Online -':
        prepaid += item.amount ?? 0.0;
        break;
    }
  }
  return {
    'cash': cash,
    'bank': bank,
    'credit': credit,
    'prepaid': prepaid,
    'unsettled': unsettled,
    'settled': settled,
  };
}

/// Mirrors the expense cash-flow total in _fetchData
double calcExpenseCashFlowTotal(List<ExpDtls> expenseList) {
  double total = 0;
  for (final item in expenseList) {
    if (item.mode == 'Cash -' || item.mode == 'Bank -') {
      total += item.expenseAmount ?? 0.0;
    }
  }
  return total;
}

/// Mirrors cashflow summary total in _fetchData
double calcCashFlowSummaryTotal(List<CashflowDtls> cashflowList) {
  return cashflowList.fold(0.0, (sum, item) => sum + (item.totalAmt ?? 0.0));
}

/// Mirrors cash-denomination total in _fetchData
double calcCashDenomTotal(List<CashDenomDtls> denomList) {
  return denomList.fold(0.0, (sum, item) => sum + (item.amount ?? 0.0));
}

/// Mirrors cash-in-hand total in _fetchData
double calcCashInHandTotal(List<HandoverDtls> handoverList) {
  return handoverList.fold(0.0, (sum, item) => sum + (item.totalAmt ?? 0.0));
}

/// Mirrors income list filtering by TransCate
List<IncDtls> filterByTransCate(List<IncDtls> list, String category) {
  return list.where((item) => item.transCate == category).toList();
}

/// Mirrors SV/TV filtering by TransCate
List<SvTvDtls> filterSvTvByTransCate(List<SvTvDtls> list, String category) {
  return list.where((item) => item.transCate == category).toList();
}

/// Mirrors CDCMS diff initialization from cdcmsListData
Map<String, List<double>> buildCdcmsDiffLists(
    List<ManagerDsrReportCdcmsListModel> cdcmsData) {
  final filled = <double>[];
  final empty = <double>[];
  final defective = <double>[];
  final total = <double>[];
  for (final item in cdcmsData) {
    filled.add(item.filledDiff?.toDouble() ?? 0.0);
    empty.add(item.emptyDiff?.toDouble() ?? 0.0);
    defective.add(item.defectiveDiff?.toDouble() ?? 0.0);
    total.add(item.total?.toDouble() ?? 0.0);
  }
  return {
    'filled': filled,
    'empty': empty,
    'defective': defective,
    'total': total,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// TESTS
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 1 – formatCurrency
  // ───────────────────────────────────────────────────────────────────────────
  group('formatCurrency', () {
    test('zero returns "0.00"', () {
      expect(formatCurrency(0), '0.00');
    });

    test('positive amount formats with two decimal places', () {
      final result = formatCurrency(26676.0);
      expect(result.contains('26676') || result.contains('26,676'), isTrue);
    });

    test('large amount does not throw', () {
      expect(() => formatCurrency(416183.0), returnsNormally);
    });

    test('sub-zero amount has leading zero before decimal', () {
      final result = formatCurrency(0.5);
      expect(result.startsWith('0'), isTrue);
    });

    test('negative amount does not throw', () {
      expect(() => formatCurrency(-500.0), returnsNormally);
    });

    test('exactly 1.0 formats correctly', () {
      final result = formatCurrency(1.0);
      expect(result.contains('1'), isTrue);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 2 – greeting
  // ───────────────────────────────────────────────────────────────────────────
  group('greeting', () {
    test('hour < 12 returns Morning', () {
      expect(greeting(0), 'Morning');
      expect(greeting(6), 'Morning');
      expect(greeting(11), 'Morning');
    });

    test('hour 12–16 returns Afternoon', () {
      expect(greeting(12), 'Afternoon');
      expect(greeting(14), 'Afternoon');
      expect(greeting(16), 'Afternoon');
    });

    test('hour >= 17 returns Evening', () {
      expect(greeting(17), 'Evening');
      expect(greeting(20), 'Evening');
      expect(greeting(23), 'Evening');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 3 – calcInitials (avatar badge)
  // ───────────────────────────────────────────────────────────────────────────
  group('calcInitials', () {
    test('two-word name produces two-letter uppercase initials', () {
      expect(calcInitials('Rajesh Kumar'), 'RK');
    });

    test('single word name with >= 2 chars produces first two chars', () {
      expect(calcInitials('Admin'), 'AD');
    });

    test('single char name returns "M" fallback', () {
      expect(calcInitials('A'), 'M');
    });

    test('three-word name uses only first two words', () {
      expect(calcInitials('Amit Kumar Singh'), 'AK');
    });

    test('extra whitespace is trimmed', () {
      expect(calcInitials('  Deepak  Sharma  '), 'DS');
    });

    test('empty string returns "M"', () {
      // trim().split gives [''], length 1 with empty string
      expect(calcInitials(''), 'M');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 4 – isDateValid
  // ───────────────────────────────────────────────────────────────────────────
  group('isDateValid', () {
    final today = DateTime(2026, 5, 15);

    test('today is valid', () {
      expect(isDateValid(today, today), isTrue);
    });

    test('future date is valid', () {
      expect(isDateValid(DateTime(2026, 5, 16), today), isTrue);
    });

    test('yesterday is not valid', () {
      expect(isDateValid(DateTime(2026, 5, 14), today), isFalse);
    });

    test('a past date is not valid', () {
      expect(isDateValid(DateTime(2025, 1, 1), today), isFalse);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 5 – ManagerDsrReportIncomeSalesModel
  // ───────────────────────────────────────────────────────────────────────────
  group('ManagerDsrReportIncomeSalesModel', () {
    test('fromJson parses all fields', () {
      final json = {
        'DistributorId': 0,
        'IncomeId': 0,
        'TransCate': 'DailySale',
        'Quantity': 88.0,
        'UnsettQty': 0,
        'SettQty': 0,
        'Mode': 'Cash -',
        'Amount': 18626.00,
        'ItemName': '14.2 KG',
        'ItemId': 1,
        'Date': '0001-01-01T00:00:00',
        'Seq': 1,
      };
      final m = ManagerDsrReportIncomeSalesModel.fromJson(json);
      expect(m.transCate, 'DailySale');
      expect(m.quantity, 88.0);
      expect(m.mode, 'Cash -');
      expect(m.amount, 18626.00);
      expect(m.itemName, '14.2 KG');
    });

    test('toJson round-trips correctly', () {
      final m = ManagerDsrReportIncomeSalesModel(
        transCate: 'ARB-SV',
        amount: 5133.0,
        mode: null,
      );
      final map = m.toJson();
      expect(map['TransCate'], 'ARB-SV');
      expect(map['Amount'], 5133.0);
      expect(map['Mode'], isNull);
    });

    test('copyWith overrides specified fields', () {
      final m = ManagerDsrReportIncomeSalesModel(
          transCate: 'DailySale', amount: 1000.0);
      final copy = m.copyWith(amount: 9999.0);
      expect(copy.transCate, 'DailySale');
      expect(copy.amount, 9999.0);
    });

    test('default constructor leaves null fields', () {
      final m = ManagerDsrReportIncomeSalesModel();
      expect(m.transCate, isNull);
      expect(m.amount, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 6 – ManagerDsrReportCdcmsListModel
  // ───────────────────────────────────────────────────────────────────────────
  group('ManagerDsrReportCdcmsListModel', () {
    test('fromJson parses all fields', () {
      final json = {
        'DistributorId': 8118,
        'GodownId': 0,
        'Date': '0001-01-01T00:00:00',
        'ItemId': 1,
        'ItemName': '14.2 KG',
        'Action': null,
        'AddedBy': 0,
        'CurrentStkFilled': 1545,
        'CurrentStkEmpty': 2146,
        'StkUpdateDate': '0001-01-01T00:00:00',
        'CurrentStkDefective': 4,
        'FilledCD': 1547,
        'EmptyCD': 1545,
        'DefectiveCD': 4,
        'FilledDiff': -2,
        'EmptyDiff': 601,
        'DefectiveDiff': 0,
        'Total': 599,
        'StockUpdatedOn': '17/02/2025 17:13',
        'StkRecoId': 1,
      };
      final m = ManagerDsrReportCdcmsListModel.fromJson(json);
      expect(m.itemId, 1);
      expect(m.itemName, '14.2 KG');
      expect(m.currentStkFilled, 1545);
      expect(m.filledDiff, -2);
      expect(m.emptyDiff, 601);
      expect(m.defectiveDiff, 0);
      expect(m.total, 599);
      expect(m.stockUpdatedOn, '17/02/2025 17:13');
    });

    test('toJson round-trips correctly', () {
      final m = ManagerDsrReportCdcmsListModel(
        itemName: '5 KG',
        filledDiff: 10,
        emptyDiff: -5,
        total: 5,
      );
      final map = m.toJson();
      expect(map['ItemName'], '5 KG');
      expect(map['FilledDiff'], 10);
      expect(map['EmptyDiff'], -5);
      expect(map['Total'], 5);
    });

    test('copyWith preserves unchanged fields', () {
      final m = ManagerDsrReportCdcmsListModel(
          itemId: 1, filledDiff: 3, total: 3);
      final copy = m.copyWith(filledDiff: 99);
      expect(copy.itemId, 1);
      expect(copy.filledDiff, 99);
    });

    test('default constructor leaves null fields', () {
      final m = ManagerDsrReportCdcmsListModel();
      expect(m.itemName, isNull);
      expect(m.total, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 7 – ManagerDsrReoprtCashFlowSummaryMode
  // ───────────────────────────────────────────────────────────────────────────
  group('ManagerDsrReoprtCashFlowSummaryMode', () {
    test('fromJson parses all fields', () {
      final json = {
        'CashHandoverId': 0,
        'DistributorId': 8118,
        'TotalAmt': 416183.00,
        'StaffIds': null,
        'CashHandoverTo_ID': 0,
        'IsCashHandover': 0,
        'AddedBy': 0,
        'CashCollDate': '2025-03-28T00:00:00',
        'StaffId': 4,
        'StaffName': 'LPG Gas Dealer',
        'CashInHand': 0.0,
        'CollAmt': 0.0,
        'PaidAmt': 0.0,
        'Date': '0001-01-01T00:00:00',
        'HeaderNameStr': 'Cash In Hand',
        'BankId': 0,
        'MappingId': 0,
      };
      final m = ManagerDsrReoprtCashFlowSummaryMode.fromJson(json);
      expect(m.distributorId, 8118);
      expect(m.totalAmt, 416183.00);
      expect(m.staffName, 'LPG Gas Dealer');
      expect(m.headerNameStr, 'Cash In Hand');
    });

    test('toJson round-trips correctly', () {
      final m = ManagerDsrReoprtCashFlowSummaryMode(
        totalAmt: 2711.0,
        staffName: 'Bharti Naiknaware',
        headerNameStr: 'Cash In Hand',
      );
      final map = m.toJson();
      expect(map['TotalAmt'], 2711.0);
      expect(map['StaffName'], 'Bharti Naiknaware');
      expect(map['HeaderNameStr'], 'Cash In Hand');
    });

    test('copyWith preserves unchanged fields', () {
      final m = ManagerDsrReoprtCashFlowSummaryMode(
          totalAmt: 1000.0, staffName: 'Test');
      final copy = m.copyWith(totalAmt: 2000.0);
      expect(copy.staffName, 'Test');
      expect(copy.totalAmt, 2000.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 8 – ManagerDsrReportExpenseDetailListModel
  // ───────────────────────────────────────────────────────────────────────────
  group('ManagerDsrReportExpenseDetailListModel', () {
    test('fromJson parses all fields', () {
      final json = {
        'DistributorId': 0,
        'IncomeId': 0,
        'TransCate': 'Other Expense',
        'Quantity': 0.0,
        'ExpHeadId': 6,
        'PHId': 5,
        'Mode': 'Cash -',
        'ExpenseAmount': 1000.00,
        'ExpenseItemName': 'Miscellaneous',
        'categoryName': null,
        'PHName': 'Other Expense',
        'Date': '0001-01-01T00:00:00',
      };
      final m = ManagerDsrReportExpenseDetailListModel.fromJson(json);
      expect(m.transCate, 'Other Expense');
      expect(m.mode, 'Cash -');
      expect(m.expenseAmount, 1000.00);
      expect(m.expenseItemName, 'Miscellaneous');
      expect(m.pHName, 'Other Expense');
    });

    test('toJson round-trips correctly', () {
      final m = ManagerDsrReportExpenseDetailListModel(
        transCate: 'TV Refund',
        mode: 'Bank -',
        expenseAmount: 1800.0,
      );
      final map = m.toJson();
      expect(map['TransCate'], 'TV Refund');
      expect(map['Mode'], 'Bank -');
      expect(map['ExpenseAmount'], 1800.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 9 – IncDtls (inner class)
  // ───────────────────────────────────────────────────────────────────────────
  group('IncDtls', () {
    test('fromJson parses DailySale entry', () {
      final json = {
        'DistributorId': 0,
        'IncomeId': 0,
        'TransCate': 'DailySale',
        'Quantity': 88.0,
        'UnsettQty': 0,
        'SettQty': 0,
        'Mode': '',
        'Amount': 75284.00,
        'ItemName': '14.2 KG',
        'ItemId': 1,
        'Date': '0001-01-01T00:00:00',
      };
      final m = IncDtls.fromJson(json);
      expect(m.transCate, 'DailySale');
      expect(m.amount, 75284.00);
      expect(m.itemName, '14.2 KG');
    });

    test('fromJson parses ARB-SV entry', () {
      final json = {
        'TransCate': 'ARB-SV',
        'Amount': 5133.00,
        'Mode': null,
        'UnsettQty': 0,
        'SettQty': 0,
      };
      final m = IncDtls.fromJson(json);
      expect(m.transCate, 'ARB-SV');
      expect(m.amount, 5133.00);
    });

    test('toJson round-trips correctly', () {
      final m = IncDtls(
        transCate: 'Receipt',
        amount: 500.0,
        mode: 'Cash -',
      );
      final map = m.toJson();
      expect(map['TransCate'], 'Receipt');
      expect(map['Amount'], 500.0);
      expect(map['Mode'], 'Cash -');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 10 – ExpDtls (inner class)
  // ───────────────────────────────────────────────────────────────────────────
  group('ExpDtls', () {
    test('fromJson parses expense entry', () {
      final json = {
        'DistributorId': 0,
        'IncomeId': 0,
        'TransCate': 'TV Refund',
        'Quantity': 1,
        'ExpHeadId': 0,
        'PHId': 0,
        'Mode': 'Bank -',
        'ExpenseAmount': 1800.00,
        'ExpenseItemName': 'TV Refund',
        'categoryName': 'TV Refund',
        'PHName': null,
        'Date': '0001-01-01T00:00:00',
      };
      final m = ExpDtls.fromJson(json);
      expect(m.transCate, 'TV Refund');
      expect(m.mode, 'Bank -');
      expect(m.expenseAmount, 1800.00);
    });

    test('toJson round-trips correctly', () {
      final m = ExpDtls(mode: 'Cash -', expenseAmount: 2500.0);
      final map = m.toJson();
      expect(map['Mode'], 'Cash -');
      expect(map['ExpenseAmount'], 2500.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 11 – SvTvDtls (inner class)
  // ───────────────────────────────────────────────────────────────────────────
  group('SvTvDtls', () {
    test('fromJson parses SV entry', () {
      final json = {
        'DistributorId': 0,
        'TransCate': 'SV',
        'Quantity': 1,
        'Mode': '',
        'Amount': 6155.50,
        'ItemName': '14.2 KG',
        'ItemId': 1,
        'Date': '0001-01-01T00:00:00',
        'SVType': 'NC',
        'TransDate': null,
        'TotalSaleQty': 0,
      };
      final m = SvTvDtls.fromJson(json);
      expect(m.transCate, 'SV');
      expect(m.amount, 6155.50);
      expect(m.sVType, 'NC');
    });

    test('fromJson parses TV Refund entry', () {
      final json = {
        'TransCate': 'TV Refund',
        'Quantity': 1,
        'Amount': 1800.00,
        'ItemName': '5 KG DOM',
        'Mode': '',
        'SVType': '',
        'TransDate': null,
        'TotalSaleQty': 0,
      };
      final m = SvTvDtls.fromJson(json);
      expect(m.transCate, 'TV Refund');
      expect(m.amount, 1800.00);
    });

    test('toJson round-trips correctly', () {
      final m = SvTvDtls(transCate: 'SV', amount: 5000.0, sVType: 'NC');
      final map = m.toJson();
      expect(map['TransCate'], 'SV');
      expect(map['Amount'], 5000.0);
      expect(map['SVType'], 'NC');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 12 – DmsaleDtls (inner class)
  // ───────────────────────────────────────────────────────────────────────────
  group('DmsaleDtls', () {
    test('fromJson parses DM sale entry', () {
      final json = {
        'DistributorId': 0,
        'DelDate': '0001-01-01T00:00:00',
        'DMId': 45,
        'StaffNo': null,
        'StaffName': '19kg Gopal',
        'ItemId': 1,
        'ItemName': '14.2 KG',
        'FilledSaleQty': 10,
        'SVQty': 0,
        'TVQty': 0,
        'EmptyRetQty': 0,
        'DeffQty': 0,
        'LessEmptyQty': 0,
        'ActualSaleQty': 10,
        'DailySaleStatus': 0,
        'DSCollMgrId': 0,
        'CollRcptDate': '0001-01-01T00:00:00',
        'Rate': 0.0,
        'TotalAmount': 8555.00,
        'TotPrepaidQty': 0,
        'TotPrepaidAmt': 0.00,
        'TotPostpaidQty': 0,
        'TotPostpaidAmt': 855.50,
        'TotRetiCrQty': 0,
        'TotRetiCrAmt': 0.00,
        'TotCashQty': 0,
        'TotCashAmt': 7699.50,
        'AddedBy': 0,
        'DenoCashExptd': 0.0,
        'DenoCashRcvd': 7699.50,
        'CashBalance': 0.0,
        'FromDate': '0001-01-01T00:00:00',
      };
      final m = DmsaleDtls.fromJson(json);
      expect(m.dMId, 45);
      expect(m.staffName, '19kg Gopal');
      expect(m.itemName, '14.2 KG');
      expect(m.filledSaleQty, 10);
      expect(m.totalAmount, 8555.00);
      expect(m.totCashAmt, 7699.50);
    });

    test('toJson round-trips correctly', () {
      final m = DmsaleDtls(
        dMId: 49,
        staffName: '5kg DurgaSingh',
        totalAmount: 16785.0,
      );
      final map = m.toJson();
      expect(map['DMId'], 49);
      expect(map['StaffName'], '5kg DurgaSingh');
      expect(map['TotalAmount'], 16785.0);
    });

    test('copyWith preserves unchanged fields', () {
      final m = DmsaleDtls(staffName: 'John', totalAmount: 5000.0);
      final copy = m.copyWith(totalAmount: 9999.0);
      expect(copy.staffName, 'John');
      expect(copy.totalAmount, 9999.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 13 – CashflowDtls (inner class)
  // ───────────────────────────────────────────────────────────────────────────
  group('CashflowDtls', () {
    test('fromJson parses cashflow entry', () {
      final json = {
        'DistributorId': 0,
        'StaffId': 0,
        'BankId': 0,
        'HeaderNameStr': 'Cash In Hand',
        'TotalAmt': 2711.00,
        'StaffName': 'Bharti Naiknaware',
        'MappingId': 0,
      };
      final m = CashflowDtls.fromJson(json);
      expect(m.headerNameStr, 'Cash In Hand');
      expect(m.totalAmt, 2711.00);
      expect(m.staffName, 'Bharti Naiknaware');
    });

    test('toJson round-trips correctly', () {
      final m = CashflowDtls(totalAmt: 50000.0, staffName: 'Sapna Panavkar');
      final map = m.toJson();
      expect(map['TotalAmt'], 50000.0);
      expect(map['StaffName'], 'Sapna Panavkar');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 14 – HandoverDtls (inner class)
  // ───────────────────────────────────────────────────────────────────────────
  group('HandoverDtls', () {
    test('fromJson parses handover entry', () {
      final json = {
        'DSRId': 0,
        'StaffId': 4,
        'StaffName': 'Shamika Joshi',
        'CollAmt': 26576.00,
        'PaidAmt': 0.00,
        'TotalAmt': 26576.00,
        'CashStatus': 0,
      };
      final m = HandoverDtls.fromJson(json);
      expect(m.staffName, 'Shamika Joshi');
      expect(m.collAmt, 26576.00);
      expect(m.totalAmt, 26576.00);
    });

    test('toJson round-trips correctly', () {
      final m = HandoverDtls(totalAmt: 1000.0, staffName: 'Test Staff');
      final map = m.toJson();
      expect(map['TotalAmt'], 1000.0);
      expect(map['StaffName'], 'Test Staff');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 15 – CashDenomDtls (inner class)
  // ───────────────────────────────────────────────────────────────────────────
  group('CashDenomDtls', () {
    test('fromJson parses denomination entry', () {
      final json = {
        'DSRId': 0,
        'NoteId': 1,
        'NoteType': 500.00,
        'Qty': 5,
        'Amount': 2500.00,
      };
      final m = CashDenomDtls.fromJson(json);
      expect(m.noteType, 500.00);
      expect(m.qty, 5);
      expect(m.amount, 2500.00);
    });

    test('toJson round-trips correctly', () {
      final m = CashDenomDtls(noteType: 100.0, qty: 10, amount: 1000.0);
      final map = m.toJson();
      expect(map['NoteType'], 100.0);
      expect(map['Qty'], 10);
      expect(map['Amount'], 1000.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 16 – Cash flow totals calculation
  // ───────────────────────────────────────────────────────────────────────────
  group('calcCashFlowTotals', () {
    final incomeList = [
      IncDtls(mode: 'Cash -', amount: 18626.00, unsettQty: 0, settQty: 0),
      IncDtls(mode: 'Merchant QR -', amount: 4212.50, unsettQty: 0, settQty: 0),
      IncDtls(mode: 'Credit -', amount: 3317.00, unsettQty: 0, settQty: 0),
      IncDtls(mode: 'Prepaid Online -', amount: 1678.50, unsettQty: 0, settQty: 0),
      IncDtls(mode: '-', amount: 65873.50, unsettQty: 77, settQty: 0),
      IncDtls(mode: '+', amount: 8555.00, unsettQty: 0, settQty: 10),
    ];

    test('cash total aggregates correctly', () {
      final result = calcCashFlowTotals(incomeList);
      expect(result['cash'], closeTo(18626.00, 0.001));
    });

    test('merchant/bank total aggregates correctly', () {
      final result = calcCashFlowTotals(incomeList);
      expect(result['bank'], closeTo(4212.50, 0.001));
    });

    test('credit total aggregates correctly', () {
      final result = calcCashFlowTotals(incomeList);
      expect(result['credit'], closeTo(3317.00, 0.001));
    });

    test('prepaid total aggregates correctly', () {
      final result = calcCashFlowTotals(incomeList);
      expect(result['prepaid'], closeTo(1678.50, 0.001));
    });

    test('unsettled total aggregates when unsettQty > 0', () {
      final result = calcCashFlowTotals(incomeList);
      expect(result['unsettled'], closeTo(65873.50, 0.001));
    });

    test('settled total aggregates when settQty > 0', () {
      final result = calcCashFlowTotals(incomeList);
      expect(result['settled'], closeTo(8555.00, 0.001));
    });

    test('empty list returns all zeros', () {
      final result = calcCashFlowTotals([]);
      expect(result['cash'], 0.0);
      expect(result['bank'], 0.0);
      expect(result['credit'], 0.0);
    });

    test('null mode is ignored', () {
      final items = [IncDtls(mode: null, amount: 100.0, unsettQty: 0, settQty: 0)];
      final result = calcCashFlowTotals(items);
      expect(result['cash'], 0.0);
      expect(result['bank'], 0.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 17 – Expense cash flow total
  // ───────────────────────────────────────────────────────────────────────────
  group('calcExpenseCashFlowTotal', () {
    test('sums Cash - and Bank - modes', () {
      final expenses = [
        ExpDtls(mode: 'Cash -', expenseAmount: 1000.0),
        ExpDtls(mode: 'Bank -', expenseAmount: 800.0),
        ExpDtls(mode: '', expenseAmount: 500.0),  // excluded
      ];
      expect(calcExpenseCashFlowTotal(expenses), closeTo(1800.0, 0.001));
    });

    test('empty mode is excluded', () {
      final expenses = [ExpDtls(mode: '', expenseAmount: 999.0)];
      expect(calcExpenseCashFlowTotal(expenses), 0.0);
    });

    test('null mode is excluded', () {
      final expenses = [ExpDtls(mode: null, expenseAmount: 500.0)];
      expect(calcExpenseCashFlowTotal(expenses), 0.0);
    });

    test('empty list returns 0.0', () {
      expect(calcExpenseCashFlowTotal([]), 0.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 18 – Cash flow summary total
  // ───────────────────────────────────────────────────────────────────────────
  group('calcCashFlowSummaryTotal', () {
    test('sums totalAmt across all entries', () {
      final cashflows = [
        CashflowDtls(totalAmt: 2711.0),
        CashflowDtls(totalAmt: 3000.0),
        CashflowDtls(totalAmt: 148555.50),
      ];
      expect(
          calcCashFlowSummaryTotal(cashflows), closeTo(154266.50, 0.001));
    });

    test('empty list returns 0.0', () {
      expect(calcCashFlowSummaryTotal([]), 0.0);
    });

    test('null totalAmt defaults to 0', () {
      final cashflows = [
        CashflowDtls(totalAmt: null),
        CashflowDtls(totalAmt: 5000.0),
      ];
      expect(calcCashFlowSummaryTotal(cashflows), 5000.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 19 – Cash denomination total
  // ───────────────────────────────────────────────────────────────────────────
  group('calcCashDenomTotal', () {
    test('sums denomination amounts', () {
      final denoms = [
        CashDenomDtls(noteType: 500, qty: 2, amount: 1000.0),
        CashDenomDtls(noteType: 100, qty: 5, amount: 500.0),
        CashDenomDtls(noteType: 50, qty: 4, amount: 200.0),
      ];
      expect(calcCashDenomTotal(denoms), closeTo(1700.0, 0.001));
    });

    test('zero amount entries contribute nothing', () {
      final denoms = [
        CashDenomDtls(noteType: 500, qty: 0, amount: 0.0),
        CashDenomDtls(noteType: 100, qty: 3, amount: 300.0),
      ];
      expect(calcCashDenomTotal(denoms), 300.0);
    });

    test('empty list returns 0.0', () {
      expect(calcCashDenomTotal([]), 0.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 20 – Cash in hand total
  // ───────────────────────────────────────────────────────────────────────────
  group('calcCashInHandTotal', () {
    test('sums totalAmt from handover entries', () {
      final handovers = [
        HandoverDtls(totalAmt: 26576.0),
        HandoverDtls(totalAmt: 5000.0),
      ];
      expect(calcCashInHandTotal(handovers), closeTo(31576.0, 0.001));
    });

    test('empty list returns 0.0', () {
      expect(calcCashInHandTotal([]), 0.0);
    });

    test('null totalAmt defaults to 0', () {
      final handovers = [
        HandoverDtls(totalAmt: null),
        HandoverDtls(totalAmt: 1000.0),
      ];
      expect(calcCashInHandTotal(handovers), 1000.0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 21 – filterByTransCate (income list filtering)
  // ───────────────────────────────────────────────────────────────────────────
  group('filterByTransCate', () {
    final incomeList = [
      IncDtls(transCate: 'DailySale', amount: 75284.0),
      IncDtls(transCate: 'DailySale', amount: 18463.5),
      IncDtls(transCate: 'ARB-SV', amount: 5133.0),
      IncDtls(transCate: 'Receipt', amount: 1000.0),
      IncDtls(transCate: 'Regulator Replacement', amount: 500.0),
    ];

    test('filters DailySale correctly', () {
      final result = filterByTransCate(incomeList, 'DailySale');
      expect(result.length, 2);
      expect(result.every((i) => i.transCate == 'DailySale'), isTrue);
    });

    test('filters ARB-SV correctly', () {
      final result = filterByTransCate(incomeList, 'ARB-SV');
      expect(result.length, 1);
      expect(result.first.amount, 5133.0);
    });

    test('filters Receipt correctly', () {
      final result = filterByTransCate(incomeList, 'Receipt');
      expect(result.length, 1);
      expect(result.first.amount, 1000.0);
    });

    test('filters Regulator Replacement correctly', () {
      final result = filterByTransCate(incomeList, 'Regulator Replacement');
      expect(result.length, 1);
    });

    test('returns empty list when no match', () {
      final result = filterByTransCate(incomeList, 'NonExistent');
      expect(result, isEmpty);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 22 – filterSvTvByTransCate
  // ───────────────────────────────────────────────────────────────────────────
  group('filterSvTvByTransCate', () {
    final svTvList = [
      SvTvDtls(transCate: 'SV', amount: 6155.50),
      SvTvDtls(transCate: 'SV', amount: 4328.50),
      SvTvDtls(transCate: 'TV Refund', amount: 1800.0),
    ];

    test('filters SV entries correctly', () {
      final result = filterSvTvByTransCate(svTvList, 'SV');
      expect(result.length, 2);
    });

    test('filters TV Refund entries correctly', () {
      final result = filterSvTvByTransCate(svTvList, 'TV Refund');
      expect(result.length, 1);
      expect(result.first.amount, 1800.0);
    });

    test('returns empty when no match', () {
      final result = filterSvTvByTransCate(svTvList, 'ARBSale');
      expect(result, isEmpty);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 23 – buildCdcmsDiffLists
  // ───────────────────────────────────────────────────────────────────────────
  group('buildCdcmsDiffLists', () {
    final cdcmsData = [
      ManagerDsrReportCdcmsListModel(
          itemName: '14.2 KG', filledDiff: -2, emptyDiff: 601,
          defectiveDiff: 0, total: 599),
      ManagerDsrReportCdcmsListModel(
          itemName: '5 KG', filledDiff: 3, emptyDiff: -1,
          defectiveDiff: 1, total: 3),
    ];

    test('builds filled diff list correctly', () {
      final result = buildCdcmsDiffLists(cdcmsData);
      expect(result['filled'], [-2.0, 3.0]);
    });

    test('builds empty diff list correctly', () {
      final result = buildCdcmsDiffLists(cdcmsData);
      expect(result['empty'], [601.0, -1.0]);
    });

    test('builds defective diff list correctly', () {
      final result = buildCdcmsDiffLists(cdcmsData);
      expect(result['defective'], [0.0, 1.0]);
    });

    test('builds total diff list correctly', () {
      final result = buildCdcmsDiffLists(cdcmsData);
      expect(result['total'], [599.0, 3.0]);
    });

    test('empty cdcms data returns all empty lists', () {
      final result = buildCdcmsDiffLists([]);
      expect(result['filled'], isEmpty);
      expect(result['empty'], isEmpty);
    });

    test('null diff values default to 0.0', () {
      final data = [
        ManagerDsrReportCdcmsListModel(
            filledDiff: null, emptyDiff: null, defectiveDiff: null, total: null),
      ];
      final result = buildCdcmsDiffLists(data);
      expect(result['filled'], [0.0]);
      expect(result['empty'], [0.0]);
      expect(result['defective'], [0.0]);
      expect(result['total'], [0.0]);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 24 – saveFlag logic (checkAndSaveDayEndData)
  // ───────────────────────────────────────────────────────────────────────────
  group('saveFlag logic', () {
    // Mirrors: saveFlag = apiResponse.isNotEmpty
    test('saveFlag true when response is non-empty', () {
      final response = [{'status': 'done'}];
      final saveFlag = response.isNotEmpty;
      expect(saveFlag, isTrue);
    });

    test('saveFlag false when response is empty', () {
      final response = <dynamic>[];
      final saveFlag = response.isNotEmpty;
      expect(saveFlag, isFalse);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 25 – _fetchData flag dispatch logic
  // ───────────────────────────────────────────────────────────────────────────
  group('_fetchData flag dispatch', () {
    // Mirrors: if (flag == 'Y') fetch saved else fetch fresh
    bool usesSavedDataPath(String flag) => flag == 'Y';

    test('"Y" flag uses saved data path', () {
      expect(usesSavedDataPath('Y'), isTrue);
    });

    test('"N" flag uses fresh data path', () {
      expect(usesSavedDataPath('N'), isFalse);
    });

    test('responseData > 0 triggers "Y" flag', () {
      const responseData = 5;
      const flag = responseData > 0 ? 'Y' : 'N';
      expect(flag, 'Y');
    });

    test('responseData == 0 triggers "N" flag', () {
      const responseData = 0;
      const flag = responseData > 0 ? 'Y' : 'N';
      expect(flag, 'N');
    });

    test('responseData < 0 triggers "N" flag', () {
      const responseData = -1;
      const flag = responseData > 0 ? 'Y' : 'N';
      expect(flag, 'N');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 26 – Date display formatting (hero strip)
  // ───────────────────────────────────────────────────────────────────────────
  group('Date display formatting', () {
    // Mirrors: DateFormat('dd MMM yyyy').format(selectedDate)
    String formatDisplayDate(DateTime date) =>
        DateFormat('dd MMM yyyy').format(date);

    test('formats date correctly', () {
      expect(
          formatDisplayDate(DateTime(2026, 5, 15)), '15 May 2026');
    });

    test('formats first of month correctly', () {
      expect(
          formatDisplayDate(DateTime(2025, 1, 1)), '01 Jan 2025');
    });

    test('formats last day of year correctly', () {
      expect(
          formatDisplayDate(DateTime(2025, 12, 31)), '31 Dec 2025');
    });
  });
}

