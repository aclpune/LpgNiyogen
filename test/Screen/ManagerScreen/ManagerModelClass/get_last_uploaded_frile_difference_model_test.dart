import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetLastUploadedFrileDifferenceModel.dart';

void main() {
  group('GetLastUploadedFrileDifferenceModel', () {
    final sampleJson = {
      'DistributorId': 0,
      'LastUploadedDatePrepaidBkg': '0001-01-01T00:00:00',
      'LastUploadedDatePrepaidBkgSettle': '0001-01-01T00:00:00',
      'BkgHrDiff': 1,
      'SettHrDiff': 1,
    };

    test('fromJson parses all fields correctly', () {
      final model = GetLastUploadedFrileDifferenceModel.fromJson(sampleJson);
      expect(model.distributorId, 0);
      expect(model.lastUploadedDatePrepaidBkg, '0001-01-01T00:00:00');
      expect(model.lastUploadedDatePrepaidBkgSettle, '0001-01-01T00:00:00');
      expect(model.bkgHrDiff, 1);
      expect(model.settHrDiff, 1);
    });

    test('toJson returns correct map', () {
      final model = GetLastUploadedFrileDifferenceModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['DistributorId'], 0);
      expect(json['BkgHrDiff'], 1);
      expect(json['SettHrDiff'], 1);
    });

    test('copyWith updates specified fields', () {
      final model = GetLastUploadedFrileDifferenceModel.fromJson(sampleJson);
      final updated = model.copyWith(bkgHrDiff: 5, settHrDiff: 3);
      expect(updated.bkgHrDiff, 5);
      expect(updated.settHrDiff, 3);
      expect(model.bkgHrDiff, 1);
    });

    test('default constructor with null values', () {
      final model = GetLastUploadedFrileDifferenceModel();
      expect(model.distributorId, isNull);
      expect(model.bkgHrDiff, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetLastUploadedFrileDifferenceModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetLastUploadedFrileDifferenceModel.fromJson(json);
      expect(model2.distributorId, model.distributorId);
      expect(model2.bkgHrDiff, model.bkgHrDiff);
      expect(model2.settHrDiff, model.settHrDiff);
    });
  });
}

