
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/SQCRegister/GetSQCFilledCylListModel.dart';

void main() {
  group('GetSqcFilledCylListModel', () {
	test('fromJson sets fields correctly and toJson returns expected map', () {
	  final json = {
		'DistributorId': 0,
		'FromDate': null,
		'ToDate': null,
		'SQCId': 2,
		'GodownId': 1,
		'ReceiptDate': '2026-03-13T00:00:00',
		'VehicleNo': 'Mh15kh5681',
		'ItemId': 5,
		'TareWt': 6.00,
		'GrossWt': 8.00,
		'ObservedWt': 8.10,
		'Variation': -0.10,
		'DPTDate': 'S-25',
		'SealingCond': 'Y',
		'LeakyBdy': 20,
		'SerialNo': 'SRL536',
		'Remarks': 'okayn.,mn,mn,m',
		'AddedBy': null,
		'AddedOn': null,
		'UploadFileName': '2_8118_20260313174912.png',
		'LastUpdatedOn': null,
		'ItemName': '2 KG FTL',
		'Action': null,
		'Leakage': 'Y',
		'Platform': null,
		'UpdatedBy': 0,
		'LeakName': 'Underweight',
		'UploadFilePath': 'https://aadyaminfotech.com/lpgniyojanuatapi/SQCFile/2_8118_20260313174912.png',
	  };

	  final model = GetSqcFilledCylListModel.fromJson(json);

	  expect(model.sQCId, 2);
	  expect(model.godownId, 1);
	  expect(model.receiptDate, '2026-03-13T00:00:00');
	  expect(model.vehicleNo, 'Mh15kh5681');
	  expect(model.itemId, 5);
	  expect(model.tareWt, 6.00);
	  expect(model.grossWt, 8.00);
	  expect(model.observedWt, 8.10);
	  expect(model.variation, -0.10);
	  expect(model.serialNo, 'SRL536');
	  expect(model.uploadFileName, '2_8118_20260313174912.png');
	  expect(model.itemName, '2 KG FTL');
	  expect(model.leakage, 'Y');
	  expect(model.leakName, 'Underweight');
	  expect(model.uploadFilePath, isNotNull);

	  final encoded = model.toJson();
	  expect(encoded['SQCId'], 2);
	  expect(encoded['VehicleNo'], 'Mh15kh5681');
	  expect(encoded['UploadFilePath'], json['UploadFilePath']);
	});

	test('copyWith returns a modified copy and leaves original unchanged', () {
	  final original = GetSqcFilledCylListModel(
		sQCId: 10,
		vehicleNo: 'V1',
		itemName: 'Old',
		tareWt: 1.5,
	  );

	  final modified = original.copyWith(vehicleNo: 'V2', itemName: 'New', tareWt: 2.0);

	  // original unchanged
	  expect(original.sQCId, 10);
	  expect(original.vehicleNo, 'V1');
	  expect(original.itemName, 'Old');
	  expect(original.tareWt, 1.5);

	  // modified has new values
	  expect(modified.sQCId, 10);
	  expect(modified.vehicleNo, 'V2');
	  expect(modified.itemName, 'New');
	  expect(modified.tareWt, 2.0);
	});

	test('handles missing keys (nulls) gracefully', () {
	  final json = <String, dynamic>{}; // empty
	  final model = GetSqcFilledCylListModel.fromJson(json);

	  expect(model.sQCId, isNull);
	  expect(model.vehicleNo, isNull);
	  expect(model.uploadFilePath, isNull);

	  final encoded = model.toJson();
	  // toJson should include keys with null values
	  expect(encoded.containsKey('SQCId'), true);
	  expect(encoded['VehicleNo'], isNull);
	});
  });
}


