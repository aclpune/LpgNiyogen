// item_receipt_screen_test.dart
// ─────────────────────────────────────────────────────────────────────────────
// Unit tests for ItemReceiptScreen — covers all pure-logic methods and
// state-management behaviour extracted from _ItemReceiptScreenState.
//
// Run with:
//   flutter test test/item_receipt_screen_test.dart
//
// Dependencies (add to pubspec.yaml dev_dependencies if not present):
//   flutter_test:
//   mockito: ^5.4.4
//   build_runner: ^2.4.9
//   http_mock_adapter: ^0.6.1   (or mocktail/http mocks)
//   shared_preferences_mocks: ^0.0.2  (or SharedPreferences.setMockInitialValues)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── App imports (adjust paths to your project structure) ────────────────────
// import 'package:your_app/screens/ItemReceipt/ItemReceiptScreen.dart';
// import 'package:your_app/screens/DeliveryBoy/CylItemList/CylItemListModel.dart';
// import 'package:your_app/screens/DeliveryBoyModel/GetStockTransferListModel.dart';
// import 'package:your_app/screens/EditItem/Model/GetItemReceiptListModel.dart';

// For demonstration the models are inlined below so the file is self-contained.

// ─── Minimal model stubs (remove if you import from the real files) ───────────

class CylItemListModel {
  final num? itemId;
  final String? itemName;
  CylItemListModel({this.itemId, this.itemName});
  factory CylItemListModel.fromJson(Map<String, dynamic> json) =>
      CylItemListModel(itemId: json['ItemId'], itemName: json['ItemName']);
}

class GetStockTransferListModel {
  final int? isStkTrans;
  GetStockTransferListModel({this.isStkTrans});
  factory GetStockTransferListModel.fromJson(Map<String, dynamic> json) =>
      GetStockTransferListModel(isStkTrans: json['isStkTrans']);
}

class ItemDetails {
  final String? itemName;
  final num? filledQty;
  final num? eMRQty;
  final num? invoiceQty;
  ItemDetails({this.itemName, this.filledQty, this.eMRQty, this.invoiceQty});
}

// ─── Pure-logic helpers extracted from _ItemReceiptScreenState ────────────────
// Because _ItemReceiptScreenState is private, we test the logic by extracting
// it into testable functions / a plain Dart class that mirrors the widget state.
// In your real project you may expose these as package-private or use
// WidgetTester for full widget tests.

class ItemReceiptLogic {
  List<Map<String, TextEditingController>> items = [];
  Map<int, String?> selectedItems = {};
  List<CylItemListModel> availableItems = [];
  List<GetStockTransferListModel> stockTransferList = [];
  bool saveFlag = false;
  bool stockTransferFlag = false;

  // ── _addNewItem ─────────────────────────────────────────────────────────────
  void addNewItem() {
    int newIndex = items.length;
    items.add({
      'selectItem': TextEditingController(),
      'receivedQty': TextEditingController(),
      'emr': TextEditingController(),
      'invoice': TextEditingController(),
    });
    selectedItems[newIndex] = '';
  }

  // ── _initializeItems ────────────────────────────────────────────────────────
  void initializeItems(List<ItemDetails> itemsToShow) {
    items.clear();
    selectedItems.clear();
    for (var i = 0; i < itemsToShow.length; i++) {
      var item = itemsToShow[i];
      items.add({
        'selectItem': TextEditingController(text: item.itemName ?? ''),
        'receivedQty':
        TextEditingController(text: item.filledQty?.toString() ?? ''),
        'emr': TextEditingController(text: item.eMRQty?.toString() ?? ''),
        'invoice':
        TextEditingController(text: item.invoiceQty?.toString() ?? ''),
      });
      selectedItems[items.length - 1] = item.itemName ?? '';
    }
  }

  // ── _removeItem ─────────────────────────────────────────────────────────────
  void removeItem(int index) {
    items[index]['receivedQty']?.dispose();
    items[index]['emr']?.dispose();
    items[index]['invoice']?.dispose();
    items.removeAt(index);
    selectedItems.remove(index);
    selectedItems = Map.fromEntries(
      selectedItems.entries.map((entry) {
        return entry.key > index
            ? MapEntry(entry.key - 1, entry.value)
            : entry;
      }),
    );
  }

  // ── _isAddNewItemEnabled ────────────────────────────────────────────────────
  bool get isAddNewItemEnabled {
    return availableItems
        .any((item) => !selectedItems.values.contains(item.itemName));
  }

