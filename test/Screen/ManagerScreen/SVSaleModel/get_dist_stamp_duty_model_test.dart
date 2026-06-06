import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SVSaleModel/GetDistStampDutyModel.dart';

void main() {
  group('GetDistStampDutyModel', () {
    final sampleJson = {
      'DistributorId': 8118,
      'StampDuty': 100.0,
    };

    test('constructor sets all fields correctly', () {
      final model = GetDistStampDutyModel(
        distributorId: 8118,
        stampDuty: 100.0,
      );

      expect(model.distributorId, 8118);
      expect(model.stampDuty, 100.0);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetDistStampDutyModel.fromJson(sampleJson);

      expect(model.distributorId, 8118);
      expect(model.stampDuty, 100.0);
    });

    test('toJson returns correct map', () {
      final model = GetDistStampDutyModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['DistributorId'], 8118);
      expect(json['StampDuty'], 100.0);
    });

    test('copyWith updates specified fields', () {
      final model = GetDistStampDutyModel.fromJson(sampleJson);
      final updated = model.copyWith(stampDuty: 200.0);

      expect(updated.stampDuty, 200.0);
      expect(model.stampDuty, 100.0);
    });

    test('copyWith preserves distributorId when only stampDuty updated', () {
      final model = GetDistStampDutyModel.fromJson(sampleJson);
      final updated = model.copyWith(stampDuty: 50.0);

      expect(updated.distributorId, model.distributorId);
    });

    test('constructor with null values', () {
      final model = GetDistStampDutyModel();
      expect(model.distributorId, isNull);
      expect(model.stampDuty, isNull);
    });

    test('toJson round-trips correctly', () {
      final original = GetDistStampDutyModel(distributorId: 1000, stampDuty: 75.5);
      final json = original.toJson();
      final restored = GetDistStampDutyModel.fromJson(json);

      expect(restored.distributorId, 1000);
      expect(restored.stampDuty, 75.5);
    });
  });
}

