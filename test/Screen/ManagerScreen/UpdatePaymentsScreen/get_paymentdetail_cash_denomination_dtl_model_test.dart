import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/UpdatePaymentsScreen/GetPaymentdetailCashDenominationDtlModel.dart';

void main() {
  group('GetPaymentdetailCashDenominationDtlModel', () {
    final sampleJson = {
      'PaymentId': 708,
      'DistributorId': 8118,
      'NoteId': 1,
      'NoteType': 500.00,
      'Qty': 20,
      'Amount': 10000.00,
      'RetNoteQty': 0,
      'RetNoteAmt': 0.00,
      'totalAmount': 20000,
      'totalAmountminus': 0,
    };

    test('constructor sets all fields correctly', () {
      final model = GetPaymentdetailCashDenominationDtlModel(
        paymentId: 708,
        distributorId: 8118,
        noteId: 1,
        noteType: 500.00,
        qty: 20,
        amount: 10000.00,
        retNoteQty: 0,
        retNoteAmt: 0.00,
        totalAmount: 20000,
        totalAmountminus: 0,
      );

      expect(model.paymentId, 708);
      expect(model.distributorId, 8118);
      expect(model.noteId, 1);
      expect(model.noteType, 500.00);
      expect(model.qty, 20);
      expect(model.amount, 10000.00);
      expect(model.retNoteQty, 0);
      expect(model.retNoteAmt, 0.00);
      expect(model.totalAmount, 20000);
      expect(model.totalAmountminus, 0);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetPaymentdetailCashDenominationDtlModel.fromJson(sampleJson);

      expect(model.paymentId, 708);
      expect(model.distributorId, 8118);
      expect(model.noteId, 1);
      expect(model.noteType, 500.00);
      expect(model.qty, 20);
      expect(model.amount, 10000.00);
      expect(model.retNoteQty, 0);
      expect(model.retNoteAmt, 0.00);
      expect(model.totalAmount, 20000);
      expect(model.totalAmountminus, 0);
    });

    test('toJson returns correct map', () {
      final model = GetPaymentdetailCashDenominationDtlModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['PaymentId'], 708);
      expect(json['DistributorId'], 8118);
      expect(json['NoteId'], 1);
      expect(json['NoteType'], 500.00);
      expect(json['Qty'], 20);
      expect(json['Amount'], 10000.00);
      expect(json['RetNoteQty'], 0);
      expect(json['RetNoteAmt'], 0.00);
      expect(json['totalAmount'], 20000);
      expect(json['totalAmountminus'], 0);
    });

    test('toJson includes all keys', () {
      final model = GetPaymentdetailCashDenominationDtlModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json.containsKey('PaymentId'), isTrue);
      expect(json.containsKey('DistributorId'), isTrue);
      expect(json.containsKey('NoteId'), isTrue);
      expect(json.containsKey('NoteType'), isTrue);
      expect(json.containsKey('Qty'), isTrue);
      expect(json.containsKey('Amount'), isTrue);
      expect(json.containsKey('RetNoteQty'), isTrue);
      expect(json.containsKey('RetNoteAmt'), isTrue);
      expect(json.containsKey('totalAmount'), isTrue);
      expect(json.containsKey('totalAmountminus'), isTrue);
    });

    test('copyWith updates specified fields', () {
      final model = GetPaymentdetailCashDenominationDtlModel.fromJson(sampleJson);
      final updated = model.copyWith(qty: 30, amount: 15000.00);

      expect(updated.qty, 30);
      expect(updated.amount, 15000.00);
      expect(model.qty, 20);
      expect(model.amount, 10000.00);
    });

    test('copyWith preserves non-updated fields', () {
      final model = GetPaymentdetailCashDenominationDtlModel.fromJson(sampleJson);
      final updated = model.copyWith(retNoteQty: 5);

      expect(updated.paymentId, model.paymentId);
      expect(updated.noteType, model.noteType);
      expect(updated.totalAmount, model.totalAmount);
      expect(updated.retNoteQty, 5);
    });

    test('default constructor with null values', () {
      final model = GetPaymentdetailCashDenominationDtlModel();

      expect(model.paymentId, isNull);
      expect(model.noteType, isNull);
      expect(model.qty, isNull);
      expect(model.amount, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetPaymentdetailCashDenominationDtlModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetPaymentdetailCashDenominationDtlModel.fromJson(json);

      expect(model2.paymentId, model.paymentId);
      expect(model2.noteType, model.noteType);
      expect(model2.qty, model.qty);
      expect(model2.amount, model.amount);
      expect(model2.totalAmount, model.totalAmount);
    });

    test('amount calculation: qty * noteType equals amount', () {
      final model = GetPaymentdetailCashDenominationDtlModel.fromJson(sampleJson);
      // 20 notes × ₹500 = ₹10000
      expect(model.qty!.toDouble() * model.noteType!.toDouble(), model.amount!.toDouble());
    });
  });
}

