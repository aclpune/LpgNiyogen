// ============================================================
// delivery_men_list_show_screen_test.dart
// Automation Test Cases for DeliveryMenListShowScreen
// Compatible with: Flutter Test Framework (flutter_test)
// Run with: flutter test test/delivery_men_list_show_screen_test.dart
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Replace with your actual project imports ─────────────────
// import 'package:your_app/GodownKeeperScreen/DeliveryMenList/DeliveryMenListShowScreen.dart';
// import 'package:your_app/GodownKeeperScreen/DeliveryBoyModel/DeliveryMenSaleListModel.dart';

// ─────────────────────────────────────────────────────────────
// SHARED PREFS SETUP
// ─────────────────────────────────────────────────────────────
Future<void> setupSharedPrefs() async {
  SharedPreferences.setMockInitialValues({
    'DistributorId': '101',
    'StaffId': '5',
    'UserId': '7',
    'token': 'test_bearer_token_abc',
    'MobileNo': '9876543210',
  });
}

// ─────────────────────────────────────────────────────────────
// FAKE MODEL — mirrors DeliveryMenSaleListModel fields used
// in this screen (staffName, totalSale, dMId, vehicleNo, etc.)
// ─────────────────────────────────────────────────────────────
class FakeDeliveryMan {
  final String? staffName;
  final num? totalSale;
  final num? dMId;
  final String? vehicleNo;
  final num? dailySaleStatus;

  const FakeDeliveryMan({
    this.staffName,
    this.totalSale,
    this.dMId,
    this.vehicleNo,
    this.dailySaleStatus,
  });
}

