import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

import 'package:lpgsalesandinventory/Screen/GodownKeeper/ItemReceipt/ItemReturn/ItenReturnItemUi.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/ItemReceipt/EditItem/Model/GetItemReceiptListModel.dart';
import 'package:lpgsalesandinventory/Screen/User/Login/provider/LoginProvider.dart';

void main() {
  group('ItemReturnScreenListItem widget', () {
	setUp(() {
	  SharedPreferences.setMockInitialValues({
		'godownId': '1',
		'DistributorId': '10',
		'StaffId': '5',
		'token': 'abc',
		'MobileNo': '9999999999',
	  });
	});

	testWidgets('renders header with vehicle number, date and Pending badge',
		(tester) async {
	  HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));

	  final item = ItemDetails(pkId: 1, itemId: 2, itemName: 'MyItem', filledQty: 5);
	  final model = GetItemReceiptListModel(
		pkId: 1,
		receiptId: 10,
		receiptDate: '2024-11-26T00:00:00',
		returnOn: '0001-01-01T00:00:00',
		vehicleNo: 'V1',
		itemDetails: [item],
	  );

	  await tester.pumpWidget(
		ChangeNotifierProvider<LoginProvider>(
		  create: (_) => LoginProvider(),
		  child: MaterialApp(home: ItemReturnScreenListItem(model)),
		),
	  );
	  await tester.pumpAndSettle();
	  // Advance fake time past InternetConnectionChecker's 10-second socket timeouts
	  await tester.pump(const Duration(seconds: 11));

	  expect(find.textContaining('Vehicle No. - V1'), findsOneWidget);
	  expect(find.text('Pending'), findsOneWidget);
	  expect(find.text('2024-11-26'), findsOneWidget);

	  HttpOverrides.global = null;
	});

	testWidgets('tapping View More shows item details list', (tester) async {
	  HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));

	  final item = ItemDetails(pkId: 1, itemId: 2, itemName: 'MyItem', filledQty: 5);
	  final model = GetItemReceiptListModel(
		pkId: 1,
		receiptId: 10,
		receiptDate: '2024-11-26T00:00:00',
		returnOn: '0001-01-01T00:00:00',
		vehicleNo: 'V1',
		itemDetails: [item],
	  );

	  await tester.pumpWidget(
		ChangeNotifierProvider<LoginProvider>(
		  create: (_) => LoginProvider(),
		  child: MaterialApp(home: ItemReturnScreenListItem(model)),
		),
	  );
	  await tester.pumpAndSettle();
	  await tester.pump(const Duration(seconds: 11));

	  // Initially the list is hidden, so item name should not be visible
	  expect(find.textContaining('MyItem'), findsNothing);

	  // Tap the View More toggle
	  final viewMore = find.text('View More');
	  expect(viewMore, findsOneWidget);
	  await tester.tap(viewMore);
	  await tester.pumpAndSettle();
	  await tester.pump(const Duration(seconds: 11));

	  // Now the item row should be visible (widget renders "Item: MyItem")
	  expect(find.textContaining('MyItem'), findsOneWidget);

	  HttpOverrides.global = null;
	});

	testWidgets('shows Returned badge when returnOn is not pending', (tester) async {
	  HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));

	  final model = GetItemReceiptListModel(
		pkId: 1,
		receiptId: 10,
		receiptDate: '2024-11-27T00:00:00',
		returnOn: '2024-11-27T00:00:00',
		vehicleNo: 'V2',
		itemDetails: [],
	  );

	  await tester.pumpWidget(
		ChangeNotifierProvider<LoginProvider>(
		  create: (_) => LoginProvider(),
		  child: MaterialApp(home: ItemReturnScreenListItem(model)),
		),
	  );
	  await tester.pumpAndSettle();
	  await tester.pump(const Duration(seconds: 11));

	  expect(find.text('Returned'), findsOneWidget);

	  HttpOverrides.global = null;
	});
  });
}

// Minimal HttpOverrides and fake HttpClient implementations used by tests
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

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _SimpleHttpClientRequest(_body, _status);

  @override
  void close({bool force = false}) {}

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SimpleHttpClientRequest implements HttpClientRequest {
  final String _body;
  final int _status;
  final HttpHeaders headers = _SimpleHttpHeaders();

  _SimpleHttpClientRequest(this._body, this._status);

  @override
  int contentLength = -1;

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




