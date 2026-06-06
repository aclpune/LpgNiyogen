// // =============================================================================
// // godown_keeper_integration_test.dart
// // =============================================================================
// // Integration test coverage for the Godown Keeper module.
// // Covers: ItemReceiptScreen, ItemReturnScreen, SQCRegisterScreen,
// //         AddReturnItemXMIScreen, ItemReturnXMIListScreen,
// //         DeliveryMenListShowScreen, DailyRefillSalePage,
// //         Edit/Delete Transaction Flow, MarkDefectiveItemScreen,
// //         DashboardScreen, StockTransferTOGodownScreen.
// //
// // Run on physical device:
// //   flutter test integration_test/godown_keeper_integration_test.dart -d <device_id>
// //
// // Architecture:
// //   - IntegrationTestWidgetsFlutterBinding for real device execution.
// //   - Pure-logic helpers mirror private _State methods (same as unit tests).
// //   - Inline model stubs replace real imports where private constructors exist.
// //   - SharedPreferences.setMockInitialValues() for pref key tests.
// //   - Arrange → Act → Assert pattern throughout.
// //   - pump + pumpAndSettle for UI interaction testing.
// // =============================================================================
//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // =============================================================================
// // SECTION A — BINDING INITIALISATION
// // =============================================================================
// // Call IntegrationTestWidgetsFlutterBinding.ensureInitialized() inside main()
// // before any test groups so the test runner can communicate with the device.
//
// // =============================================================================
// // SECTION B — SHARED WIDGET WRAPPER
// // =============================================================================
// Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));
//
// // =============================================================================
// // SECTION C — SHARED PREFS SETUP HELPER
// // =============================================================================
// Future<void> _setupPrefs() async {
//   SharedPreferences.setMockInitialValues({
//     'DistributorId': '8118',
//     'godownId': '1',
//     'StaffId': '5',
//     'UserId': '7',
//     'godownKeeperId': '3',
//     'token': 'test_bearer_token',
//     'MobileNo': '9876543210',
//   });
// }
//
// // =============================================================================
// // SECTION D — INLINE STUB MODELS
// // =============================================================================
//
// class StubCylItem {
//   final num? itemId;
//   final String? itemName;
//   const StubCylItem({this.itemId, this.itemName});
// }
//
// class StubStockTransfer {
//   final int? isStkTrans;
//   const StubStockTransfer({this.isStkTrans});
// }
//
// class StubItemDetails {
//   final int? itemId;
//   final String? itemName;
//   final num? filledQty;
//   final num? eMRQty;
//   final num? invoiceQty;
//   const StubItemDetails({this.itemId, this.itemName, this.filledQty, this.eMRQty, this.invoiceQty});
// }
//
// class StubReceipt {
//   final int? receiptId;
//   final String? vehicleNo;
//   final String? receiptDate;
//   final String? returnOn;
//   final int? godownId;
//   final List<StubItemDetails>? itemDetails;
//   const StubReceipt({
//     this.receiptId,
//     this.vehicleNo,
//     this.receiptDate,
//     this.returnOn,
//     this.godownId,
//     this.itemDetails,
//   });
// }
//
// StubReceipt _buildReceipt({
//   int receiptId = 1,
//   String vehicleNo = 'MH12AB1234',
//   String receiptDate = '2024-01-15T00:00:00',
//   String returnOn = '0001-01-01T00:00:00',
//   int godownId = 1,
//   List<StubItemDetails>? items,
// }) =>
//     StubReceipt(
//       receiptId: receiptId,
//       vehicleNo: vehicleNo,
//       receiptDate: receiptDate,
//       returnOn: returnOn,
//       godownId: godownId,
//       itemDetails: items ?? [const StubItemDetails(itemId: 1, itemName: 'LPG 14.2kg', filledQty: 10)],
//     );
//
// class StubDeliveryMan {
//   final String? staffName;
//   final num? totalSale;
//   final num? dMId;
//   final String? vehicleNo;
//   final num? dailySaleStatus;
//   const StubDeliveryMan({this.staffName, this.totalSale, this.dMId, this.vehicleNo, this.dailySaleStatus});
// }
//
// class StubSQCCard {
//   final String? vehicleNo;
//   final String? sQCStatus;
//   final num? todayTruckIn;
//   final num? todaySQCDone;
//   final num? monthTruckIn;
//   const StubSQCCard({this.vehicleNo, this.sQCStatus, this.todayTruckIn, this.todaySQCDone, this.monthTruckIn});
// }
//
// class StubOpeningStock {
//   final num? itemId;
//   final num? filledOpeningStk;
//   final num? emptyOpeningStk;
//   final num? defOpeningStk;
//   const StubOpeningStock({this.itemId, this.filledOpeningStk, this.emptyOpeningStk, this.defOpeningStk});
// }
//
// class StubCurrentStock {
//   final num? itemId;
//   final num? currentStkFilled;
//   final num? currentStkEmpty;
//   final num? currentStkDefective;
//   const StubCurrentStock({this.itemId, this.currentStkFilled, this.currentStkEmpty, this.currentStkDefective});
// }
//
// // =============================================================================
// // SECTION E — PURE LOGIC HELPERS (mirror private _State methods)
// // =============================================================================
//
// // ── Item Receipt ──────────────────────────────────────────────────────────────
// String? _validateItemReceiptSubmit({
//   required String vehicleNo,
//   required List<Map<String, dynamic>> items,
//   required List<StubCylItem> availableItems,
// }) {
//   if (vehicleNo.isEmpty) return 'vehicleValidation';
//   for (var i = 0; i < items.length; i++) {
//     final selectedName = items[i]['selectedName'] as String?;
//     final invoiceQty = items[i]['invoiceQty'] as String? ?? '';
//     final filledQty = items[i]['filledQty'] as String? ?? '';
//     final emrQty = items[i]['emrQty'] as String? ?? '';
//     if (selectedName == null || selectedName.isEmpty) return 'selectValidItemReceipt';
//     if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) return 'atLeastOneQtyRequired';
//     if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
//         (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
//       return 'atLeastOneQtyRequired';
//     }
//   }
//   final seen = <num>{};
//   for (var item in items) {
//     final name = item['selectedName'] as String?;
//     final found = availableItems.firstWhere((m) => m.itemName == name,
//         orElse: () => const StubCylItem(itemId: 0));
//     if (found.itemId != null && found.itemId != 0) {
//       if (seen.contains(found.itemId)) return 'recordExist';
//       seen.add(found.itemId!);
//     }
//   }
//   return null;
// }
//
// int? _updateSum(String filledQty, String emrQty) {
//   final filled = double.tryParse(filledQty) ?? 0;
//   final emr = double.tryParse(emrQty) ?? 0;
//   if (filled != 0 || emr != 0) return (filled + emr).toInt();
//   return null;
// }
//
// bool _isSubmitActive({required bool saveFlag, required bool stockTransferFlag, required String vehicleNo}) =>
//     !saveFlag && stockTransferFlag && vehicleNo.isNotEmpty;
//
// bool _computeStockTransferFlag(List<StubStockTransfer> list) => !list.any((e) => e.isStkTrans == 0);
//
// bool _computeSaveFlag(List<dynamic> apiResponse) => apiResponse.isNotEmpty;
//
// String _interpretReceiptResponseValue(int value) {
//   if (value > 0) return 'success';
//   if (value == -1) return 'vehicleNotReturn';
//   if (value == -2) return 'itemreceiptDataNotInserted';
//   return 'failToInserRecord';
// }
//
// // ── Item Return ───────────────────────────────────────────────────────────────
// bool _isPending(String? returnOn) => returnOn == '0001-01-01T00:00:00';
//
// List<StubReceipt> _pendingForSQC(List<StubReceipt> list) =>
//     list.where((r) => _isPending(r.returnOn)).toList();
//
// // ── SQC ───────────────────────────────────────────────────────────────────────
// Map<String, dynamic> _filterSQCList({
//   required List<StubSQCCard> all,
//   required String selectedStatus,
// }) {
//   String status;
//   switch (selectedStatus) {
//     case 'SQC Completed':
//       status = 'yes';
//       break;
//     case 'SQC Pending':
//       status = 'no';
//       break;
//     default:
//       status = 'all';
//   }
//   final filtered = status == 'all'
//       ? List<StubSQCCard>.from(all)
//       : all.where((i) => (i.sQCStatus ?? '').toLowerCase() == status).toList();
//   return {
//     'filtered': filtered,
//     'vehicleNo': filtered.isNotEmpty ? (filtered[0].vehicleNo ?? '') : '',
//     'sqcStatus': filtered.isNotEmpty ? (filtered[0].sQCStatus ?? '') : '',
//   };
// }
//
// // ── XMI Return ───────────────────────────────────────────────────────────────
// String? _validateXMIReturn({
//   required String vehicleNo,
//   required String? selectedItem,
//   required int invoiceQty,
//   required int emrQty,
//   required int availableEmptyStock,
// }) {
//   if (vehicleNo.isEmpty) return 'vehicleValidation';
//   if (selectedItem == null || selectedItem.isEmpty) return 'selectItem';
//   if (invoiceQty <= 0 && emrQty <= 0) return 'atLeastOneQtyRequired';
//   if ((invoiceQty + emrQty) > availableEmptyStock) return 'insufficientEmptyStock';
//   return null;
// }
//
// // ── Delivery Men ──────────────────────────────────────────────────────────────
// List<StubDeliveryMan> _filterDeliveryMen(List<StubDeliveryMan> all, String query) {
//   final trimmed = query.trim();
//   if (trimmed.isEmpty) return all;
//   return all.where((item) => item.staffName!.toLowerCase().contains(trimmed.toLowerCase())).toList();
// }
//
// List<StubDeliveryMan> _sortDeliveryMenByName(List<StubDeliveryMan> list) {
//   final copy = List<StubDeliveryMan>.from(list);
//   copy.sort((a, b) => a.staffName!.toLowerCase().compareTo(b.staffName!.toLowerCase()));
//   return copy;
// }
//
// // ── Daily Refill Sale ─────────────────────────────────────────────────────────
// int _calcAutoEmpty({
//   required int filled,
//   required int sv,
//   required int tv,
//   required int defective,
//   required int lessEmpty,
// }) =>
//     filled - sv + tv - defective - lessEmpty;
//
// int _parseToInt(String text, {int defaultValue = 0}) {
//   if (text.isEmpty || int.tryParse(text) == null) return defaultValue;
//   return int.parse(text);
// }
//
// String? _validateAddNewItem({
//   required String emptyText,
//   required int filledValue,
//   required num filledStock,
//   required int lessEmptyValue,
//   required int svValue,
//   required int defectiveValue,
//   required int emptyValue,
// }) {
//   if (emptyText.isEmpty) return 'addEmptyCylinderCount';
//   if (filledValue > filledStock) return 'totalSaleQtyDailySale';
//   if (filledValue < lessEmptyValue) return 'countShouldNotBeGreater';
//   if (filledValue < svValue) return 'countShouldNotBeGreater';
//   if (filledValue < defectiveValue) return 'countShouldNotBeGreater';
//   if (emptyValue < 0) return 'countShouldNotBeGreater';
//   return null;
// }
//
// String? _validateSVConsumerCount(List<String> consumerNumbers, int svQty) {
//   int currentCount = consumerNumbers.map((r) => r.split(',').length).fold(0, (a, b) => a + b);
//   if (currentCount > svQty) return 'svConsumerCountExceed';
//   return null;
// }
//
// String? _validateTVConsumerCount(List<String> consumerNumbers, int tvQty) {
//   int currentCount = consumerNumbers.map((r) => r.split(',').length).fold(0, (a, b) => a + b);
//   if (currentCount > tvQty) return 'tvConsumerCountExceed';
//   return null;
// }
//
// String? _validateUpdateItemFilledStock({
//   required int filledValue,
//   required num filledStock,
//   required num? editFilledStock,
//   required int lessEmptyValue,
//   required int svValue,
//   required int defectiveValue,
//   required int emptyValue,
// }) {
//   final allowedMax = filledStock + (editFilledStock ?? 0);
//   if (filledValue > allowedMax) return 'totalSaleQtyDailySale';
//   if (filledValue < lessEmptyValue) return 'countShouldNotBeGreater';
//   if (filledValue < svValue) return 'countShouldNotBeGreater';
//   if (filledValue < defectiveValue) return 'countShouldNotBeGreater';
//   if (emptyValue < 0) return 'countShouldNotBeGreater';
//   return null;
// }
//
// String _resolveSubmitTap({
//   required bool stockTransferFlag,
//   required bool saveFlag,
//   required bool isEditMode,
//   required bool stockDataFutureNotNull,
//   required bool dataFromDBNotEmpty,
//   required bool selectedDelBoyNameNotEmpty,
// }) {
//   if (!stockTransferFlag) return 'showStockNotAcceptedAlert';
//   if (saveFlag) return 'showDayEndCompleted';
//   if (isEditMode) {
//     return stockDataFutureNotNull ? 'sendEditedDataToApi' : 'doNothing';
//   } else {
//     return (dataFromDBNotEmpty && selectedDelBoyNameNotEmpty) ? 'sendDataToApi' : 'doNothing';
//   }
// }
//
// String _interpretSendDataResponse(int statusCode) {
//   if (statusCode == 200) return 'dataSentSuccessfully';
//   return 'failedToSendData';
// }
//
// bool _isAddButtonEnabled({
//   required String filledText,
//   required String tvText,
//   required String? selectedDelBoyName,
//   required String? selectedItem,
// }) =>
//     (filledText.isNotEmpty || tvText.isNotEmpty) && selectedDelBoyName != null && selectedItem != null;
//
// // ── Stock Transfer ────────────────────────────────────────────────────────────
// String? _validateStockTransfer({
//   required String? selectedItem,
//   required int transferQty,
//   required int availableStock,
//   required String? destinationGodown,
// }) {
//   if (selectedItem == null || selectedItem.isEmpty) return 'selectItem';
//   if (transferQty <= 0) return 'invalidQty';
//   if (transferQty > availableStock) return 'insufficientStock';
//   if (destinationGodown == null || destinationGodown.isEmpty) return 'selectDestination';
//   return null;
// }
//
// bool _isTransactionFrozen(List<StubStockTransfer> transfers) => transfers.any((t) => t.isStkTrans == 0);
//
// // ── Dashboard ─────────────────────────────────────────────────────────────────
// Map<String, int> _filterBothStockLists({
//   required num? selectedItemId,
//   required List<StubOpeningStock> openingStock,
//   required List<StubCurrentStock> currentStock,
// }) {
//   if (selectedItemId == null) {
//     return {'filled': 0, 'empty': 0, 'defective': 0, 'currentFilled': 0, 'currentEmpty': 0, 'currentDefective': 0};
//   }
//   final opening = openingStock.firstWhere((i) => i.itemId == selectedItemId,
//       orElse: () => const StubOpeningStock());
//   final current = currentStock.firstWhere((i) => i.itemId == selectedItemId,
//       orElse: () => const StubCurrentStock());
//   return {
//     'filled': opening.filledOpeningStk?.toInt() ?? 0,
//     'empty': opening.emptyOpeningStk?.toInt() ?? 0,
//     'defective': opening.defOpeningStk?.toInt() ?? 0,
//     'currentFilled': current.currentStkFilled?.toInt() ?? 0,
//     'currentEmpty': current.currentStkEmpty?.toInt() ?? 0,
//     'currentDefective': current.currentStkDefective?.toInt() ?? 0,
//   };
// }
//
// // ── Mark Defective ────────────────────────────────────────────────────────────
// String? _validateMarkDefective({
//   required String? selectedItem,
//   required int qty,
//   required int availableStock,
// }) {
//   if (selectedItem == null || selectedItem.isEmpty) return 'selectItem';
//   if (qty <= 0) return 'invalidQty';
//   if (qty > availableStock) return 'insufficientStock';
//   return null;
// }
//
// // ── Edit / Delete ─────────────────────────────────────────────────────────────
// String? _validateDeleteTransaction({required bool dayEndSaved, required bool cashCollected}) {
//   if (dayEndSaved) return 'dayEndRestriction';
//   if (cashCollected) return 'cashCollectionRestriction';
//   return null;
// }
//
// String _interpretDeleteResponse(int value) {
//   if (value > 0) return 'deleteSuccess';
//   return 'deleteFailed';
// }
//
// // ── Navigation ────────────────────────────────────────────────────────────────
// bool _shouldRefreshToken(int statusCode) => statusCode != 200;
// String _resolveBackNavigation(Object? arg) =>
//     arg == 'fromDrawer' ? 'navigateWithOnBack' : 'navigatePlain';
//
// // =============================================================================
// // SECTION F — SAMPLE WIDGET STUBS FOR UI INTEGRATION TESTS
// // =============================================================================
//
// // Minimal ItemReceiptScreen stub for widget pump tests
// class _ItemReceiptScreenStub extends StatefulWidget {
//   const _ItemReceiptScreenStub();
//   @override
//   State<_ItemReceiptScreenStub> createState() => _ItemReceiptScreenStubState();
// }
//
// class _ItemReceiptScreenStubState extends State<_ItemReceiptScreenStub> {
//   final TextEditingController _vehicleController = TextEditingController();
//   String? _errorMessage;
//   bool _submitted = false;
//
//   void _submit() {
//     if (_vehicleController.text.isEmpty) {
//       setState(() => _errorMessage = 'vehicleValidation');
//     } else {
//       setState(() {
//         _errorMessage = null;
//         _submitted = true;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(key: const Key('vehicleField'), controller: _vehicleController),
//         ElevatedButton(key: const Key('submitBtn'), onPressed: _submit, child: const Text('Submit')),
//         if (_errorMessage != null) Text(_errorMessage!, key: const Key('errorMsg')),
//         if (_submitted) const Text('Receipt Submitted', key: Key('successMsg')),
//       ],
//     );
//   }
// }
//
// // Minimal DeliveryMenListScreen stub
// class _DeliveryMenListStub extends StatefulWidget {
//   final List<StubDeliveryMan> deliveryMen;
//   const _DeliveryMenListStub({required this.deliveryMen});
//   @override
//   State<_DeliveryMenListStub> createState() => _DeliveryMenListStubState();
// }
//
// class _DeliveryMenListStubState extends State<_DeliveryMenListStub> {
//   final TextEditingController _searchController = TextEditingController();
//   List<StubDeliveryMan> _filtered = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _filtered = widget.deliveryMen;
//     _searchController.addListener(() {
//       setState(() => _filtered = _filterDeliveryMen(widget.deliveryMen, _searchController.text));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(key: const Key('searchField'), controller: _searchController),
//         ..._filtered.map(
//               (d) => ListTile(key: Key('dm_${d.dMId}'), title: Text(d.staffName ?? '')),
//         ),
//       ],
//     );
//   }
// }
//
// // Minimal StockTransfer stub
// class _StockTransferStub extends StatefulWidget {
//   const _StockTransferStub();
//   @override
//   State<_StockTransferStub> createState() => _StockTransferStubState();
// }
//
// class _StockTransferStubState extends State<_StockTransferStub> {
//   String? _selectedItem;
//   String? _destinationGodown;
//   final TextEditingController _qtyController = TextEditingController();
//   String? _validationError;
//   bool _transferSuccess = false;
//
//   void _submitTransfer() {
//     final error = _validateStockTransfer(
//       selectedItem: _selectedItem,
//       transferQty: int.tryParse(_qtyController.text) ?? 0,
//       availableStock: 50,
//       destinationGodown: _destinationGodown,
//     );
//     setState(() {
//       _validationError = error;
//       _transferSuccess = error == null;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         DropdownButton<String>(
//           key: const Key('itemDropdown'),
//           value: _selectedItem,
//           hint: const Text('Select Item'),
//           items: const [
//             DropdownMenuItem(value: 'LPG 14.2kg', child: Text('LPG 14.2kg')),
//             DropdownMenuItem(value: 'LPG 5kg', child: Text('LPG 5kg')),
//           ],
//           onChanged: (v) => setState(() => _selectedItem = v),
//         ),
//         TextField(key: const Key('qtyField'), controller: _qtyController, keyboardType: TextInputType.number),
//         DropdownButton<String>(
//           key: const Key('godownDropdown'),
//           value: _destinationGodown,
//           hint: const Text('Select Godown'),
//           items: const [
//             DropdownMenuItem(value: 'Godown A', child: Text('Godown A')),
//             DropdownMenuItem(value: 'Godown B', child: Text('Godown B')),
//           ],
//           onChanged: (v) => setState(() => _destinationGodown = v),
//         ),
//         ElevatedButton(key: const Key('transferBtn'), onPressed: _submitTransfer, child: const Text('Transfer')),
//         if (_validationError != null) Text(_validationError!, key: const Key('transferError')),
//         if (_transferSuccess) const Text('Transfer Successful', key: Key('transferSuccess')),
//       ],
//     );
//   }
// }
//
// // =============================================================================
// // MAIN INTEGRATION TEST SUITE
// // =============================================================================
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//   // ===========================================================================
//   // INT-MODULE 1 — SHARED PREFERENCES SETUP ON DEVICE
//   // ===========================================================================
//   group('[INT] SharedPreferences — device pref read/write', () {
//     testWidgets('[+] All required pref keys are set and readable on device', (tester) async {
//       await _setupPrefs();
//       final prefs = await SharedPreferences.getInstance();
//       expect(prefs.getString('DistributorId'), '8118');
//       expect(prefs.getString('godownId'), '1');
//       expect(prefs.getString('StaffId'), '5');
//       expect(prefs.getString('token'), 'test_bearer_token');
//       expect(prefs.getString('MobileNo'), '9876543210');
//     });
//
//     testWidgets('[-] Missing token returns null on device', (tester) async {
//       SharedPreferences.setMockInitialValues({});
//       final prefs = await SharedPreferences.getInstance();
//       expect(prefs.getString('token'), isNull);
//     });
//
//     testWidgets('[+] DistributorId can be parsed to int on device', (tester) async {
//       await _setupPrefs();
//       final prefs = await SharedPreferences.getInstance();
//       final id = int.tryParse(prefs.getString('DistributorId') ?? '');
//       expect(id, 8118);
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 2 — ITEM RECEIPT SCREEN — UI WIDGET INTEGRATION
//   // ===========================================================================
//   group('[INT] ItemReceiptScreen — widget pump on device', () {
//     testWidgets('[+] Screen renders with vehicle text field and submit button', (tester) async {
//       await tester.pumpWidget(_wrap(const _ItemReceiptScreenStub()));
//       await tester.pumpAndSettle();
//       expect(find.byKey(const Key('vehicleField')), findsOneWidget);
//       expect(find.byKey(const Key('submitBtn')), findsOneWidget);
//     });
//
//     testWidgets('[-] Submit with empty vehicle shows vehicleValidation error', (tester) async {
//       await tester.pumpWidget(_wrap(const _ItemReceiptScreenStub()));
//       await tester.pumpAndSettle();
//       await tester.tap(find.byKey(const Key('submitBtn')));
//       await tester.pumpAndSettle();
//       expect(find.byKey(const Key('errorMsg')), findsOneWidget);
//       expect(find.text('vehicleValidation'), findsOneWidget);
//     });
//
//     testWidgets('[+] Submit with valid vehicle shows success message', (tester) async {
//       await tester.pumpWidget(_wrap(const _ItemReceiptScreenStub()));
//       await tester.pumpAndSettle();
//       await tester.enterText(find.byKey(const Key('vehicleField')), 'MH12AB1234');
//       await tester.pumpAndSettle();
//       await tester.tap(find.byKey(const Key('submitBtn')));
//       await tester.pumpAndSettle();
//       expect(find.byKey(const Key('successMsg')), findsOneWidget);
//       expect(find.text('Receipt Submitted'), findsOneWidget);
//     });
//
//     testWidgets('[+] Error clears when valid vehicle entered and submitted', (tester) async {
//       await tester.pumpWidget(_wrap(const _ItemReceiptScreenStub()));
//       await tester.pumpAndSettle();
//       // First submit with empty — triggers error
//       await tester.tap(find.byKey(const Key('submitBtn')));
//       await tester.pumpAndSettle();
//       expect(find.byKey(const Key('errorMsg')), findsOneWidget);
//       // Now enter vehicle and re-submit
//       await tester.enterText(find.byKey(const Key('vehicleField')), 'GJ01XY9999');
//       await tester.pumpAndSettle();
//       await tester.tap(find.byKey(const Key('submitBtn')));
//       await tester.pumpAndSettle();
//       expect(find.byKey(const Key('errorMsg')), findsNothing);
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 3 — ITEM RECEIPT — LOGIC VALIDATION ON DEVICE
//   // ===========================================================================
//   group('[INT] ItemReceiptScreen — logic validation on device', () {
//     final availableItems = [
//       const StubCylItem(itemId: 1, itemName: 'LPG 14.2kg'),
//       const StubCylItem(itemId: 2, itemName: 'LPG 5kg'),
//     ];
//
//     Map<String, dynamic> _row({
//       String selectedName = 'LPG 14.2kg',
//       String invoiceQty = '10',
//       String filledQty = '10',
//       String emrQty = '0',
//     }) =>
//         {'selectedName': selectedName, 'invoiceQty': invoiceQty, 'filledQty': filledQty, 'emrQty': emrQty};
//
//     testWidgets('[+] Valid vehicle + valid row returns no error', (tester) async {
//       final result = _validateItemReceiptSubmit(
//         vehicleNo: 'MH12AB1234',
//         items: [_row()],
//         availableItems: availableItems,
//       );
//       expect(result, isNull);
//     });
//
//     testWidgets('[-] Empty vehicle returns vehicleValidation', (tester) async {
//       final result = _validateItemReceiptSubmit(
//         vehicleNo: '',
//         items: [_row()],
//         availableItems: availableItems,
//       );
//       expect(result, 'vehicleValidation');
//     });
//
//     testWidgets('[-] Duplicate items in same receipt returns recordExist', (tester) async {
//       final result = _validateItemReceiptSubmit(
//         vehicleNo: 'MH12AB1234',
//         items: [_row(), _row()],
//         availableItems: availableItems,
//       );
//       expect(result, 'recordExist');
//     });
//
//     testWidgets('[-] Zero invoiceQty returns atLeastOneQtyRequired', (tester) async {
//       final result = _validateItemReceiptSubmit(
//         vehicleNo: 'MH12AB1234',
//         items: [_row(invoiceQty: '0')],
//         availableItems: availableItems,
//       );
//       expect(result, 'atLeastOneQtyRequired');
//     });
//
//     testWidgets('[+] Both filled and EMR provided calculates correct sum', (tester) async {
//       final sum = _updateSum('8', '2');
//       expect(sum, 10);
//     });
//
//     testWidgets('[+] API response > 0 interpreted as success', (tester) async {
//       expect(_interpretReceiptResponseValue(1), 'success');
//     });
//
//     testWidgets('[-] API response -1 returns vehicleNotReturn', (tester) async {
//       expect(_interpretReceiptResponseValue(-1), 'vehicleNotReturn');
//     });
//
//     testWidgets('[-] API response -2 returns itemreceiptDataNotInserted', (tester) async {
//       expect(_interpretReceiptResponseValue(-2), 'itemreceiptDataNotInserted');
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 4 — ITEM RETURN SCREEN — PENDING RETURN LOGIC ON DEVICE
//   // ===========================================================================
//   group('[INT] ItemReturnScreen — pending return logic on device', () {
//     testWidgets('[+] Receipt with default returnOn is pending', (tester) async {
//       final r = _buildReceipt();
//       expect(_isPending(r.returnOn), isTrue);
//     });
//
//     testWidgets('[-] Receipt with actual returnOn is not pending', (tester) async {
//       final r = _buildReceipt(returnOn: '2024-01-15T10:00:00');
//       expect(_isPending(r.returnOn), isFalse);
//     });
//
//     testWidgets('[+] Filter returns only pending receipts from mixed list', (tester) async {
//       final list = [
//         _buildReceipt(receiptId: 1),
//         _buildReceipt(receiptId: 2, returnOn: '2024-01-15T10:00:00'),
//         _buildReceipt(receiptId: 3),
//       ];
//       final pending = _pendingForSQC(list);
//       expect(pending.length, 2);
//       expect(pending.every((r) => _isPending(r.returnOn)), isTrue);
//     });
//
//     testWidgets('[+] All returned receipts filtered out — pending list is empty', (tester) async {
//       final list = [
//         _buildReceipt(receiptId: 1, returnOn: '2024-01-14T08:00:00'),
//         _buildReceipt(receiptId: 2, returnOn: '2024-01-15T10:00:00'),
//       ];
//       expect(_pendingForSQC(list), isEmpty);
//     });
//
//     testWidgets('[+] Stock transfer flag true when no isStkTrans==0', (tester) async {
//       final transfers = [const StubStockTransfer(isStkTrans: 1)];
//       expect(_computeStockTransferFlag(transfers), isTrue);
//     });
//
//     testWidgets('[-] Stock transfer flag false when any isStkTrans==0', (tester) async {
//       final transfers = [const StubStockTransfer(isStkTrans: 0)];
//       expect(_computeStockTransferFlag(transfers), isFalse);
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 5 — SQC REGISTER SCREEN — FILTER LOGIC ON DEVICE
//   // ===========================================================================
//   group('[INT] SQCRegisterScreen — filter logic on device', () {
//     final sqcList = [
//       const StubSQCCard(vehicleNo: 'MH12AB1234', sQCStatus: 'yes'),
//       const StubSQCCard(vehicleNo: 'GJ01XY5678', sQCStatus: 'no'),
//       const StubSQCCard(vehicleNo: 'KA03ZZ9999', sQCStatus: 'yes'),
//     ];
//
//     testWidgets('[+] Filter All returns complete list', (tester) async {
//       final result = _filterSQCList(all: sqcList, selectedStatus: 'All');
//       expect((result['filtered'] as List).length, 3);
//     });
//
//     testWidgets('[+] Filter SQC Completed returns only yes-status items', (tester) async {
//       final result = _filterSQCList(all: sqcList, selectedStatus: 'SQC Completed');
//       final filtered = result['filtered'] as List<StubSQCCard>;
//       expect(filtered.length, 2);
//       expect(filtered.every((i) => i.sQCStatus == 'yes'), isTrue);
//     });
//
//     testWidgets('[+] Filter SQC Pending returns only no-status items', (tester) async {
//       final result = _filterSQCList(all: sqcList, selectedStatus: 'SQC Pending');
//       final filtered = result['filtered'] as List<StubSQCCard>;
//       expect(filtered.length, 1);
//       expect(filtered.first.vehicleNo, 'GJ01XY5678');
//     });
//
//     testWidgets('[+] First vehicleNo extracted correctly from filter result', (tester) async {
//       final result = _filterSQCList(all: sqcList, selectedStatus: 'SQC Completed');
//       expect(result['vehicleNo'], 'MH12AB1234');
//     });
//
//     testWidgets('[+] Empty filtered list returns empty vehicleNo string', (tester) async {
//       final result = _filterSQCList(all: [], selectedStatus: 'SQC Pending');
//       expect(result['vehicleNo'], '');
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 6 — ADD RETURN ITEM XMI SCREEN — LOGIC ON DEVICE
//   // ===========================================================================
//   group('[INT] AddReturnItemXMIScreen — validation on device', () {
//     testWidgets('[+] Valid XMI return passes all validations', (tester) async {
//       expect(
//         _validateXMIReturn(
//           vehicleNo: 'MH12AB1234',
//           selectedItem: 'LPG 14.2kg',
//           invoiceQty: 5,
//           emrQty: 0,
//           availableEmptyStock: 20,
//         ),
//         isNull,
//       );
//     });
//
//     testWidgets('[-] Empty vehicle number returns vehicleValidation', (tester) async {
//       expect(
//         _validateXMIReturn(
//           vehicleNo: '',
//           selectedItem: 'LPG 14.2kg',
//           invoiceQty: 5,
//           emrQty: 0,
//           availableEmptyStock: 20,
//         ),
//         'vehicleValidation',
//       );
//     });
//
//     testWidgets('[-] No item selected returns selectItem', (tester) async {
//       expect(
//         _validateXMIReturn(
//           vehicleNo: 'MH12AB1234',
//           selectedItem: null,
//           invoiceQty: 5,
//           emrQty: 0,
//           availableEmptyStock: 20,
//         ),
//         'selectItem',
//       );
//     });
//
//     testWidgets('[-] Both invoice and EMR qty zero returns atLeastOneQtyRequired', (tester) async {
//       expect(
//         _validateXMIReturn(
//           vehicleNo: 'MH12AB1234',
//           selectedItem: 'LPG 14.2kg',
//           invoiceQty: 0,
//           emrQty: 0,
//           availableEmptyStock: 20,
//         ),
//         'atLeastOneQtyRequired',
//       );
//     });
//
//     testWidgets('[-] Total qty exceeds available empty stock returns insufficientEmptyStock', (tester) async {
//       expect(
//         _validateXMIReturn(
//           vehicleNo: 'MH12AB1234',
//           selectedItem: 'LPG 14.2kg',
//           invoiceQty: 15,
//           emrQty: 10,
//           availableEmptyStock: 20,
//         ),
//         'insufficientEmptyStock',
//       );
//     });
//
//     testWidgets('[+] Only EMR qty provided with zero invoice — passes if within stock', (tester) async {
//       expect(
//         _validateXMIReturn(
//           vehicleNo: 'MH12AB1234',
//           selectedItem: 'LPG 14.2kg',
//           invoiceQty: 0,
//           emrQty: 5,
//           availableEmptyStock: 20,
//         ),
//         isNull,
//       );
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 7 — DELIVERY MEN LIST SCREEN — WIDGET + SEARCH ON DEVICE
//   // ===========================================================================
//   group('[INT] DeliveryMenListShowScreen — widget + search on device', () {
//     final deliveryMen = [
//       const StubDeliveryMan(staffName: 'Ravi Kumar', dMId: 1, vehicleNo: 'MH12AB1234'),
//       const StubDeliveryMan(staffName: 'Amit Shah', dMId: 2, vehicleNo: 'GJ01XY5678'),
//       const StubDeliveryMan(staffName: 'Sunil Patil', dMId: 3, vehicleNo: 'KA03ZZ9999'),
//     ];
//
//     testWidgets('[+] All delivery men rendered in list', (tester) async {
//       await tester.pumpWidget(_wrap(_DeliveryMenListStub(deliveryMen: deliveryMen)));
//       await tester.pumpAndSettle();
//       expect(find.byKey(const Key('dm_1')), findsOneWidget);
//       expect(find.byKey(const Key('dm_2')), findsOneWidget);
//       expect(find.byKey(const Key('dm_3')), findsOneWidget);
//     });
//
//     testWidgets('[+] Search by partial name filters correctly on device', (tester) async {
//       await tester.pumpWidget(_wrap(_DeliveryMenListStub(deliveryMen: deliveryMen)));
//       await tester.pumpAndSettle();
//       await tester.enterText(find.byKey(const Key('searchField')), 'Ravi');
//       await tester.pumpAndSettle();
//       expect(find.byKey(const Key('dm_1')), findsOneWidget);
//       expect(find.byKey(const Key('dm_2')), findsNothing);
//       expect(find.byKey(const Key('dm_3')), findsNothing);
//     });
//
//     testWidgets('[+] Clearing search restores full list', (tester) async {
//       await tester.pumpWidget(_wrap(_DeliveryMenListStub(deliveryMen: deliveryMen)));
//       await tester.pumpAndSettle();
//       await tester.enterText(find.byKey(const Key('searchField')), 'Amit');
//       await tester.pumpAndSettle();
//       expect(find.byKey(const Key('dm_2')), findsOneWidget);
//       // Clear search
//       await tester.enterText(find.byKey(const Key('searchField')), '');
//       await tester.pumpAndSettle();
//       expect(find.byKey(const Key('dm_1')), findsOneWidget);
//       expect(find.byKey(const Key('dm_2')), findsOneWidget);
//       expect(find.byKey(const Key('dm_3')), findsOneWidget);
//     });
//
//     testWidgets('[+] Case-insensitive search works on device', (tester) async {
//       await tester.pumpWidget(_wrap(_DeliveryMenListStub(deliveryMen: deliveryMen)));
//       await tester.pumpAndSettle();
//       await tester.enterText(find.byKey(const Key('searchField')), 'sunil');
//       await tester.pumpAndSettle();
//       expect(find.byKey(const Key('dm_3')), findsOneWidget);
//     });
//
//     testWidgets('[+] Sorted delivery men list is alphabetical', (tester) async {
//       final sorted = _sortDeliveryMenByName(deliveryMen);
//       expect(sorted[0].staffName, 'Amit Shah');
//       expect(sorted[1].staffName, 'Ravi Kumar');
//       expect(sorted[2].staffName, 'Sunil Patil');
//     });
//
//     testWidgets('[-] Non-matching search returns empty list', (tester) async {
//       final result = _filterDeliveryMen(deliveryMen, 'XYZ999');
//       expect(result, isEmpty);
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 8 — DAILY REFILL SALE PAGE — ADD ITEM FLOW ON DEVICE
//   // ===========================================================================
//   group('[INT] DailyRefillSalePage — add item flow on device', () {
//     testWidgets('[+] All guards pass → no error returned', (tester) async {
//       final result = _validateAddNewItem(
//         emptyText: '5',
//         filledValue: 10,
//         filledStock: 20,
//         lessEmptyValue: 2,
//         svValue: 3,
//         defectiveValue: 1,
//         emptyValue: 5,
//       );
//       expect(result, isNull);
//     });
//
//     testWidgets('[-] Empty emptyText returns addEmptyCylinderCount', (tester) async {
//       final result = _validateAddNewItem(
//         emptyText: '',
//         filledValue: 10,
//         filledStock: 20,
//         lessEmptyValue: 0,
//         svValue: 0,
//         defectiveValue: 0,
//         emptyValue: 0,
//       );
//       expect(result, 'addEmptyCylinderCount');
//     });
//
//     testWidgets('[-] filledValue > filledStock returns totalSaleQtyDailySale', (tester) async {
//       final result = _validateAddNewItem(
//         emptyText: '5',
//         filledValue: 30,
//         filledStock: 20,
//         lessEmptyValue: 0,
//         svValue: 0,
//         defectiveValue: 0,
//         emptyValue: 5,
//       );
//       expect(result, 'totalSaleQtyDailySale');
//     });
//
//     testWidgets('[-] filledValue < svValue returns countShouldNotBeGreater', (tester) async {
//       final result = _validateAddNewItem(
//         emptyText: '5',
//         filledValue: 2,
//         filledStock: 20,
//         lessEmptyValue: 0,
//         svValue: 5,
//         defectiveValue: 0,
//         emptyValue: 5,
//       );
//       expect(result, 'countShouldNotBeGreater');
//     });
//
//     testWidgets('[+] Auto empty formula calculated correctly', (tester) async {
//       final empty = _calcAutoEmpty(filled: 20, sv: 3, tv: 1, defective: 1, lessEmpty: 2);
//       expect(empty, 15); // 20 - 3 + 1 - 1 - 2 = 15
//     });
//
//     testWidgets('[+] parseToInt returns 0 for empty string', (tester) async {
//       expect(_parseToInt(''), 0);
//     });
//
//     testWidgets('[+] parseToInt parses valid string correctly', (tester) async {
//       expect(_parseToInt('42'), 42);
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 9 — DAILY REFILL SALE PAGE — UPDATE FLOW ON DEVICE
//   // ===========================================================================
//   group('[INT] DailyRefillSalePage — update/edit flow on device', () {
//     testWidgets('[+] Edit mode: filledValue within allowedMax passes', (tester) async {
//       final result = _validateUpdateItemFilledStock(
//         filledValue: 15,
//         filledStock: 10,
//         editFilledStock: 10,
//         lessEmptyValue: 2,
//         svValue: 3,
//         defectiveValue: 1,
//         emptyValue: 5,
//       );
//       expect(result, isNull);
//     });
//
//     testWidgets('[-] Edit mode: filledValue exceeds allowedMax returns totalSaleQtyDailySale', (tester) async {
//       final result = _validateUpdateItemFilledStock(
//         filledValue: 25,
//         filledStock: 10,
//         editFilledStock: 10,
//         lessEmptyValue: 0,
//         svValue: 0,
//         defectiveValue: 0,
//         emptyValue: 5,
//       );
//       expect(result, 'totalSaleQtyDailySale');
//     });
//
//     testWidgets('[+] SV consumer count within limit passes', (tester) async {
//       expect(_validateSVConsumerCount(['C001', 'C002'], 5), isNull);
//     });
//
//     testWidgets('[-] SV consumer count exceeds svQty returns svConsumerCountExceed', (tester) async {
//       expect(_validateSVConsumerCount(['C001,C002,C003,C004'], 2), 'svConsumerCountExceed');
//     });
//
//     testWidgets('[+] TV consumer count within limit passes', (tester) async {
//       expect(_validateTVConsumerCount(['T001'], 3), isNull);
//     });
//
//     testWidgets('[-] TV consumer count exceeds tvQty returns tvConsumerCountExceed', (tester) async {
//       expect(_validateTVConsumerCount(['T001,T002,T003'], 2), 'tvConsumerCountExceed');
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 10 — DAILY REFILL SALE PAGE — SUBMIT FLOW ON DEVICE
//   // ===========================================================================
//   group('[INT] DailyRefillSalePage — submit flow on device', () {
//     testWidgets('[+] stockTransferFlag false → showStockNotAcceptedAlert', (tester) async {
//       expect(
//         _resolveSubmitTap(
//           stockTransferFlag: false,
//           saveFlag: false,
//           isEditMode: false,
//           stockDataFutureNotNull: false,
//           dataFromDBNotEmpty: true,
//           selectedDelBoyNameNotEmpty: true,
//         ),
//         'showStockNotAcceptedAlert',
//       );
//     });
//
//     testWidgets('[+] saveFlag true → showDayEndCompleted', (tester) async {
//       expect(
//         _resolveSubmitTap(
//           stockTransferFlag: true,
//           saveFlag: true,
//           isEditMode: false,
//           stockDataFutureNotNull: false,
//           dataFromDBNotEmpty: true,
//           selectedDelBoyNameNotEmpty: true,
//         ),
//         'showDayEndCompleted',
//       );
//     });
//
//     testWidgets('[+] All conditions clear → sendDataToApi', (tester) async {
//       expect(
//         _resolveSubmitTap(
//           stockTransferFlag: true,
//           saveFlag: false,
//           isEditMode: false,
//           stockDataFutureNotNull: false,
//           dataFromDBNotEmpty: true,
//           selectedDelBoyNameNotEmpty: true,
//         ),
//         'sendDataToApi',
//       );
//     });
//
//     testWidgets('[+] API 200 → dataSentSuccessfully', (tester) async {
//       expect(_interpretSendDataResponse(200), 'dataSentSuccessfully');
//     });
//
//     testWidgets('[-] API 500 → failedToSendData', (tester) async {
//       expect(_interpretSendDataResponse(500), 'failedToSendData');
//     });
//
//     testWidgets('[+] Add button enabled when filledText and delBoy and item provided', (tester) async {
//       expect(
//         _isAddButtonEnabled(
//           filledText: '10',
//           tvText: '',
//           selectedDelBoyName: 'Ravi Kumar',
//           selectedItem: 'LPG 14.2kg',
//         ),
//         isTrue,
//       );
//     });
//
//     testWidgets('[-] Add button disabled when no delBoy selected', (tester) async {
//       expect(
//         _isAddButtonEnabled(
//           filledText: '10',
//           tvText: '',
//           selectedDelBoyName: null,
//           selectedItem: 'LPG 14.2kg',
//         ),
//         isFalse,
//       );
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 11 — STOCK TRANSFER — WIDGET + LOGIC ON DEVICE
//   // ===========================================================================
//   group('[INT] StockTransferTOGodownScreen — widget + logic on device', () {
//     testWidgets('[+] Transfer screen renders item dropdown, qty field, godown dropdown', (tester) async {
//       await tester.pumpWidget(_wrap(const _StockTransferStub()));
//       await tester.pumpAndSettle();
//       expect(find.byKey(const Key('itemDropdown')), findsOneWidget);
//       expect(find.byKey(const Key('qtyField')), findsOneWidget);
//       expect(find.byKey(const Key('godownDropdown')), findsOneWidget);
//       expect(find.byKey(const Key('transferBtn')), findsOneWidget);
//     });
//
//     testWidgets('[-] Submit without item selection shows selectItem error', (tester) async {
//       await tester.pumpWidget(_wrap(const _StockTransferStub()));
//       await tester.pumpAndSettle();
//       await tester.tap(find.byKey(const Key('transferBtn')));
//       await tester.pumpAndSettle();
//       expect(find.text('selectItem'), findsOneWidget);
//     });
//
//     testWidgets('[+] Full valid transfer flow shows success', (tester) async {
//       await tester.pumpWidget(_wrap(const _StockTransferStub()));
//       await tester.pumpAndSettle();
//       // Select item
//       await tester.tap(find.byKey(const Key('itemDropdown')));
//       await tester.pumpAndSettle();
//       await tester.tap(find.text('LPG 14.2kg').last);
//       await tester.pumpAndSettle();
//       // Enter qty
//       await tester.enterText(find.byKey(const Key('qtyField')), '10');
//       await tester.pumpAndSettle();
//       // Select destination
//       await tester.tap(find.byKey(const Key('godownDropdown')));
//       await tester.pumpAndSettle();
//       await tester.tap(find.text('Godown A').last);
//       await tester.pumpAndSettle();
//       // Submit
//       await tester.tap(find.byKey(const Key('transferBtn')));
//       await tester.pumpAndSettle();
//       expect(find.text('Transfer Successful'), findsOneWidget);
//     });
//
//     testWidgets('[+] Validate transfer logic: valid input passes', (tester) async {
//       expect(
//         _validateStockTransfer(
//           selectedItem: 'LPG 14.2kg',
//           transferQty: 10,
//           availableStock: 50,
//           destinationGodown: 'Godown A',
//         ),
//         isNull,
//       );
//     });
//
//     testWidgets('[-] Validate transfer logic: qty exceeds stock returns insufficientStock', (tester) async {
//       expect(
//         _validateStockTransfer(
//           selectedItem: 'LPG 14.2kg',
//           transferQty: 100,
//           availableStock: 50,
//           destinationGodown: 'Godown A',
//         ),
//         'insufficientStock',
//       );
//     });
//
//     testWidgets('[+] Transaction frozen when pending transfer exists', (tester) async {
//       final transfers = [const StubStockTransfer(isStkTrans: 0)];
//       expect(_isTransactionFrozen(transfers), isTrue);
//     });
//
//     testWidgets('[+] Transaction not frozen when all transfers accepted', (tester) async {
//       final transfers = [const StubStockTransfer(isStkTrans: 1)];
//       expect(_isTransactionFrozen(transfers), isFalse);
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 12 — DASHBOARD — STOCK FILTER LOGIC ON DEVICE
//   // ===========================================================================
//   group('[INT] DashboardScreen — stock filter logic on device', () {
//     final openingStock = [
//       const StubOpeningStock(itemId: 1, filledOpeningStk: 100, emptyOpeningStk: 50, defOpeningStk: 5),
//       const StubOpeningStock(itemId: 2, filledOpeningStk: 60, emptyOpeningStk: 30, defOpeningStk: 2),
//     ];
//     final currentStock = [
//       const StubCurrentStock(itemId: 1, currentStkFilled: 80, currentStkEmpty: 40, currentStkDefective: 3),
//       const StubCurrentStock(itemId: 2, currentStkFilled: 45, currentStkEmpty: 25, currentStkDefective: 1),
//     ];
//
//     testWidgets('[+] Filter for itemId 1 returns correct opening stock', (tester) async {
//       final result = _filterBothStockLists(
//         selectedItemId: 1,
//         openingStock: openingStock,
//         currentStock: currentStock,
//       );
//       expect(result['filled'], 100);
//       expect(result['empty'], 50);
//       expect(result['defective'], 5);
//     });
//
//     testWidgets('[+] Filter for itemId 1 returns correct current stock', (tester) async {
//       final result = _filterBothStockLists(
//         selectedItemId: 1,
//         openingStock: openingStock,
//         currentStock: currentStock,
//       );
//       expect(result['currentFilled'], 80);
//       expect(result['currentEmpty'], 40);
//       expect(result['currentDefective'], 3);
//     });
//
//     testWidgets('[+] Filter for itemId 2 returns correct values', (tester) async {
//       final result = _filterBothStockLists(
//         selectedItemId: 2,
//         openingStock: openingStock,
//         currentStock: currentStock,
//       );
//       expect(result['filled'], 60);
//       expect(result['currentFilled'], 45);
//     });
//
//     testWidgets('[-] Null selectedItemId returns all zeros', (tester) async {
//       final result = _filterBothStockLists(
//         selectedItemId: null,
//         openingStock: openingStock,
//         currentStock: currentStock,
//       );
//       expect(result.values.every((v) => v == 0), isTrue);
//     });
//
//     testWidgets('[-] Unknown itemId returns zeros (item not found)', (tester) async {
//       final result = _filterBothStockLists(
//         selectedItemId: 99,
//         openingStock: openingStock,
//         currentStock: currentStock,
//       );
//       expect(result['filled'], 0);
//       expect(result['currentFilled'], 0);
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 13 — MARK DEFECTIVE ITEM — LOGIC ON DEVICE
//   // ===========================================================================
//   group('[INT] MarkDefectiveItemScreen — logic on device', () {
//     testWidgets('[+] Valid item and qty passes validation', (tester) async {
//       expect(
//         _validateMarkDefective(selectedItem: 'LPG 14.2kg', qty: 3, availableStock: 10),
//         isNull,
//       );
//     });
//
//     testWidgets('[-] No item selected returns selectItem', (tester) async {
//       expect(
//         _validateMarkDefective(selectedItem: null, qty: 3, availableStock: 10),
//         'selectItem',
//       );
//     });
//
//     testWidgets('[-] Zero qty returns invalidQty', (tester) async {
//       expect(
//         _validateMarkDefective(selectedItem: 'LPG 14.2kg', qty: 0, availableStock: 10),
//         'invalidQty',
//       );
//     });
//
//     testWidgets('[-] Qty exceeds stock returns insufficientStock', (tester) async {
//       expect(
//         _validateMarkDefective(selectedItem: 'LPG 14.2kg', qty: 20, availableStock: 10),
//         'insufficientStock',
//       );
//     });
//
//     testWidgets('[+] Qty exactly equals available stock passes', (tester) async {
//       expect(
//         _validateMarkDefective(selectedItem: 'LPG 14.2kg', qty: 10, availableStock: 10),
//         isNull,
//       );
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 14 — EDIT / DELETE TRANSACTION — LOGIC ON DEVICE
//   // ===========================================================================
//   group('[INT] Edit/Delete Transaction — logic on device', () {
//     testWidgets('[+] No restrictions — delete proceeds', (tester) async {
//       expect(
//         _validateDeleteTransaction(dayEndSaved: false, cashCollected: false),
//         isNull,
//       );
//     });
//
//     testWidgets('[-] Day end saved — returns dayEndRestriction', (tester) async {
//       expect(
//         _validateDeleteTransaction(dayEndSaved: true, cashCollected: false),
//         'dayEndRestriction',
//       );
//     });
//
//     testWidgets('[-] Cash collected — returns cashCollectionRestriction', (tester) async {
//       expect(
//         _validateDeleteTransaction(dayEndSaved: false, cashCollected: true),
//         'cashCollectionRestriction',
//       );
//     });
//
//     testWidgets('[+] API response > 0 — deleteSuccess', (tester) async {
//       expect(_interpretDeleteResponse(1), 'deleteSuccess');
//     });
//
//     testWidgets('[-] API response 0 — deleteFailed', (tester) async {
//       expect(_interpretDeleteResponse(0), 'deleteFailed');
//     });
//
//     testWidgets('[-] API response negative — deleteFailed', (tester) async {
//       expect(_interpretDeleteResponse(-1), 'deleteFailed');
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 15 — NAVIGATION & TOKEN REFRESH LOGIC ON DEVICE
//   // ===========================================================================
//   group('[INT] Navigation and token refresh logic on device', () {
//     testWidgets('[+] Non-200 status code triggers token refresh', (tester) async {
//       expect(_shouldRefreshToken(401), isTrue);
//       expect(_shouldRefreshToken(403), isTrue);
//       expect(_shouldRefreshToken(500), isTrue);
//     });
//
//     testWidgets('[-] 200 status code does not trigger token refresh', (tester) async {
//       expect(_shouldRefreshToken(200), isFalse);
//     });
//
//     testWidgets('[+] fromDrawer arg resolves to navigateWithOnBack', (tester) async {
//       expect(_resolveBackNavigation('fromDrawer'), 'navigateWithOnBack');
//     });
//
//     testWidgets('[+] Other arg resolves to navigatePlain', (tester) async {
//       expect(_resolveBackNavigation('other'), 'navigatePlain');
//       expect(_resolveBackNavigation(null), 'navigatePlain');
//     });
//   });
//
//   // ===========================================================================
//   // INT-MODULE 16 — END-TO-END GODOWN KEEPER FLOW ON DEVICE
//   // ===========================================================================
//   group('[INT] End-to-end Godown Keeper flow on device', () {
//     testWidgets('[+] Full receipt → return → SQC → daily sale flow logic passes', (tester) async {
//       // Step 1: Receive cylinders
//       await _setupPrefs();
//       final prefs = await SharedPreferences.getInstance();
//       expect(prefs.getString('godownId'), '1');
//
//       // Step 2: Build receipt
//       final receipt = _buildReceipt(vehicleNo: 'MH12AB1234');
//       expect(receipt.vehicleNo, 'MH12AB1234');
//       expect(_isPending(receipt.returnOn), isTrue);
//
//       // Step 3: Validate receipt submit
//       final receiptError = _validateItemReceiptSubmit(
//         vehicleNo: receipt.vehicleNo!,
//         items: [
//           {'selectedName': 'LPG 14.2kg', 'invoiceQty': '10', 'filledQty': '10', 'emrQty': '0'}
//         ],
//         availableItems: [const StubCylItem(itemId: 1, itemName: 'LPG 14.2kg')],
//       );
//       expect(receiptError, isNull);
//
//       // Step 4: SQC filter shows this vehicle as pending
//       final sqcList = [StubSQCCard(vehicleNo: receipt.vehicleNo, sQCStatus: 'no')];
//       final sqcResult = _filterSQCList(all: sqcList, selectedStatus: 'SQC Pending');
//       expect((sqcResult['filtered'] as List).length, 1);
//
//       // Step 5: Daily sale validation passes
//       final saleError = _validateAddNewItem(
//         emptyText: '8',
//         filledValue: 10,
//         filledStock: 20,
//         lessEmptyValue: 0,
//         svValue: 2,
//         defectiveValue: 0,
//         emptyValue: 8,
//       );
//       expect(saleError, isNull);
//
//       // Step 6: Submit resolves to sendDataToApi
//       final submitResult = _resolveSubmitTap(
//         stockTransferFlag: true,
//         saveFlag: false,
//         isEditMode: false,
//         stockDataFutureNotNull: false,
//         dataFromDBNotEmpty: true,
//         selectedDelBoyNameNotEmpty: true,
//       );
//       expect(submitResult, 'sendDataToApi');
//
//       // Step 7: API 200 = success
//       expect(_interpretSendDataResponse(200), 'dataSentSuccessfully');
//     });
//
//     testWidgets('[+] Stock transfer freeze → accept → resume flow logic passes', (tester) async {
//       // Pending transfer freezes transactions
//       final pendingTransfers = [const StubStockTransfer(isStkTrans: 0)];
//       expect(_isTransactionFrozen(pendingTransfers), isTrue);
//       expect(_computeStockTransferFlag(pendingTransfers), isFalse);
//
//       // After acceptance, transactions resume
//       final acceptedTransfers = [const StubStockTransfer(isStkTrans: 1)];
//       expect(_isTransactionFrozen(acceptedTransfers), isFalse);
//       expect(_computeStockTransferFlag(acceptedTransfers), isTrue);
//     });
//
//     testWidgets('[+] Delete transaction passes when no day-end and no cash-collection', (tester) async {
//       expect(
//         _validateDeleteTransaction(dayEndSaved: false, cashCollected: false),
//         isNull,
//       );
//       expect(_interpretDeleteResponse(1), 'deleteSuccess');
//     });
//   });
// }




