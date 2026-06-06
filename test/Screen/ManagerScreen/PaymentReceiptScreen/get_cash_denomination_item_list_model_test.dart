import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/PaymentReceiptScreen/GetCashDenominationItemListModel.dart';

void main() {
  group('GetCashDenominationItemListModel', () {
    final sampleJson = {
      'Id': 1,
      'NoteType': 500.0,
      'isActive': 1,
    };

    test('constructor sets all fields correctly', () {
      final model = GetCashDenominationItemListModel(
        id: 1,
        noteType: 500.0,
        isActive: 1,
      );

      expect(model.id, 1);
      expect(model.noteType, 500.0);
      expect(model.isActive, 1);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetCashDenominationItemListModel.fromJson(sampleJson);

      expect(model.id, 1);
      expect(model.noteType, 500.0);
      expect(model.isActive, 1);
    });

    test('toJson returns correct map', () {
      final model = GetCashDenominationItemListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['Id'], 1);
      expect(json['NoteType'], 500.0);
      expect(json['isActive'], 1);
    });

    test('copyWith updates specified fields', () {
      final model = GetCashDenominationItemListModel.fromJson(sampleJson);
      final updated = model.copyWith(noteType: 100.0, isActive: 0);

      expect(updated.noteType, 100.0);
      expect(updated.isActive, 0);
      expect(model.noteType, 500.0);
      expect(model.isActive, 1);
    });

    test('copyWith preserves id when not overridden', () {
      final model = GetCashDenominationItemListModel.fromJson(sampleJson);
      final updated = model.copyWith(noteType: 200.0);

      expect(updated.id, model.id);
    });

    test('constructor with null values', () {
      final model = GetCashDenominationItemListModel();
      expect(model.id, isNull);
      expect(model.noteType, isNull);
      expect(model.isActive, isNull);
    });

    test('toJson round-trips correctly', () {
      final original = GetCashDenominationItemListModel(id: 5, noteType: 2000.0, isActive: 1);
      final json = original.toJson();
      final restored = GetCashDenominationItemListModel.fromJson(json);

      expect(restored.id, 5);
      expect(restored.noteType, 2000.0);
      expect(restored.isActive, 1);
    });
  });
}