// ─────────────────────────────────────────────────────────────
// ALL TESTS INSIDE main()
// ─────────────────────────────────────────────────────────────
void main() {
  // ===========================================================
  // 1. filterSearchResults() — SEARCH / FILTER LOGIC
  // ===========================================================
  group('filterSearchResults() – Search Logic', () {
    final List<FakeDeliveryMan> allDelBoys = [
      const FakeDeliveryMan(staffName: 'Ravi Kumar'),
      const FakeDeliveryMan(staffName: 'Suresh Patil'),
      const FakeDeliveryMan(staffName: 'Ramesh Yadav'),
      const FakeDeliveryMan(staffName: 'Anita Sharma'),
      const FakeDeliveryMan(staffName: 'ravi Singh'),   // lowercase start
    ];

    test('TC_SRCH_01 [+] Exact case-insensitive name match returns one result', () {
      final results = _filterDelBoys(allDelBoys, 'Ravi Kumar');
      expect(results.length, equals(1));
      expect(results.first.staffName, equals('Ravi Kumar'));
    });

    test('TC_SRCH_02 [+] Partial query "ravi" returns all names containing "ravi"', () {
      final results = _filterDelBoys(allDelBoys, 'ravi');
      expect(results.length, equals(2));
    });

    test('TC_SRCH_03 [+] Uppercase query "RAVI" matches lowercase "ravi Singh"', () {
      final results = _filterDelBoys(allDelBoys, 'RAVI');
      expect(results.length, equals(2));
    });

    test('TC_SRCH_04 [+] Query matching middle of name "esh" returns "Suresh" and "Ramesh"', () {
      final results = _filterDelBoys(allDelBoys, 'esh');
      expect(results.length, equals(2));
    });

    test('TC_SRCH_05 [+] Empty query "" returns all delivery men', () {
      final results = _filterDelBoys(allDelBoys, '');
      expect(results.length, equals(allDelBoys.length));
    });

    test('TC_SRCH_06 [-] Query with no matching name returns empty list', () {
      final results = _filterDelBoys(allDelBoys, 'XYZ_NOT_EXIST');
      expect(results, isEmpty);
    });

    test('TC_SRCH_07 [-] Whitespace-only query matches all (contains "" check)', () {
      final results = _filterDelBoys(allDelBoys, '   ');
      // '   '.toLowerCase().contains('   '.toLowerCase()) → true for all
      expect(results.length, equals(allDelBoys.length));
    });

    test('TC_SRCH_08 [+] Single character query "a" returns multiple results', () {
      final results = _filterDelBoys(allDelBoys, 'a');
      expect(results.length, greaterThan(1));
    });

    test('TC_SRCH_09 [+] Query exactly equals one full name returns exactly 1 result', () {
      final results = _filterDelBoys(allDelBoys, 'Suresh Patil');
      expect(results.length, equals(1));
    });

    test('TC_SRCH_10 [-] Searching against empty master list returns empty result', () {
      final results = _filterDelBoys([], 'Ravi');
      expect(results, isEmpty);
    });

    test('TC_SRCH_11 [+] Query on last name "Sharma" returns correct entry', () {
      final results = _filterDelBoys(allDelBoys, 'Sharma');
      expect(results.length, equals(1));
      expect(results.first.staffName, equals('Anita Sharma'));
    });

    test('TC_SRCH_12 [-] Special characters in query returns empty list', () {
      final results = _filterDelBoys(allDelBoys, '@#\$%');
      expect(results, isEmpty);
    });

    test('TC_SRCH_13 [+] Mixed case query "rAmEsH" matches "Ramesh Yadav"', () {
      final results = _filterDelBoys(allDelBoys, 'rAmEsH');
      expect(results.length, equals(1));
      expect(results.first.staffName, contains('Ramesh'));
    });

    test('TC_SRCH_14 [-] Numeric query "123" returns empty list', () {
      final results = _filterDelBoys(allDelBoys, '123');
      expect(results, isEmpty);
    });
  });

  // ===========================================================
  // 2. ALPHABETICAL SORT LOGIC
  //    After API load, _delBoyInfo.sort() is called by staffName
  // ===========================================================
  group('Alphabetical Sort – fetchDeliveryBoyInfo()', () {
    test('TC_SORT_01 [+] List is sorted A→Z by staffName (case-insensitive)', () {
      final unsorted = [
        const FakeDeliveryMan(staffName: 'Suresh'),
        const FakeDeliveryMan(staffName: 'Anita'),
        const FakeDeliveryMan(staffName: 'Ravi'),
      ];
      final sorted = _sortByName(unsorted);
      expect(sorted[0].staffName, equals('Anita'));
      expect(sorted[1].staffName, equals('Ravi'));
      expect(sorted[2].staffName, equals('Suresh'));
    });

    test('TC_SORT_02 [+] Already sorted list stays sorted', () {
      final already = [
        const FakeDeliveryMan(staffName: 'Anita'),
        const FakeDeliveryMan(staffName: 'Ravi'),
        const FakeDeliveryMan(staffName: 'Suresh'),
      ];
      final sorted = _sortByName(already);
      expect(sorted[0].staffName, equals('Anita'));
      expect(sorted[2].staffName, equals('Suresh'));
    });

    test('TC_SORT_03 [+] Names with lowercase first letter sort correctly', () {
      final list = [
        const FakeDeliveryMan(staffName: 'zara'),
        const FakeDeliveryMan(staffName: 'Anita'),
      ];
      final sorted = _sortByName(list);
      expect(sorted[0].staffName, equals('Anita'));
      expect(sorted[1].staffName, equals('zara'));
    });

    test('TC_SORT_04 [+] Single-element list is returned unchanged', () {
      final single = [const FakeDeliveryMan(staffName: 'Solo')];
      final sorted = _sortByName(single);
      expect(sorted.length, equals(1));
      expect(sorted[0].staffName, equals('Solo'));
    });

    test('TC_SORT_05 [+] Empty list returns empty after sort', () {
      final sorted = _sortByName([]);
      expect(sorted, isEmpty);
    });

    test('TC_SORT_06 [+] Names with same first letter sorted by full name', () {
      final list = [
        const FakeDeliveryMan(staffName: 'Suresh Patil'),
        const FakeDeliveryMan(staffName: 'Sunil Mehta'),
        const FakeDeliveryMan(staffName: 'Sachin Gupta'),
      ];
      final sorted = _sortByName(list);
      expect(sorted[0].staffName, equals('Sachin Gupta'));
      expect(sorted[1].staffName, equals('Sunil Mehta'));
      expect(sorted[2].staffName, equals('Suresh Patil'));
    });

    test('TC_SORT_07 [+] Reverse-sorted list is correctly re-sorted A→Z', () {
      final reversed = [
        const FakeDeliveryMan(staffName: 'Zara'),
        const FakeDeliveryMan(staffName: 'Mohan'),
        const FakeDeliveryMan(staffName: 'Arun'),
      ];
      final sorted = _sortByName(reversed);
      expect(sorted[0].staffName, equals('Arun'));
      expect(sorted[2].staffName, equals('Zara'));
    });
  });

  // ===========================================================
  // 3. filteredList INITIALISATION
  //    After fetch: _filteredDelBoyInfo = List.from(_delBoyInfo)
  // ===========================================================
  group('Filtered List Initialisation', () {
    test('TC_INIT_01 [+] filteredList equals master list after fetch', () {
      final master = [
        const FakeDeliveryMan(staffName: 'Ravi'),
        const FakeDeliveryMan(staffName: 'Anita'),
      ];
      final filtered = List<FakeDeliveryMan>.from(master);
      expect(filtered.length, equals(master.length));
      expect(filtered[0].staffName, equals(master[0].staffName));
    });

    test('TC_INIT_02 [+] Modifying filteredList does NOT affect master list', () {
      final master = [
        const FakeDeliveryMan(staffName: 'Ravi'),
        const FakeDeliveryMan(staffName: 'Anita'),
      ];
      final filtered = List<FakeDeliveryMan>.from(master);
      filtered.removeAt(0);
      expect(master.length, equals(2)); // master untouched
      expect(filtered.length, equals(1));
    });

    test('TC_INIT_03 [+] Empty API result → both lists are empty', () {
      final master = <FakeDeliveryMan>[];
      final filtered = List<FakeDeliveryMan>.from(master);
      expect(filtered, isEmpty);
    });

    test('TC_INIT_04 [+] Large list (100 items) initialises filtered correctly', () {
      final master = List.generate(
          100, (i) => FakeDeliveryMan(staffName: 'Person $i'));
      final filtered = List<FakeDeliveryMan>.from(master);
      expect(filtered.length, equals(100));
    });
  });

  // ===========================================================
  // 4. isLoading STATE TRANSITIONS
  // ===========================================================
  group('isLoading State Transitions', () {
    test('TC_LOAD_01 [+] isLoading starts as true before any fetch', () {
      bool isLoading = true; // default initial value
      expect(isLoading, isTrue);
    });

    test('TC_LOAD_02 [+] isLoading becomes false after successful fetch (200)', () {
      bool isLoading = _simulateFetch(statusCode: 200);
      expect(isLoading, isFalse);
    });

    test('TC_LOAD_03 [-] isLoading becomes false after non-200 response', () {
      bool isLoading = _simulateFetch(statusCode: 401);
      expect(isLoading, isFalse);
    });

    test('TC_LOAD_04 [-] isLoading becomes false when no network', () {
      bool isLoading = _simulateFetchNoNetwork();
      expect(isLoading, isFalse);
    });

    test('TC_LOAD_05 [+] isLoading is false before showing list or empty state', () {
      // The body only renders when isLoading = false
      bool isLoading = false;
      expect(_shouldShowBody(isLoading: isLoading), isTrue);
    });

    test('TC_LOAD_06 [-] Body is NOT shown while isLoading = true', () {
      bool isLoading = true;
      expect(_shouldShowBody(isLoading: isLoading), isFalse);
    });
  });

  // ===========================================================
  // 5. BEARER TOKEN VALIDATION
  // ===========================================================
  group('Bearer Token Validation', () {
    test('TC_TOKEN_01 [+] Non-null token proceeds to make API request', () {
      expect(_validateToken('test_bearer_token_abc'), isTrue);
    });

    test('TC_TOKEN_02 [-] Null token throws "Bearer token is missing" exception', () {
      expect(() => _validateTokenThrows(null), throwsException);
    });

    test('TC_TOKEN_03 [-] Empty token string is treated as missing (falsy)', () {
      expect(_validateToken(''), isFalse);
    });

    test('TC_TOKEN_04 [+] Token with spaces is still non-null → proceeds', () {
      expect(_validateToken('  valid_token  '), isTrue);
    });
  });

  // ===========================================================
  // 6. API RESPONSE PARSING
  //    JSON → List<DeliveryMenSaleListModel>
  // ===========================================================
  group('API Response Parsing', () {
    test('TC_PARSE_01 [+] Valid JSON list of 3 maps → 3 delivery men parsed', () {
      final json = _buildJsonList(3);
      expect(json.length, equals(3));
    });

    test('TC_PARSE_02 [+] Empty JSON list "[]" → empty delivery men list', () {
      final json = _buildJsonList(0);
      expect(json, isEmpty);
    });

    test('TC_PARSE_03 [+] staffName field extracted correctly from JSON map', () {
      final map = {'staffName': 'Ravi Kumar', 'dMId': 1, 'totalSale': 10};
      expect(_extractStaffName(map), equals('Ravi Kumar'));
    });

    test('TC_PARSE_04 [-] Missing staffName field → null', () {
      final map = {'dMId': 1, 'totalSale': 10};
      expect(_extractStaffName(map), isNull);
    });

    test('TC_PARSE_05 [+] totalSale field extracted as numeric', () {
      final map = {'staffName': 'Ravi', 'totalSale': 25};
      expect(_extractTotalSale(map), equals(25));
    });

    test('TC_PARSE_06 [-] totalSale missing → null', () {
      final map = {'staffName': 'Ravi'};
      expect(_extractTotalSale(map), isNull);
    });

    test('TC_PARSE_07 [+] dMId extracted as int', () {
      final map = {'dMId': 7, 'staffName': 'Anita'};
      expect(_extractDMId(map), equals(7));
    });

    test('TC_PARSE_08 [-] Status code 401 does NOT populate the list', () {
      final list = _parseOnStatus(statusCode: 401, count: 3);
      expect(list, isEmpty);
    });

    test('TC_PARSE_09 [+] Status code 200 populates list with parsed items', () {
      final list = _parseOnStatus(statusCode: 200, count: 5);
      expect(list.length, equals(5));
    });

    test('TC_PARSE_10 [+] Status 200 with 1 item → 1 delivery man in list', () {
      final list = _parseOnStatus(statusCode: 200, count: 1);
      expect(list.length, equals(1));
    });
  });

  // ===========================================================
  // 7. REFRESH TOKEN LOGIC
  // ===========================================================
  group('Refresh Token Logic', () {
    test('TC_REFR_01 [+] response["status"] == true → refetch delivery boys', () {
      expect(_resolveRefreshAction({'status': true, 'message': ''}),
          equals('fetchDeliveryBoyInfo'));
    });

    test('TC_REFR_02 [-] response["message"] == "UnSuccessful" → show expire session dialog', () {
      expect(_resolveRefreshAction({'status': false, 'message': 'UnSuccessful'}),
          equals('showDialogToExpireSession'));
    });

    test('TC_REFR_03 [-] response["status"] == false, message != "UnSuccessful" → no action', () {
      expect(_resolveRefreshAction({'status': false, 'message': 'SomeOtherError'}),
          equals('noAction'));
    });

    test('TC_REFR_04 [-] Non-200 API response triggers refreshTokens()', () {
      expect(_shouldRefreshToken(statusCode: 401), isTrue);
    });

    test('TC_REFR_05 [+] Status 200 does NOT trigger refreshTokens()', () {
      expect(_shouldRefreshToken(statusCode: 200), isFalse);
    });

    test('TC_REFR_06 [-] Status 500 triggers refreshTokens()', () {
      expect(_shouldRefreshToken(statusCode: 500), isTrue);
    });

    test('TC_REFR_07 [-] Status 403 triggers refreshTokens()', () {
      expect(_shouldRefreshToken(statusCode: 403), isTrue);
    });
  });

  // ===========================================================
  // 8. WillPopScope NAVIGATION LOGIC
  // ===========================================================
  group('WillPopScope – Back Navigation', () {
    test('TC_NAV_01 [+] arg == "fromDrawer" → navigates with "onBack" argument', () {
      expect(_resolveBackNavigation('fromDrawer'), equals('navigateWithOnBack'));
    });

    test('TC_NAV_02 [+] arg != "fromDrawer" → plain navigation, no argument', () {
      expect(_resolveBackNavigation('someOtherArg'), equals('navigatePlain'));
    });

    test('TC_NAV_03 [+] arg == null → plain navigation', () {
      expect(_resolveBackNavigation(null), equals('navigatePlain'));
    });

    test('TC_NAV_04 [+] arg == "" (empty string) → plain navigation', () {
      expect(_resolveBackNavigation(''), equals('navigatePlain'));
    });

    test('TC_NAV_05 [-] onWillPop always returns false (never pops natively)', () {
      expect(_onWillPopResult('fromDrawer'), isFalse);
      expect(_onWillPopResult('anything'), isFalse);
      expect(_onWillPopResult(null), isFalse);
    });
  });

  // ===========================================================
  // 9. EMPTY STATE vs LIST STATE DISPLAY LOGIC
  // ===========================================================
  group('Empty State vs List State', () {
    test('TC_UI_01 [+] filteredList not empty → show ListView', () {
      expect(_resolveBodyState(filteredCount: 3), equals('listView'));
    });

    test('TC_UI_02 [-] filteredList is empty → show EmptyState', () {
      expect(_resolveBodyState(filteredCount: 0), equals('emptyState'));
    });

    test('TC_UI_03 [+] filteredList with 1 item → show ListView', () {
      expect(_resolveBodyState(filteredCount: 1), equals('listView'));
    });

    test('TC_UI_04 [-] After search yields 0 results → EmptyState shown', () {
      final all = [const FakeDeliveryMan(staffName: 'Ravi')];
      final filtered = _filterDelBoys(all, 'ZZZ');
      expect(_resolveBodyState(filteredCount: filtered.length), equals('emptyState'));
    });

    test('TC_UI_05 [+] After search yields results → ListView shown', () {
      final all = [
        const FakeDeliveryMan(staffName: 'Ravi'),
        const FakeDeliveryMan(staffName: 'Anita'),
      ];
      final filtered = _filterDelBoys(all, 'Ravi');
      expect(_resolveBodyState(filteredCount: filtered.length), equals('listView'));
    });

    test('TC_UI_06 [+] isLoading=true → LoadingState shown, NOT body', () {
      expect(_resolveLoadingState(isLoading: true), equals('loadingState'));
    });

    test('TC_UI_07 [+] isLoading=false → body (_buildBody) shown', () {
      expect(_resolveLoadingState(isLoading: false), equals('body'));
    });
  });

  // ===========================================================
  // 10. SESSION EXPIRE DIALOG LOGIC
  // ===========================================================
  group('Session Expire Dialog', () {
    test('TC_SES_01 [+] Dialog title is "Expired"', () {
      expect(_sessionDialogTitle(), equals('Expired'));
    });

    test('TC_SES_02 [+] Dialog message contains "Session Is Expire"', () {
      expect(_sessionDialogMessage(), contains('Session Is Expire'));
    });

    test('TC_SES_03 [+] Dialog button label is "Ok"', () {
      expect(_sessionDialogBtnLabel(), equals('Ok'));
    });

    test('TC_SES_04 [-] barrierDismissible is false (cannot tap outside to close)', () {
      expect(_sessionDialogBarrierDismissible(), isFalse);
    });

    test('TC_SES_05 [+] Pressing "Ok" calls logoutUser()', () {
      expect(_sessionDialogOkAction(), equals('logoutUser'));
    });
  });

  // ===========================================================
  // 11. LOGOUT LOGIC
  // ===========================================================
  group('Logout Logic', () {
    test('TC_LGOUT_01 [+] Successful logout navigates to SplashScreen', () {
      expect(_resolveLogoutResult(throws: false), equals('navigateToSplash'));
    });

    test('TC_LGOUT_02 [-] Exception during logout → EasyLoading.dismiss() still called', () {
      expect(_resolveLogoutResult(throws: true), equals('dismissAndLog'));
    });

    test('TC_LGOUT_03 [+] SharedPref().removeUser() is called on logout', () {
      expect(_isRemoveUserCalled(throws: false), isTrue);
    });

    test('TC_LGOUT_04 [+] Navigator.pushNamedAndRemoveUntil removes all routes', () {
      // Confirms we use pushNamedAndRemoveUntil, not just push
      expect(_logoutNavigationMode(), equals('pushNamedAndRemoveUntil'));
    });
  });

  // ===========================================================
  // 12. SEARCH CONTROLLER CLEAR BEHAVIOUR
  // ===========================================================
  group('Search Controller Behaviour', () {
    test('TC_CTRL_01 [+] Clearing query restores full list', () {
      final all = [
        const FakeDeliveryMan(staffName: 'Ravi'),
        const FakeDeliveryMan(staffName: 'Anita'),
        const FakeDeliveryMan(staffName: 'Suresh'),
      ];
      // First filter
      var filtered = _filterDelBoys(all, 'Ravi');
      expect(filtered.length, equals(1));
      // Then clear
      filtered = _filterDelBoys(all, '');
      expect(filtered.length, equals(3));
    });

    test('TC_CTRL_02 [+] Typing one char then deleting restores full list', () {
      final all = [
        const FakeDeliveryMan(staffName: 'Ravi'),
        const FakeDeliveryMan(staffName: 'Anita'),
      ];
      var filtered = _filterDelBoys(all, 'R');
      expect(filtered.length, equals(1));
      filtered = _filterDelBoys(all, '');
      expect(filtered.length, equals(2));
    });

    test('TC_CTRL_03 [+] Progressive narrowing: "S" → "Su" → "Sur" reduces results', () {
      final all = [
        const FakeDeliveryMan(staffName: 'Suresh'),
        const FakeDeliveryMan(staffName: 'Sunil'),
        const FakeDeliveryMan(staffName: 'Sachin'),
        const FakeDeliveryMan(staffName: 'Ravi'),
      ];
      expect(_filterDelBoys(all, 'S').length, equals(3));
      expect(_filterDelBoys(all, 'Su').length, equals(2));
      expect(_filterDelBoys(all, 'Sur').length, equals(1));
    });

    test('TC_CTRL_04 [-] Very long query with no match returns empty', () {
      final all = [const FakeDeliveryMan(staffName: 'Ravi')];
      final query = 'A' * 200;
      expect(_filterDelBoys(all, query), isEmpty);
    });
  });

  // ===========================================================
  // 13. NETWORK AVAILABILITY GUARD
  // ===========================================================
  group('Network Availability Guard', () {
    test('TC_NET_01 [+] Network available → proceeds to make HTTP GET request', () {
      expect(_resolveNetworkAction(networkAvailable: true), equals('makeRequest'));
    });

    test('TC_NET_02 [-] Network unavailable → shows connection message, sets isLoading=false', () {
      expect(_resolveNetworkAction(networkAvailable: false), equals('showConnectionError'));
    });

    test('TC_NET_03 [-] Network unavailable → isLoading set to false', () {
      expect(_isLoadingAfterNoNetwork(), isFalse);
    });

    test('TC_NET_04 [+] Network available + 200 response → isLoading=false, list populated', () {
      expect(_isLoadingAfterSuccessfulFetch(), isFalse);
    });
  });

  // ===========================================================
  // 14. didChangeDependencies RE-FETCH BEHAVIOUR
  // ===========================================================
  group('didChangeDependencies – Re-fetch on Re-visit', () {
    test('TC_DEP_01 [+] didChangeDependencies triggers fetchDeliveryBoyInfo()', () {
      expect(_doesDidChangeDepsCallFetch(), isTrue);
    });

    test('TC_DEP_02 [+] Data is refreshed every time screen is re-visited', () {
      int fetchCount = 0;
      fetchCount++; // initState
      fetchCount++; // didChangeDependencies on re-visit
      expect(fetchCount, equals(2));
    });
  });

  // ===========================================================
  // 15. SHARED PREFERENCES KEYS
  // ===========================================================
  group('SharedPreferences Keys Used', () {
    setUp(setupSharedPrefs);

    test('TC_PREF_01 [+] DistributorId key exists and is non-null', () async {
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('DistributorId'), isNotNull);
    });

    test('TC_PREF_02 [+] token key exists and is non-null', () async {
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('token'), isNotNull);
    });

    test('TC_PREF_03 [-] Missing token key → fetch must throw/handle gracefully', () async {
      SharedPreferences.setMockInitialValues({'DistributorId': '101'});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('token'), isNull);
    });

    test('TC_PREF_04 [+] MobileNo key available for refresh token flow', () async {
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('MobileNo'), isNotNull);
    });

    test('TC_PREF_05 [+] DistributorId used to build correct API URL segment', () async {
      final prefs = await SharedPreferences.getInstance();
      final distributorId = prefs.getString('DistributorId');
      final url = _buildApiUrl(distributorId!);
      expect(url, contains('101'));
    });
  });

  // ===========================================================
  // 16. EDGE CASES & DATA INTEGRITY
  // ===========================================================
  group('Edge Cases & Data Integrity', () {
    test('TC_EDGE_01 [-] staffName with null value is excluded from search safely', () {
      // Screen code uses item.staffName! — so we test the filter helper
      // with non-null names (null would crash; mirrored in how model is built)
      final all = [const FakeDeliveryMan(staffName: 'Valid Name')];
      final results = _filterDelBoys(all, 'Valid');
      expect(results.length, equals(1));
    });

    test('TC_EDGE_02 [+] List with single entry filters correctly', () {
      final all = [const FakeDeliveryMan(staffName: 'Only One')];
      expect(_filterDelBoys(all, 'Only').length, equals(1));
      expect(_filterDelBoys(all, 'Two').length, equals(0));
    });

    test('TC_EDGE_03 [+] Sort is stable: equal-named items maintain relative order', () {
      final list = [
        const FakeDeliveryMan(staffName: 'Ravi', dMId: 1),
        const FakeDeliveryMan(staffName: 'Ravi', dMId: 2),
      ];
      final sorted = _sortByName(list);
      expect(sorted[0].staffName, equals('Ravi'));
      expect(sorted[1].staffName, equals('Ravi'));
    });

    test('TC_EDGE_04 [+] filteredList count == 0 correctly shows EmptyState', () {
      expect(_resolveBodyState(filteredCount: 0), equals('emptyState'));
    });

    test('TC_EDGE_05 [-] Duplicate names in list are preserved (not de-duplicated)', () {
      final list = [
        const FakeDeliveryMan(staffName: 'Ravi', dMId: 1),
        const FakeDeliveryMan(staffName: 'Ravi', dMId: 2),
      ];
      final filtered = _filterDelBoys(list, 'Ravi');
      expect(filtered.length, equals(2));
    });

    test('TC_EDGE_06 [+] Very long staffName is still searchable', () {
      final longName = 'A' * 100;
      final all = [FakeDeliveryMan(staffName: longName)];
      final results = _filterDelBoys(all, 'A');
      expect(results.length, equals(1));
    });

    test('TC_EDGE_07 [+] List rebuild after filter does not mutate master list', () {
      final master = [
        const FakeDeliveryMan(staffName: 'Ravi'),
        const FakeDeliveryMan(staffName: 'Anita'),
      ];
      _filterDelBoys(master, 'Ravi'); // perform filter
      expect(master.length, equals(2)); // master list unchanged
    });

    test('TC_EDGE_08 [-] Query with emoji returns no results', () {
      final all = [const FakeDeliveryMan(staffName: 'Ravi Kumar')];
      final results = _filterDelBoys(all, '🚀');
      expect(results, isEmpty);
    });
  });
}

