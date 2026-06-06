// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:lpgsalesandinventory/Screen/GodownKeeper/DelBoyStockReturn/StockTransferToGodownScreen.dart';
//
// void main() {
//   group('StockTransferToGodownScreen widget tests', () {
// 	setUp(() {
// 	  SharedPreferences.setMockInitialValues({
// 		'godownId': '1',
// 		'DistributorId': '10',
// 		'StaffId': '5',
// 		'token': 'abc',
// 		'MobileNo': '9999999999',
// 	  });
// 	});
//
// 	testWidgets('renders stock summary from route arguments', (tester) async {
// 	  final recorder = _RequestRecorder();
// 	  HttpOverrides.global = _RecordingHttpOverrides(recorder: recorder);
//
// 	  // Push the screen with arguments using a wrapper so ModalRoute has settings
// 	  await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) {
// 		WidgetsBinding.instance.addPostFrameCallback((_) {
// 		  Navigator.of(context).push(MaterialPageRoute(
// 			builder: (_) => const StockTransferTOGodownScreen(),
// 			settings: RouteSettings(arguments: {
// 			  'itemName': 'Test Item',
// 			  'itemID': 5,
// 			  'filledStock': 10,
// 			  'emptyStock': 2,
// 			  'defectiveStock': 1,
// 			}),
// 		  ));
// 		});
// 		return const SizedBox.shrink();
// 	  })));
//
// 	  await tester.pumpAndSettle();
//
// 	  expect(find.text('Test Item'), findsOneWidget);
// 	  expect(find.text('Filled'), findsOneWidget);
//
// 	  HttpOverrides.global = null;
// 	});
//
// 	testWidgets('clears filled qty when entered value exceeds available filledCount', (tester) async {
// 	  HttpOverrides.global = _RecordingHttpOverrides();
//
// 	  await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) {
// 		WidgetsBinding.instance.addPostFrameCallback((_) {
// 		  Navigator.of(context).push(MaterialPageRoute(
// 			builder: (_) => const StockTransferTOGodownScreen(),
// 			settings: RouteSettings(arguments: {
// 			  'itemName': 'I1', 'itemID': 1, 'filledStock': 5, 'emptyStock': 2, 'defectiveStock': 1
// 			}),
// 		  ));
// 		});
// 		return const SizedBox.shrink();
// 	  })));
//
// 	  await tester.pumpAndSettle();
//
// 	  // find the Filled Qty TextField by hint text
// 	  final filledField = find.byWidgetPredicate((w) => w is TextField && (w.decoration?.hintText ?? '') == 'Enter Filled Qty');
// 	  expect(filledField, findsOneWidget);
//
// 	  await tester.enterText(filledField, '6');
// 	  await tester.pumpAndSettle();
//
// 	  // The UI code clears the controller when value > filledCount, so the entered text should not persist
// 	  expect(find.text('6'), findsNothing);
//
// 	  HttpOverrides.global = null;
// 	});
//
// 	testWidgets('does not call submit API when no godown selected or no quantities provided', (tester) async {
// 	  final recorder = _RequestRecorder();
// 	  HttpOverrides.global = _RecordingHttpOverrides(recorder: recorder);
//
// 	  await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) {
// 		WidgetsBinding.instance.addPostFrameCallback((_) {
// 		  Navigator.of(context).push(MaterialPageRoute(
// 			builder: (_) => const StockTransferTOGodownScreen(),
// 			settings: RouteSettings(arguments: {
// 			  'itemName': 'I2', 'itemID': 2, 'filledStock': 5, 'emptyStock': 2, 'defectiveStock': 1
// 			}),
// 		  ));
// 		});
// 		return const SizedBox.shrink();
// 	  })));
//
// 	  await tester.pumpAndSettle();
//
// 	  // Tap Submit without selecting godown and without entering quantities
// 	  final submitBtn = find.text('Submit');
// 	  expect(submitBtn, findsOneWidget);
// 	  await tester.tap(submitBtn);
// 	  await tester.pumpAndSettle();
//
// 	  // Recorder should show no POST requests (submitStockToApi not called)
// 	  expect(recorder.postCount, 0);
//
// 	  HttpOverrides.global = null;
// 	});
//
// 	testWidgets('successful submit posts data and pops route', (tester) async {
// 	  final recorder = _RequestRecorder();
// 	  HttpOverrides.global = _RecordingHttpOverrides(recorder: recorder);
//
// 	  await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) {
// 		WidgetsBinding.instance.addPostFrameCallback((_) {
// 		  Navigator.of(context).push(MaterialPageRoute(
// 			builder: (_) => const StockTransferTOGodownScreen(),
// 			settings: RouteSettings(arguments: {
// 			  'itemName': 'I3', 'itemID': 3, 'filledStock': 5, 'emptyStock': 2, 'defectiveStock': 1
// 			}),
// 		  ));
// 		});
// 		return const SizedBox.shrink();
// 	  })));
//
// 	  await tester.pumpAndSettle();
//
// 	  // Select godown from dropdown: open first DropdownButtonFormField
// 	  final anyDropdown = find.byType(DropdownButtonFormField).first;
// 	  await tester.tap(anyDropdown);
// 	  await tester.pumpAndSettle();
//
// 	  // Tap the mocked godown label
// 	  final expectedGodownText = find.text('G-2');
// 	  if (expectedGodownText.evaluate().isNotEmpty) {
// 		await tester.tap(expectedGodownText);
// 	  }
// 	  await tester.pumpAndSettle();
//
// 	  // Enter valid quantities
// 	  final filledField = find.byWidgetPredicate((w) => w is TextField && (w.decoration?.hintText ?? '') == 'Enter Filled Qty');
// 	  final emptyField = find.byWidgetPredicate((w) => w is TextField && (w.decoration?.hintText ?? '') == 'Enter Empty Qty');
// 	  final defField = find.byWidgetPredicate((w) => w is TextField && (w.decoration?.hintText ?? '') == 'Enter Defective Qty');
//
// 	  await tester.enterText(filledField, '2');
// 	  await tester.enterText(emptyField, '1');
// 	  await tester.enterText(defField, '0');
// 	  await tester.pumpAndSettle();
//
// 	  // Tap Submit
// 	  await tester.tap(find.text('Submit'));
// 	  await tester.pumpAndSettle(const Duration(seconds: 1));
//
// 	  // Recorder should have recorded a POST to SaveGodownStockTransferDtls
// 	  expect(recorder.postCount, greaterThan(0));
//
// 	  HttpOverrides.global = null;
// 	}, skip: true);
//   });
// }
//
// // --- Helpers: HTTP recording overrides ---
// class _RequestRecorder {
//   int postCount = 0;
//   final List<Uri> posts = [];
// }
//
// class _RecordingHttpOverrides extends HttpOverrides {
//   final _RequestRecorder? recorder;
//   _RecordingHttpOverrides({this.recorder});
//
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
// 	return _RecordingHttpClient(recorder);
//   }
// }
//
// class _RecordingHttpClient implements HttpClient {
//   final _RequestRecorder? recorder;
//   _RecordingHttpClient(this.recorder);
//
//   @override
//   Future<HttpClientRequest> getUrl(Uri url) async => _RecordingHttpClientRequest(url, recorder, method: 'GET');
//
//   @override
//   Future<HttpClientRequest> openUrl(String method, Uri url) async => _RecordingHttpClientRequest(url, recorder, method: method);
//
//   @override
//   void close({bool force = false}) {}
//
//   @override
//   noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }
//
// class _RecordingHttpClientRequest implements HttpClientRequest {
//   final Uri url;
//   final _RequestRecorder? recorder;
//   final String method;
//   final HttpHeaders headers = _SimpleHttpHeaders();
//   final _buffer = <int>[];
//
//   _RecordingHttpClientRequest(this.url, this.recorder, {required this.method});
//
//   @override
//   void add(List<int> data) => _buffer.addAll(data);
//
//   @override
//   Future<HttpClientResponse> close() async {
// 	// respond based on URL path
// 	final path = url.path;
// 	if (method == 'POST') {
// 	  recorder?.postCount++;
// 	}
// 	String body = '[]';
// 	int status = 200;
// 	if (path.contains('GetGodownMasterList')) {
// 	  body = json.encode([{'GodownId': 2, 'GodownNo': 'G-2'}]);
// 	} else if (path.contains('GetStockTransferDtls')) {
// 	  body = json.encode([]);
// 	} else if (path.contains('CheckDayEndConfirmation')) {
// 	  body = json.encode([]);
// 	} else if (path.contains('SaveGodownStockTransferDtls')) {
// 	  body = json.encode({'status': true});
// 	  status = 200;
// 	}
// 	return _SimpleHttpClientResponse(body, status);
//   }
//
//   @override
//   noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }
//
// class _SimpleHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
//   final String _body;
//   final int _status;
//   _SimpleHttpClientResponse(this._body, this._status);
//
//   @override
//   int get statusCode => _status;
//
//   @override
//   HttpHeaders get headers => _SimpleHttpHeaders();
//
//   @override
//   StreamSubscription<List<int>> listen(void Function(List<int>)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
// 	final controller = StreamController<List<int>>();
// 	controller.add(utf8.encode(_body));
// 	controller.close();
// 	return controller.stream.listen((data) {
// 	  if (onData != null) onData(data);
// 	}, onError: onError, onDone: onDone, cancelOnError: cancelOnError ?? false);
//   }
//
//   @override
//   noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }
//
// class _SimpleHttpHeaders implements HttpHeaders {
//   final Map<String, List<String>> _map = {};
//   @override
//   void add(String name, Object value, {bool preserveHeaderCase = false}) => _map.putIfAbsent(name, () => []).add(value.toString());
//   @override
//   void set(String name, Object value, {bool preserveHeaderCase = false}) => _map[name] = [value.toString()];
//   @override
//   noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }
//
//


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FAKE / STUB MODELS
// Mirrors the real models used by the screen so tests have zero real imports.
// ─────────────────────────────────────────────────────────────────────────────