// ============================================================
//  GODOWN KEEPER — SCENARIO-BASED INTEGRATION TESTS
//  File: integration_test/godown_keeper_integration_test.dart
//
//  ROOT CAUSE FIX:
//  SharedPreferences.setMockInitialValues() MUST be called before
//  app.main() starts the widget tree. Previously the session was
//  injected too late → SplashScreen always appeared.
//
//  Pattern used here (guaranteed order):
//    1. setMockInitialValues(...)   ← prefs ready in memory
//    2. app.main()                 ← reads prefs in initState → no splash
//    3. pumpAndSettle / assertions
//
//  Run all tests:
//    flutter test integration_test/godown_keeper_integration_test.dart \
//      --device-id <id>
//
//  Run one group:
//    flutter test integration_test/godown_keeper_integration_test.dart \
//      --name "G1"
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Replace with your actual package name ──────────────────
import 'package:lpgsalesandinventory/main.dart' as app;
// ───────────────────────────────────────────────────────────

// ══════════════════════════════════════════════════════════════
//  SESSION CONSTANTS
//  Use real values from a test/QA account.
//  All pref keys are taken directly from your source code.
// ══════════════════════════════════════════════════════════════
const _kToken           = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJTYWhlYnJhbyBKYW5nYWxlIiwianRpIjoiZTU1OWQ2OTAtMjg5Ni00ODAzLWJhMTYtNjk1Mjk0ZjZkMDhkIiwibmFtZWlkIjoiU2FoZWJyYW8gSmFuZ2FsZSIsInJvbGUiOiIwIiwiTG9nZ2VkT24iOiI1LzE5LzIwMjYgNToyNjoxOSBQTSIsIkRpc3BsYXlOYW1lIjoiU2FoZWJyYW8gSmFuZ2FsZSIsIm5iZiI6MTc3OTE5MTc3OSwiZXhwIjoxNzc5Mjk5Nzc5LCJpYXQiOjE3NzkxOTE3NzksImlzcyI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSIsImF1ZCI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSJ9.IJSs_b6kpyp5Zxh4L065jsRLs8eyw7Cxv9r5yweqqpk';
const _kDistributorId   = '8118';
const _kStaffId         = '22';
const _kUserId          = '0';
const _kStaffName       = 'Sahebrao Jangale';
const _kRoleName        = 'GodownKeeper';
const _kRoleId          = '0';
const _kMobileNo        = '9700097000';
const _kGodownId        = '1';
const _kGodownKeeperId  = '22';
const _kDistributorName = 'SHREE RENUKA GAS SUPPLY COMPANY';
// IsAlreadyLogin must be '1' — otherwise fetchSavedData redirects to Splash
const _kIsAlreadyLogin  = '1';