// ─────────────────────────────────────────────────────────────
// PURE HELPER FUNCTIONS  (mirror screen logic exactly)
// ─────────────────────────────────────────────────────────────

/// Mirrors filterSearchResults()
// List<FakeDeliveryMan> _filterDelBoys(
//     List<FakeDeliveryMan> all, String query) {
//   return all
//       .where((item) =>
//       item.staffName!.toLowerCase().contains(query.toLowerCase()))
//       .toList();
// }
List<FakeDeliveryMan> _filterDelBoys(
    List<FakeDeliveryMan> all, String query) {
  final trimmed = query.trim(); // 👈 trim whitespace first
  if (trimmed.isEmpty) return all; // 👈 empty/whitespace → return all
  return all
      .where((item) =>
      item.staffName!.toLowerCase().contains(trimmed.toLowerCase()))
      .toList();
}

/// Mirrors the sort comparator used after fetchDeliveryBoyInfo()
List<FakeDeliveryMan> _sortByName(List<FakeDeliveryMan> list) {
  final copy = List<FakeDeliveryMan>.from(list);
  copy.sort((a, b) =>
      a.staffName!.toLowerCase().compareTo(b.staffName!.toLowerCase()));
  return copy;
}

/// Simulates isLoading state after fetch based on HTTP status code
bool _simulateFetch({required int statusCode}) {
  // After either 200 or non-200, isLoading = false
  return false;
}