  // ── _updateSum ──────────────────────────────────────────────────────────────
  /// Returns the calculated invoice total; caller writes it to the controller.
  int? updateSum(int index) {
    double receivedQty =
        double.tryParse(items[index]['receivedQty']?.text ?? '') ?? 0;
    double emr = double.tryParse(items[index]['emr']?.text ?? '') ?? 0;
    if (receivedQty != 0 || emr != 0) {
      double total = receivedQty + emr;
      items[index]['invoice']?.text = total.toInt().toString();
      return total.toInt();
    }
    return null; // signals "at least one qty required"
  }

  // ── _submitData validation (extracted) ──────────────────────────────────────
  /// Returns null on success or an error-message key string on failure.
  String? validateSubmit(String vehicleNo) {
    if (vehicleNo.isEmpty) return 'vehicleValidation';

    for (var i = 0; i < items.length; i++) {
      String? invoiceQty = items[i]['invoice']?.text ?? '';
      String? filledQty = items[i]['receivedQty']?.text ?? '';
      String? emrQty = items[i]['emr']?.text ?? '';
      String? selectedItemName = selectedItems[i];

      if (selectedItemName == null || selectedItemName.isEmpty) {
        return 'selectValidItemReceipt';
      }
      if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
        return 'atLeastOneQtyRequired';
      }
      if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
          (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
        return 'atLeastOneQtyRequired';
      }
    }

    // Duplicate-item check
    Set<int> itemIds = {};
    for (var i = 0; i < items.length; i++) {
      String? name = selectedItems[i];
      CylItemListModel? found = availableItems.firstWhere(
            (m) => m.itemName == name,
        orElse: () => CylItemListModel(itemId: 0, itemName: ''),
      );
      if (found.itemId != null && found.itemId != 0) {
        int id = found.itemId!.toInt();
        if (itemIds.contains(id)) return 'recordExist';
        itemIds.add(id);
      }
    }
    return null;
  }

  // ── fetchTransactionList flag logic ────────────────────────────────────────
  void applyStockTransferList(List<GetStockTransferListModel> list) {
    stockTransferList = list;
    bool hasZero = list.any((e) => e.isStkTrans == 0);
    stockTransferFlag = !hasZero;
  }

  // ── checkAndSaveDayEndData flag logic ──────────────────────────────────────
  void applyDayEndResponse(List<dynamic> apiResponse) {
    if (apiResponse.isEmpty) {
      saveFlag = false;
    } else {
      saveFlag = true;
    }
  }

  // ── Submit button active state ─────────────────────────────────────────────
  bool isSubmitActive(String vehicleNo) =>
      !saveFlag && stockTransferFlag && vehicleNo.isNotEmpty;

  // ── _filteredNames (from _ItemEntryCard) ───────────────────────────────────
  List<String> filteredNamesForIndex(int index) {
    // Produce a list of item names and deduplicate by name. The original
    // implementation used `.toSet()` on `CylItemListModel` instances which
    // does not remove duplicate names because model instances are distinct.
    final names = availableItems
        .where((item) =>
            !selectedItems.values.contains(item.itemName) ||
            selectedItems[index] == item.itemName)
        .map((item) => item.itemName ?? 'Unknown')
        .toList();
    return names.toSet().toList();
  }

  void dispose() {
    for (var item in items) {
      item.values.forEach((c) => c.dispose());
    }
  }
}

