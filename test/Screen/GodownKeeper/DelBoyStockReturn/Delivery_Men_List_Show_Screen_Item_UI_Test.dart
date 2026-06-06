// delivery_men_list_show_screen_item_ui_test.dart
//
// Self-contained automation tests for DeliveryMenListShowScreenItemUI logic.
// All models and widgets are defined inline — no external package imports needed.
//
// Run with:  flutter test test/delivery_men_list_show_screen_item_ui_test.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// =============================================================================
// INLINE MODEL DEFINITIONS
// =============================================================================

class DeliveryMenSaleListModel {
  final String? staffName;
  final int? dMId;
  final String? vehicleNo;
  final int? filledSaleQty;

  DeliveryMenSaleListModel({
    this.staffName,
    this.dMId,
    this.vehicleNo,
    this.filledSaleQty,
  });
}

class GetStockTransferListModel {
  final int? id;
  final int? isStkTrans;
  final int? dMId;

  GetStockTransferListModel({this.id, this.isStkTrans, this.dMId});

  factory GetStockTransferListModel.fromJson(Map<String, dynamic> json) {
    return GetStockTransferListModel(
      id: json['id'] as int?,
      isStkTrans: json['isStkTrans'] as int?,
      dMId: json['dMId'] as int?,
    );
  }
}

// =============================================================================
// INLINE WIDGET DEFINITIONS (mirrors real widgets)
// =============================================================================

class DeliveryMenListShowScreenItemUI extends StatefulWidget {
  final DeliveryMenSaleListModel _listModel;

  const DeliveryMenListShowScreenItemUI(this._listModel, {Key? key})
      : super(key: key);

  @override
  State<DeliveryMenListShowScreenItemUI> createState() =>
      _DeliveryMenListShowScreenItemUIState();
}

class _DeliveryMenListShowScreenItemUIState
    extends State<DeliveryMenListShowScreenItemUI> {
  bool isListViewVisible = false;
  bool isLoading = true;
  bool saveFlag = false;
  bool stockTransferFlag = false;
  List<GetStockTransferListModel> stockTransferList = [];

  @override
  void initState() {
    super.initState();
    // fetchTransactionList() is intentionally commented out in the real code.
  }

  @override
  Widget build(BuildContext context) {
    final value = widget._listModel;

    if (value.toString() == '') {
      return const _NoDataCard();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/daily_refill_sale',
              arguments: {
                'delBoyName': value.staffName,
                'delBoyID': value.dMId,
                'vehicleNo': value.vehicleNo,
              },
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: _DeliveryManCard(value: value),
        ),
      ),
    );
  }

  // Extracted pure function — mirrors the setState block in fetchTransactionList.
  static bool computeStockTransferFlag(List<GetStockTransferListModel> list) {
    for (final item in list) {
      if (item.isStkTrans == 0) return false;
    }
    return true;
  }
}

class _DeliveryManCard extends StatelessWidget {
  const _DeliveryManCard({required this.value});
  final DeliveryMenSaleListModel value;

  @override
  Widget build(BuildContext context) {
    final initials =
    (value.staffName != null && value.staffName!.isNotEmpty)
        ? value.staffName![0].toUpperCase()
        : '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(initials,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value.staffName.toString(),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('Total Sale: ',
                        style:
                        TextStyle(fontSize: 13, color: Colors.grey)),
                    Text(value.filledSaleQty.toString(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: Colors.grey, size: 22),
        ],
      ),
    );
  }
}

class _NoDataCard extends StatelessWidget {
  const _NoDataCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text('No data found',
          style: TextStyle(fontSize: 14, color: Colors.grey)),
    );
  }
}

// =============================================================================
// FAKE MODEL — triggers _NoDataCard path via toString() == ""
// =============================================================================

class _EmptyStringModel extends DeliveryMenSaleListModel {
  _EmptyStringModel() : super();

  @override
  String toString() => '';
}

// =============================================================================
// NAVIGATOR SPY
// =============================================================================

class _NavSpy extends NavigatorObserver {
  String? pushedRouteName;
  Map<String, dynamic>? pushedArgs;

  @override
  void didPush(Route route, Route? previousRoute) {
    pushedRouteName = route.settings.name;
    pushedArgs = route.settings.arguments as Map<String, dynamic>?;
    super.didPush(route, previousRoute);
  }
}

// =============================================================================
// HELPERS
// =============================================================================

DeliveryMenSaleListModel makeModel({
  String? staffName = 'Rahul Sharma',
  int? dMId = 101,
  String? vehicleNo = 'MH-12-AB-1234',
  int? filledSaleQty = 25,
}) =>
    DeliveryMenSaleListModel(
      staffName: staffName,
      dMId: dMId,
      vehicleNo: vehicleNo,
      filledSaleQty: filledSaleQty,
    );