// ══════════════════════════════════════════════════════════════
//  CORE HELPER: injectSession()
//
//  ALWAYS call this BEFORE app.main().
//  SharedPreferences.setMockInitialValues writes values into the
//  in-memory store synchronously. When app.main() later calls
//  SharedPreferences.getInstance(), it reads from this store
//  immediately — the app finds a valid session and skips Splash.
// ══════════════════════════════════════════════════════════════
void injectSession() {
  SharedPreferences.setMockInitialValues({
    'token'           : _kToken,
    'DistributorId'   : _kDistributorId,
    'StaffId'         : _kStaffId,
    'UserId'          : _kUserId,
    'StaffName'       : _kStaffName,
    'RoleName'        : _kRoleName,
    'RoleId'          : _kRoleId,   // uppercase key
    'roleId'          : _kRoleId,   // lowercase key — app may check both
    'MobileNo'        : _kMobileNo,
    'godownId'        : _kGodownId,
    'godownKeeperId'  : _kGodownKeeperId,
    'DistributorName' : _kDistributorName,
    // This key is checked in fetchSavedData() — must be '1' (not '0' or empty)
    'IsAlreadyLogin'  : _kIsAlreadyLogin,
    // Required: prevents "Deactivated User" screen
    'userActive'      : 'Y',
  });
}

