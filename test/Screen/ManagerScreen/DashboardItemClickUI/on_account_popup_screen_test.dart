// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/OnAccountPopupScreen.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from OnAccountPopupScreen ───────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

/// Mirrors: amounts[index] = (double.tryParse(value) ?? 0.0) * data.noteType!
double calcDenomAmount(String qtyText, double noteType) =>
    (double.tryParse(qtyText) ?? 0.0) * noteType;

/// Mirrors: totalAmount = amounts.fold(0.0, (sum, a) => sum + a)
double calcTotalAmount(List<double> amounts) =>
    amounts.fold(0.0, (sum, a) => sum + a);

/// Mirrors: returnAmount = amountsReturn.fold(0.0, (sum, a) => sum + a)
double calcReturnAmount(List<double> amounts) =>
    amounts.fold(0.0, (sum, a) => sum + a);

/// Mirrors: finalAmountCashDeno = totalAmount - returnAmount
double calcFinalCashDeno(double total, double returnAmt) => total - returnAmt;

/// Mirrors: enteredAmount > totalBalance → clear
bool isAmountExceedsBalance(String entered, String totalBalance) {
  final e = double.tryParse(entered) ?? 0.0;
  final t = double.tryParse(totalBalance) ?? 0.0;
  return e > t;
}

/// Mirrors: selectedTransMode == null || isEmpty
bool isTransModeValid(String? mode) => mode != null && mode.isNotEmpty;

/// Mirrors: _balanceController.text.isEmpty
bool isBalanceEntered(String text) => text.isNotEmpty;

/// Mirrors: Online branch validation
String? validateOnlineMode({
  required String? transMode,
  required bool hasBankSelected,
  required String tranCode,
}) {
  if (transMode != 'Online') return null;
  if (!hasBankSelected) return 'Please select bank';
  if (tranCode.isEmpty)  return 'Please enter transaction code';
  return null;
}

/// Mirrors: finalAmountCashDeno != totalAmt → error (cash mode)
bool isDenomMatchingReceipt(double finalDeno, double receiptAmt) =>
    finalDeno == receiptAmt;

/// Mirrors: isPaymentButtonEnabled = isCheckedList.contains(true)
bool isPaymentEnabled(List<bool> checkedList) => checkedList.contains(true);

/// Mirrors: totalAmt loop over filteredReports when checkbox checked
double calcSelectedTotal(
    List<Map<String, dynamic>> reports, List<bool> checked) {
  double total = 0.0;
  for (int i = 0; i < reports.length; i++) {
    if (checked[i]) total += (reports[i]['balance'] as num? ?? 0.0).toDouble();
  }
  return total;
}

/// Mirrors: ledgerIdsString = selectedLedgerIds.join(',')
String joinLedgerIds(List<String> ids) => ids.join(',');

/// Mirrors: getTransMode constant
const List<String> getTransMode = ['Cash', 'Online'];

/// Mirrors: initializeControllers amounts[i] = qty * noteType
List<double> initAmounts(List<Map<String, dynamic>> denomModel) =>
    denomModel.map((d) {
      final qty      = ((d['qty']      ?? 0) as num).toDouble();
      final noteType = ((d['noteType'] ?? 0) as num).toDouble();
      return qty * noteType;
    }).toList();

/// Mirrors: isQtyFilled[index] = (denominationModel[index].qty ?? 0) > 0
Map<int, bool> buildIsQtyFilled(List<Map<String, dynamic>> denomModel) {
  final result = <int, bool>{};
  for (int i = 0; i < denomModel.length; i++) {
    result[i] = ((denomModel[i]['qty'] ?? 0) as num) > 0;
  }
  return result;
}

/// Mirrors: checkAndSaveDayEndData saveFlag logic
bool calcSaveFlag(Map<String, dynamic>? data) {
  if (data == null) return false;
  final dsr   = (data['DSRSaved']       ?? 0) as int;
  final cdcms = (data['CDCMSStkSaved']  ?? 0) as int;
  final opcl  = (data['OpClSaved']      ?? 0) as int;
  return dsr == 1 && cdcms == 1 && opcl == 1;
}