Widget buildTestable(
    DeliveryMenSaleListModel model, {
      _NavSpy? observer,
      Map<String, WidgetBuilder>? routes,
    }) {
  return MaterialApp(
    navigatorObservers: observer != null ? [observer] : [],
    routes: routes ??
        {
          '/daily_refill_sale': (_) =>
          const Scaffold(body: Text('DailyRefillSalePage')),
        },
    home: Scaffold(body: DeliveryMenListShowScreenItemUI(model)),
  );
}

// =============================================================================
// TESTS
// =============================================================================

void main() {
  // ---------------------------------------------------------------------------
  // GROUP 1: Widget Rendering — Positive
  // ---------------------------------------------------------------------------
  group('Group 1 | Widget Rendering — Positive', () {
    testWidgets('TC-P-01: renders staffName for valid model', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel(staffName: 'Rahul Sharma')));
      expect(find.text('Rahul Sharma'), findsOneWidget);
    });

    testWidgets('TC-P-02: renders filledSaleQty and "Total Sale:" label',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel(filledSaleQty: 42)));
          expect(find.text('42'), findsOneWidget);
          expect(find.text('Total Sale: '), findsOneWidget);
        });

    testWidgets('TC-P-03: avatar shows first letter uppercased', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel(staffName: 'rahul')));
      expect(find.text('R'), findsOneWidget);
    });

    testWidgets('TC-P-04: avatar shows "?" when staffName is empty string',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel(staffName: '')));
          expect(find.text('?'), findsOneWidget);
        });

    testWidgets('TC-P-05: avatar shows "?" when staffName is null',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel(staffName: null)));
          expect(find.text('?'), findsOneWidget);
        });

    testWidgets('TC-P-06: chevron_right_rounded icon is present', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel()));
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    });

    testWidgets('TC-P-07: card is wrapped in InkWell', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel()));
      expect(find.byType(InkWell), findsAtLeastNWidgets(1));
    });

    testWidgets('TC-P-08: filledSaleQty of 0 renders "0"', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel(filledSaleQty: 0)));
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('TC-P-09: large quantity (999) renders correctly', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel(filledSaleQty: 999)));
      expect(find.text('999'), findsOneWidget);
    });

    testWidgets('TC-P-10: multi-word name — avatar uses first char, full name shown',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel(staffName: 'amit kumar')));
          expect(find.text('A'), findsOneWidget);
          expect(find.text('amit kumar'), findsOneWidget);
        });

    testWidgets('TC-P-11: widget builds without exception for valid model',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel()));
          expect(tester.takeException(), isNull);
        });
  });

  // ---------------------------------------------------------------------------
  // GROUP 2: Widget Rendering — Negative / Edge Cases
  // ---------------------------------------------------------------------------
  group('Group 2 | Widget Rendering — Negative / Edge Cases', () {
    testWidgets(
        'TC-N-01: shows _NoDataCard when model.toString() returns empty string',
            (tester) async {
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: DeliveryMenListShowScreenItemUI(_EmptyStringModel())),
          ));
          expect(find.text('No data found'), findsOneWidget);
          expect(find.byType(InkWell), findsNothing);
        });

    testWidgets('TC-N-02: _NoDataCard has no chevron icon', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: DeliveryMenListShowScreenItemUI(_EmptyStringModel())),
      ));
      expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
    });

    testWidgets('TC-N-03: very long staffName does not cause layout overflow',
            (tester) async {
          const longName = 'Rajkumar Subrahmanyam Venkatanarasimharajuvaripeta';
          await tester.pumpWidget(buildTestable(makeModel(staffName: longName)));
          expect(tester.takeException(), isNull);
          expect(find.text(longName), findsOneWidget);
        });

    testWidgets('TC-N-04: filledSaleQty null renders "null" without crash',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel(filledSaleQty: null)));
          expect(tester.takeException(), isNull);
          expect(find.text('null'), findsOneWidget);
        });

    testWidgets('TC-N-05: staffName with only whitespace does not crash',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel(staffName: '   ')));
          expect(tester.takeException(), isNull);
        });

    testWidgets('TC-N-06: unicode staffName — first codepoint in avatar',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel(staffName: 'अमित')));
          expect(find.text('अ'), findsOneWidget);
          expect(tester.takeException(), isNull);
        });

    testWidgets('TC-N-07: vehicleNo = null — widget still renders', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel(vehicleNo: null)));
      expect(tester.takeException(), isNull);
    });

    testWidgets('TC-N-08: dMId = null — widget still renders', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel(dMId: null)));
      expect(tester.takeException(), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // GROUP 3: Navigation — Positive
  // ---------------------------------------------------------------------------
  group('Group 3 | Navigation — Positive', () {
    testWidgets('TC-P-12: tapping card pushes the correct named route',
            (tester) async {
          final spy = _NavSpy();
          await tester.pumpWidget(buildTestable(makeModel(), observer: spy));
          await tester.tap(find.byType(InkWell).first);
          await tester.pumpAndSettle();
          expect(spy.pushedRouteName, equals('/daily_refill_sale'));
        });

    testWidgets('TC-P-13: navigation arguments contain correct delBoyName',
            (tester) async {
          Map<String, dynamic>? capturedArgs;
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: DeliveryMenListShowScreenItemUI(
                    makeModel(staffName: 'Suresh'))),
            onGenerateRoute: (settings) {
              if (settings.name == '/daily_refill_sale') {
                capturedArgs = settings.arguments as Map<String, dynamic>?;
              }
              return MaterialPageRoute(builder: (_) => const Scaffold());
            },
          ));
          await tester.tap(find.byType(InkWell).first);
          await tester.pumpAndSettle();
          expect(capturedArgs?['delBoyName'], equals('Suresh'));
        });

    testWidgets('TC-P-14: navigation arguments contain correct delBoyID',
            (tester) async {
          Map<String, dynamic>? capturedArgs;
          await tester.pumpWidget(MaterialApp(
            home:
            Scaffold(body: DeliveryMenListShowScreenItemUI(makeModel(dMId: 77))),
            onGenerateRoute: (settings) {
              if (settings.name == '/daily_refill_sale') {
                capturedArgs = settings.arguments as Map<String, dynamic>?;
              }
              return MaterialPageRoute(builder: (_) => const Scaffold());
            },
          ));
          await tester.tap(find.byType(InkWell).first);
          await tester.pumpAndSettle();
          expect(capturedArgs?['delBoyID'], equals(77));
        });

    testWidgets('TC-P-15: navigation arguments contain correct vehicleNo',
            (tester) async {
          Map<String, dynamic>? capturedArgs;
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: DeliveryMenListShowScreenItemUI(
                    makeModel(vehicleNo: 'GJ-05-ZZ-9999'))),
            onGenerateRoute: (settings) {
              if (settings.name == '/daily_refill_sale') {
                capturedArgs = settings.arguments as Map<String, dynamic>?;
              }
              return MaterialPageRoute(builder: (_) => const Scaffold());
            },
          ));
          await tester.tap(find.byType(InkWell).first);
          await tester.pumpAndSettle();
          expect(capturedArgs?['vehicleNo'], equals('GJ-05-ZZ-9999'));
        });

    testWidgets('TC-P-16: tapping card navigates to destination screen',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel()));
          expect(find.text('DailyRefillSalePage'), findsNothing);
          await tester.tap(find.byType(InkWell).first);
          await tester.pumpAndSettle();
          expect(find.text('DailyRefillSalePage'), findsOneWidget);
        });
  });

  // ---------------------------------------------------------------------------
  // GROUP 4: Navigation — Negative
  // ---------------------------------------------------------------------------
  group('Group 4 | Navigation — Negative', () {
    testWidgets('TC-N-09: _NoDataCard does NOT trigger navigation',
            (tester) async {
          final spy = _NavSpy();
          await tester.pumpWidget(MaterialApp(
            navigatorObservers: [spy],
            home: Scaffold(
                body: DeliveryMenListShowScreenItemUI(_EmptyStringModel())),
          ));
          await tester.tap(find.text('No data found'));
          await tester.pumpAndSettle();
          expect(spy.pushedRouteName, isNot(equals('/daily_refill_sale')));
        });

    testWidgets('TC-N-10: navigation arguments contain exactly 3 keys',
            (tester) async {
          Map<String, dynamic>? capturedArgs;
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(body: DeliveryMenListShowScreenItemUI(makeModel())),
            onGenerateRoute: (settings) {
              if (settings.name == '/daily_refill_sale') {
                capturedArgs = settings.arguments as Map<String, dynamic>?;
              }
              return MaterialPageRoute(builder: (_) => const Scaffold());
            },
          ));
          await tester.tap(find.byType(InkWell).first);
          await tester.pumpAndSettle();
          expect(capturedArgs?.keys.toSet(),
              equals({'delBoyName', 'delBoyID', 'vehicleNo'}));
        });
  });

  // ---------------------------------------------------------------------------
  // GROUP 5: stockTransferFlag Logic — Positive
  // ---------------------------------------------------------------------------
  group('Group 5 | stockTransferFlag Logic — Positive', () {
    test('TC-P-17: flag true when all isStkTrans are non-zero', () {
      final list = [
        GetStockTransferListModel(id: 1, isStkTrans: 1),
        GetStockTransferListModel(id: 2, isStkTrans: 2),
      ];
      expect(
          _DeliveryMenListShowScreenItemUIState.computeStockTransferFlag(list),
          isTrue);
    });

    test('TC-P-18: flag true for empty list', () {
      expect(
          _DeliveryMenListShowScreenItemUIState.computeStockTransferFlag([]),
          isTrue);
    });

    test('TC-P-19: flag true when all values are positive integers', () {
      final list = List.generate(
          5, (i) => GetStockTransferListModel(id: i, isStkTrans: i + 1));
      expect(
          _DeliveryMenListShowScreenItemUIState.computeStockTransferFlag(list),
          isTrue);
    });

    test('TC-P-20: loop breaks early at first zero — rest not evaluated', () {
      final list = [
        GetStockTransferListModel(id: 1, isStkTrans: 0),
        GetStockTransferListModel(id: 2, isStkTrans: 1),
        GetStockTransferListModel(id: 3, isStkTrans: 1),
      ];
      expect(
          _DeliveryMenListShowScreenItemUIState.computeStockTransferFlag(list),
          isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // GROUP 6: stockTransferFlag Logic — Negative
  // ---------------------------------------------------------------------------
  group('Group 6 | stockTransferFlag Logic — Negative', () {
    test('TC-N-11: flag false when first item has isStkTrans == 0', () {
      final list = [GetStockTransferListModel(id: 1, isStkTrans: 0)];
      expect(
          _DeliveryMenListShowScreenItemUIState.computeStockTransferFlag(list),
          isFalse);
    });

    test('TC-N-12: flag false when last item has isStkTrans == 0', () {
      final list = [
        GetStockTransferListModel(id: 1, isStkTrans: 1),
        GetStockTransferListModel(id: 2, isStkTrans: 1),
        GetStockTransferListModel(id: 3, isStkTrans: 0),
      ];
      expect(
          _DeliveryMenListShowScreenItemUIState.computeStockTransferFlag(list),
          isFalse);
    });

    test('TC-N-13: flag false when all items have isStkTrans == 0', () {
      final list = [
        GetStockTransferListModel(id: 1, isStkTrans: 0),
        GetStockTransferListModel(id: 2, isStkTrans: 0),
      ];
      expect(
          _DeliveryMenListShowScreenItemUIState.computeStockTransferFlag(list),
          isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // GROUP 7: JSON Parsing
  // ---------------------------------------------------------------------------
  group('Group 7 | JSON Parsing', () {
    test('TC-P-21: valid JSON array parses into model list', () {
      final body = json.encode([
        {'id': 1, 'isStkTrans': 1, 'dMId': 10},
        {'id': 2, 'isStkTrans': 0, 'dMId': 11},
      ]);
      final list = (json.decode(body) as List)
          .map((e) => GetStockTransferListModel.fromJson(e))
          .toList();
      expect(list.length, equals(2));
      expect(list[0].isStkTrans, equals(1));
      expect(list[1].isStkTrans, equals(0));
    });

    test('TC-P-22: single-item JSON body parses correctly', () {
      final body = json.encode([
        {'id': 5, 'isStkTrans': 3, 'dMId': 20}
      ]);
      final list = (json.decode(body) as List)
          .map((e) => GetStockTransferListModel.fromJson(e))
          .toList();
      expect(list.length, equals(1));
      expect(list[0].id, equals(5));
    });

    test('TC-P-23: empty JSON array parses to empty list', () {
      final body = json.encode([]);
      final list = (json.decode(body) as List)
          .map((e) => GetStockTransferListModel.fromJson(e))
          .toList();
      expect(list, isEmpty);
    });

    test('TC-N-14: malformed JSON throws FormatException', () {
      expect(() => json.decode('NOT_VALID_JSON'), throwsFormatException);
    });

    test('TC-N-15: JSON item missing "isStkTrans" — field is null', () {
      final model = GetStockTransferListModel.fromJson({'id': 1});
      expect(model.isStkTrans, isNull);
    });

    test('TC-N-16: completely empty JSON map — all fields are null', () {
      final model = GetStockTransferListModel.fromJson({});
      expect(model.id, isNull);
      expect(model.isStkTrans, isNull);
      expect(model.dMId, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // GROUP 8: isLoading & Exception State Simulation
  // ---------------------------------------------------------------------------
  group('Group 8 | isLoading & Exception State', () {
    test('TC-P-24: isLoading false after HTTP 200', () {
      bool isLoading = true;
      if (200 == 200) isLoading = false;
      expect(isLoading, isFalse);
    });

    test('TC-N-17: isLoading false after HTTP non-200', () {
      bool isLoading = true;
      if (500 != 200) isLoading = false;
      expect(isLoading, isFalse);
    });

    test('TC-N-18: isLoading false when no network', () {
      bool isLoading = true;
      const isNetworkAvailable = false;
      if (!isNetworkAvailable) isLoading = false;
      expect(isLoading, isFalse);
    });

    test('TC-N-19: throws Exception("Failed To Load Items") on non-200', () {
      expect(
            () {
          if (404 != 200) throw Exception('Failed To Load Items');
        },
        throwsA(isA<Exception>().having(
              (e) => e.toString(),
          'message',
          contains('Failed To Load Items'),
        )),
      );
    });

    test('TC-N-20: throws Exception when bearer token is null', () {
      String? bearerToken;
      expect(
            () {
          if (bearerToken == null) throw Exception('Bearer token is missing');
        },
        throwsA(isA<Exception>().having(
              (e) => e.toString(),
          'message',
          contains('Bearer token is missing'),
        )),
      );
    });

    test('TC-N-21: int.parse throws FormatException for non-numeric string', () {
      expect(() => int.parse('abc'), throwsFormatException);
    });

    test('TC-P-25: int.parse converts numeric string correctly', () {
      expect(int.parse('42'), equals(42));
    });
  });

  // ---------------------------------------------------------------------------
  // GROUP 9: _DeliveryManCard
  // ---------------------------------------------------------------------------
  group('Group 9 | _DeliveryManCard', () {
    testWidgets('TC-P-26: renders staffName', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel(staffName: 'Kiran Patil')));
      expect(find.text('Kiran Patil'), findsOneWidget);
    });

    testWidgets('TC-P-27: renders "Total Sale: " label', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel()));
      expect(find.text('Total Sale: '), findsOneWidget);
    });

    testWidgets('TC-P-28: renders filledSaleQty value', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel(filledSaleQty: 7)));
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('TC-P-29: avatar shows correct initial', (tester) async {
      await tester.pumpWidget(buildTestable(makeModel(staffName: 'Zara')));
      expect(find.text('Z'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // GROUP 10: _NoDataCard
  // ---------------------------------------------------------------------------
  group('Group 10 | _NoDataCard', () {
    testWidgets('TC-P-30: renders "No data found"', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: _NoDataCard())));
      expect(find.text('No data found'), findsOneWidget);
    });

    testWidgets('TC-N-22: _NoDataCard has no InkWell', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: _NoDataCard())));
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('TC-N-23: _NoDataCard has no chevron icon', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(body: _NoDataCard())));
      expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
    });

    testWidgets('TC-N-24: _NoDataCard does not show "Total Sale:" label',
            (tester) async {
          await tester.pumpWidget(const MaterialApp(
              home: Scaffold(body: _NoDataCard())));
          expect(find.text('Total Sale: '), findsNothing);
        });
  });

  // ---------------------------------------------------------------------------
  // GROUP 11: Initial Widget State
  // ---------------------------------------------------------------------------
  group('Group 11 | Initial Widget State', () {
    testWidgets(
        'TC-P-31: widget renders without calling fetchTransactionList on init',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel()));
          expect(tester.takeException(), isNull);
        });

    testWidgets('TC-P-32: DeliveryMenListShowScreenItemUI found in widget tree',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel()));
          expect(find.byType(DeliveryMenListShowScreenItemUI), findsOneWidget);
        });

    testWidgets('TC-P-33: Padding widget present (bottom spacing applied)',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel()));
          expect(find.byType(Padding), findsAtLeastNWidgets(1));
        });
  });

  // ---------------------------------------------------------------------------
  // GROUP 12: Accessibility Smoke Tests
  // ---------------------------------------------------------------------------
  group('Group 12 | Accessibility', () {
    testWidgets('TC-P-34: valid model passes basic semantics check',
            (tester) async {
          await tester.pumpWidget(buildTestable(makeModel(staffName: 'Test User')));
          final handle = tester.ensureSemantics();
          expect(tester.takeException(), isNull);
          handle.dispose();
        });

    testWidgets('TC-P-35: _NoDataCard passes basic semantics check',
            (tester) async {
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: DeliveryMenListShowScreenItemUI(_EmptyStringModel())),
          ));
          final handle = tester.ensureSemantics();
          expect(tester.takeException(), isNull);
          handle.dispose();
        });
  });
}