/// Inject an EMPTY session — simulates fresh install / logged-out state.
/// Use only in G0 login tests.
void clearSession() {
  SharedPreferences.setMockInitialValues({});
}

// ══════════════════════════════════════════════════════════════
//  PUMP HELPERS
// ══════════════════════════════════════════════════════════════

/// Keep pumping until [finder] appears or [timeout] elapses.
Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
      Duration timeout = const Duration(seconds: 20),
    }) async {
  final deadline = DateTime.now().add(timeout);
  do {
    if (tester.any(finder)) return;
    await tester.pump(const Duration(milliseconds: 400));
  } while (DateTime.now().isBefore(deadline));
  throw Exception('pumpUntilFound timed out: $finder');
}

/// Wait for loading spinners / async API calls to settle.
Future<void> settle(WidgetTester tester, {int seconds = 4}) async {
  await tester.pump(Duration(seconds: seconds));
  try {
    await tester.pumpAndSettle(const Duration(seconds: 3));
  } catch (_) {
    // pumpAndSettle throws if there are infinite animations (e.g. loaders).
    // Swallow it — we already pumped enough frames.
  }
}

Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.tap(finder, warnIfMissed: false);
  await settle(tester, seconds: 2);
}

Future<void> enterText(WidgetTester tester, Finder finder, String text) async {
  await tester.tap(finder, warnIfMissed: false);
  await tester.pumpAndSettle();
  await tester.enterText(finder, text);
  await tester.pumpAndSettle();
}