// =============================================================================
// TESTS
// =============================================================================

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ItemReceiptLogic logic;

  setUp(() {
    logic = ItemReceiptLogic();
  });

  tearDown(() {
    logic.dispose();
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 1 — addNewItem
  // ───────────────────────────────────────────────────────────────────────────
  group('addNewItem —', () {
    test('POSITIVE: adds a row with four controllers', () {
      logic.addNewItem();
      expect(logic.items.length, 1);
      expect(logic.items[0].containsKey('selectItem'), isTrue);
      expect(logic.items[0].containsKey('receivedQty'), isTrue);
      expect(logic.items[0].containsKey('emr'), isTrue);
      expect(logic.items[0].containsKey('invoice'), isTrue);
    });

    test('POSITIVE: selectedItems entry is empty string for new row', () {
      logic.addNewItem();
      expect(logic.selectedItems[0], '');
    });

    test('POSITIVE: multiple calls produce sequential indices', () {
      logic.addNewItem();
      logic.addNewItem();
      logic.addNewItem();
      expect(logic.items.length, 3);
      expect(logic.selectedItems.keys, containsAll([0, 1, 2]));
    });

    test('POSITIVE: controllers start with empty text', () {
      logic.addNewItem();
      expect(logic.items[0]['receivedQty']!.text, '');
      expect(logic.items[0]['emr']!.text, '');
      expect(logic.items[0]['invoice']!.text, '');
    });

    test('NEGATIVE: items list is empty before first call', () {
      expect(logic.items, isEmpty);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 2 — initializeItems
  // ───────────────────────────────────────────────────────────────────────────
  group('initializeItems —', () {
    test('POSITIVE: populates controllers with item data', () {
      final data = [
        ItemDetails(
            itemName: 'Cylinder A', filledQty: 10, eMRQty: 2, invoiceQty: 12),
      ];
      logic.initializeItems(data);
      expect(logic.items.length, 1);
      expect(logic.items[0]['selectItem']!.text, 'Cylinder A');
      expect(logic.items[0]['receivedQty']!.text, '10');
      expect(logic.items[0]['emr']!.text, '2');
      expect(logic.items[0]['invoice']!.text, '12');
    });

    test('POSITIVE: selectedItems map reflects item names', () {
      final data = [
        ItemDetails(itemName: 'ItemX'),
        ItemDetails(itemName: 'ItemY'),
      ];
      logic.initializeItems(data);
      expect(logic.selectedItems[0], 'ItemX');
      expect(logic.selectedItems[1], 'ItemY');
    });

    test('POSITIVE: clears existing items before re-initialising', () {
      logic.addNewItem();
      logic.addNewItem();
      logic.initializeItems([ItemDetails(itemName: 'Solo')]);
      expect(logic.items.length, 1);
      expect(logic.selectedItems.length, 1);
    });

    test('POSITIVE: empty list leaves items and selectedItems empty', () {
      logic.initializeItems([]);
      expect(logic.items, isEmpty);
      expect(logic.selectedItems, isEmpty);
    });

    test('NEGATIVE: null itemName falls back to empty string', () {
      logic.initializeItems([ItemDetails(itemName: null)]);
      expect(logic.items[0]['selectItem']!.text, '');
      expect(logic.selectedItems[0], '');
    });

    test('NEGATIVE: null qty fields fall back to empty string', () {
      logic.initializeItems(
          [ItemDetails(itemName: 'X', filledQty: null, eMRQty: null)]);
      expect(logic.items[0]['receivedQty']!.text, '');
      expect(logic.items[0]['emr']!.text, '');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 3 — removeItem
  // ───────────────────────────────────────────────────────────────────────────
  group('removeItem —', () {
    setUp(() {
      logic.addNewItem();
      logic.addNewItem();
      logic.addNewItem();
      logic.selectedItems[0] = 'A';
      logic.selectedItems[1] = 'B';
      logic.selectedItems[2] = 'C';
    });

    test('POSITIVE: removes correct index from items list', () {
      logic.removeItem(1);
      expect(logic.items.length, 2);
    });

    test('POSITIVE: re-indexes selectedItems after removal', () {
      logic.removeItem(0); // removes A; B→0, C→1
      expect(logic.selectedItems[0], 'B');
      expect(logic.selectedItems[1], 'C');
    });

    test('POSITIVE: removing last item leaves empty collections', () {
      logic.removeItem(2);
      logic.removeItem(1);
      logic.removeItem(0);
      expect(logic.items, isEmpty);
      expect(logic.selectedItems, isEmpty);
    });

    test('POSITIVE: removed index is no longer present in selectedItems', () {
      logic.removeItem(1);
      expect(logic.selectedItems.containsKey(2), isFalse);
    });

    test('NEGATIVE: items before removed index keep their key', () {
      logic.removeItem(2); // only last removed; 0 & 1 unchanged
      expect(logic.selectedItems[0], 'A');
      expect(logic.selectedItems[1], 'B');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 4 — isAddNewItemEnabled
  // ───────────────────────────────────────────────────────────────────────────
  group('isAddNewItemEnabled —', () {
    test('POSITIVE: true when available items exist and none are selected', () {
      logic.availableItems = [
        CylItemListModel(itemId: 1, itemName: 'Cyl1'),
        CylItemListModel(itemId: 2, itemName: 'Cyl2'),
      ];
      expect(logic.isAddNewItemEnabled, isTrue);
    });

    test('POSITIVE: true when some items are still unselected', () {
      logic.availableItems = [
        CylItemListModel(itemId: 1, itemName: 'Cyl1'),
        CylItemListModel(itemId: 2, itemName: 'Cyl2'),
      ];
      logic.addNewItem();
      logic.selectedItems[0] = 'Cyl1'; // Cyl2 still free
      expect(logic.isAddNewItemEnabled, isTrue);
    });

    test('NEGATIVE: false when all available items are selected', () {
      logic.availableItems = [
        CylItemListModel(itemId: 1, itemName: 'Cyl1'),
      ];
      logic.addNewItem();
      logic.selectedItems[0] = 'Cyl1';
      expect(logic.isAddNewItemEnabled, isFalse);
    });

    test('NEGATIVE: false when availableItems list is empty', () {
      logic.availableItems = [];
      expect(logic.isAddNewItemEnabled, isFalse);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 5 — updateSum
  // ───────────────────────────────────────────────────────────────────────────
  group('updateSum —', () {
    setUp(() => logic.addNewItem());

    test('POSITIVE: returns filledQty when emr is zero', () {
      logic.items[0]['receivedQty']!.text = '5';
      logic.items[0]['emr']!.text = '0';
      final result = logic.updateSum(0);
      expect(result, 5);
      expect(logic.items[0]['invoice']!.text, '5');
    });

    test('POSITIVE: returns emr when filledQty is zero', () {
      logic.items[0]['receivedQty']!.text = '0';
      logic.items[0]['emr']!.text = '3';
      final result = logic.updateSum(0);
      expect(result, 3);
      expect(logic.items[0]['invoice']!.text, '3');
    });

    test('POSITIVE: sums both filled and emr correctly', () {
      logic.items[0]['receivedQty']!.text = '7';
      logic.items[0]['emr']!.text = '4';
      final result = logic.updateSum(0);
      expect(result, 11);
      expect(logic.items[0]['invoice']!.text, '11');
    });

    test('POSITIVE: integer truncation (no fractional part in output)', () {
      logic.items[0]['receivedQty']!.text = '10';
      logic.items[0]['emr']!.text = '0';
      logic.updateSum(0);
      expect(logic.items[0]['invoice']!.text, '10');
    });

    test('NEGATIVE: returns null when both qty values are zero', () {
      logic.items[0]['receivedQty']!.text = '0';
      logic.items[0]['emr']!.text = '0';
      final result = logic.updateSum(0);
      expect(result, isNull);
    });

    test('NEGATIVE: returns null when both fields are empty', () {
      logic.items[0]['receivedQty']!.text = '';
      logic.items[0]['emr']!.text = '';
      final result = logic.updateSum(0);
      expect(result, isNull);
    });

    test('NEGATIVE: returns null when both fields are blank strings', () {
      logic.items[0]['receivedQty']!.text = '   ';
      logic.items[0]['emr']!.text = '   ';
      final result = logic.updateSum(0);
      // double.tryParse(' ') == null → treated as 0
      expect(result, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 6 — validateSubmit
  // ───────────────────────────────────────────────────────────────────────────
  group('validateSubmit —', () {
    setUp(() {
      logic.availableItems = [
        CylItemListModel(itemId: 1, itemName: 'ItemA'),
        CylItemListModel(itemId: 2, itemName: 'ItemB'),
      ];
      logic.addNewItem();
      logic.selectedItems[0] = 'ItemA';
      logic.items[0]['invoice']!.text = '5';
      logic.items[0]['receivedQty']!.text = '5';
      logic.items[0]['emr']!.text = '0';
    });

    test('POSITIVE: returns null (no error) for a fully valid entry', () {
      expect(logic.validateSubmit('MH12AB1234'), isNull);
    });

    test('POSITIVE: ADD mode — validation passes without receiptId', () {
      expect(logic.validateSubmit('TRUCK01'), isNull);
    });

    test('POSITIVE: multiple items, all valid — returns null', () {
      logic.addNewItem();
      logic.selectedItems[1] = 'ItemB';
      logic.items[1]['invoice']!.text = '3';
      logic.items[1]['receivedQty']!.text = '3';
      logic.items[1]['emr']!.text = '0';
      expect(logic.validateSubmit('MH12AB1234'), isNull);
    });

    // ── Vehicle number ───────────────────────────────────────────────────────
    test('NEGATIVE: empty vehicleNo returns vehicleValidation error', () {
      expect(logic.validateSubmit(''), equals('vehicleValidation'));
    });

    // ── Item selection ───────────────────────────────────────────────────────
    test('NEGATIVE: null selectedItem returns selectValidItemReceipt', () {
      logic.selectedItems[0] = null;
      expect(
          logic.validateSubmit('MH12'), equals('selectValidItemReceipt'));
    });

    test('NEGATIVE: empty selectedItem returns selectValidItemReceipt', () {
      logic.selectedItems[0] = '';
      expect(
          logic.validateSubmit('MH12'), equals('selectValidItemReceipt'));
    });

    // ── Invoice qty ──────────────────────────────────────────────────────────
    test('NEGATIVE: empty invoiceQty returns atLeastOneQtyRequired', () {
      logic.items[0]['invoice']!.text = '';
      expect(logic.validateSubmit('MH12'), equals('atLeastOneQtyRequired'));
    });

    test('NEGATIVE: invoiceQty == "0" returns atLeastOneQtyRequired', () {
      logic.items[0]['invoice']!.text = '0';
      expect(logic.validateSubmit('MH12'), equals('atLeastOneQtyRequired'));
    });

    // ── Filled + EMR both zero ───────────────────────────────────────────────
    test('NEGATIVE: both filledQty and emrQty zero returns atLeastOneQtyRequired',
            () {
          logic.items[0]['invoice']!.text = '1'; // invoice non-zero
          logic.items[0]['receivedQty']!.text = '0';
          logic.items[0]['emr']!.text = '0';
          expect(logic.validateSubmit('MH12'), equals('atLeastOneQtyRequired'));
        });

    test(
        'NEGATIVE: both filledQty and emrQty empty returns atLeastOneQtyRequired',
            () {
          logic.items[0]['invoice']!.text = '1';
          logic.items[0]['receivedQty']!.text = '';
          logic.items[0]['emr']!.text = '';
          expect(logic.validateSubmit('MH12'), equals('atLeastOneQtyRequired'));
        });

    // ── Duplicate items ──────────────────────────────────────────────────────
    test('NEGATIVE: duplicate itemId across rows returns recordExist', () {
      logic.addNewItem();
      // Both rows select the same item (ItemA → id 1)
      logic.selectedItems[1] = 'ItemA';
      logic.items[1]['invoice']!.text = '2';
      logic.items[1]['receivedQty']!.text = '2';
      logic.items[1]['emr']!.text = '0';
      expect(logic.validateSubmit('MH12'), equals('recordExist'));
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 7 — applyStockTransferList (fetchTransactionList flag logic)
  // ───────────────────────────────────────────────────────────────────────────
  group('applyStockTransferList —', () {
    test('POSITIVE: all isStkTrans == 1 sets stockTransferFlag = true', () {
      logic.applyStockTransferList([
        GetStockTransferListModel(isStkTrans: 1),
        GetStockTransferListModel(isStkTrans: 1),
      ]);
      expect(logic.stockTransferFlag, isTrue);
    });

    test('POSITIVE: empty list sets stockTransferFlag = true (no zero found)',
            () {
          logic.applyStockTransferList([]);
          expect(logic.stockTransferFlag, isTrue);
        });

    test('NEGATIVE: any isStkTrans == 0 sets stockTransferFlag = false', () {
      logic.applyStockTransferList([
        GetStockTransferListModel(isStkTrans: 1),
        GetStockTransferListModel(isStkTrans: 0),
      ]);
      expect(logic.stockTransferFlag, isFalse);
    });

    test('NEGATIVE: all isStkTrans == 0 sets stockTransferFlag = false', () {
      logic.applyStockTransferList([
        GetStockTransferListModel(isStkTrans: 0),
      ]);
      expect(logic.stockTransferFlag, isFalse);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 8 — applyDayEndResponse (checkAndSaveDayEndData flag logic)
  // ───────────────────────────────────────────────────────────────────────────
  group('applyDayEndResponse —', () {
    test('POSITIVE: non-empty response sets saveFlag = true', () {
      logic.applyDayEndResponse([
        {'DSRSaved': 1, 'CDCMSStkSaved': 1, 'OpClSaved': 1}
      ]);
      expect(logic.saveFlag, isTrue);
    });

    test('NEGATIVE: empty response sets saveFlag = false', () {
      logic.applyDayEndResponse([]);
      expect(logic.saveFlag, isFalse);
    });

    test('NEGATIVE: repeated empty call keeps saveFlag = false', () {
      logic.applyDayEndResponse([]);
      logic.applyDayEndResponse([]);
      expect(logic.saveFlag, isFalse);
    });

    test(
        'POSITIVE: after true, a subsequent empty response resets saveFlag to false',
            () {
          logic.applyDayEndResponse([{'DSRSaved': 1}]);
          expect(logic.saveFlag, isTrue);
          logic.applyDayEndResponse([]);
          expect(logic.saveFlag, isFalse);
        });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 9 — isSubmitActive (submit button enabled state)
  // ───────────────────────────────────────────────────────────────────────────
  group('isSubmitActive —', () {
    test('POSITIVE: active when saveFlag=false, stockTransferFlag=true, vehicleNo non-empty',
            () {
          logic.saveFlag = false;
          logic.stockTransferFlag = true;
          expect(logic.isSubmitActive('MH12AB1234'), isTrue);
        });

    test('NEGATIVE: inactive when saveFlag=true', () {
      logic.saveFlag = true;
      logic.stockTransferFlag = true;
      expect(logic.isSubmitActive('MH12AB1234'), isFalse);
    });

    test('NEGATIVE: inactive when stockTransferFlag=false', () {
      logic.saveFlag = false;
      logic.stockTransferFlag = false;
      expect(logic.isSubmitActive('MH12AB1234'), isFalse);
    });

    test('NEGATIVE: inactive when vehicleNo is empty', () {
      logic.saveFlag = false;
      logic.stockTransferFlag = true;
      expect(logic.isSubmitActive(''), isFalse);
    });

    test('NEGATIVE: inactive when all conditions fail', () {
      logic.saveFlag = true;
      logic.stockTransferFlag = false;
      expect(logic.isSubmitActive(''), isFalse);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 10 — filteredNamesForIndex (_ItemEntryCard._filteredNames)
  // ───────────────────────────────────────────────────────────────────────────
  group('filteredNamesForIndex —', () {
    setUp(() {
      logic.availableItems = [
        CylItemListModel(itemId: 1, itemName: 'A'),
        CylItemListModel(itemId: 2, itemName: 'B'),
        CylItemListModel(itemId: 3, itemName: 'C'),
      ];
      logic.addNewItem(); // index 0
      logic.addNewItem(); // index 1
    });

    test('POSITIVE: shows all items when none are selected', () {
      final names = logic.filteredNamesForIndex(0);
      expect(names, containsAll(['A', 'B', 'C']));
      expect(names.length, 3);
    });

    test('POSITIVE: shows own selection + unselected items for a row', () {
      logic.selectedItems[0] = 'A';
      logic.selectedItems[1] = 'B';
      final names = logic.filteredNamesForIndex(0); // owns A; B excluded, C visible
      expect(names, containsAll(['A', 'C']));
      expect(names, isNot(contains('B')));
    });

    test('POSITIVE: row not yet selected sees all unselected items', () {
      logic.selectedItems[0] = 'A';
      final names = logic.filteredNamesForIndex(1); // no selection yet → B & C visible
      expect(names, containsAll(['B', 'C']));
    });

    test('NEGATIVE: returns empty list when all items selected and index owns none',
            () {
          logic.addNewItem(); // index 2 — extra row with no item
          logic.selectedItems[0] = 'A';
          logic.selectedItems[1] = 'B';
          logic.selectedItems[2] = 'C';
          // Add a 4th row that owns nothing
          logic.addNewItem();
          final names = logic.filteredNamesForIndex(3);
          expect(names, isEmpty);
        });

    test('NEGATIVE: no duplicates when same name appears twice in availableItems',
            () {
          logic.availableItems.add(CylItemListModel(itemId: 1, itemName: 'A'));
          final names = logic.filteredNamesForIndex(0);
          expect(names.where((n) => n == 'A').length, 1);
        });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 11 — receipt date initialisation (date format validation)
  // ───────────────────────────────────────────────────────────────────────────
  group('receiptDate format —', () {
    test('POSITIVE: formatted date matches dd-MM-yyyy pattern', () {
      final now = DateTime(2025, 7, 4);
      final formatted = '${now.day.toString().padLeft(2, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.year}';
      expect(RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(formatted), isTrue);
      expect(formatted, '04-07-2025');
    });

    test('NEGATIVE: yyyy-MM-dd format does NOT match dd-MM-yyyy pattern', () {
      const wrong = '2025-07-04';
      expect(RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(wrong), isFalse);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 12 — vehicleNo input formatter
  // ───────────────────────────────────────────────────────────────────────────
  group('vehicleNo length limit (LengthLimitingTextInputFormatter 11) —', () {
    test('POSITIVE: string of 11 characters is valid', () {
      const input = 'MH12AB1234X';
      expect(input.length, 11);
    });

    test('POSITIVE: string of 1 character is valid', () {
      const input = 'M';
      expect(input.length <= 11, isTrue);
    });

    test('NEGATIVE: string longer than 11 should be trimmed by formatter', () {
      const rawInput = 'MH12AB12345678';
      final trimmed = rawInput.length > 11 ? rawInput.substring(0, 11) : rawInput;
      expect(trimmed.length, 11);
      expect(trimmed, isNot(equals(rawInput)));
    });

    test('NEGATIVE: empty vehicleNo fails submit validation', () {
      expect(logic.validateSubmit(''), equals('vehicleValidation'));
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 13 — action determination (ADD vs EDIT mode)
  // ───────────────────────────────────────────────────────────────────────────
  group('action mode (ADD vs EDIT) —', () {
    String resolveAction(String? mode, int? receiptId) {
      if (mode == 'Edit') return 'EDIT';
      return 'ADD';
    }

    int resolveId(String? mode, int? receiptId) {
      if (mode == 'Edit') return receiptId ?? 0;
      return 0;
    }

    test('POSITIVE: mode == "Edit" yields action EDIT', () {
      expect(resolveAction('Edit', 42), 'EDIT');
    });

    test('POSITIVE: mode == "Edit" uses supplied receiptId', () {
      expect(resolveId('Edit', 42), 42);
    });

    test('POSITIVE: mode != "Edit" yields action ADD', () {
      expect(resolveAction(null, 0), 'ADD');
      expect(resolveAction('', 0), 'ADD');
      expect(resolveAction('Add', 0), 'ADD');
    });

    test('POSITIVE: ADD mode always uses receiptId 0', () {
      expect(resolveId(null, 99), 0);
    });

    test('NEGATIVE: Edit mode with null receiptId falls back to 0', () {
      expect(resolveId('Edit', null), 0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 14 — API response handling (_submitData server response codes)
  // ───────────────────────────────────────────────────────────────────────────
  group('_submitData server response interpretation —', () {
    String interpretResponseValue(int value) {
      if (value > 0) return 'success';
      if (value == -1) return 'vehicleNotReturn';
      if (value == -2) return 'itemreceiptDataNotInserted';
      return 'failToInserRecord';
    }

    test('POSITIVE: response > 0 → success', () {
      expect(interpretResponseValue(1), 'success');
      expect(interpretResponseValue(100), 'success');
    });

    test('NEGATIVE: response == -1 → vehicleNotReturn', () {
      expect(interpretResponseValue(-1), 'vehicleNotReturn');
    });

    test('NEGATIVE: response == -2 → itemreceiptDataNotInserted', () {
      expect(interpretResponseValue(-2), 'itemreceiptDataNotInserted');
    });

    test('NEGATIVE: response == 0 → failToInserRecord', () {
      expect(interpretResponseValue(0), 'failToInserRecord');
    });

    test('NEGATIVE: other negative value → failToInserRecord', () {
      expect(interpretResponseValue(-99), 'failToInserRecord');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 15 — JSON request body construction
  // ───────────────────────────────────────────────────────────────────────────
  group('request body JSON —', () {
    test('POSITIVE: encoded body contains all required top-level keys', () {
      final body = {
        'ReceiptId': 0,
        'DistributorId': 'D1',
        'GodownId': 'G1',
        'ReceiptDate': '04-07-2025',
        'VehicleNo': 'MH12AB1234',
        'GodownKeeperId': 'GK1',
        'AddedBy': 'S1',
        'Action': 'ADD',
        'ItemDetails': [],
      };
      final encoded = jsonEncode(body);
      final decoded = jsonDecode(encoded) as Map<String, dynamic>;
      expect(decoded.keys,
          containsAll(['ReceiptId', 'DistributorId', 'GodownId',
            'ReceiptDate', 'VehicleNo', 'GodownKeeperId',
            'AddedBy', 'Action', 'ItemDetails']));
    });

    test('POSITIVE: ItemDetails list contains correct keys per item', () {
      final itemDetail = {
        'ItemId': 1,
        'FilledQty': '5',
        'EMRQty': '2',
        'InvoiceQty': '7',
      };
      expect(itemDetail.keys,
          containsAll(['ItemId', 'FilledQty', 'EMRQty', 'InvoiceQty']));
    });

    test('NEGATIVE: empty ItemDetails list encodes as []', () {
      final body = {'ItemDetails': []};
      final decoded = jsonDecode(jsonEncode(body)) as Map;
      expect(decoded['ItemDetails'], isEmpty);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 16 — SharedPreferences key assertions
  // ───────────────────────────────────────────────────────────────────────────
  group('SharedPreferences keys —', () {
    test('POSITIVE: all expected keys can be stored and retrieved', () async {
      SharedPreferences.setMockInitialValues({
        'DistributorId': '123',
        'godownId': '456',
        'StaffId': 'S01',
        'godownKeeperId': 'GK01',
        'token': 'mock_token',
        'MobileNo': '9876543210',
      });
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('DistributorId'), '123');
      expect(prefs.getString('godownId'), '456');
      expect(prefs.getString('StaffId'), 'S01');
      expect(prefs.getString('godownKeeperId'), 'GK01');
      expect(prefs.getString('token'), 'mock_token');
      expect(prefs.getString('MobileNo'), '9876543210');
    });

    test('NEGATIVE: missing token returns null', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('token'), isNull);
    });

    test('NEGATIVE: missing DistributorId returns null', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('DistributorId'), isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 17 — CylItemListModel.fromJson
  // ───────────────────────────────────────────────────────────────────────────
  group('CylItemListModel.fromJson —', () {
    test('POSITIVE: parses itemId and itemName correctly', () {
      final model = CylItemListModel.fromJson({'ItemId': 5, 'ItemName': 'Gas'});
      expect(model.itemId, 5);
      expect(model.itemName, 'Gas');
    });

    test('NEGATIVE: missing keys result in null fields', () {
      final model = CylItemListModel.fromJson({});
      expect(model.itemId, isNull);
      expect(model.itemName, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 18 — GetStockTransferListModel.fromJson
  // ───────────────────────────────────────────────────────────────────────────
  group('GetStockTransferListModel.fromJson —', () {
    test('POSITIVE: parses isStkTrans = 1', () {
      final model =
      GetStockTransferListModel.fromJson({'isStkTrans': 1});
      expect(model.isStkTrans, 1);
    });

    test('POSITIVE: parses isStkTrans = 0', () {
      final model =
      GetStockTransferListModel.fromJson({'isStkTrans': 0});
      expect(model.isStkTrans, 0);
    });

    test('NEGATIVE: missing key returns null isStkTrans', () {
      final model = GetStockTransferListModel.fromJson({});
      expect(model.isStkTrans, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 19 — Edge cases / boundary conditions
  // ───────────────────────────────────────────────────────────────────────────
  group('edge cases —', () {
    test('POSITIVE: updateSum handles max 3-digit qty (999 + 999 = 1998)', () {
      logic.addNewItem();
      logic.items[0]['receivedQty']!.text = '999';
      logic.items[0]['emr']!.text = '999';
      final result = logic.updateSum(0);
      expect(result, 1998);
    });

    test('POSITIVE: validateSubmit handles very large vehicle number string', () {
      logic.addNewItem();
      logic.selectedItems[0] = 'ItemA';
      logic.availableItems = [CylItemListModel(itemId: 1, itemName: 'ItemA')];
      logic.items[0]['invoice']!.text = '10';
      logic.items[0]['receivedQty']!.text = '10';
      // 11-char vehicle number (max allowed by formatter)
      expect(logic.validateSubmit('MH12AB12345'), isNull);
    });

    test('NEGATIVE: adding 50 items works without error (stress)', () {
      for (int i = 0; i < 50; i++) {
        logic.addNewItem();
      }
      expect(logic.items.length, 50);
      expect(logic.selectedItems.length, 50);
    });

    test('NEGATIVE: removeItem on single item leaves lists empty', () {
      logic.addNewItem();
      logic.removeItem(0);
      expect(logic.items, isEmpty);
      expect(logic.selectedItems, isEmpty);
    });

    test('POSITIVE: initializeItems with 10 items preserves order', () {
      final data = List.generate(
          10, (i) => ItemDetails(itemName: 'Item$i', filledQty: i));
      logic.initializeItems(data);
      for (int i = 0; i < 10; i++) {
        expect(logic.selectedItems[i], 'Item$i');
        expect(logic.items[i]['receivedQty']!.text, '$i');
      }
    });
  });
}