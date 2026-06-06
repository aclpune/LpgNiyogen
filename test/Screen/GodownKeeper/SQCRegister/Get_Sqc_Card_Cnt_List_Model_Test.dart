
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/SQCRegister/GetSqcCardCntListModel.dart';

void main() {
  group('GetSqcCardCntListModel', () {
	test('fromJson -> getters and toJson', () {
	  final json = {
		'TodayTruckIn': 1,
		'TodaySQCDone': 2,
		'TodayNotDone': -1,
		'TodayBodyLeak': 3,
		'TodayLessQtyCyls': 0,
		'MonthTruckIn': 10,
		'MonthSQCDone': 20,
		'MonthNotDone': -10,
		'MonthBodyLeak': 15,
		'MonthLessQtyCyls': 0,
		'VehicleNo': 'MH12AB1234',
		'SQCStatus': 'OK',
	  };

	  final model = GetSqcCardCntListModel.fromJson(json);
	  expect(model.todayTruckIn, 1);
	  expect(model.todaySQCDone, 2);
	  expect(model.todayNotDone, -1);
	  expect(model.todayBodyLeak, 3);
	  expect(model.monthTruckIn, 10);
	  expect(model.vehicleNo, 'MH12AB1234');
	  expect(model.sQCStatus, 'OK');

	  final encoded = model.toJson();
	  expect(encoded['TodayTruckIn'], 1);
	  expect(encoded['MonthSQCDone'], 20);
	  expect(encoded['VehicleNo'], 'MH12AB1234');
	});

	test('copyWith returns modified copy without changing original', () {
	  final original = GetSqcCardCntListModel(
		todayTruckIn: 5,
		todaySQCDone: 6,
		vehicleNo: 'V1',
		sQCStatus: 'P',
	  );

	  final changed = original.copyWith(todayTruckIn: 7, vehicleNo: 'V2');
	  expect(original.todayTruckIn, 5);
	  expect(original.vehicleNo, 'V1');
	  expect(changed.todayTruckIn, 7);
	  expect(changed.vehicleNo, 'V2');
	  // unchanged fields should be preserved
	  expect(changed.todaySQCDone, 6);
	});
  });
}


