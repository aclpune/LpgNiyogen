import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetSVARBManagerDashboardCountModel.dart';

void main() {
  group('GetSvarbManagerDashboardCountModel', () {
    final sampleJson = {
      'DistributorId': 8118,
      'SVGrossRevenue': 472.00,
      'ARBGrossRevenue': 27147.00,
      'ARBGrossProfit': -43553.00,
      'RefillGrossRevenue': 191342.50,
      'RefillGrossProfit': 27875.00,
    };

    test('fromJson parses all fields correctly', () {
      final model = GetSvarbManagerDashboardCountModel.fromJson(sampleJson);
      expect(model.distributorId, 8118);
      expect(model.sVGrossRevenue, 472.00);
      expect(model.aRBGrossRevenue, 27147.00);
      expect(model.aRBGrossProfit, -43553.00);
      expect(model.refillGrossRevenue, 191342.50);
      expect(model.refillGrossProfit, 27875.00);
    });

    test('toJson returns correct map', () {
      final model = GetSvarbManagerDashboardCountModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['DistributorId'], 8118);
      expect(json['SVGrossRevenue'], 472.00);
      expect(json['ARBGrossProfit'], -43553.00);
    });

    test('copyWith updates specified fields', () {
      final model = GetSvarbManagerDashboardCountModel.fromJson(sampleJson);
      final updated = model.copyWith(sVGrossRevenue: 1000.0, refillGrossProfit: 5000.0);
      expect(updated.sVGrossRevenue, 1000.0);
      expect(updated.refillGrossProfit, 5000.0);
      expect(model.sVGrossRevenue, 472.00);
    });

    test('negative profit value is preserved', () {
      final model = GetSvarbManagerDashboardCountModel.fromJson(sampleJson);
      expect(model.aRBGrossProfit, isNegative);
    });

    test('default constructor with null values', () {
      final model = GetSvarbManagerDashboardCountModel();
      expect(model.distributorId, isNull);
      expect(model.sVGrossRevenue, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetSvarbManagerDashboardCountModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetSvarbManagerDashboardCountModel.fromJson(json);
      expect(model2.distributorId, model.distributorId);
      expect(model2.aRBGrossProfit, model.aRBGrossProfit);
      expect(model2.refillGrossRevenue, model.refillGrossRevenue);
    });
  });
}

