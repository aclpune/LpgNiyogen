// Tests for: lib/Screen/ManagerScreen/ExpensesScreen/GetDashboardFYGrossExpenseDtlsModel.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ExpensesScreen/GetDashboardFYGrossExpenseDtlsModel.dart';

void main() {
  // ── fromJson ──────────────────────────────────────────────────────────────
  group('[GetDashboardFyGrossExpenseDtlsModel] fromJson', () {
    final json = {
      'April': 0.0, 'May': 0.0, 'June': 500.0, 'July': 0.0,
      'August': 1200.0, 'September': 0.0, 'October': 800.0,
      'November': 0.0, 'December': 300.0, 'January': 0.0,
      'February': 90593.0, 'March': 140314.0,
    };

    test('parses April', () =>
        expect(GetDashboardFyGrossExpenseDtlsModel.fromJson(json).april, 0.0));
    test('parses June', () =>
        expect(GetDashboardFyGrossExpenseDtlsModel.fromJson(json).june, 500.0));
    test('parses August', () =>
        expect(GetDashboardFyGrossExpenseDtlsModel.fromJson(json).august, 1200.0));
    test('parses October', () =>
        expect(GetDashboardFyGrossExpenseDtlsModel.fromJson(json).october, 800.0));
    test('parses December', () =>
        expect(GetDashboardFyGrossExpenseDtlsModel.fromJson(json).december, 300.0));
    test('parses February', () =>
        expect(GetDashboardFyGrossExpenseDtlsModel.fromJson(json).february, 90593.0));
    test('parses March', () =>
        expect(GetDashboardFyGrossExpenseDtlsModel.fromJson(json).march, 140314.0));
    test('null field stays null', () {
      final j = <String, dynamic>{'April': null};
      expect(GetDashboardFyGrossExpenseDtlsModel.fromJson(j).april, isNull);
    });
  });

  // ── default constructor ────────────────────────────────────────────────────
  group('[GetDashboardFyGrossExpenseDtlsModel] default constructor', () {
    test('all fields null by default', () {
      final m = GetDashboardFyGrossExpenseDtlsModel();
      expect(m.april,     isNull);
      expect(m.may,       isNull);
      expect(m.june,      isNull);
      expect(m.july,      isNull);
      expect(m.august,    isNull);
      expect(m.september, isNull);
      expect(m.october,   isNull);
      expect(m.november,  isNull);
      expect(m.december,  isNull);
      expect(m.january,   isNull);
      expect(m.february,  isNull);
      expect(m.march,     isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('[GetDashboardFyGrossExpenseDtlsModel] toJson', () {
    test('round-trips February and March', () {
      final m = GetDashboardFyGrossExpenseDtlsModel(
          february: 90593.0, march: 140314.0);
      final map = m.toJson();
      expect(map['February'], 90593.0);
      expect(map['March'],    140314.0);
    });
    test('has 12 keys', () {
      final m = GetDashboardFyGrossExpenseDtlsModel();
      expect(m.toJson().keys.length, 12);
    });
    test('contains all month keys', () {
      final keys = GetDashboardFyGrossExpenseDtlsModel().toJson().keys.toSet();
      expect(keys, containsAll([
        'April','May','June','July','August','September',
        'October','November','December','January','February','March',
      ]));
    });
    test('null values in toJson', () {
      final m = GetDashboardFyGrossExpenseDtlsModel();
      expect(m.toJson()['April'], isNull);
    });
    test('non-null value preserved in toJson', () {
      final m = GetDashboardFyGrossExpenseDtlsModel(june: 500.0);
      expect(m.toJson()['June'], 500.0);
    });
  });

  // ── copyWith ──────────────────────────────────────────────────────────────
  group('[GetDashboardFyGrossExpenseDtlsModel] copyWith', () {
    test('overrides only specified field', () {
      final m = GetDashboardFyGrossExpenseDtlsModel(
          february: 90593.0, march: 140314.0);
      final copy = m.copyWith(march: 999.0);
      expect(copy.february, 90593.0);
      expect(copy.march,    999.0);
    });
    test('no override → all original values', () {
      final m = GetDashboardFyGrossExpenseDtlsModel(april: 100.0, may: 200.0);
      final copy = m.copyWith();
      expect(copy.april, 100.0);
      expect(copy.may,   200.0);
    });
    test('override multiple fields', () {
      final m = GetDashboardFyGrossExpenseDtlsModel(
          january: 1000.0, february: 2000.0, march: 3000.0);
      final copy = m.copyWith(january: 9999.0, march: 8888.0);
      expect(copy.january,  9999.0);
      expect(copy.february, 2000.0);
      expect(copy.march,    8888.0);
    });
  });

  // ── getters ───────────────────────────────────────────────────────────────
  group('[GetDashboardFyGrossExpenseDtlsModel] getters', () {
    final m = GetDashboardFyGrossExpenseDtlsModel(
      april: 1.0, may: 2.0, june: 3.0, july: 4.0,
      august: 5.0, september: 6.0, october: 7.0, november: 8.0,
      december: 9.0, january: 10.0, february: 11.0, march: 12.0,
    );
    test('april getter', () => expect(m.april, 1.0));
    test('may getter', () => expect(m.may, 2.0));
    test('june getter', () => expect(m.june, 3.0));
    test('july getter', () => expect(m.july, 4.0));
    test('august getter', () => expect(m.august, 5.0));
    test('september getter', () => expect(m.september, 6.0));
    test('october getter', () => expect(m.october, 7.0));
    test('november getter', () => expect(m.november, 8.0));
    test('december getter', () => expect(m.december, 9.0));
    test('january getter', () => expect(m.january, 10.0));
    test('february getter', () => expect(m.february, 11.0));
    test('march getter', () => expect(m.march, 12.0));
  });
}

