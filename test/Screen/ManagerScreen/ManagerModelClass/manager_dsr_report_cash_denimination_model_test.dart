import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDSRReportCashDeniminationModel.dart';

void main() {
  group('ManagerDsrReportCashDeniminationModel', () {
    final sampleJson = {
      'Date': '0001-01-01T00:00:00',
      'StaffId': 0,
      'PaymentId': 0,
      'DistributorId': 0,
      'NoteId': 1,
      'NoteType': 500.00,
      'Qty': 16,
      'Amount': 8000.00,
      'RetNoteQty': 0,
      'RetNoteAmt': 0.0,
      'totalAmount': 8000.0,
      'totalAmountminus': 0.0,
    };

    test('fromJson parses all fields correctly', () {
      final model = ManagerDsrReportCashDeniminationModel.fromJson(sampleJson);
      expect(model.date, '0001-01-01T00:00:00');
      expect(model.noteId, 1);
      expect(model.noteType, 500.00);
      expect(model.qty, 16);
      expect(model.amount, 8000.00);
      expect(model.retNoteQty, 0);
      expect(model.totalAmount, 8000.0);
      expect(model.totalAmountminus, 0.0);
    });

    test('toJson returns correct map', () {
      final model = ManagerDsrReportCashDeniminationModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['NoteType'], 500.00);
      expect(json['Qty'], 16);
      expect(json['Amount'], 8000.00);
      expect(json['totalAmount'], 8000.0);
    });

    test('copyWith updates specified fields', () {
      final model = ManagerDsrReportCashDeniminationModel.fromJson(sampleJson);
      final updated = model.copyWith(qty: 20, amount: 10000.0);
      expect(updated.qty, 20);
      expect(updated.amount, 10000.0);
      expect(model.qty, 16);
    });

    test('default constructor with null values', () {
      final model = ManagerDsrReportCashDeniminationModel();
      expect(model.noteType, isNull);
      expect(model.qty, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = ManagerDsrReportCashDeniminationModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = ManagerDsrReportCashDeniminationModel.fromJson(json);
      expect(model2.noteType, model.noteType);
      expect(model2.qty, model.qty);
      expect(model2.amount, model.amount);
    });

    test('amount equals noteType * qty', () {
      final model = ManagerDsrReportCashDeniminationModel.fromJson(sampleJson);
      expect(model.amount, model.noteType! * model.qty!);
    });
  });
}