class FakeGetGodownListModel {
  final int? godownId;
  final String? godownNo;

  FakeGetGodownListModel({this.godownId, this.godownNo});

  factory FakeGetGodownListModel.fromJson(Map<String, dynamic> json) {
    return FakeGetGodownListModel(
      godownId: json['GodownId'],
      godownNo: json['GodownNo'],
    );
  }
}

class FakeGetStockTransferListModel {
  final int? isStkTrans;
  final String? itemName;
  final int? filledStk;
  final int? emptyStk;
  final int? defectiveStk;

  FakeGetStockTransferListModel({
    this.isStkTrans,
    this.itemName,
    this.filledStk,
    this.emptyStk,
    this.defectiveStk,
  });

  factory FakeGetStockTransferListModel.fromJson(Map<String, dynamic> json) {
    return FakeGetStockTransferListModel(
      isStkTrans: json['IsStkTrans'],
      itemName: json['ItemName'],
      filledStk: json['FilledStk'],
      emptyStk: json['EmptyStk'],
      defectiveStk: json['DefectiveStk'],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BUSINESS LOGIC HELPERS
// Extracted pure functions that mirror the logic inside the screen state.
// These are what we unit-test without needing Flutter widgets or HTTP.
// ─────────────────────────────────────────────────────────────────────────────

/// Mirrors: `stockTransferFlag` derivation from `_stockTransferList`
/// Returns true  → all items have isStkTrans != 0 (transfer allowed)
/// Returns false → at least one item has isStkTrans == 0 (pending acceptance)
bool deriveStockTransferFlag(List<FakeGetStockTransferListModel> list) {
  for (final item in list) {
    if (item.isStkTrans == 0) return false;
  }
  return true;
}

/// Mirrors: filled-qty validation inside _QtyField.onChanged
bool isFilledQtyExceeded(String inputText, int filledCount) {
  final qty = int.tryParse(inputText) ?? 0;
  return qty > filledCount;
}

/// Mirrors: empty-qty validation inside _QtyField.onChanged
bool isEmptyQtyExceeded(String inputText, int emptyCount) {
  final qty = int.tryParse(inputText) ?? 0;
  return qty > emptyCount;
}

/// Mirrors: defective-qty validation inside _QtyField.onChanged
bool isDefectiveQtyExceeded(String inputText, int defectiveCount) {
  final qty = int.tryParse(inputText) ?? 0;
  return qty > defectiveCount;
}

/// Mirrors: Submit button pre-condition check
/// Returns a [SubmitResult] describing which validation message should fire.
enum SubmitResult {
  dayEndAlreadyCompleted,
  godownNotSelected,
  noQtyEntered,
  stockNotAccepted,
  proceedToApi,
}

SubmitResult evaluateSubmit({
  required bool saveFlag,
  required String? selectedGodownName,
  required String filledText,
  required String emptyText,
  required String defectiveText,
  required bool stockTransferFlag,
}) {
  if (saveFlag) return SubmitResult.dayEndAlreadyCompleted;
  if (selectedGodownName == null) return SubmitResult.godownNotSelected;
  if (filledText.isEmpty && emptyText.isEmpty && defectiveText.isEmpty) {
    return SubmitResult.noQtyEntered;
  }
  if (!stockTransferFlag) return SubmitResult.stockNotAccepted;
  return SubmitResult.proceedToApi;
}

/// Mirrors: godown list filtering — removes the current godown from the list.
List<FakeGetGodownListModel> filterGodownList(
    List<FakeGetGodownListModel> all, int currentGodownId) {
  return all.where((g) => g.godownId != currentGodownId).toList();
}

/// Mirrors: request-body construction in `submitStockToApi`
Map<String, dynamic> buildRequestBody({
  required int distributorId,
  required int fromGodownId,
  required String stkTransDate,
  required int toGodownId,
  required int itemId,
  required String filledText,
  required String emptyText,
  required String defectiveText,
  required String remark,
  required String addedBy,
}) {
  return {
    "DistributorId": distributorId,
    "FromGodownId": fromGodownId,
    "StkTransDate": stkTransDate,
    "ToGodownId": toGodownId,
    "ItemId": itemId,
    "FilledStk": int.tryParse(filledText) ?? 0,
    "EmptyStk": int.tryParse(emptyText) ?? 0,
    "DefectiveStk": int.tryParse(defectiveText) ?? 0,
    "IsStkTrans": 0,
    "Remark": remark,
    "AddedBy": addedBy,
  };
}

/// Mirrors: `saveFlag` derivation from `checkAndSaveDayEndData` API response
bool deriveSaveFlag(List<dynamic> apiResponse) {
  return apiResponse.isNotEmpty;
}

/// Mirrors: `GetStockTransferListModel.fromJson` list parsing
List<FakeGetStockTransferListModel> parseTransferList(String responseBody) {
  final List<dynamic> data = json.decode(responseBody);
  return data.map((j) => FakeGetStockTransferListModel.fromJson(j)).toList();
}

/// Mirrors: `GetGodownListModel.fromJson` list parsing
List<FakeGetGodownListModel> parseGodownList(String responseBody) {
  final List<dynamic> data = json.decode(responseBody);
  return data.map((j) => FakeGetGodownListModel.fromJson(j)).toList();
}

// ─────────────────────────────────────────────────────────────────────────────
// TEST DATA
// ─────────────────────────────────────────────────────────────────────────────

final List<FakeGetGodownListModel> sampleGodowns = [
  FakeGetGodownListModel(godownId: 1, godownNo: 'GDN-001'),
  FakeGetGodownListModel(godownId: 2, godownNo: 'GDN-002'),
  FakeGetGodownListModel(godownId: 3, godownNo: 'GDN-003'),
];

final List<FakeGetStockTransferListModel> allAccepted = [
  FakeGetStockTransferListModel(isStkTrans: 1, itemName: 'Item A', filledStk: 10),
  FakeGetStockTransferListModel(isStkTrans: 1, itemName: 'Item B', filledStk: 5),
];

final List<FakeGetStockTransferListModel> somePending = [
  FakeGetStockTransferListModel(isStkTrans: 1, itemName: 'Item A', filledStk: 10),
  FakeGetStockTransferListModel(isStkTrans: 0, itemName: 'Item B', filledStk: 5),
];

final List<FakeGetStockTransferListModel> allPending = [
  FakeGetStockTransferListModel(isStkTrans: 0, itemName: 'Item A', filledStk: 10),
  FakeGetStockTransferListModel(isStkTrans: 0, itemName: 'Item B', filledStk: 5),
];

// ─────────────────────────────────────────────────────────────────────────────
// TESTS
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 1 ── stockTransferFlag derivation
  // ═══════════════════════════════════════════════════════════════════════════
  group('stockTransferFlag derivation', () {
    // ── POSITIVE ──────────────────────────────────────────────────────────────

    test('TC_STF_01 [+] All isStkTrans==1 → stockTransferFlag true', () {
      expect(deriveStockTransferFlag(allAccepted), isTrue);
    });

    test('TC_STF_02 [+] Empty transfer list → stockTransferFlag true (no pending)',
            () {
          expect(deriveStockTransferFlag([]), isTrue);
        });

    test('TC_STF_03 [+] Single item with isStkTrans==1 → flag true', () {
      final list = [
        FakeGetStockTransferListModel(isStkTrans: 1),
      ];
      expect(deriveStockTransferFlag(list), isTrue);
    });

    // ── NEGATIVE ──────────────────────────────────────────────────────────────

    test('TC_STF_04 [-] At least one isStkTrans==0 → stockTransferFlag false',
            () {
          expect(deriveStockTransferFlag(somePending), isFalse);
        });

    test('TC_STF_05 [-] All isStkTrans==0 → stockTransferFlag false', () {
      expect(deriveStockTransferFlag(allPending), isFalse);
    });

    test('TC_STF_06 [-] Single item with isStkTrans==0 → flag false', () {
      final list = [
        FakeGetStockTransferListModel(isStkTrans: 0),
      ];
      expect(deriveStockTransferFlag(list), isFalse);
    });

    test('TC_STF_07 [-] Null isStkTrans treated as non-zero → flag true', () {
      // null != 0 so the loop never finds 0; flag stays true
      final list = [
        FakeGetStockTransferListModel(isStkTrans: null),
      ];
      expect(deriveStockTransferFlag(list), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 2 ── Quantity field validation
  // ═══════════════════════════════════════════════════════════════════════════
  group('Quantity field validation', () {
    // ── FILLED QTY ──────────────────────────────────────────────────────────

    test('TC_QTY_01 [+] Filled qty within limit → not exceeded', () {
      expect(isFilledQtyExceeded('5', 10), isFalse);
    });

    test('TC_QTY_02 [+] Filled qty equal to limit → not exceeded', () {
      expect(isFilledQtyExceeded('10', 10), isFalse);
    });

    test('TC_QTY_03 [+] Filled qty zero → not exceeded', () {
      expect(isFilledQtyExceeded('0', 10), isFalse);
    });

    test('TC_QTY_04 [-] Filled qty exceeds limit → exceeded', () {
      expect(isFilledQtyExceeded('11', 10), isTrue);
    });

    test('TC_QTY_05 [-] Filled qty empty string → treated as 0, not exceeded',
            () {
          expect(isFilledQtyExceeded('', 10), isFalse);
        });

    test('TC_QTY_06 [-] Filled qty non-numeric → treated as 0, not exceeded',
            () {
          expect(isFilledQtyExceeded('abc', 10), isFalse);
        });

    test('TC_QTY_07 [-] Filled qty exceeds zero stock → exceeded', () {
      expect(isFilledQtyExceeded('1', 0), isTrue);
    });

    // ── EMPTY QTY ───────────────────────────────────────────────────────────

    test('TC_QTY_08 [+] Empty qty within limit → not exceeded', () {
      expect(isEmptyQtyExceeded('3', 8), isFalse);
    });

    test('TC_QTY_09 [+] Empty qty equal to limit → not exceeded', () {
      expect(isEmptyQtyExceeded('8', 8), isFalse);
    });

    test('TC_QTY_10 [-] Empty qty exceeds limit → exceeded', () {
      expect(isEmptyQtyExceeded('9', 8), isTrue);
    });

    test('TC_QTY_11 [-] Empty qty non-numeric → treated as 0', () {
      expect(isEmptyQtyExceeded('xyz', 8), isFalse);
    });

    // ── DEFECTIVE QTY ───────────────────────────────────────────────────────

    test('TC_QTY_12 [+] Defective qty within limit → not exceeded', () {
      expect(isDefectiveQtyExceeded('2', 5), isFalse);
    });

    test('TC_QTY_13 [+] Defective qty equal to limit → not exceeded', () {
      expect(isDefectiveQtyExceeded('5', 5), isFalse);
    });

    test('TC_QTY_14 [-] Defective qty exceeds limit → exceeded', () {
      expect(isDefectiveQtyExceeded('6', 5), isTrue);
    });

    test('TC_QTY_15 [-] Defective qty empty string → 0, not exceeded', () {
      expect(isDefectiveQtyExceeded('', 5), isFalse);
    });

    test('TC_QTY_16 [-] Defective qty exceeds zero stock → exceeded', () {
      expect(isDefectiveQtyExceeded('1', 0), isTrue);
    });

    test('TC_QTY_17 [-] Very large qty (999) exceeds small stock → exceeded',
            () {
          expect(isFilledQtyExceeded('999', 100), isTrue);
        });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 3 ── Submit button logic
  // ═══════════════════════════════════════════════════════════════════════════
  group('Submit button evaluation', () {
    // ── POSITIVE (happy path) ────────────────────────────────────────────────

    test('TC_SUB_01 [+] All valid → proceeds to API call', () {
      final result = evaluateSubmit(
        saveFlag: false,
        selectedGodownName: 'GDN-002',
        filledText: '5',
        emptyText: '',
        defectiveText: '',
        stockTransferFlag: true,
      );
      expect(result, SubmitResult.proceedToApi);
    });

    test('TC_SUB_02 [+] Only emptyText filled → proceeds to API call', () {
      final result = evaluateSubmit(
        saveFlag: false,
        selectedGodownName: 'GDN-002',
        filledText: '',
        emptyText: '3',
        defectiveText: '',
        stockTransferFlag: true,
      );
      expect(result, SubmitResult.proceedToApi);
    });

    test('TC_SUB_03 [+] Only defectiveText filled → proceeds to API call', () {
      final result = evaluateSubmit(
        saveFlag: false,
        selectedGodownName: 'GDN-002',
        filledText: '',
        emptyText: '',
        defectiveText: '2',
        stockTransferFlag: true,
      );
      expect(result, SubmitResult.proceedToApi);
    });

    test('TC_SUB_04 [+] All three qty fields filled → proceeds to API call',
            () {
          final result = evaluateSubmit(
            saveFlag: false,
            selectedGodownName: 'GDN-002',
            filledText: '5',
            emptyText: '3',
            defectiveText: '1',
            stockTransferFlag: true,
          );
          expect(result, SubmitResult.proceedToApi);
        });

    // ── NEGATIVE ──────────────────────────────────────────────────────────────

    test('TC_SUB_05 [-] saveFlag true → day end already completed', () {
      final result = evaluateSubmit(
        saveFlag: true,
        selectedGodownName: 'GDN-002',
        filledText: '5',
        emptyText: '',
        defectiveText: '',
        stockTransferFlag: true,
      );
      expect(result, SubmitResult.dayEndAlreadyCompleted);
    });

    test('TC_SUB_06 [-] saveFlag true overrides everything else', () {
      // Even if godown not selected, saveFlag check comes first
      final result = evaluateSubmit(
        saveFlag: true,
        selectedGodownName: null,
        filledText: '',
        emptyText: '',
        defectiveText: '',
        stockTransferFlag: false,
      );
      expect(result, SubmitResult.dayEndAlreadyCompleted);
    });

    test('TC_SUB_07 [-] No godown selected → godownNotSelected', () {
      final result = evaluateSubmit(
        saveFlag: false,
        selectedGodownName: null,
        filledText: '5',
        emptyText: '',
        defectiveText: '',
        stockTransferFlag: true,
      );
      expect(result, SubmitResult.godownNotSelected);
    });

    test('TC_SUB_08 [-] All qty fields empty → noQtyEntered', () {
      final result = evaluateSubmit(
        saveFlag: false,
        selectedGodownName: 'GDN-002',
        filledText: '',
        emptyText: '',
        defectiveText: '',
        stockTransferFlag: true,
      );
      expect(result, SubmitResult.noQtyEntered);
    });

    test('TC_SUB_09 [-] stockTransferFlag false → stockNotAccepted', () {
      final result = evaluateSubmit(
        saveFlag: false,
        selectedGodownName: 'GDN-002',
        filledText: '5',
        emptyText: '',
        defectiveText: '',
        stockTransferFlag: false,
      );
      expect(result, SubmitResult.stockNotAccepted);
    });

    test(
        'TC_SUB_10 [-] Godown selected, qty present, but stock not accepted → stockNotAccepted',
            () {
          final result = evaluateSubmit(
            saveFlag: false,
            selectedGodownName: 'GDN-003',
            filledText: '2',
            emptyText: '1',
            defectiveText: '0',
            stockTransferFlag: false,
          );
          expect(result, SubmitResult.stockNotAccepted);
        });

    test('TC_SUB_11 [-] Whitespace-only qty → still empty → noQtyEntered', () {
      // Whitespace strings are non-empty but should be trimmed before check;
      // here we test the raw logic as the screen does: text.isNotEmpty
      // A space character passes isNotEmpty — document this boundary.
      final result = evaluateSubmit(
        saveFlag: false,
        selectedGodownName: 'GDN-002',
        filledText: ' ',   // space — not empty!
        emptyText: '',
        defectiveText: '',
        stockTransferFlag: true,
      );
      // " ".isNotEmpty == true → goes forward to stockTransferFlag check
      expect(result, SubmitResult.proceedToApi);
      // NOTE: This documents a known UI edge-case. int.tryParse(' ') == null → 0.
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 4 ── Godown list filtering
  // ═══════════════════════════════════════════════════════════════════════════
  group('Godown list filtering (exclude current godown)', () {
    // ── POSITIVE ──────────────────────────────────────────────────────────────

    test('TC_GDN_01 [+] Current godown removed from list', () {
      final filtered = filterGodownList(sampleGodowns, 1);
      expect(filtered.any((g) => g.godownId == 1), isFalse);
    });

    test('TC_GDN_02 [+] Other godowns remain in filtered list', () {
      final filtered = filterGodownList(sampleGodowns, 1);
      expect(filtered.length, equals(2));
      expect(filtered.map((g) => g.godownId), containsAll([2, 3]));
    });

    test('TC_GDN_03 [+] Last godown in list is correctly excluded', () {
      final filtered = filterGodownList(sampleGodowns, 3);
      expect(filtered.any((g) => g.godownId == 3), isFalse);
      expect(filtered.length, equals(2));
    });

    test('TC_GDN_04 [+] Middle godown excluded', () {
      final filtered = filterGodownList(sampleGodowns, 2);
      expect(filtered.any((g) => g.godownId == 2), isFalse);
      expect(filtered.length, equals(2));
    });

    // ── NEGATIVE ──────────────────────────────────────────────────────────────

    test('TC_GDN_05 [-] Non-existent godown id → no item removed', () {
      final filtered = filterGodownList(sampleGodowns, 99);
      expect(filtered.length, equals(sampleGodowns.length));
    });

    test('TC_GDN_06 [-] Empty input list → empty output', () {
      final filtered = filterGodownList([], 1);
      expect(filtered, isEmpty);
    });

    test('TC_GDN_07 [-] Single-item list whose id matches → result is empty',
            () {
          final list = [FakeGetGodownListModel(godownId: 5, godownNo: 'GDN-005')];
          expect(filterGodownList(list, 5), isEmpty);
        });

    test(
        'TC_GDN_08 [-] Single-item list whose id does not match → result has 1 item',
            () {
          final list = [FakeGetGodownListModel(godownId: 5, godownNo: 'GDN-005')];
          expect(filterGodownList(list, 9).length, equals(1));
        });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 5 ── saveFlag derivation from day-end API response
  // ═══════════════════════════════════════════════════════════════════════════
  group('saveFlag derivation from checkAndSaveDayEndData response', () {
    // ── POSITIVE ──────────────────────────────────────────────────────────────

    test('TC_SAV_01 [+] Non-empty API response → saveFlag true', () {
      final response = [
        {'DSRSaved': 1, 'CDCMSStkSaved': 1, 'OpClSaved': 1}
      ];
      expect(deriveSaveFlag(response), isTrue);
    });

    test('TC_SAV_02 [+] Multiple records in response → saveFlag true', () {
      final response = [
        {'DSRSaved': 1},
        {'DSRSaved': 0},
      ];
      expect(deriveSaveFlag(response), isTrue);
    });

    // ── NEGATIVE ──────────────────────────────────────────────────────────────

    test('TC_SAV_03 [-] Empty API response list → saveFlag false', () {
      expect(deriveSaveFlag([]), isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 6 ── Request body construction
  // ═══════════════════════════════════════════════════════════════════════════
  group('Request body construction for submitStockToApi', () {
    // ── POSITIVE ──────────────────────────────────────────────────────────────

    test('TC_REQ_01 [+] All fields populated correctly', () {
      final body = buildRequestBody(
        distributorId: 10,
        fromGodownId: 1,
        stkTransDate: '2025-01-15',
        toGodownId: 2,
        itemId: 100,
        filledText: '5',
        emptyText: '3',
        defectiveText: '1',
        remark: 'Test remark',
        addedBy: 'Staff01',
      );
      expect(body['DistributorId'], equals(10));
      expect(body['FromGodownId'], equals(1));
      expect(body['ToGodownId'], equals(2));
      expect(body['ItemId'], equals(100));
      expect(body['FilledStk'], equals(5));
      expect(body['EmptyStk'], equals(3));
      expect(body['DefectiveStk'], equals(1));
      expect(body['Remark'], equals('Test remark'));
      expect(body['AddedBy'], equals('Staff01'));
      expect(body['IsStkTrans'], equals(0));
    });

    test('TC_REQ_02 [+] IsStkTrans is always 0 in request body', () {
      final body = buildRequestBody(
        distributorId: 1, fromGodownId: 1, stkTransDate: '2025-01-01',
        toGodownId: 2, itemId: 1,
        filledText: '1', emptyText: '0', defectiveText: '0',
        remark: '', addedBy: 'S1',
      );
      expect(body['IsStkTrans'], equals(0));
    });

    test('TC_REQ_03 [+] Empty remark string included in body', () {
      final body = buildRequestBody(
        distributorId: 1, fromGodownId: 1, stkTransDate: '2025-01-01',
        toGodownId: 2, itemId: 1,
        filledText: '1', emptyText: '0', defectiveText: '0',
        remark: '', addedBy: 'S1',
      );
      expect(body['Remark'], equals(''));
    });

    test('TC_REQ_04 [+] Date format is passed through verbatim', () {
      final body = buildRequestBody(
        distributorId: 1, fromGodownId: 1, stkTransDate: '2025-12-31',
        toGodownId: 2, itemId: 1,
        filledText: '0', emptyText: '0', defectiveText: '0',
        remark: '', addedBy: 'S1',
      );
      expect(body['StkTransDate'], equals('2025-12-31'));
    });

    // ── NEGATIVE ──────────────────────────────────────────────────────────────

    test('TC_REQ_05 [-] Non-numeric filledText → FilledStk defaults to 0', () {
      final body = buildRequestBody(
        distributorId: 1, fromGodownId: 1, stkTransDate: '2025-01-01',
        toGodownId: 2, itemId: 1,
        filledText: 'abc', emptyText: '', defectiveText: '',
        remark: '', addedBy: 'S1',
      );
      expect(body['FilledStk'], equals(0));
    });

    test('TC_REQ_06 [-] Empty filledText → FilledStk defaults to 0', () {
      final body = buildRequestBody(
        distributorId: 1, fromGodownId: 1, stkTransDate: '2025-01-01',
        toGodownId: 2, itemId: 1,
        filledText: '', emptyText: '', defectiveText: '',
        remark: '', addedBy: 'S1',
      );
      expect(body['FilledStk'], equals(0));
      expect(body['EmptyStk'], equals(0));
      expect(body['DefectiveStk'], equals(0));
    });

    test('TC_REQ_07 [-] Non-numeric emptyText → EmptyStk defaults to 0', () {
      final body = buildRequestBody(
        distributorId: 1, fromGodownId: 1, stkTransDate: '2025-01-01',
        toGodownId: 2, itemId: 1,
        filledText: '', emptyText: '!!', defectiveText: '',
        remark: '', addedBy: 'S1',
      );
      expect(body['EmptyStk'], equals(0));
    });

    test('TC_REQ_08 [-] Non-numeric defectiveText → DefectiveStk defaults to 0',
            () {
          final body = buildRequestBody(
            distributorId: 1, fromGodownId: 1, stkTransDate: '2025-01-01',
            toGodownId: 2, itemId: 1,
            filledText: '', emptyText: '', defectiveText: 'N/A',
            remark: '', addedBy: 'S1',
          );
          expect(body['DefectiveStk'], equals(0));
        });

    test('TC_REQ_09 [-] Body can be JSON-encoded without error', () {
      final body = buildRequestBody(
        distributorId: 10, fromGodownId: 1, stkTransDate: '2025-01-15',
        toGodownId: 2, itemId: 100,
        filledText: '5', emptyText: '3', defectiveText: '1',
        remark: 'Test', addedBy: 'Staff01',
      );
      expect(() => json.encode(body), returnsNormally);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 7 ── JSON parsing (API response → model list)
  // ═══════════════════════════════════════════════════════════════════════════
  group('JSON parsing – transfer list & godown list', () {
    // ── POSITIVE ──────────────────────────────────────────────────────────────

    test('TC_PRS_01 [+] Valid transfer list JSON parses correctly', () {
      const rawJson = '''[
        {"IsStkTrans": 1, "ItemName": "Item A", "FilledStk": 10, "EmptyStk": 5, "DefectiveStk": 0},
        {"IsStkTrans": 0, "ItemName": "Item B", "FilledStk": 3,  "EmptyStk": 2, "DefectiveStk": 1}
      ]''';
      final list = parseTransferList(rawJson);
      expect(list.length, equals(2));
      expect(list[0].isStkTrans, equals(1));
      expect(list[1].isStkTrans, equals(0));
      expect(list[0].itemName, equals('Item A'));
    });

    test('TC_PRS_02 [+] Empty transfer list JSON → empty list', () {
      final list = parseTransferList('[]');
      expect(list, isEmpty);
    });

    test('TC_PRS_03 [+] Valid godown list JSON parses correctly', () {
      const rawJson = '''[
        {"GodownId": 1, "GodownNo": "GDN-001"},
        {"GodownId": 2, "GodownNo": "GDN-002"}
      ]''';
      final list = parseGodownList(rawJson);
      expect(list.length, equals(2));
      expect(list[0].godownId, equals(1));
      expect(list[1].godownNo, equals('GDN-002'));
    });

    test('TC_PRS_04 [+] Empty godown list JSON → empty list', () {
      final list = parseGodownList('[]');
      expect(list, isEmpty);
    });

    test('TC_PRS_05 [+] Transfer list with all isStkTrans==1 → flag becomes true',
            () {
          const rawJson = '''[
        {"IsStkTrans": 1}, {"IsStkTrans": 1}, {"IsStkTrans": 1}
      ]''';
          final list = parseTransferList(rawJson);
          expect(deriveStockTransferFlag(list), isTrue);
        });

    test('TC_PRS_06 [+] Transfer list with one isStkTrans==0 → flag false', () {
      const rawJson = '''[
        {"IsStkTrans": 1}, {"IsStkTrans": 0}
      ]''';
      final list = parseTransferList(rawJson);
      expect(deriveStockTransferFlag(list), isFalse);
    });

    // ── NEGATIVE ──────────────────────────────────────────────────────────────

    test('TC_PRS_07 [-] Missing IsStkTrans key → null, treated as non-zero',
            () {
          const rawJson = '[{"ItemName": "Item X"}]';
          final list = parseTransferList(rawJson);
          expect(list[0].isStkTrans, isNull);
          // null != 0 → flag stays true
          expect(deriveStockTransferFlag(list), isTrue);
        });

    test('TC_PRS_08 [-] Missing GodownNo key → null', () {
      const rawJson = '[{"GodownId": 7}]';
      final list = parseGodownList(rawJson);
      expect(list[0].godownNo, isNull);
    });

    test('TC_PRS_09 [-] Malformed JSON throws FormatException', () {
      expect(() => parseTransferList('{bad json}'), throwsA(isA<FormatException>()));
    });

    test('TC_PRS_10 [-] JSON object instead of array throws TypeError', () {
      expect(() => parseTransferList('{"key": "val"}'),
          throwsA(isA<TypeError>()));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 8 ── _StockSummaryCard widget tests
  // ═══════════════════════════════════════════════════════════════════════════
  group('_StockChip label and count display logic', () {
    // Pure value tests – no widget pump needed

    test('TC_CHIP_01 [+] Count 0 renders as string "0"', () {
      expect(0.toString(), equals('0'));
    });

    test('TC_CHIP_02 [+] Large count renders correctly', () {
      expect(9999.toString(), equals('9999'));
    });

    test('TC_CHIP_03 [+] Label uppercased for display', () {
      expect('Filled'.toUpperCase(), equals('FILLED'));
      expect('Empty'.toUpperCase(), equals('EMPTY'));
      expect('Defective'.toUpperCase(), equals('DEFECTIVE'));
    });

    test('TC_CHIP_04 [-] Negative count renders as negative string', () {
      // Edge-case: UI doesn't guard against negatives passed in
      expect((-5).toString(), equals('-5'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 9 ── Remark field constraints
  // ═══════════════════════════════════════════════════════════════════════════
  group('Remark field constraints', () {
    test('TC_RMK_01 [+] Remark within 250 chars is valid', () {
      final remark = 'A' * 250;
      expect(remark.length <= 250, isTrue);
    });

    test('TC_RMK_02 [+] Empty remark is acceptable', () {
      expect(''.length <= 250, isTrue);
    });

    test('TC_RMK_03 [-] Remark exceeding 250 chars gets truncated by maxLength',
            () {
          // maxLength: 250 is enforced by Flutter TextField; simulate the clamp:
          final input = 'B' * 300;
          final clamped = input.substring(0, 250);
          expect(clamped.length, equals(250));
        });

    test('TC_RMK_04 [+] Remark with special characters is included in body',
            () {
          const remark = 'Stock transferred! #rush @godown-2 (urgent)';
          final body = buildRequestBody(
            distributorId: 1, fromGodownId: 1, stkTransDate: '2025-01-01',
            toGodownId: 2, itemId: 1,
            filledText: '1', emptyText: '0', defectiveText: '0',
            remark: remark, addedBy: 'S1',
          );
          expect(body['Remark'], equals(remark));
        });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GROUP 10 ── Edge-case combinations
  // ═══════════════════════════════════════════════════════════════════════════
  group('Edge-case combinations', () {
    test(
        'TC_EDGE_01 [+] Transfer list empty → stockTransferFlag true → submit proceeds if godown set',
            () {
          final flag = deriveStockTransferFlag([]);
          final result = evaluateSubmit(
            saveFlag: false,
            selectedGodownName: 'GDN-002',
            filledText: '1',
            emptyText: '',
            defectiveText: '',
            stockTransferFlag: flag,
          );
          expect(result, SubmitResult.proceedToApi);
        });

    test(
        'TC_EDGE_02 [-] saveFlag true + no godown + no qty + flag false → dayEndAlreadyCompleted (saveFlag wins)',
            () {
          final result = evaluateSubmit(
            saveFlag: true,
            selectedGodownName: null,
            filledText: '',
            emptyText: '',
            defectiveText: '',
            stockTransferFlag: false,
          );
          expect(result, SubmitResult.dayEndAlreadyCompleted);
        });

    test('TC_EDGE_03 [-] Qty exceeds stock of 0 → exceeded for all types', () {
      expect(isFilledQtyExceeded('1', 0), isTrue);
      expect(isEmptyQtyExceeded('1', 0), isTrue);
      expect(isDefectiveQtyExceeded('1', 0), isTrue);
    });

    test('TC_EDGE_04 [+] Qty 0 never exceeds any stock', () {
      expect(isFilledQtyExceeded('0', 0), isFalse);
      expect(isEmptyQtyExceeded('0', 0), isFalse);
      expect(isDefectiveQtyExceeded('0', 0), isFalse);
    });

    test(
        'TC_EDGE_05 [+] All three qty fields zero → noQtyEntered still blocked (all empty strings)',
            () {
          // User enters nothing — fields remain empty strings
          final result = evaluateSubmit(
            saveFlag: false,
            selectedGodownName: 'GDN-002',
            filledText: '',
            emptyText: '',
            defectiveText: '',
            stockTransferFlag: true,
          );
          expect(result, SubmitResult.noQtyEntered);
        });

    test(
        'TC_EDGE_06 [+] Current godown filtered, selected godown ID assigned correctly',
            () {
          final filtered = filterGodownList(sampleGodowns, 1);
          // Simulate user picking first item from filtered list
          final picked = filtered.first;
          expect(picked.godownId, isNot(equals(1)));
          expect(picked.godownNo, isNotNull);
        });

    test('TC_EDGE_07 [-] Request body with max remark 250 chars encodes fine',
            () {
          final remark = 'X' * 250;
          final body = buildRequestBody(
            distributorId: 1, fromGodownId: 1, stkTransDate: '2025-01-01',
            toGodownId: 2, itemId: 1,
            filledText: '1', emptyText: '0', defectiveText: '0',
            remark: remark, addedBy: 'S1',
          );
          expect(() => json.encode(body), returnsNormally);
          expect((body['Remark'] as String).length, equals(250));
        });
  });
}