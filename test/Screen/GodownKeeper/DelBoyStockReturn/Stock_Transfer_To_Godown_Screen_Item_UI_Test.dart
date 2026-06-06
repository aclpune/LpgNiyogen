import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lpgsalesandinventory/Screen/GodownKeeper/DelBoyStockReturn/StockTransferTOGodownScreenItemUI.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DeliveryBoyModel/GetStockTransferListModel.dart';

void main() {
  group('GetStockTransferListModel (model)', () {
	test('fromJson/toJson/copyWith', () {
	  final json = {
		'StkTransId': 3,
		'DistributorId': 8118,
		'StkTransDate': '2025-02-07T00:00:00',
		'FromGodownId': 1,
		'ToGodownId': 24,
		'ItemId': 4,
		'ItemName': '2 Kg',
		'FilledStk': 20,
		'EmptyStk': 0,
		'DefectiveStk': 0,
		'IsStkTrans': 0,
		'Remark': 'test',
		'AddedOn': '2025-02-07T09:04:32.03',
		'AddedBy': 61,
	  };

	  final model = GetStockTransferListModel.fromJson(json);
	  expect(model.stkTransId, 3);
	  expect(model.itemName, '2 Kg');

	  final encoded = model.toJson();
	  expect(encoded['ItemName'], '2 Kg');

	  final changed = model.copyWith(itemName: '5 Kg', filledStk: 5);
	  expect(changed.itemName, '5 Kg');
	  expect(changed.filledStk, 5);
	});
  });

  group('StockTransferTOGodownScreenItemUI widget', () {
	setUp(() {
	  // default mock prefs values
	  SharedPreferences.setMockInitialValues({
		'godownId': '1',
		'DistributorId': '10',
		'StaffId': '5',
		'token': 'abc',
		'MobileNo': '9999999999',
	  });
	});

	testWidgets('renders item name, date badge and Accept button when visible',
		(tester) async {
	  // Arrange: fake HTTP responses (return empty list for any request)
	  final overrides = _SimpleHttpOverrides(responseBody: json.encode([]));
	  HttpOverrides.global = overrides;

	  final model = GetStockTransferListModel(
		stkTransId: 1,
		stkTransDate: '2025-02-07T00:00:00',
		fromGodownId: 2,
		toGodownId: 3,
		itemId: 4,
		itemName: 'Test Item',
		filledStk: 10,
		emptyStk: 0,
		defectiveStk: 0,
		isStkTrans: 0,
		remark: 'ok',
	  );

	  await tester.pumpWidget(MaterialApp(home: StockTransferTOGodownScreenItemUI(model)));

	  // Await async operations triggered by initState
	  await tester.pumpAndSettle();

	  expect(find.text('Test Item'), findsOneWidget);
	  expect(find.text('Accept'), findsOneWidget);

	  // Clean up
	  HttpOverrides.global = null;
	});

	testWidgets('hides Accept button when fromGodownId equals saved godownId',
		(tester) async {
	  HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));

	  final model = GetStockTransferListModel(
		stkTransId: 2,
		stkTransDate: '2025-02-07T00:00:00',
		fromGodownId: 1, // same as mocked godownId
		toGodownId: 3,
		itemId: 5,
		itemName: 'Hidden Accept',
		filledStk: 5,
		emptyStk: 0,
		defectiveStk: 0,
		isStkTrans: 0,
	  );

	  await tester.pumpWidget(MaterialApp(home: StockTransferTOGodownScreenItemUI(model)));
	  await tester.pumpAndSettle();

	  expect(find.text('Hidden Accept'), findsOneWidget);
	  expect(find.text('Accept'), findsNothing);

	  HttpOverrides.global = null;
	});
  });
}

// A minimal HttpOverrides that returns a HttpClient which responds with a fixed
// body and 200 status for any request. This is sufficient for package:http's
// IOClient used under the hood by `http.get`/`http.post`.
class _SimpleHttpOverrides extends HttpOverrides {
  final String responseBody;
  final int statusCode;

  _SimpleHttpOverrides({required this.responseBody, this.statusCode = 200});

  @override
  HttpClient createHttpClient(SecurityContext? context) {
	return _SimpleHttpClient(responseBody, statusCode);
  }
}

class _SimpleHttpClient implements HttpClient {
  final String _body;
  final int _status;

  _SimpleHttpClient(this._body, this._status);

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _SimpleHttpClientRequest(_body, _status);

  // The tests only require getUrl; other members can be no-op / throw if used.
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SimpleHttpClientRequest implements HttpClientRequest {
  final String _body;
  final int _status;
  final HttpHeaders headers = _SimpleHttpHeaders();

  _SimpleHttpClientRequest(this._body, this._status);

  @override
  Future<HttpClientResponse> close() async => _SimpleHttpClientResponse(_body, _status);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SimpleHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  final String _body;
  final int _status;

  _SimpleHttpClientResponse(this._body, this._status);

  @override
  int get statusCode => _status;

  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;

  @override
  HttpHeaders get headers => _SimpleHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
	final controller = StreamController<List<int>>();
	controller.add(utf8.encode(_body));
	controller.close();
	return controller.stream.listen((data) {
	  if (onData != null) onData(data);
	}, onError: onError, onDone: onDone, cancelOnError: cancelOnError ?? false);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SimpleHttpHeaders implements HttpHeaders {
  final Map<String, List<String>> _map = {};

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
	_map.putIfAbsent(name, () => []).add(value.toString());
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) => _map[name] = [value.toString()];

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}