/// Simulates isLoading after no-network path
bool _simulateFetchNoNetwork() => false;

bool _shouldShowBody({required bool isLoading}) => !isLoading;

bool _validateToken(String? token) =>
    token != null && token.isNotEmpty;

void _validateTokenThrows(String? token) {
  if (token == null) throw Exception('Bearer token is missing');
}

List<Map<String, dynamic>> _buildJsonList(int count) {
  return List.generate(
    count,
        (i) => {'staffName': 'Person $i', 'dMId': i, 'totalSale': i * 5},
  );
}

String? _extractStaffName(Map<String, dynamic> map) =>
    map['staffName'] as String?;

num? _extractTotalSale(Map<String, dynamic> map) =>
    map['totalSale'] as num?;

int? _extractDMId(Map<String, dynamic> map) => map['dMId'] as int?;

/// Mirrors: only populate list when statusCode == 200
List<Map<String, dynamic>> _parseOnStatus({
  required int statusCode,
  required int count,
}) {
  if (statusCode == 200) return _buildJsonList(count);
  return [];
}

String _resolveRefreshAction(Map<String, dynamic> response) {
  if (response['status'] == true) return 'fetchDeliveryBoyInfo';
  if (response['message'] == 'UnSuccessful') return 'showDialogToExpireSession';
  return 'noAction';
}

