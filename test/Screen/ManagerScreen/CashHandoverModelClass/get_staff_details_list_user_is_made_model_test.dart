import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/CashHandoverModelClass/GetStaffDetailsListUserIsMadeModel.dart';

void main() {
  final fullJson = {
    'DistributorId': 0, 'UserId': 69, 'StaffId': 214,
    'StaffNo': 'SN/035', 'StaffName': 'Snehal',
    'OwnerAddress': null, 'ContactPhone': null, 'Ownerstatus': 1,
  };

  group('GetStaffDetailsListUserIsMadeModel.fromJson', () {
    test('parses all 8 fields', () {
      final m = GetStaffDetailsListUserIsMadeModel.fromJson(fullJson);
      expect(m.distributorId, 0); expect(m.userId, 69);
      expect(m.staffId, 214); expect(m.staffNo, 'SN/035');
      expect(m.staffName, 'Snehal'); expect(m.ownerAddress, isNull);
      expect(m.contactPhone, isNull); expect(m.ownerstatus, 1);
    });
    test('handles empty JSON', () {
      final m = GetStaffDetailsListUserIsMadeModel.fromJson({});
      expect(m.staffId, isNull); expect(m.staffName, isNull);
    });
    test('handles null contactPhone and ownerAddress', () {
      final m = GetStaffDetailsListUserIsMadeModel.fromJson(fullJson);
      expect(m.contactPhone, isNull); expect(m.ownerAddress, isNull);
    });
  });

  group('GetStaffDetailsListUserIsMadeModel.toJson', () {
    test('serialises 8 fields', () {
      final j = GetStaffDetailsListUserIsMadeModel.fromJson(fullJson).toJson();
      expect(j.length, 8);
      expect(j['StaffName'], 'Snehal'); expect(j['StaffNo'], 'SN/035');
    });
    test('round-trips correctly', () {
      final o = GetStaffDetailsListUserIsMadeModel.fromJson(fullJson);
      final r = GetStaffDetailsListUserIsMadeModel.fromJson(o.toJson());
      expect(r.staffId, o.staffId); expect(r.staffName, o.staffName);
    });
  });

  group('GetStaffDetailsListUserIsMadeModel.copyWith', () {
    test('replaces staffName', () {
      final m = GetStaffDetailsListUserIsMadeModel.fromJson(fullJson);
      expect(m.copyWith(staffName: 'Raj').staffName, 'Raj');
    });
    test('replaces ownerstatus', () {
      final m = GetStaffDetailsListUserIsMadeModel.fromJson(fullJson);
      expect(m.copyWith(ownerstatus: 0).ownerstatus, 0);
    });
    test('preserves all without args', () {
      final m = GetStaffDetailsListUserIsMadeModel.fromJson(fullJson);
      expect(m.copyWith().staffNo, m.staffNo);
    });
  });

  group('Staff details – business logic', () {
    test('ownerstatus 1 means active staff', () {
      final m = GetStaffDetailsListUserIsMadeModel.fromJson(fullJson);
      expect(m.ownerstatus, 1);
    });
    test('staffNo follows SN/nnn pattern', () {
      final m = GetStaffDetailsListUserIsMadeModel.fromJson(fullJson);
      expect(m.staffNo!.startsWith('SN/'), isTrue);
    });
    test('userId is positive', () {
      final m = GetStaffDetailsListUserIsMadeModel.fromJson(fullJson);
      expect((m.userId ?? 0) > 0, isTrue);
    });
    test('staffId is positive', () {
      final m = GetStaffDetailsListUserIsMadeModel.fromJson(fullJson);
      expect((m.staffId ?? 0) > 0, isTrue);
    });
  });
}