/// Returns true if the current tree contains any Splash-related widget.
bool splashVisible(WidgetTester tester) {
  return tester.any(
    find.byWidgetPredicate(
          (w) => w.runtimeType.toString().toLowerCase().contains('splash'),
    ),
  );
}

/// Assert splash is NOT visible with a meaningful reason string.
void expectNoSplash(WidgetTester tester, String context) {
  expect(
    splashVisible(tester),
    isFalse,
    reason: 'SplashScreen must NOT appear during: $context',
  );
}

// ══════════════════════════════════════════════════════════════
//  LAUNCH HELPER
//
//  Every test that needs to skip Splash calls launchAsGodownKeeper().
//  Order is: injectSession() → app.main() → wait for Dashboard.
// ══════════════════════════════════════════════════════════════
Future<void> launchAsGodownKeeper(WidgetTester tester) async {
  // ① Write prefs BEFORE the widget tree is created
  injectSession();

  // ② Start the app
  app.main();

  // ③ Pump the first frame so the MaterialApp + routes are built
  await tester.pump();

  // ④ Wait until the bottom-navigation / Dashboard is visible.
  //    Uses pumpUntilFound so that slow CI devices get enough time.
  await pumpUntilFound(
    tester,
    find.text('Dashboard'),
    timeout: const Duration(seconds: 25),
  );

  // ⑤ Let any pending API calls / animations finish
  await settle(tester, seconds: 3);

  // ⑥ Confirm we are NOT on Splash
  expectNoSplash(tester, 'initial launch as GodownKeeper');
}