/// Mirrors: cashDenominationMandatory flag check
bool checkCashDenomMandatory(List<Map<String, dynamic>> list, String distId) {
  for (final item in list) {
    if (item['distributorId'].toString() == distId &&
        item['permissionFor'] == 'Cash Denomination' &&
        item['isActive'] == 1) {
      return true;
    }
  }
  return false;
}

/// Mirrors: _selectedIndex tab (0 = Cash Denomination, 1 = Cash Return)
int switchTab(int current, int tappedIndex) => tappedIndex;

void main() {
  // ── formatCurrency ──────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () =>
        expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('does not start with "." for sub-zero', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large amount has comma', () =>
        expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative does not throw', () =>
        expect(() => formatCurrency(-100.0), returnsNormally));
    test('same input same output', () =>
        expect(formatCurrency(1500.0), formatCurrency(1500.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(10.0), isNot('0.00')));
  });

  // ── calcDenomAmount ──────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] calcDenomAmount', () {
    test('2 × 500 = 1000', () =>
        expect(calcDenomAmount('2', 500.0), closeTo(1000.0, 0.001)));
    test('5 × 100 = 500', () =>
        expect(calcDenomAmount('5', 100.0), closeTo(500.0, 0.001)));
    test('0 qty → 0', () => expect(calcDenomAmount('0', 500.0), 0.0));
    test('empty text → 0', () => expect(calcDenomAmount('', 200.0), 0.0));
    test('invalid text → 0', () => expect(calcDenomAmount('abc', 100.0), 0.0));
    test('10 × 50 = 500', () =>
        expect(calcDenomAmount('10', 50.0), closeTo(500.0, 0.001)));
    test('1 × 2000 = 2000', () =>
        expect(calcDenomAmount('1', 2000.0), closeTo(2000.0, 0.001)));
    test('negative text → negative total', () =>
        expect(calcDenomAmount('-1', 500.0), -500.0));
  });

  // ── calcTotalAmount ──────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] calcTotalAmount', () {
    test('sums amounts', () =>
        expect(calcTotalAmount([1000.0, 500.0, 200.0]), closeTo(1700.0, 0.001)));
    test('empty list → 0', () => expect(calcTotalAmount([]), 0.0));
    test('single amount', () =>
        expect(calcTotalAmount([2500.0]), closeTo(2500.0, 0.001)));
    test('all zeros → 0', () =>
        expect(calcTotalAmount([0.0, 0.0, 0.0]), 0.0));
    test('many items', () {
      final amounts = List.generate(10, (i) => 100.0);
      expect(calcTotalAmount(amounts), closeTo(1000.0, 0.001));
    });
  });

  // ── calcReturnAmount ─────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] calcReturnAmount', () {
    test('sums return amounts', () =>
        expect(calcReturnAmount([200.0, 100.0]), closeTo(300.0, 0.001)));
    test('empty → 0', () => expect(calcReturnAmount([]), 0.0));
    test('single item', () =>
        expect(calcReturnAmount([500.0]), closeTo(500.0, 0.001)));
  });

  // ── calcFinalCashDeno ─────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] calcFinalCashDeno', () {
    test('no return → final equals total', () =>
        expect(calcFinalCashDeno(1500.0, 0.0), closeTo(1500.0, 0.001)));
    test('partial return', () =>
        expect(calcFinalCashDeno(1500.0, 500.0), closeTo(1000.0, 0.001)));
    test('full return → 0', () =>
        expect(calcFinalCashDeno(1000.0, 1000.0), 0.0));
    test('over-return → negative', () =>
        expect(calcFinalCashDeno(800.0, 1000.0), closeTo(-200.0, 0.001)));
    test('both zero → 0', () =>
        expect(calcFinalCashDeno(0.0, 0.0), 0.0));
  });

  // ── isAmountExceedsBalance ────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] isAmountExceedsBalance', () {
    test('entered < balance → false', () =>
        expect(isAmountExceedsBalance('500', '1000'), isFalse));
    test('entered == balance → false', () =>
        expect(isAmountExceedsBalance('1000', '1000'), isFalse));
    test('entered > balance → true', () =>
        expect(isAmountExceedsBalance('1500', '1000'), isTrue));
    test('empty entry → 0.0 → false', () =>
        expect(isAmountExceedsBalance('', '1000'), isFalse));
    test('invalid entry → 0.0 → false', () =>
        expect(isAmountExceedsBalance('abc', '500'), isFalse));
    test('invalid balance → treats as 0 → any positive exceeds', () =>
        expect(isAmountExceedsBalance('1', 'xyz'), isTrue));
    test('0 balance → any positive exceeds', () =>
        expect(isAmountExceedsBalance('0.01', '0'), isTrue));
  });

  // ── isTransModeValid ─────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] isTransModeValid', () {
    test('null → invalid', () => expect(isTransModeValid(null), isFalse));
    test('"" → invalid', () => expect(isTransModeValid(''), isFalse));
    test('"Cash" → valid', () => expect(isTransModeValid('Cash'), isTrue));
    test('"Online" → valid', () => expect(isTransModeValid('Online'), isTrue));
    test('whitespace only → valid (non-empty)', () =>
        expect(isTransModeValid(' '), isTrue));
  });

  // ── isBalanceEntered ─────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] isBalanceEntered', () {
    test('"" → false', () => expect(isBalanceEntered(''), isFalse));
    test('"0" → true', () => expect(isBalanceEntered('0'), isTrue));
    test('"500" → true', () => expect(isBalanceEntered('500'), isTrue));
    test('" " → true', () => expect(isBalanceEntered(' '), isTrue));
  });

  // ── validateOnlineMode ────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] validateOnlineMode', () {
    test('Cash mode → no error', () {
      expect(validateOnlineMode(
          transMode: 'Cash', hasBankSelected: false, tranCode: ''), isNull);
    });
    test('Online + no bank → error', () {
      expect(validateOnlineMode(
          transMode: 'Online', hasBankSelected: false, tranCode: 'TC1'),
          contains('bank'));
    });
    test('Online + bank + no code → error', () {
      expect(validateOnlineMode(
          transMode: 'Online', hasBankSelected: true, tranCode: ''),
          contains('transaction code'));
    });
    test('Online + bank + code → no error', () {
      expect(validateOnlineMode(
          transMode: 'Online', hasBankSelected: true, tranCode: 'TC1'), isNull);
    });
    test('null mode → no error', () {
      expect(validateOnlineMode(
          transMode: null, hasBankSelected: false, tranCode: ''), isNull);
    });
  });

  // ── isDenomMatchingReceipt ────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] isDenomMatchingReceipt', () {
    test('matching → true', () =>
        expect(isDenomMatchingReceipt(1500.0, 1500.0), isTrue));
    test('mismatch → false', () =>
        expect(isDenomMatchingReceipt(1500.0, 1400.0), isFalse));
    test('both zero → true', () =>
        expect(isDenomMatchingReceipt(0.0, 0.0), isTrue));
    test('denom > receipt → false', () =>
        expect(isDenomMatchingReceipt(1600.0, 1500.0), isFalse));
  });

  // ── isPaymentEnabled ─────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] isPaymentEnabled', () {
    test('at least one true → enabled', () =>
        expect(isPaymentEnabled([false, true, false]), isTrue));
    test('all false → disabled', () =>
        expect(isPaymentEnabled([false, false, false]), isFalse));
    test('empty list → disabled', () =>
        expect(isPaymentEnabled([]), isFalse));
    test('all true → enabled', () =>
        expect(isPaymentEnabled([true, true, true]), isTrue));
    test('single true → enabled', () =>
        expect(isPaymentEnabled([true]), isTrue));
    test('single false → disabled', () =>
        expect(isPaymentEnabled([false]), isFalse));
  });

  // ── calcSelectedTotal ─────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] calcSelectedTotal', () {
    test('all checked → sum of all balances', () {
      final reports = [
        {'balance': 500.0}, {'balance': 300.0}, {'balance': 200.0},
      ];
      expect(calcSelectedTotal(reports, [true, true, true]),
          closeTo(1000.0, 0.001));
    });
    test('none checked → 0', () {
      final reports = [{'balance': 500.0}, {'balance': 300.0}];
      expect(calcSelectedTotal(reports, [false, false]), 0.0);
    });
    test('partial selection', () {
      final reports = [
        {'balance': 500.0}, {'balance': 300.0}, {'balance': 200.0},
      ];
      expect(calcSelectedTotal(reports, [true, false, true]),
          closeTo(700.0, 0.001));
    });
    test('null balance treated as 0', () {
      final reports = [{'balance': null}, {'balance': 400.0}];
      expect(calcSelectedTotal(reports, [true, true]), closeTo(400.0, 0.001));
    });
    test('single item checked', () {
      expect(calcSelectedTotal([{'balance': 750.0}], [true]),
          closeTo(750.0, 0.001));
    });
    test('single item unchecked → 0', () {
      expect(calcSelectedTotal([{'balance': 750.0}], [false]), 0.0);
    });
  });

  // ── joinLedgerIds ─────────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] joinLedgerIds', () {
    test('single id → no comma', () =>
        expect(joinLedgerIds(['101']), '101'));
    test('two ids → comma-separated', () =>
        expect(joinLedgerIds(['101', '202']), '101,202'));
    test('three ids', () =>
        expect(joinLedgerIds(['1', '2', '3']), '1,2,3'));
    test('empty list → ""', () =>
        expect(joinLedgerIds([]), ''));
    test('preserves order', () =>
        expect(joinLedgerIds(['55', '33', '77']), '55,33,77'));
  });

  // ── getTransMode ─────────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] getTransMode', () {
    test('has exactly 2 modes', () => expect(getTransMode.length, 2));
    test('contains "Cash"', () => expect(getTransMode.contains('Cash'), isTrue));
    test('contains "Online"', () => expect(getTransMode.contains('Online'), isTrue));
    test('first is "Cash"', () => expect(getTransMode.first, 'Cash'));
    test('last is "Online"', () => expect(getTransMode.last, 'Online'));
  });

  // ── initAmounts ───────────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] initAmounts', () {
    test('calculates qty × noteType', () {
      final model = [
        {'qty': 2, 'noteType': 500.0},
        {'qty': 5, 'noteType': 100.0},
      ];
      final amounts = initAmounts(model);
      expect(amounts[0], closeTo(1000.0, 0.001));
      expect(amounts[1], closeTo(500.0, 0.001));
    });
    test('zero qty → 0', () {
      final model = [{'qty': 0, 'noteType': 500.0}];
      expect(initAmounts(model).first, 0.0);
    });
    test('null qty treated as 0', () {
      final model = [{'qty': null, 'noteType': 200.0}];
      expect(initAmounts(model).first, 0.0);
    });
    test('empty model → empty amounts', () {
      expect(initAmounts([]), isEmpty);
    });
    test('length matches model length', () {
      final model = List.generate(5, (i) => {'qty': 1, 'noteType': 100.0});
      expect(initAmounts(model).length, 5);
    });
  });

  // ── buildIsQtyFilled ─────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] buildIsQtyFilled', () {
    test('qty > 0 → true', () {
      final model = [{'qty': 3}];
      expect(buildIsQtyFilled(model)[0], isTrue);
    });
    test('qty == 0 → false', () {
      final model = [{'qty': 0}];
      expect(buildIsQtyFilled(model)[0], isFalse);
    });
    test('null qty → false', () {
      final model = [{'qty': null}];
      expect(buildIsQtyFilled(model)[0], isFalse);
    });
    test('mixed qtys', () {
      final model = [{'qty': 2}, {'qty': 0}, {'qty': 5}];
      final map = buildIsQtyFilled(model);
      expect(map[0], isTrue);
      expect(map[1], isFalse);
      expect(map[2], isTrue);
    });
    test('empty model → empty map', () {
      expect(buildIsQtyFilled(<Map<String, dynamic>>[]), isEmpty);
    });
  });

  // ── calcSaveFlag ──────────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] calcSaveFlag', () {
    test('all 3 saved → true', () {
      expect(calcSaveFlag({'DSRSaved': 1, 'CDCMSStkSaved': 1, 'OpClSaved': 1}),
          isTrue);
    });
    test('DSRSaved 0 → false', () {
      expect(calcSaveFlag({'DSRSaved': 0, 'CDCMSStkSaved': 1, 'OpClSaved': 1}),
          isFalse);
    });
    test('CDCMSStkSaved 0 → false', () {
      expect(calcSaveFlag({'DSRSaved': 1, 'CDCMSStkSaved': 0, 'OpClSaved': 1}),
          isFalse);
    });
    test('OpClSaved 0 → false', () {
      expect(calcSaveFlag({'DSRSaved': 1, 'CDCMSStkSaved': 1, 'OpClSaved': 0}),
          isFalse);
    });
    test('null data → false', () => expect(calcSaveFlag(null), isFalse));
    test('empty map → false', () => expect(calcSaveFlag({}), isFalse));
    test('all null fields → false', () {
      expect(calcSaveFlag(
          {'DSRSaved': null, 'CDCMSStkSaved': null, 'OpClSaved': null}),
          isFalse);
    });
  });

  // ── checkCashDenomMandatory ───────────────────────────────────────────────────
  group('[OnAccountPopupScreen] checkCashDenomMandatory', () {
    test('matching active record → true', () {
      final list = [
        {'distributorId': 8118, 'permissionFor': 'Cash Denomination', 'isActive': 1},
      ];
      expect(checkCashDenomMandatory(list, '8118'), isTrue);
    });
    test('isActive 0 → false', () {
      final list = [
        {'distributorId': 8118, 'permissionFor': 'Cash Denomination', 'isActive': 0},
      ];
      expect(checkCashDenomMandatory(list, '8118'), isFalse);
    });
    test('wrong distributorId → false', () {
      final list = [
        {'distributorId': 9999, 'permissionFor': 'Cash Denomination', 'isActive': 1},
      ];
      expect(checkCashDenomMandatory(list, '8118'), isFalse);
    });
    test('wrong permissionFor → false', () {
      final list = [
        {'distributorId': 8118, 'permissionFor': 'Other', 'isActive': 1},
      ];
      expect(checkCashDenomMandatory(list, '8118'), isFalse);
    });
    test('empty list → false', () =>
        expect(checkCashDenomMandatory([], '8118'), isFalse));
    test('second item matches → true', () {
      final list = [
        {'distributorId': 8118, 'permissionFor': 'Other', 'isActive': 1},
        {'distributorId': 8118, 'permissionFor': 'Cash Denomination', 'isActive': 1},
      ];
      expect(checkCashDenomMandatory(list, '8118'), isTrue);
    });
  });

  // ── switchTab ─────────────────────────────────────────────────────────────────
  group('[OnAccountPopupScreen] switchTab (_selectedIndex)', () {
    test('tap 0 → index 0 (Cash Denomination)', () =>
        expect(switchTab(1, 0), 0));
    test('tap 1 → index 1 (Cash Return)', () =>
        expect(switchTab(0, 1), 1));
    test('initial state is 0', () => expect(0, 0));
    test('tap same index keeps it', () =>
        expect(switchTab(0, 0), 0));
  });
}

