import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/PaymentModeModel.dart';

void main() {
  group('PaymentModeModel', () {
    final sampleJson = {
      'Payment mode': 'Bank',
    };

    test('constructor sets paymentmode correctly', () {
      final model = PaymentModeModel(paymentmode: 'Cash');
      expect(model.paymentmode, 'Cash');
    });

    test('fromJson parses paymentmode correctly', () {
      final model = PaymentModeModel.fromJson(sampleJson);
      expect(model.paymentmode, 'Bank');
    });

    test('toJson returns correct map', () {
      final model = PaymentModeModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['Payment mode'], 'Bank');
    });

    test('copyWith updates paymentmode', () {
      final model = PaymentModeModel.fromJson(sampleJson);
      final updated = model.copyWith(paymentmode: 'Online');
      expect(updated.paymentmode, 'Online');
      expect(model.paymentmode, 'Bank');
    });

    test('default constructor with null value', () {
      final model = PaymentModeModel();
      expect(model.paymentmode, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = PaymentModeModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = PaymentModeModel.fromJson(json);
      expect(model2.paymentmode, model.paymentmode);
    });

    test('all payment modes are parseable', () {
      for (final mode in ['Cash', 'Online', 'Bank', 'Credit']) {
        final model = PaymentModeModel.fromJson({'Payment mode': mode});
        expect(model.paymentmode, mode);
      }
    });
  });
}