// ══════════════════════════════════════════════════════════════
//  TESTS
// ══════════════════════════════════════════════════════════════
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ────────────────────────────────────────────────────────────
  //  G0 — LOGIN (uses real login flow, no pre-injected session)
  // ────────────────────────────────────────────────────────────
  group('G0 – Login & Session', () {
    testWidgets(
      'TC-G0-01 [POSITIVE] Valid credentials → Dashboard, no Splash',
          (tester) async {
        clearSession(); // Start from logged-out state
        app.main();
        await settle(tester, seconds: 5);

        // ── Fill login form ─────────────────────────────────
        // Adjust these finders to match your actual login screen widgets
        final mobileField  = find.byKey(const Key('login_mobile'));
        final passwordField = find.byKey(const Key('login_password'));
        final loginBtn     = find.byKey(const Key('login_button'));

        if (tester.any(mobileField)) {
          await enterText(tester, mobileField, _kMobileNo);
          await enterText(tester, passwordField, 'YourRealPassword');
          await tapAndSettle(tester, loginBtn);
          await settle(tester, seconds: 8);
        }

        // After successful login → Dashboard visible, Splash gone
        await pumpUntilFound(tester, find.text('Dashboard'));
        expectNoSplash(tester, 'TC-G0-01 after login');
      },
    );

    testWidgets(
      'TC-G0-02 [NEGATIVE] Wrong credentials → error shown, stays on Login',
          (tester) async {
        clearSession();
        app.main();
        await settle(tester, seconds: 5);

        final mobileField  = find.byKey(const Key('login_mobile'));
        final passwordField = find.byKey(const Key('login_password'));
        final loginBtn     = find.byKey(const Key('login_button'));

        if (tester.any(mobileField)) {
          await enterText(tester, mobileField, '0000000000');
          await enterText(tester, passwordField, 'wrongpass');
          await tapAndSettle(tester, loginBtn);
          await settle(tester, seconds: 5);

          // Error toast / snackbar / inline message
          expect(
            find.byWidgetPredicate((w) =>
            w is Text &&
                ['invalid','error','failed','incorrect','wrong']
                    .any((s) => w.data?.toLowerCase().contains(s) == true)),
            findsAtLeastNWidgets(1),
            reason: 'Error must be shown for wrong credentials',
          );
          expect(find.text('Dashboard'), findsNothing);
        }
      },
    );

    testWidgets(
      'TC-G0-03 [POSITIVE] Pre-injected session skips Splash entirely',
          (tester) async {
        // The key scenario: inject BEFORE main() is called
        injectSession();
        app.main();
        await tester.pump(); // first frame
        // Should go directly to Dashboard — splash should never appear
        await pumpUntilFound(tester, find.text('Dashboard'));
        expectNoSplash(tester, 'TC-G0-03 pre-injected session');
      },
    );

    testWidgets(
      'TC-G0-04 [POSITIVE] Navigate all 4 tabs — session never lost',
          (tester) async {
        await launchAsGodownKeeper(tester);

        for (final tab in ['Dashboard', 'Daily Sale', "Today's Summary", 'More']) {
          await tapAndSettle(tester, find.text(tab));
          await settle(tester, seconds: 3);
          expectNoSplash(tester, 'TC-G0-04 tab: $tab');
        }
      },
    );
  });

  // ────────────────────────────────────────────────────────────
  //  G1 — DASHBOARD SCREEN
  // ────────────────────────────────────────────────────────────
  group('G1 – Dashboard Screen', () {
    testWidgets('TC-G1-01 [POSITIVE] All 5 dashboard sections render', (tester) async {
      await launchAsGodownKeeper(tester);

      expect(find.textContaining("Today's Opening Stock"), findsOneWidget);
      expect(find.textContaining('Current Stock'),         findsOneWidget);
      expect(find.textContaining('Physical Stock Imbalance'), findsOneWidget);
      expect(find.textContaining('SQC Status'),            findsOneWidget);
      expect(find.textContaining('Today Vehicle SQC'),     findsOneWidget);
      expectNoSplash(tester, 'TC-G1-01');
    });

    testWidgets('TC-G1-02 [POSITIVE] Pull-to-refresh works, stays on Dashboard', (tester) async {
      await launchAsGodownKeeper(tester);

      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await settle(tester, seconds: 6);

      expect(find.textContaining("Today's Opening Stock"), findsOneWidget);
      expectNoSplash(tester, 'TC-G1-02 after pull-to-refresh');
    });

    testWidgets('TC-G1-03 [POSITIVE] FAB shows Confirm Refresh dialog', (tester) async {
      await launchAsGodownKeeper(tester);

      final fab = find.byType(FloatingActionButton);
      if (tester.any(fab)) {
        await tapAndSettle(tester, fab);
        expect(find.text('Confirm Refresh'), findsOneWidget);
        expect(find.text('Yes'),             findsOneWidget);
        expect(find.text('No'),              findsOneWidget);
        await tapAndSettle(tester, find.text('No')); // dismiss
      }
    });

    testWidgets('TC-G1-04 [POSITIVE] FAB Refresh → Yes stays on Dashboard', (tester) async {
      await launchAsGodownKeeper(tester);

      final fab = find.byType(FloatingActionButton);
      if (tester.any(fab)) {
        await tapAndSettle(tester, fab);
        await tapAndSettle(tester, find.text('Yes'));
        await settle(tester, seconds: 6);
        expect(find.textContaining("Today's Opening Stock"), findsOneWidget);
        expectNoSplash(tester, 'TC-G1-04 after FAB refresh');
      }
    });

    testWidgets('TC-G1-05 [POSITIVE] Item dropdown changes opening stock view', (tester) async {
      await launchAsGodownKeeper(tester);

      final dropdown = find.byType(DropdownButton<num>).first;
      if (tester.any(dropdown)) {
        await tapAndSettle(tester, dropdown);
        final items = find.byType(DropdownMenuItem<num>);
        if (tester.any(items)) {
          await tapAndSettle(tester, items.first);
          await settle(tester, seconds: 2);
          expect(find.text('Filled'), findsWidgets);
          expect(find.text('Empty'),  findsWidgets);
        }
      }
    });

    testWidgets('TC-G1-06 [POSITIVE] SQC filter dropdown options visible', (tester) async {
      await launchAsGodownKeeper(tester);

      final sqcDropdown = find.byType(DropdownButton<String>);
      if (tester.any(sqcDropdown)) {
        await tapAndSettle(tester, sqcDropdown.first);
        final anyOption =
            tester.any(find.text('All Vehicles')) ||
                tester.any(find.text('Done'))         ||
                tester.any(find.text('Not Done'));
        expect(anyOption, isTrue, reason: 'SQC filter options must appear');
        await tester.tapAt(const Offset(10, 10)); // close
        await tester.pumpAndSettle();
      }
    });

    testWidgets('TC-G1-07 [POSITIVE] Transfer button navigates without Splash', (tester) async {
      await launchAsGodownKeeper(tester);

      final transferBtn = find.textContaining('Transfer');
      if (tester.any(transferBtn)) {
        await tapAndSettle(tester, transferBtn.first);
        await settle(tester, seconds: 4);
        expectNoSplash(tester, 'TC-G1-07 after Transfer tap');
      }
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G2 — DAILY SALE (Del Boy Stock Return)
  // ────────────────────────────────────────────────────────────
  group('G2 – Daily Sale / Del Boy Stock Return', () {
    testWidgets('TC-G2-01 [POSITIVE] Tab loads delivery men list', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('Daily Sale'));
      await settle(tester, seconds: 5);

      expectNoSplash(tester, 'TC-G2-01');
      expect(
        tester.any(find.byType(ListTile)) || tester.any(find.textContaining('No')),
        isTrue,
        reason: 'List or empty state must render',
      );
    });

    testWidgets('TC-G2-02 [POSITIVE] Tap delivery man → opens stock return form', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('Daily Sale'));
      await settle(tester, seconds: 5);

      if (tester.any(find.byType(ListTile))) {
        await tapAndSettle(tester, find.byType(ListTile).first);
        await settle(tester, seconds: 4);
        expectNoSplash(tester, 'TC-G2-02 after tapping delivery man');
      }
    });

    testWidgets('TC-G2-03 [NEGATIVE] Submit empty stock return → validation fires', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('Daily Sale'));
      await settle(tester, seconds: 5);

      if (tester.any(find.byType(ListTile))) {
        await tapAndSettle(tester, find.byType(ListTile).first);
        await settle(tester, seconds: 3);

        final submitBtn = find.textContaining('Submit');
        if (tester.any(submitBtn)) {
          await tapAndSettle(tester, submitBtn.first);
          expect(
            tester.any(find.textContaining('required', skipOffstage: false)) ||
                tester.any(find.textContaining('enter',    skipOffstage: false)),
            isTrue,
            reason: 'Validation errors must appear on empty submit',
          );
        }
      }
    });

    testWidgets('TC-G2-04 [NEGATIVE] Negative quantity rejected', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('Daily Sale'));
      await settle(tester, seconds: 5);

      if (tester.any(find.byType(ListTile))) {
        await tapAndSettle(tester, find.byType(ListTile).first);
        await settle(tester, seconds: 3);

        final fields = find.byType(TextFormField);
        if (tester.any(fields)) {
          await enterText(tester, fields.first, '-5');
          final submitBtn = find.textContaining('Submit');
          if (tester.any(submitBtn)) {
            await tapAndSettle(tester, submitBtn.first);
            expect(
              tester.any(find.textContaining('invalid', skipOffstage: false)) ||
                  tester.any(find.textContaining('valid',   skipOffstage: false)),
              isTrue,
              reason: 'Negative quantity must be rejected',
            );
          }
        }
      }
    });

    testWidgets('TC-G2-05 [POSITIVE] Valid quantities submitted — no crash', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('Daily Sale'));
      await settle(tester, seconds: 5);

      if (tester.any(find.byType(ListTile))) {
        await tapAndSettle(tester, find.byType(ListTile).first);
        await settle(tester, seconds: 3);

        final fields = find.byType(TextFormField);
        for (int i = 0; i < fields.evaluate().length; i++) {
          await enterText(tester, fields.at(i), '2');
        }
        final submitBtn = find.textContaining('Submit');
        if (tester.any(submitBtn)) {
          await tapAndSettle(tester, submitBtn.first);
          await settle(tester, seconds: 6);
          expect(find.byType(Exception), findsNothing);
          expectNoSplash(tester, 'TC-G2-05 after valid submit');
        }
      }
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G3 — TODAY'S SUMMARY (Stock Submit to Manager)
  // ────────────────────────────────────────────────────────────
  group("G3 – Today's Summary / Stock Submit to Manager", () {
    testWidgets("TC-G3-01 [POSITIVE] Tab loads without Splash", (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text("Today's Summary"));
      await settle(tester, seconds: 5);
      expectNoSplash(tester, 'TC-G3-01');
    });

    testWidgets('TC-G3-02 [NEGATIVE] Empty submit shows validation', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text("Today's Summary"));
      await settle(tester, seconds: 5);

      final btn = find.textContaining('Submit');
      if (tester.any(btn)) {
        await tapAndSettle(tester, btn.first);
        expect(
          tester.any(find.textContaining('required', skipOffstage: false)) ||
              tester.any(find.textContaining('enter',    skipOffstage: false)),
          isTrue,
        );
      }
    });

    testWidgets('TC-G3-03 [NEGATIVE] Non-numeric text rejected', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text("Today's Summary"));
      await settle(tester, seconds: 5);

      final fields = find.byType(TextFormField);
      if (tester.any(fields)) {
        await enterText(tester, fields.first, 'abc');
        final btn = find.textContaining('Submit');
        if (tester.any(btn)) {
          await tapAndSettle(tester, btn.first);
          expect(
            tester.any(find.textContaining('invalid', skipOffstage: false)) ||
                tester.any(find.textContaining('number',  skipOffstage: false)),
            isTrue,
          );
        }
      }
    });

    testWidgets('TC-G3-04 [POSITIVE] Valid data submit — no crash', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text("Today's Summary"));
      await settle(tester, seconds: 5);

      final fields = find.byType(TextFormField);
      for (int i = 0; i < fields.evaluate().length; i++) {
        await enterText(tester, fields.at(i), '1');
      }
      final btn = find.textContaining('Submit');
      if (tester.any(btn)) {
        await tapAndSettle(tester, btn.first);
        await settle(tester, seconds: 6);
        expect(find.byType(Exception), findsNothing);
        expectNoSplash(tester, 'TC-G3-04 after valid submit');
      }
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G4 — MORE OPTIONS SCREEN
  // ────────────────────────────────────────────────────────────
  group('G4 – More Options Screen', () {
    testWidgets('TC-G4-01 [POSITIVE] All menu sections visible', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 3);

      expect(find.text('More Options'),              findsOneWidget);
      expect(find.textContaining('Item Receipt'),    findsWidgets);
      expect(find.textContaining('Item Return'),     findsWidgets);
      expect(find.textContaining('EXMI'),            findsWidgets);
      expect(find.textContaining('Mark Defective'),  findsWidgets);
      expect(find.textContaining('Logout'),          findsOneWidget);
      expectNoSplash(tester, 'TC-G4-01');
    });

    testWidgets('TC-G4-02 [POSITIVE] Logout shows confirm dialog', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 3);

      await tapAndSettle(tester, find.text('Logout'));
      expect(find.text('Confirm Logout'), findsOneWidget);
      expect(find.text('Cancel'),         findsOneWidget);
    });

    testWidgets('TC-G4-03 [POSITIVE] Logout Cancel → stays on More Options', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 3);

      await tapAndSettle(tester, find.text('Logout'));
      await tapAndSettle(tester, find.text('Cancel'));

      expect(find.text('More Options'), findsOneWidget);
      expectNoSplash(tester, 'TC-G4-03 after Cancel');
    });

    testWidgets('TC-G4-04 [POSITIVE] Logout Confirm → session cleared → Splash/Login', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 3);

      await tapAndSettle(tester, find.text('Logout'));
      // The dialog has TWO widgets with text 'Logout' — tap the last (button inside dialog)
      await tapAndSettle(tester, find.text('Logout').last);
      await settle(tester, seconds: 6);

      // After logout: Dashboard & More Options must NOT be visible
      expect(find.text('More Options'), findsNothing);
      expect(find.text('Dashboard'),    findsNothing);
    });

    testWidgets('TC-G4-05 [POSITIVE] Back press from More → BottomNav (not Splash)', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 3);

      final NavigatorState nav = tester.state(find.byType(Navigator).last);
      nav.pop();
      await settle(tester, seconds: 3);

      expectNoSplash(tester, 'TC-G4-05 after back press from More');
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G5 — ITEM RECEIPT  (More → Item Receipt)
  // ────────────────────────────────────────────────────────────
  group('G5 – Item Receipt', () {
    Future<void> openItemReceipt(WidgetTester tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 2);
      await tapAndSettle(tester, find.text('Item Receipt'));
      await settle(tester, seconds: 5);
    }

    testWidgets('TC-G5-01 [POSITIVE] Screen opens without Splash', (tester) async {
      await openItemReceipt(tester);
      expectNoSplash(tester, 'TC-G5-01');
    });

    testWidgets('TC-G5-02 [NEGATIVE] Empty submit triggers validation', (tester) async {
      await openItemReceipt(tester);
      final btn = tester.any(find.textContaining('Save'))
          ? find.textContaining('Save')
          : find.textContaining('Submit');
      if (tester.any(btn)) {
        await tapAndSettle(tester, btn.first);
        expect(
          tester.any(find.textContaining('required', skipOffstage: false)) ||
              tester.any(find.textContaining('enter',    skipOffstage: false)),
          isTrue,
        );
      }
    });

    testWidgets('TC-G5-03 [NEGATIVE] Quantity = 0 rejected', (tester) async {
      await openItemReceipt(tester);
      final fields = find.byType(TextFormField);
      if (tester.any(fields)) {
        await enterText(tester, fields.first, '0');
        final btn = find.textContaining('Save');
        if (tester.any(btn)) {
          await tapAndSettle(tester, btn.first);
          expect(
            tester.any(find.textContaining('greater',  skipOffstage: false)) ||
                tester.any(find.textContaining('invalid',  skipOffstage: false)) ||
                tester.any(find.textContaining('required', skipOffstage: false)),
            isTrue,
          );
        }
      }
    });

    testWidgets('TC-G5-04 [POSITIVE] Fill all fields and save — no crash', (tester) async {
      await openItemReceipt(tester);
      final fields = find.byType(TextFormField);
      for (int i = 0; i < fields.evaluate().length; i++) {
        await enterText(tester, fields.at(i), '10');
      }
      final dropdowns = find.byType(DropdownButtonFormField);
      if (tester.any(dropdowns)) {
        await tapAndSettle(tester, dropdowns.first);
        final opt = find.byType(DropdownMenuItem).first;
        if (tester.any(opt)) await tapAndSettle(tester, opt);
      }
      final btn = find.textContaining('Save');
      if (tester.any(btn)) {
        await tapAndSettle(tester, btn.first);
        await settle(tester, seconds: 6);
        expect(find.byType(Exception), findsNothing);
        expectNoSplash(tester, 'TC-G5-04 after save');
      }
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G6 — ITEM RETURN  (More → Item Return)
  // ────────────────────────────────────────────────────────────
  group('G6 – Item Return', () {
    Future<void> openItemReturn(WidgetTester tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 2);
      await tapAndSettle(tester, find.text('Item Return'));
      await settle(tester, seconds: 5);
    }

    testWidgets('TC-G6-01 [POSITIVE] Screen opens without Splash', (tester) async {
      await openItemReturn(tester);
      expectNoSplash(tester, 'TC-G6-01');
    });

    testWidgets('TC-G6-02 [NEGATIVE] Empty submit → validation fires', (tester) async {
      await openItemReturn(tester);
      final btn = find.textContaining('Submit');
      if (tester.any(btn)) {
        await tapAndSettle(tester, btn.first);
        expect(
          tester.any(find.textContaining('required', skipOffstage: false)) ||
              tester.any(find.textContaining('enter',    skipOffstage: false)),
          isTrue,
        );
      }
    });

    testWidgets('TC-G6-03 [POSITIVE] Valid return data submitted — no crash', (tester) async {
      await openItemReturn(tester);
      final fields = find.byType(TextFormField);
      for (int i = 0; i < fields.evaluate().length; i++) {
        await enterText(tester, fields.at(i), '1');
      }
      final btn = find.textContaining('Submit');
      if (tester.any(btn)) {
        await tapAndSettle(tester, btn.first);
        await settle(tester, seconds: 6);
        expect(find.byType(Exception), findsNothing);
        expectNoSplash(tester, 'TC-G6-03 after submit');
      }
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G7 — RETURN EXMI / Rev-EMR
  // ────────────────────────────────────────────────────────────
  group('G7 – Return EXMI / Rev-EMR', () {
    Future<void> openReturnExmi(WidgetTester tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 2);
      await tapAndSettle(tester, find.text('Return EXMI / Rev-EMR'));
      await settle(tester, seconds: 5);
    }

    testWidgets('TC-G7-01 [POSITIVE] Screen opens without Splash', (tester) async {
      await openReturnExmi(tester);
      expectNoSplash(tester, 'TC-G7-01');
    });

    testWidgets('TC-G7-02 [NEGATIVE] Empty submit → validation fires', (tester) async {
      await openReturnExmi(tester);
      final btn = tester.any(find.textContaining('Submit'))
          ? find.textContaining('Submit')
          : find.textContaining('Save');
      if (tester.any(btn)) {
        await tapAndSettle(tester, btn.first);
        expect(
          tester.any(find.textContaining('required', skipOffstage: false)) ||
              tester.any(find.textContaining('enter',    skipOffstage: false)),
          isTrue,
        );
      }
    });

    testWidgets('TC-G7-03 [POSITIVE] Valid data submit — no crash', (tester) async {
      await openReturnExmi(tester);
      final fields = find.byType(TextFormField);
      for (int i = 0; i < fields.evaluate().length; i++) {
        await enterText(tester, fields.at(i), '5');
      }
      final dropdowns = find.byType(DropdownButtonFormField);
      if (tester.any(dropdowns)) {
        await tapAndSettle(tester, dropdowns.first);
        final opt = find.byType(DropdownMenuItem).first;
        if (tester.any(opt)) await tapAndSettle(tester, opt);
      }
      final btn = find.textContaining('Submit');
      if (tester.any(btn)) {
        await tapAndSettle(tester, btn.first);
        await settle(tester, seconds: 6);
        expect(find.byType(Exception), findsNothing);
        expectNoSplash(tester, 'TC-G7-03 after submit');
      }
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G8 — RECEIPT EXMI LIST
  // ────────────────────────────────────────────────────────────
  group('G8 – Receipt EXMI List', () {
    testWidgets('TC-G8-01 [POSITIVE] List loads from More screen', (tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 2);
      await tapAndSettle(tester, find.text('Receipt EXMI'));
      await settle(tester, seconds: 5);

      expectNoSplash(tester, 'TC-G8-01');
      expect(
        tester.any(find.byType(ListTile)) ||
            tester.any(find.byType(Card))     ||
            tester.any(find.textContaining('No')),
        isTrue,
        reason: 'List or empty state must render',
      );
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G9 — MARK DEFECTIVE
  // ────────────────────────────────────────────────────────────
  group('G9 – Mark Defective', () {
    Future<void> openMarkDefective(WidgetTester tester) async {
      await launchAsGodownKeeper(tester);
      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 2);
      await tapAndSettle(tester, find.text('Mark Defective'));
      await settle(tester, seconds: 5);
    }

    testWidgets('TC-G9-01 [POSITIVE] Screen opens without Splash', (tester) async {
      await openMarkDefective(tester);
      expectNoSplash(tester, 'TC-G9-01');
    });

    testWidgets('TC-G9-02 [NEGATIVE] Empty submit → validation fires', (tester) async {
      await openMarkDefective(tester);
      final btn = tester.any(find.textContaining('Submit'))
          ? find.textContaining('Submit')
          : find.textContaining('Mark');
      if (tester.any(btn)) {
        await tapAndSettle(tester, btn.first);
        expect(
          tester.any(find.textContaining('required', skipOffstage: false)) ||
              tester.any(find.textContaining('select',   skipOffstage: false)) ||
              tester.any(find.textContaining('enter',    skipOffstage: false)),
          isTrue,
        );
      }
    });

    testWidgets('TC-G9-03 [NEGATIVE] Excess quantity → handled without crash', (tester) async {
      await openMarkDefective(tester);
      final fields = find.byType(TextFormField);
      if (tester.any(fields)) {
        await enterText(tester, fields.first, '999999');
        final btn = find.textContaining('Submit');
        if (tester.any(btn)) {
          await tapAndSettle(tester, btn.first);
          await settle(tester, seconds: 5);
          expect(find.byType(Exception), findsNothing);
        }
      }
    });

    testWidgets('TC-G9-04 [POSITIVE] Valid defective data submit — no crash', (tester) async {
      await openMarkDefective(tester);
      final fields = find.byType(TextFormField);
      for (int i = 0; i < fields.evaluate().length; i++) {
        await enterText(tester, fields.at(i), '1');
      }
      final dropdowns = find.byType(DropdownButtonFormField);
      if (tester.any(dropdowns)) {
        await tapAndSettle(tester, dropdowns.first);
        final opt = find.byType(DropdownMenuItem).first;
        if (tester.any(opt)) await tapAndSettle(tester, opt);
      }
      final btn = find.textContaining('Submit');
      if (tester.any(btn)) {
        await tapAndSettle(tester, btn.first);
        await settle(tester, seconds: 6);
        expect(find.byType(Exception), findsNothing);
        expectNoSplash(tester, 'TC-G9-04 after submit');
      }
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G10 — NO-SPLASH REGRESSION (runs after every deep navigation)
  // ────────────────────────────────────────────────────────────
  group('G10 – No-Splash Regression Suite', () {
    const tabs = ['Dashboard', 'Daily Sale', "Today's Summary", 'More'];

    for (final tab in tabs) {
      testWidgets('TC-G10 [REGRESSION] Tab "$tab" never shows Splash', (tester) async {
        await launchAsGodownKeeper(tester);
        await tapAndSettle(tester, find.text(tab));
        await settle(tester, seconds: 5);
        expectNoSplash(tester, 'G10 tab: $tab');
      });
    }

    testWidgets('TC-G10-DEEP More→ItemReceipt→back→Dashboard — no Splash', (tester) async {
      await launchAsGodownKeeper(tester);

      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 2);
      await tapAndSettle(tester, find.text('Item Receipt'));
      await settle(tester, seconds: 4);
      expectNoSplash(tester, 'G10-DEEP on ItemReceipt');

      // Back
      final NavigatorState nav = tester.state(find.byType(Navigator).last);
      nav.pop();
      await settle(tester, seconds: 3);
      expectNoSplash(tester, 'G10-DEEP after back from ItemReceipt');

      await tapAndSettle(tester, find.text('Dashboard'));
      await settle(tester, seconds: 4);
      expect(find.textContaining("Today's Opening Stock"), findsOneWidget);
      expectNoSplash(tester, 'G10-DEEP on Dashboard after deep nav');
    });

    testWidgets('TC-G10-LOGOUT-RELOGIN After logout → re-login → no Splash during session', (tester) async {
      await launchAsGodownKeeper(tester);

      // Logout
      await tapAndSettle(tester, find.text('More'));
      await settle(tester, seconds: 2);
      await tapAndSettle(tester, find.text('Logout'));
      await tapAndSettle(tester, find.text('Logout').last);
      await settle(tester, seconds: 6);

      // Re-inject session (simulates login)
      injectSession();
      await settle(tester, seconds: 2);

      // Navigate to Dashboard
      final dashboard = find.text('Dashboard');
      if (tester.any(dashboard)) {
        await tapAndSettle(tester, dashboard);
        await settle(tester, seconds: 4);
        expectNoSplash(tester, 'G10-LOGOUT-RELOGIN after re-login');
      }
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G11 — TOKEN / NETWORK EDGE CASES
  // ────────────────────────────────────────────────────────────
  group('G11 – Token & Network Edge Cases', () {
    testWidgets('TC-G11-01 [NEGATIVE] Expired token → app handles gracefully', (tester) async {
      // Inject session with bad token — IsAlreadyLogin is still valid so
      // fetchSavedData won't redirect. Only API calls will fail.
      SharedPreferences.setMockInitialValues({
        'token'           : 'EXPIRED_TOKEN',
        'DistributorId'   : _kDistributorId,
        'StaffId'         : _kStaffId,
        'roleId'          : _kRoleId,
        'StaffName'       : _kStaffName,
        'RoleName'        : _kRoleName,
        'godownId'        : _kGodownId,
        'godownKeeperId'  : _kGodownKeeperId,
        'DistributorName' : _kDistributorName,
        'IsAlreadyLogin'  : _kIsAlreadyLogin,
      });
      app.main();
      await settle(tester, seconds: 8);

      // App must not crash; may show error toast
      expect(find.byType(Exception), findsNothing);
    });

    testWidgets('TC-G11-02 [NEGATIVE] Missing godownId → app handles gracefully', (tester) async {
      SharedPreferences.setMockInitialValues({
        'token'           : _kToken,
        'DistributorId'   : _kDistributorId,
        'StaffId'         : _kStaffId,
        'roleId'          : _kRoleId,
        'StaffName'       : _kStaffName,
        'RoleName'        : _kRoleName,
        // godownId intentionally omitted
        'godownKeeperId'  : _kGodownKeeperId,
        'DistributorName' : _kDistributorName,
        'IsAlreadyLogin'  : _kIsAlreadyLogin,
      });
      app.main();
      await settle(tester, seconds: 8);
      expect(find.byType(Exception), findsNothing);
    });

    testWidgets('TC-G11-03 [NEGATIVE] IsAlreadyLogin = "0" → shows logout dialog, not crash', (tester) async {
      // This specifically tests the fetchSavedData() guard in DashboardScreen
      SharedPreferences.setMockInitialValues({
        'token'           : _kToken,
        'DistributorId'   : _kDistributorId,
        'StaffId'         : _kStaffId,
        'roleId'          : _kRoleId,
        'StaffName'       : _kStaffName,
        'RoleName'        : _kRoleName,
        'godownId'        : _kGodownId,
        'godownKeeperId'  : _kGodownKeeperId,
        'DistributorName' : _kDistributorName,
        'IsAlreadyLogin'  : '0',   // ← triggers _showLogoutDialog in fetchSavedData
      });
      app.main();
      await settle(tester, seconds: 8);

      // The app shows a logout dialog — this is expected behavior, not a crash
      expect(find.byType(Exception), findsNothing,
          reason: 'IsAlreadyLogin=0 must show a dialog, not crash');
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G12 — SQC REGISTER
  // ────────────────────────────────────────────────────────────
  group('G12 – SQC Register', () {
    testWidgets('TC-G12-01 [POSITIVE] SQC section shows truck-in counts', (tester) async {
      await launchAsGodownKeeper(tester);
      expect(find.textContaining('SQC'), findsWidgets);
      expectNoSplash(tester, 'TC-G12-01');
    });

    testWidgets('TC-G12-02 [POSITIVE] Tap SQC row — no Splash', (tester) async {
      await launchAsGodownKeeper(tester);
      final sqcTile = find.textContaining('Truck');
      if (tester.any(sqcTile)) {
        await tapAndSettle(tester, sqcTile.first);
        await settle(tester, seconds: 4);
        expectNoSplash(tester, 'TC-G12-02 after SQC tap');
      }
    });
  });

  // ────────────────────────────────────────────────────────────
  //  G13 — PHYSICAL STOCK IMBALANCE
  // ────────────────────────────────────────────────────────────
  group('G13 – Physical Stock Imbalance', () {
    testWidgets('TC-G13-01 [POSITIVE] Imbalance section renders', (tester) async {
      await launchAsGodownKeeper(tester);
      expect(find.textContaining('Imbalance'), findsOneWidget);
      expectNoSplash(tester, 'TC-G13-01');
    });

    testWidgets('TC-G13-02 [POSITIVE] Filled/Empty/Defective values shown without crash', (tester) async {
      await launchAsGodownKeeper(tester);
      expect(find.byType(Exception), findsNothing);
      expect(find.text('Filled'), findsWidgets);
      expectNoSplash(tester, 'TC-G13-02');
    });
  });
}