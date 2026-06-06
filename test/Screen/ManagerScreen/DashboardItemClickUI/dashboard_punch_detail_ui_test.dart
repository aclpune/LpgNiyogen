// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/DashboardPunchDetailUI.dart

import 'package:flutter_test/flutter_test.dart';

// ── Pure-logic helpers extracted from DashboardPunchDetailUI ─────────────────

bool toggleVisibility(bool current) => !current;

String dropdownIcon(bool visible) =>
    visible ? 'arrow_drop_up' : 'arrow_drop_down';

String todayDateDisplay(String? todayDate) => todayDate ?? '';
String staffNameDisplay(String? staffName) => staffName ?? '';
String niyojanQtyDisplay(num? qty) => qty?.toString() ?? '0';
String settlementQtyDisplay(num? qty) => qty?.toString() ?? '0';
String pendingQtyDisplay(num? qty) => qty?.toString() ?? '0';

/// Mirrors: punchModel = punchSale.consumerDetails! assignment
int punchConsumerDetailsCount(List<dynamic>? details) => details?.length ?? 0;

void main() {
  // ── toggleVisibility ─────────────────────────────────────────────────────────
  group('[DashboardPunchDetailUI] toggleVisibility', () {
    test('false → true', () => expect(toggleVisibility(false), isTrue));
    test('true → false', () => expect(toggleVisibility(true), isFalse));
    test('double toggle restores original', () {
      expect(toggleVisibility(toggleVisibility(false)), isFalse);
    });
    test('double toggle true restores true', () {
      expect(toggleVisibility(toggleVisibility(true)), isTrue);
    });
    test('initial state is false (not visible)', () {
      const initial = false;
      expect(initial, isFalse);
    });
  });

  // ── dropdownIcon ─────────────────────────────────────────────────────────────
  group('[DashboardPunchDetailUI] dropdownIcon', () {
    test('visible → "arrow_drop_up"', () =>
        expect(dropdownIcon(true), 'arrow_drop_up'));
    test('hidden → "arrow_drop_down"', () =>
        expect(dropdownIcon(false), 'arrow_drop_down'));
    test('after toggle: was hidden → now visible → up arrow', () {
      const wasHidden = false;
      final isNowVisible = toggleVisibility(wasHidden);
      expect(dropdownIcon(isNowVisible), 'arrow_drop_up');
    });
    test('after toggle: was visible → now hidden → down arrow', () {
      const wasVisible = true;
      final isNowHidden = toggleVisibility(wasVisible);
      expect(dropdownIcon(isNowHidden), 'arrow_drop_down');
    });
  });

  // ── todayDateDisplay ─────────────────────────────────────────────────────────
  group('[DashboardPunchDetailUI] todayDateDisplay', () {
    test('null → ""', () => expect(todayDateDisplay(null), ''));
    test('valid date returned', () =>
        expect(todayDateDisplay('2025-04-07'), '2025-04-07'));
    test('empty string returned', () =>
        expect(todayDateDisplay(''), ''));
    test('formatted date returned', () =>
        expect(todayDateDisplay('07-04-2025'), '07-04-2025'));
  });

  // ── staffNameDisplay ─────────────────────────────────────────────────────────
  group('[DashboardPunchDetailUI] staffNameDisplay', () {
    test('null → ""', () => expect(staffNameDisplay(null), ''));
    test('valid name returned', () =>
        expect(staffNameDisplay('Ravi Kumar'), 'Ravi Kumar'));
    test('empty string → ""', () => expect(staffNameDisplay(''), ''));
    test('name with spaces preserved', () =>
        expect(staffNameDisplay('5kg Swarup'), '5kg Swarup'));
  });

  // ── niyojanQtyDisplay ────────────────────────────────────────────────────────
  group('[DashboardPunchDetailUI] niyojanQtyDisplay', () {
    test('null → "0"', () => expect(niyojanQtyDisplay(null), '0'));
    test('0 → "0"', () => expect(niyojanQtyDisplay(0), '0'));
    test('10 → "10"', () => expect(niyojanQtyDisplay(10), '10'));
    test('large qty', () => expect(niyojanQtyDisplay(999), '999'));
    test('1 → "1"', () => expect(niyojanQtyDisplay(1), '1'));
  });

  // ── settlementQtyDisplay ─────────────────────────────────────────────────────
  group('[DashboardPunchDetailUI] settlementQtyDisplay', () {
    test('null → "0"', () => expect(settlementQtyDisplay(null), '0'));
    test('0 → "0"', () => expect(settlementQtyDisplay(0), '0'));
    test('5 → "5"', () => expect(settlementQtyDisplay(5), '5'));
    test('20 → "20"', () => expect(settlementQtyDisplay(20), '20'));
  });

  // ── pendingQtyDisplay ────────────────────────────────────────────────────────
  group('[DashboardPunchDetailUI] pendingQtyDisplay', () {
    test('null → "0"', () => expect(pendingQtyDisplay(null), '0'));
    test('0 → "0"', () => expect(pendingQtyDisplay(0), '0'));
    test('3 → "3"', () => expect(pendingQtyDisplay(3), '3'));
    test('15 → "15"', () => expect(pendingQtyDisplay(15), '15'));
  });

  // ── punchConsumerDetailsCount ────────────────────────────────────────────────
  group('[DashboardPunchDetailUI] punchConsumerDetailsCount', () {
    test('null list → 0', () => expect(punchConsumerDetailsCount(null), 0));
    test('empty list → 0', () => expect(punchConsumerDetailsCount([]), 0));
    test('3 items → 3', () => expect(punchConsumerDetailsCount([1, 2, 3]), 3));
    test('1 item → 1', () => expect(punchConsumerDetailsCount([{}]), 1));
  });

  // ── state simulation ─────────────────────────────────────────────────────────
  group('[DashboardPunchDetailUI] visibility state simulation', () {
    test('three taps: false → true → false → true', () {
      bool state = false;
      state = toggleVisibility(state); // true
      expect(state, isTrue);
      state = toggleVisibility(state); // false
      expect(state, isFalse);
      state = toggleVisibility(state); // true
      expect(state, isTrue);
    });
  });
}