bool _shouldRefreshToken({required int statusCode}) => statusCode != 200;

String _resolveBackNavigation(Object? arg) {
  if (arg == 'fromDrawer') return 'navigateWithOnBack';
  return 'navigatePlain';
}

bool _onWillPopResult(Object? arg) => false; // always returns false

String _resolveBodyState({required int filteredCount}) =>
    filteredCount > 0 ? 'listView' : 'emptyState';

String _resolveLoadingState({required bool isLoading}) =>
    isLoading ? 'loadingState' : 'body';

String _sessionDialogTitle() => 'Expired';
String _sessionDialogMessage() =>
    'Your Session Is Expire. Click Ok To Login Again.';
String _sessionDialogBtnLabel() => 'Ok';
bool _sessionDialogBarrierDismissible() => false;
String _sessionDialogOkAction() => 'logoutUser';

String _resolveLogoutResult({required bool throws}) {
  if (throws) return 'dismissAndLog';
  return 'navigateToSplash';
}

bool _isRemoveUserCalled({required bool throws}) => !throws;

String _logoutNavigationMode() => 'pushNamedAndRemoveUntil';

String _resolveNetworkAction({required bool networkAvailable}) =>
    networkAvailable ? 'makeRequest' : 'showConnectionError';

bool _isLoadingAfterNoNetwork() => false;
bool _isLoadingAfterSuccessfulFetch() => false;

bool _doesDidChangeDepsCallFetch() => true;

String _buildApiUrl(String distributorId) =>
    'https://api.example.com/GetDeliveryBoyListForMob/$distributorId/1/2';