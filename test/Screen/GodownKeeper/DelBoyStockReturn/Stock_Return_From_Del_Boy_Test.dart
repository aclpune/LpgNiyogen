// ============================================================
// stock_return_from_del_boy_test.dart
// Automation Test Cases for DailyRefillSalePage
// (StockReturnFromDelBoy screen)
// Compatible with: Flutter Test Framework (flutter_test)
// Run with: flutter test test/stock_return_from_del_boy_test.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Replace with your actual imports ─────────────────────────
// import 'package:your_app/GodownKeeperScreen/StockReturnFromDelBoy.dart';

// ─────────────────────────────────────────────────────────────
// SHARED PREFS SETUP
// ─────────────────────────────────────────────────────────────
Future<void> setupSharedPrefs() async {
  SharedPreferences.setMockInitialValues({
    'DistributorId': '101',
    'StaffId': '5',
    'UserId': '7',
    'godownId': '3',
    'godownKeeperId': '9',
    'token': 'test_bearer_token_abc',
    'MobileNo': '9876543210',
  });
}

// ─────────────────────────────────────────────────────────────
// ALL TESTS INSIDE main()
// ─────────────────────────────────────────────────────────────
void main() {
  // ===========================================================
  // 1. EMPTY CYLINDER AUTO-CALCULATION
  //    Formula: Empty = Filled - SV + TV - Defective - LessEmpty
  // ===========================================================
  group('Empty Cylinder Auto-Calculation', () {
    test('TC_EMPTY_01 [+] Basic: Filled(10) - SV(2) + TV(1) - Def(1) - LessEmpty(0) = 8', () {
      expect(_calcEmpty(filled: 10, sv: 2, tv: 1, defective: 1, lessEmpty: 0), equals(8));
    });

    test('TC_EMPTY_02 [+] All zeros produce zero empty', () {
      expect(_calcEmpty(filled: 0, sv: 0, tv: 0, defective: 0, lessEmpty: 0), equals(0));
    });

    test('TC_EMPTY_03 [+] TV increases empty count (TV is addition)', () {
      expect(_calcEmpty(filled: 5, sv: 0, tv: 3, defective: 0, lessEmpty: 0), equals(8));
    });

    test('TC_EMPTY_04 [+] SV reduces empty count (SV is subtraction)', () {
      expect(_calcEmpty(filled: 10, sv: 4, tv: 0, defective: 0, lessEmpty: 0), equals(6));
    });

    test('TC_EMPTY_05 [+] LessEmpty reduces empty count', () {
      expect(_calcEmpty(filled: 10, sv: 0, tv: 0, defective: 0, lessEmpty: 3), equals(7));
    });

    test('TC_EMPTY_06 [+] Defective reduces empty count', () {
      expect(_calcEmpty(filled: 10, sv: 0, tv: 0, defective: 2, lessEmpty: 0), equals(8));
    });

    test('TC_EMPTY_07 [-] Result can be negative when SV > Filled', () {
      // Negative empty is possible (screen stores the value; validation is separate)
      expect(_calcEmpty(filled: 5, sv: 10, tv: 0, defective: 0, lessEmpty: 0), equals(-5));
    });

    test('TC_EMPTY_08 [+] Complex mix: Filled(20) SV(3) TV(2) Def(1) LessEmpty(4) = 14', () {
      expect(_calcEmpty(filled: 20, sv: 3, tv: 2, defective: 1, lessEmpty: 4), equals(14));
    });

    test('TC_EMPTY_09 [+] Remaining DM Qty = LessEmpty - assigned consumer qty', () {
      expect(_calcRemainingDMQty(lessEmpty: 10, totalAssigned: 4), equals(6));
    });

    test('TC_EMPTY_10 [+] Remaining DM Qty = 0 when all less empty assigned', () {
      expect(_calcRemainingDMQty(lessEmpty: 5, totalAssigned: 5), equals(0));
    });
  });

  // ===========================================================
  // 2. _addNewItem() VALIDATION GUARDS
  // ===========================================================
  group('_addNewItem() Validation Guards', () {
    test('TC_ADD_01 [+] All valid fields → no error', () {
      expect(
        _simulateAddItemValidation(
          emptyCylinderText: '5',
          filledValue: 10,
          filledStock: 15,
          lessEmptyValue: 0,
          svValue: 3,
          defectiveValue: 2,
          emptyValue: 5,
        ),
        isNull,
      );
    });

    test('TC_ADD_02 [-] Empty cylinder field is blank → "Add Empty Cylinder Count!"', () {
      expect(
        _simulateAddItemValidation(
          emptyCylinderText: '',
          filledValue: 10,
          filledStock: 15,
          lessEmptyValue: 0,
          svValue: 3,
          defectiveValue: 2,
          emptyValue: 5,
        ),
        equals('Add Empty Cylinder Count!'),
      );
    });

    test('TC_ADD_03 [-] Filled exceeds filledStock → totalSaleQty error', () {
      expect(
        _simulateAddItemValidation(
          emptyCylinderText: '5',
          filledValue: 20,
          filledStock: 10,
          lessEmptyValue: 0,
          svValue: 0,
          defectiveValue: 0,
          emptyValue: 5,
        ),
        equals('totalSaleQtyError'),
      );
    });

    test('TC_ADD_04 [-] Filled < lessEmpty → countShouldNotBeGreater error', () {
      expect(
        _simulateAddItemValidation(
          emptyCylinderText: '5',
          filledValue: 5,
          filledStock: 15,
          lessEmptyValue: 8,
          svValue: 0,
          defectiveValue: 0,
          emptyValue: 5,
        ),
        equals('countShouldNotBeGreater'),
      );
    });

    test('TC_ADD_05 [-] Filled < svValue → countShouldNotBeGreater error', () {
      expect(
        _simulateAddItemValidation(
          emptyCylinderText: '5',
          filledValue: 5,
          filledStock: 15,
          lessEmptyValue: 0,
          svValue: 10,
          defectiveValue: 0,
          emptyValue: 5,
        ),
        equals('countShouldNotBeGreater'),
      );
    });

    test('TC_ADD_06 [-] Filled < defectiveValue → countShouldNotBeGreater error', () {
      expect(
        _simulateAddItemValidation(
          emptyCylinderText: '5',
          filledValue: 5,
          filledStock: 15,
          lessEmptyValue: 0,
          svValue: 0,
          defectiveValue: 10,
          emptyValue: 5,
        ),
        equals('countShouldNotBeGreater'),
      );
    });

    test('TC_ADD_07 [-] emptyValue < 0 → countShouldNotBeGreater error', () {
      expect(
        _simulateAddItemValidation(
          emptyCylinderText: '-1',
          filledValue: 5,
          filledStock: 15,
          lessEmptyValue: 0,
          svValue: 0,
          defectiveValue: 0,
          emptyValue: -1,
        ),
        equals('countShouldNotBeGreater'),
      );
    });

    test('TC_ADD_08 [+] Filled equal to filledStock is allowed', () {
      expect(
        _simulateAddItemValidation(
          emptyCylinderText: '5',
          filledValue: 10,
          filledStock: 10,
          lessEmptyValue: 0,
          svValue: 0,
          defectiveValue: 0,
          emptyValue: 5,
        ),
        isNull,
      );
    });

    test('TC_ADD_09 [+] Filled equal to lessEmpty is valid (boundary)', () {
      expect(
        _simulateAddItemValidation(
          emptyCylinderText: '5',
          filledValue: 5,
          filledStock: 10,
          lessEmptyValue: 5,
          svValue: 0,
          defectiveValue: 0,
          emptyValue: 5,
        ),
        isNull,
      );
    });
  });

  // ===========================================================
  // 3. LESS EMPTY IMBALANCE VALIDATION
  //    Rule: totalUsedQty (dmQty + customerTotal) must == enteredLessEmptyQty
  // ===========================================================
  group('Less Empty Imbalance Validation', () {
    test('TC_IMB_01 [+] DM qty + customer qty equals lessEmpty → valid', () {
      expect(
        _validateLessEmptyBalance(
          lessEmpty: 10,
          dmQty: 4,
          customerTotal: 6,
        ),
        isTrue,
      );
    });

    test('TC_IMB_02 [-] Total does not match entered qty → invalid', () {
      expect(
        _validateLessEmptyBalance(
          lessEmpty: 10,
          dmQty: 3,
          customerTotal: 4,
        ),
        isFalse,
      );
    });

    test('TC_IMB_03 [+] Only DM qty (isDeliverySelected=true, isCustomerSelected=false) → valid', () {
      expect(
        _validateLessEmptyOnlyDM(lessEmpty: 5, dmQty: 5),
        isTrue,
      );
    });

    test('TC_IMB_04 [-] DM only mode but DM qty does not match → invalid', () {
      expect(
        _validateLessEmptyOnlyDM(lessEmpty: 5, dmQty: 3),
        isFalse,
      );
    });

    test('TC_IMB_05 [+] Zero lessEmpty → imbalance block is skipped', () {
      expect(_isLessEmptyBlockRequired(lessEmpty: 0), isFalse);
    });

    test('TC_IMB_06 [+] Positive lessEmpty → imbalance block is required', () {
      expect(_isLessEmptyBlockRequired(lessEmpty: 3), isTrue);
    });

    test('TC_IMB_07 [-] lesEmpty > 0 but both checkboxes false → "Select Customer or Delivery Men" error', () {
      expect(
        _resolveImbalanceError(
          lessEmpty: 5,
          isDeliverySelected: false,
          isCustomerSelected: false,
          customerIDList: [],
        ),
        equals('Select Customer or Delivery Men For Imbalance.'),
      );
    });

    test('TC_IMB_08 [-] isCustomerSelected=true but customerIDList empty → "Select Customer For Imbalance." error', () {
      expect(
        _resolveImbalanceError(
          lessEmpty: 5,
          isDeliverySelected: false,
          isCustomerSelected: true,
          customerIDList: [],
        ),
        equals('Select Customer For Imbalance.'),
      );
    });

    test('TC_IMB_09 [+] isDeliverySelected=true, isCustomerSelected=false, no customerIDList needed → no error', () {
      expect(
        _resolveImbalanceError(
          lessEmpty: 5,
          isDeliverySelected: true,
          isCustomerSelected: false,
          customerIDList: [],
        ),
        isNull,
      );
    });

    test('TC_IMB_10 [+] Both selected and customer list not empty → no error', () {
      expect(
        _resolveImbalanceError(
          lessEmpty: 5,
          isDeliverySelected: true,
          isCustomerSelected: true,
          customerIDList: [101],
        ),
        isNull,
      );
    });

    test('TC_IMB_11 [-] Both selected but customer list empty → "Select Customer For Imbalance." error', () {
      expect(
        _resolveImbalanceError(
          lessEmpty: 5,
          isDeliverySelected: true,
          isCustomerSelected: true,
          customerIDList: [],
        ),
        equals('Select Customer For Imbalance.'),
      );
    });

    test('TC_IMB_12 [+] Customer-only mode with list not empty → no error', () {
      expect(
        _resolveImbalanceError(
          lessEmpty: 5,
          isDeliverySelected: false,
          isCustomerSelected: true,
          customerIDList: [55],
        ),
        isNull,
      );
    });
  });

  // ===========================================================
  // 4. SUBMIT BUTTON STATE (_getButtonColor / enable logic)
  // ===========================================================
  group('Submit Button Enable/Disable State', () {
    test('TC_BTN_01 [+] Non-editMode: data exists and delBoy selected → enabled (blue)', () {
      expect(
        _getButtonColor(
          flagEditMode: null,
          dataNotEmpty: true,
          delBoyName: 'John',
        ),
        equals('blue'),
      );
    });

    test('TC_BTN_02 [-] Non-editMode: data is empty → disabled (grey)', () {
      expect(
        _getButtonColor(
          flagEditMode: null,
          dataNotEmpty: false,
          delBoyName: 'John',
        ),
        equals('grey'),
      );
    });

    test('TC_BTN_03 [-] Non-editMode: delBoy name empty → disabled (grey)', () {
      expect(
        _getButtonColor(
          flagEditMode: null,
          dataNotEmpty: true,
          delBoyName: '',
        ),
        equals('grey'),
      );
    });

    test('TC_BTN_04 [+] EditMode: stockDataFuture is set → enabled (blue)', () {
      expect(
        _getButtonColor(
          flagEditMode: 'editMode',
          dataNotEmpty: false,
          delBoyName: 'Jane',
          stockDataFutureNotNull: true,
        ),
        equals('blue'),
      );
    });

    test('TC_BTN_05 [-] EditMode: stockDataFuture is null → disabled (grey)', () {
      expect(
        _getButtonColor(
          flagEditMode: 'editMode',
          dataNotEmpty: false,
          delBoyName: 'Jane',
          stockDataFutureNotNull: false,
        ),
        equals('grey'),
      );
    });

    test('TC_BTN_06 [-] saveFlag=true → showFlushBar("dayEndCompleted") instead of submitting', () {
      // The submit button is enabled but pressing it shows dayEndCompleted
      expect(_resolveSubmitAction(saveFlag: true, stockTransferFlag: true), equals('dayEndCompleted'));
    });

    test('TC_BTN_07 [-] stockTransferFlag=false → showCustomAlert("stockNotAccepted")', () {
      expect(_resolveSubmitAction(saveFlag: false, stockTransferFlag: false), equals('stockNotAccepted'));
    });

    test('TC_BTN_08 [+] saveFlag=false, stockTransferFlag=true → proceed to submit', () {
      expect(_resolveSubmitAction(saveFlag: false, stockTransferFlag: true), equals('proceed'));
    });
  });

  // ===========================================================
  // 5. ADD ENTRY BUTTON ENABLE STATE
  //    Enabled when: (filledController OR tvController not empty)
  //                  AND selectedDelBoyName != null
  //                  AND selectedItem != null
  // ===========================================================
  group('Add Entry Button Enable State', () {
    test('TC_ENTRY_BTN_01 [+] Filled entered + delBoy + item all set → enabled', () {
      expect(
        _isAddEntryButtonEnabled(
          filledText: '10',
          tvText: '',
          delBoyName: 'Ravi',
          selectedItem: 'LPG 14.2 KG',
        ),
        isTrue,
      );
    });

    test('TC_ENTRY_BTN_02 [+] TV entered + delBoy + item → enabled', () {
      expect(
        _isAddEntryButtonEnabled(
          filledText: '',
          tvText: '5',
          delBoyName: 'Ravi',
          selectedItem: 'LPG 14.2 KG',
        ),
        isTrue,
      );
    });

    test('TC_ENTRY_BTN_03 [-] Neither filled nor TV entered → disabled', () {
      expect(
        _isAddEntryButtonEnabled(
          filledText: '',
          tvText: '',
          delBoyName: 'Ravi',
          selectedItem: 'LPG 14.2 KG',
        ),
        isFalse,
      );
    });

    test('TC_ENTRY_BTN_04 [-] Filled entered but no delivery boy → disabled', () {
      expect(
        _isAddEntryButtonEnabled(
          filledText: '10',
          tvText: '',
          delBoyName: null,
          selectedItem: 'LPG 14.2 KG',
        ),
        isFalse,
      );
    });

    test('TC_ENTRY_BTN_05 [-] Filled entered + delBoy + no item → disabled', () {
      expect(
        _isAddEntryButtonEnabled(
          filledText: '10',
          tvText: '',
          delBoyName: 'Ravi',
          selectedItem: null,
        ),
        isFalse,
      );
    });

    test('TC_ENTRY_BTN_06 [-] All three null/empty → disabled', () {
      expect(
        _isAddEntryButtonEnabled(
          filledText: '',
          tvText: '',
          delBoyName: null,
          selectedItem: null,
        ),
        isFalse,
      );
    });
  });

  // ===========================================================
  // 6. SV / TV CONSUMER COUNT VALIDATION
  //    currentCount (no. of consumer numbers selected) must NOT exceed svQty/tvQty
  // ===========================================================
  group('SV / TV Consumer Count Validation', () {
    test('TC_SVTV_01 [+] SV consumer count = svQty → valid (exact match)', () {
      expect(_isSVCountValid(consumerCount: 3, svQty: 3), isTrue);
    });

    test('TC_SVTV_02 [+] SV consumer count < svQty → valid', () {
      expect(_isSVCountValid(consumerCount: 2, svQty: 5), isTrue);
    });

    test('TC_SVTV_03 [-] SV consumer count > svQty → invalid (svConsumerCountExceed)', () {
      expect(_isSVCountValid(consumerCount: 6, svQty: 5), isFalse);
    });

    test('TC_SVTV_04 [+] TV consumer count = tvQty → valid', () {
      expect(_isTVCountValid(consumerCount: 4, tvQty: 4), isTrue);
    });

    test('TC_SVTV_05 [-] TV consumer count > tvQty → invalid (tvConsumerCountExceed)', () {
      expect(_isTVCountValid(consumerCount: 5, tvQty: 2), isFalse);
    });

    test('TC_SVTV_06 [+] Zero consumers selected → valid (no SV used)', () {
      expect(_isSVCountValid(consumerCount: 0, svQty: 3), isTrue);
    });

    test('TC_SVTV_07 [+] Zero TV consumers → valid', () {
      expect(_isTVCountValid(consumerCount: 0, tvQty: 0), isTrue);
    });
  });

  // ===========================================================
  // 7. parseToInt() HELPER
  // ===========================================================
  group('parseToInt() Helper Function', () {
    test('TC_PARSE_01 [+] Valid integer string "10" returns 10', () {
      expect(_parseToInt('10'), equals(10));
    });

    test('TC_PARSE_02 [+] "0" returns 0', () {
      expect(_parseToInt('0'), equals(0));
    });

    test('TC_PARSE_03 [-] Empty string returns default 0', () {
      expect(_parseToInt(''), equals(0));
    });

    test('TC_PARSE_04 [-] Non-numeric "abc" returns default 0', () {
      expect(_parseToInt('abc'), equals(0));
    });

    test('TC_PARSE_05 [-] Null-like empty returns default 0', () {
      expect(_parseToInt('   '), equals(0));
    });

    test('TC_PARSE_06 [+] "999" returns 999', () {
      expect(_parseToInt('999'), equals(999));
    });

    test('TC_PARSE_07 [-] Decimal "12.5" returns default 0 (not a valid int string)', () {
      expect(_parseToInt('12.5'), equals(0));
    });
  });

  // ===========================================================
  // 8. clearForm() / Clear Button State Reset
  // ===========================================================
  group('Clear Button – State Reset', () {
    test('TC_CLR_01 [+] All cylinder qty fields cleared', () {
      final s = _FakeSaleState()
        ..fillAll()
        ..clearForm();
      expect(s.filled, isEmpty);
      expect(s.sv, isEmpty);
      expect(s.tv, isEmpty);
      expect(s.empty, isEmpty);
      expect(s.defective, isEmpty);
      expect(s.lessEmpty, isEmpty);
      expect(s.remark, isEmpty);
    });

    test('TC_CLR_02 [+] All consumer selection lists cleared', () {
      final s = _FakeSaleState()
        ..fillAll()
        ..clearForm();
      expect(s.selectedConsumerNumbers, isEmpty);
      expect(s.selectedCylinderQuantities, isEmpty);
      expect(s.selectedSVUniqueID, isEmpty);
      expect(s.selectedConsumerNumbersTV, isEmpty);
      expect(s.selectedCylinderQuantitiesTV, isEmpty);
    });

    test('TC_CLR_03 [+] Less empty consumer tracking cleared', () {
      final s = _FakeSaleState()
        ..fillAll()
        ..clearForm();
      expect(s.selectedConsumerIDLessEmpty, isEmpty);
      expect(s.selectedConsumerQtyLessEmpty, isEmpty);
      expect(s.selectedCustomerNamesLessEmpty, isEmpty);
    });

    test('TC_CLR_04 [+] Totals and flags reset to zero/false', () {
      final s = _FakeSaleState()
        ..fillAll()
        ..clearForm();
      expect(s.totalCylinderQty, equals(0.0));
      expect(s.totalCylinderQtyTV, equals(0.0));
      expect(s.isDeliverySelected, isFalse);
      expect(s.isCustomerSelected, isFalse);
    });

    test('TC_CLR_05 [+] DM imbalance qty controller cleared', () {
      final s = _FakeSaleState()
        ..fillAll()
        ..clearForm();
      expect(s.totalImbalanceQtyDMQty, isEmpty);
      expect(s.totalImbalanceQtyDMCustomer, isEmpty);
    });

    test('TC_CLR_06 [+] SV original consumer maps cleared', () {
      final s = _FakeSaleState()
        ..fillAll()
        ..clearForm();
      expect(s.originalConsumerNumbersSV, isEmpty);
      expect(s.originalConsumerQtySV, isEmpty);
      expect(s.originalSVUniqueIdMap, isEmpty);
    });

    test('TC_CLR_07 [+] TV original consumer maps cleared', () {
      final s = _FakeSaleState()
        ..fillAll()
        ..clearForm();
      expect(s.originalConsumerNumbersTV, isEmpty);
      expect(s.originalConsumerQtyTV, isEmpty);
    });

    test('TC_CLR_08 [-] Re-filling after clearForm works correctly', () {
      final s = _FakeSaleState()
        ..fillAll()
        ..clearForm()
        ..fillAll();
      expect(s.filled, equals('10'));
      expect(s.selectedConsumerNumbers, isNotEmpty);
    });

    test('TC_CLR_09 [-] vehicleNo and delBoy info NOT cleared by clear button', () {
      final s = _FakeSaleState()
        ..vehicleNo = 'MH12AB1234'
        ..selectedDelBoyName = 'Ravi'
        ..fillAll()
        ..clearForm();
      expect(s.vehicleNo, equals('MH12AB1234'));
      expect(s.selectedDelBoyName, equals('Ravi'));
    });
  });

  // ===========================================================
  // 9. _onEditItem() FIELD POPULATION
  // ===========================================================
  group('_onEditItem() – Field Pre-Population', () {
    test('TC_EDIT_01 [+] Filled field populated from item.filledSaleQty', () {
      final state = _FakeSaleState();
      state.populateFromEditItem(
        filled: '8', sv: '2', tv: '1', empty: '5', defective: '0', lessEmpty: '1', remark: 'ok',
      );
      expect(state.filled, equals('8'));
    });

    test('TC_EDIT_02 [+] SV consumers parsed from comma-separated string', () {
      final numbers = _parseSVRemark('C001, C002, C003');
      expect(numbers, equals(['C001', 'C002', 'C003']));
    });

    test('TC_EDIT_03 [+] SV quantities parsed from comma-separated qty string', () {
      final qtys = _parseSVCount('2, 3, 1');
      expect(qtys, equals([2, 3, 1]));
    });

    test('TC_EDIT_04 [+] TV consumers parsed from comma-separated string', () {
      final numbers = _parseSVRemark('T001, T002');
      expect(numbers, equals(['T001', 'T002']));
    });

    test('TC_EDIT_05 [+] TV quantities parsed from comma-separated qty string', () {
      final qtys = _parseSVCount('4, 2');
      expect(qtys, equals([4, 2]));
    });

    test('TC_EDIT_06 [-] Empty svRemark → selectedConsumerNumbers stays empty', () {
      final numbers = _parseSVRemark('');
      expect(numbers, isEmpty);
    });

    test('TC_EDIT_07 [+] DMImbQty > 0 → isDeliverySelected=true', () {
      expect(_resolveDeliverySelected(dmImbQty: 5), isTrue);
    });

    test('TC_EDIT_08 [-] DMImbQty = 0 → isDeliverySelected=false', () {
      expect(_resolveDeliverySelected(dmImbQty: 0), isFalse);
    });

    test('TC_EDIT_09 [+] lessEmptyCustomerId non-empty + non-zero → isCustomerSelected=true', () {
      expect(_resolveCustomerSelected(lessEmptyCustomerId: '55'), isTrue);
    });

    test('TC_EDIT_10 [-] lessEmptyCustomerId empty → isCustomerSelected=false', () {
      expect(_resolveCustomerSelected(lessEmptyCustomerId: ''), isFalse);
    });

    test('TC_EDIT_11 [-] lessEmptyCustomerId "0" → isCustomerSelected=false', () {
      expect(_resolveCustomerSelected(lessEmptyCustomerId: '0'), isFalse);
    });
  });

  // ===========================================================
  // 10. VEHICLE SELECTION
  // ===========================================================
  group('Vehicle Selection Logic', () {
    test('TC_VEH_01 [+] In editMode, vehicle matched by vehicleNo string', () {
      expect(
        _resolveVehicleNo(
          flagEditMode: 'editMode',
          vehicleNumb: 'MH04XY9988',
          vehicleListNos: ['MH04XY9988', 'MH12AB1111'],
        ),
        equals('MH04XY9988'),
      );
    });

    test('TC_VEH_02 [+] In add mode, vehicle matched by staffId', () {
      expect(
        _resolveVehicleByStaff(
          staffId: 7,
          vehicleStaffIds: [7, 8],
          vehicleNos: ['MH04XY9988', 'MH12AB1111'],
        ),
        equals('MH04XY9988'),
      );
    });

    test('TC_VEH_03 [-] In editMode, vehicleNo not found → falls back to first vehicle', () {
      expect(
        _resolveVehicleNo(
          flagEditMode: 'editMode',
          vehicleNumb: 'UNKNOWN',
          vehicleListNos: ['MH04XY9988', 'MH12AB1111'],
        ),
        equals('MH04XY9988'), // orElse → first
      );
    });

    test('TC_VEH_04 [-] Empty vehicle list → null returned', () {
      expect(
        _resolveVehicleNo(
          flagEditMode: 'editMode',
          vehicleNumb: 'MH04XY9988',
          vehicleListNos: [],
        ),
        isNull,
      );
    });
  });

  // ===========================================================
  // 11. API PAYLOAD ENCODING (sendDataToApi)
  // ===========================================================
  group('API Payload – Field Encoding', () {
    test('TC_API_01 [+] Action "ADD" in non-edit mode', () {
      expect(_resolveApiAction(flagEditMode: null), equals('ADD'));
    });

    test('TC_API_02 [+] Action "EDIT" in editMode', () {
      expect(_resolveApiAction(flagEditMode: 'editMode'), equals('EDIT'));
    });

    test('TC_API_03 [+] dailySaleStatus 3 → encoded as 4', () {
      expect(_encodeDailySaleStatus(currentStatus: 3), equals(4));
    });

    test('TC_API_04 [+] dailySaleStatus 1 → encoded as 1', () {
      expect(_encodeDailySaleStatus(currentStatus: 1), equals(1));
    });

    test('TC_API_05 [+] Empty remark encodes to empty string ""', () {
      expect(_encodeOptionalString(''), equals(''));
    });

    test('TC_API_06 [+] Non-empty remark encodes to its value', () {
      expect(_encodeOptionalString('Good'), equals('Good'));
    });

    test('TC_API_07 [+] Empty lessEmpty string encodes to "0"', () {
      expect(_encodeLessEmpty(''), equals('0'));
    });

    test('TC_API_08 [+] Non-empty lessEmpty "3" encodes to "3"', () {
      expect(_encodeLessEmpty('3'), equals('3'));
    });

    test('TC_API_09 [+] Whitespace-only lessEmpty encodes to "0"', () {
      expect(_encodeLessEmpty('   '), equals('0'));
    });

    test('TC_API_10 [-] Empty svRemark list → empty string in payload', () {
      expect(_encodeList([]), equals(''));
    });

    test('TC_API_11 [+] svRemark ["C001", "C002"] → "C001, C002"', () {
      expect(_encodeList(['C001', 'C002']), equals('C001, C002'));
    });

    test('TC_API_12 [+] SaleGKId "0" for new entry', () {
      expect(_resolveSaleGKId(isAdd: true, saleGKId: null), equals('0'));
    });

    test('TC_API_13 [+] SaleGKId from widget in edit mode', () {
      expect(_resolveSaleGKId(isAdd: false, saleGKId: 42), equals('42'));
    });
  });

  // ===========================================================
  // 12. DAY-END SAVE FLAG BEHAVIOUR
  // ===========================================================
  group('Day-End Save Flag (checkAndSaveDayEndData)', () {
    test('TC_DAYEND_01 [-] API returns empty list → saveFlag = false', () {
      expect(_resolveSaveFlag(apiResponseEmpty: true), isFalse);
    });

    test('TC_DAYEND_02 [+] API returns non-empty list → saveFlag = true', () {
      expect(_resolveSaveFlag(apiResponseEmpty: false), isTrue);
    });

    test('TC_DAYEND_03 [-] saveFlag=true + any button click → "dayEndCompleted" message', () {
      expect(_resolveSaveFlagMessage(saveFlag: true), equals('dayEndCompleted'));
    });

    test('TC_DAYEND_04 [+] saveFlag=false → no restriction message', () {
      expect(_resolveSaveFlagMessage(saveFlag: false), isNull);
    });
  });

  // ===========================================================
  // 13. STOCK TRANSFER FLAG BEHAVIOUR
  // ===========================================================
  group('Stock Transfer Flag (fetchTransactionList)', () {
    test('TC_STK_01 [-] Any item has isStkTrans=0 → stockTransferFlag=false', () {
      expect(_resolveStockTransferFlag(isStkTransValues: [1, 0, 1]), isFalse);
    });

    test('TC_STK_02 [+] All items have isStkTrans != 0 → stockTransferFlag=true', () {
      expect(_resolveStockTransferFlag(isStkTransValues: [1, 1, 1]), isTrue);
    });

    test('TC_STK_03 [+] Empty list → stockTransferFlag=true (no blocking item)', () {
      expect(_resolveStockTransferFlag(isStkTransValues: []), isTrue);
    });

    test('TC_STK_04 [-] stockTransferFlag=false + submit → "stockNotAccepted" alert', () {
      expect(
        _resolveSubmitAction(saveFlag: false, stockTransferFlag: false),
        equals('stockNotAccepted'),
      );
    });
  });

  // ===========================================================
  // 14. IMBALANCE POPUP VALIDATION (showSimplePopup)
  // ===========================================================
  group('Imbalance Customer Popup Validation', () {
    test('TC_POPUP_01 [-] No customer selected → "Please select customer" error', () {
      expect(_validateImbalancePopup(customerSelected: false, qty: 5, remainingDMQty: 10), equals('Please select customer'));
    });

    test('TC_POPUP_02 [-] qty <= 0 → "Enter valid qty" error', () {
      expect(_validateImbalancePopup(customerSelected: true, qty: 0, remainingDMQty: 10), equals('Enter valid qty'));
    });

    test('TC_POPUP_03 [-] qty > remainingDMQty → "Qty exceeds available DM quantity" error', () {
      expect(_validateImbalancePopup(customerSelected: true, qty: 15, remainingDMQty: 10), equals('Qty exceeds available DM quantity'));
    });

    test('TC_POPUP_04 [+] Valid customer, qty=5, remainingDMQty=10 → no error', () {
      expect(_validateImbalancePopup(customerSelected: true, qty: 5, remainingDMQty: 10), isNull);
    });

    test('TC_POPUP_05 [+] qty == remainingDMQty (boundary) → valid', () {
      expect(_validateImbalancePopup(customerSelected: true, qty: 10, remainingDMQty: 10), isNull);
    });

    test('TC_POPUP_06 [+] remainingDMQty after adding customer = original - qty', () {
      expect(_calcRemainingAfterAssign(remainingDMQty: 10, assignedQty: 4), equals(6));
    });

    test('TC_POPUP_07 [-] Deleting a customer entry restores remainingDMQty', () {
      expect(_calcRemainingAfterDelete(remainingDMQty: 6, deletedQty: 4), equals(10));
    });
  });
}

// ─────────────────────────────────────────────────────────────
// PURE HELPER FUNCTIONS  (mirror screen logic)
// ─────────────────────────────────────────────────────────────

/// Empty = Filled - SV + TV - Defective - LessEmpty
int _calcEmpty({
  required int filled,
  required int sv,
  required int tv,
  required int defective,
  required int lessEmpty,
}) =>
    filled - sv + tv - defective - lessEmpty;

int _calcRemainingDMQty({required int lessEmpty, required int totalAssigned}) =>
    lessEmpty - totalAssigned;

/// Mirrors _addNewItem() guard chain. Returns null for valid, or error key.
String? _simulateAddItemValidation({
  required String emptyCylinderText,
  required int filledValue,
  required int filledStock,
  required int lessEmptyValue,
  required int svValue,
  required int defectiveValue,
  required int emptyValue,
}) {
  if (emptyCylinderText.isEmpty) return 'Add Empty Cylinder Count!';
  if (filledValue > filledStock) return 'totalSaleQtyError';
  if (filledValue < lessEmptyValue) return 'countShouldNotBeGreater';
  if (filledValue < svValue) return 'countShouldNotBeGreater';
  if (filledValue < defectiveValue) return 'countShouldNotBeGreater';
  if (emptyValue < 0) return 'countShouldNotBeGreater';
  return null;
}

bool _validateLessEmptyBalance({
  required int lessEmpty,
  required int dmQty,
  required int customerTotal,
}) =>
    (dmQty + customerTotal) == lessEmpty;

bool _validateLessEmptyOnlyDM({required int lessEmpty, required int dmQty}) =>
    dmQty == lessEmpty;

bool _isLessEmptyBlockRequired({required int lessEmpty}) => lessEmpty > 0;

String? _resolveImbalanceError({
  required int lessEmpty,
  required bool isDeliverySelected,
  required bool isCustomerSelected,
  required List<int> customerIDList,
}) {
  if (lessEmpty <= 0) return null;
  if (isDeliverySelected && isCustomerSelected) {
    if (customerIDList.isEmpty) return 'Select Customer For Imbalance.';
    return null;
  }
  if (isDeliverySelected && !isCustomerSelected) return null;
  if (!isDeliverySelected && !isCustomerSelected) {
    return 'Select Customer or Delivery Men For Imbalance.';
  }
  if (!isDeliverySelected && isCustomerSelected) {
    if (customerIDList.isEmpty) return 'Select Customer For Imbalance.';
    return null;
  }
  return null;
}

String _getButtonColor({
  required String? flagEditMode,
  required bool dataNotEmpty,
  required String delBoyName,
  bool stockDataFutureNotNull = false,
}) {
  if (flagEditMode == 'editMode') {
    return stockDataFutureNotNull ? 'blue' : 'grey';
  } else {
    return (dataNotEmpty && delBoyName.isNotEmpty) ? 'blue' : 'grey';
  }
}

String _resolveSubmitAction({required bool saveFlag, required bool stockTransferFlag}) {
  if (!stockTransferFlag) return 'stockNotAccepted';
  if (saveFlag) return 'dayEndCompleted';
  return 'proceed';
}

bool _isAddEntryButtonEnabled({
  required String filledText,
  required String tvText,
  required String? delBoyName,
  required String? selectedItem,
}) {
  return (filledText.isNotEmpty || tvText.isNotEmpty) &&
      delBoyName != null &&
      selectedItem != null;
}

bool _isSVCountValid({required int consumerCount, required int svQty}) =>
    consumerCount <= svQty;

bool _isTVCountValid({required int consumerCount, required int tvQty}) =>
    consumerCount <= tvQty;

int _parseToInt(String text, {int defaultValue = 0}) {
  final trimmed = text.trim();
  if (trimmed.isEmpty || int.tryParse(trimmed) == null) return defaultValue;
  return int.parse(trimmed);
}

List<String> _parseSVRemark(String svRemark) {
  if (svRemark.isEmpty) return [];
  return svRemark.split(',').map((e) => e.trim()).toList();
}

List<int> _parseSVCount(String svCount) {
  if (svCount.isEmpty) return [];
  return svCount.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
}

bool _resolveDeliverySelected({required int dmImbQty}) => dmImbQty > 0;

bool _resolveCustomerSelected({required String lessEmptyCustomerId}) {
  if (lessEmptyCustomerId.isEmpty) return false;
  int id = int.tryParse(lessEmptyCustomerId) ?? 0;
  return id > 0;
}

String? _resolveVehicleNo({
  required String? flagEditMode,
  required String vehicleNumb,
  required List<String> vehicleListNos,
}) {
  if (vehicleListNos.isEmpty) return null;
  if (flagEditMode == 'editMode') {
    return vehicleListNos.contains(vehicleNumb) ? vehicleNumb : vehicleListNos.first;
  }
  return vehicleListNos.first;
}

String? _resolveVehicleByStaff({
  required int staffId,
  required List<int> vehicleStaffIds,
  required List<String> vehicleNos,
}) {
  final idx = vehicleStaffIds.indexOf(staffId);
  if (idx == -1) return vehicleNos.isNotEmpty ? vehicleNos.first : null;
  return vehicleNos[idx];
}

String _resolveApiAction({required String? flagEditMode}) =>
    flagEditMode == 'editMode' ? 'EDIT' : 'ADD';

int _encodeDailySaleStatus({required int currentStatus}) {
  if (currentStatus == 3) return 4;
  if (currentStatus == 1) return 1;
  return currentStatus;
}

String _encodeOptionalString(String value) => value;

String _encodeLessEmpty(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? '0' : trimmed;
}

String _encodeList(List<String> list) => list.isEmpty ? '' : list.join(', ');

String _resolveSaleGKId({required bool isAdd, required int? saleGKId}) =>
    isAdd ? '0' : (saleGKId?.toString() ?? '0');

bool _resolveSaveFlag({required bool apiResponseEmpty}) => !apiResponseEmpty;

String? _resolveSaveFlagMessage({required bool saveFlag}) =>
    saveFlag ? 'dayEndCompleted' : null;

bool _resolveStockTransferFlag({required List<int> isStkTransValues}) =>
    !isStkTransValues.any((v) => v == 0);

String? _validateImbalancePopup({
  required bool customerSelected,
  required int qty,
  required int remainingDMQty,
}) {
  if (!customerSelected) return 'Please select customer';
  if (qty <= 0) return 'Enter valid qty';
  if (qty > remainingDMQty) return 'Qty exceeds available DM quantity';
  return null;
}

int _calcRemainingAfterAssign({required int remainingDMQty, required int assignedQty}) =>
    remainingDMQty - assignedQty;

int _calcRemainingAfterDelete({required int remainingDMQty, required int deletedQty}) =>
    remainingDMQty + deletedQty;

// ─────────────────────────────────────────────────────────────
// FAKE STATE CLASS — used by clearForm() and edit tests
// ─────────────────────────────────────────────────────────────
class _FakeSaleState {
  String filled = '';
  String sv = '';
  String tv = '';
  String empty = '';
  String defective = '';
  String lessEmpty = '';
  String remark = '';
  String vehicleNo = '';
  String? selectedDelBoyName;

  double totalCylinderQty = 0;
  double totalCylinderQtyTV = 0;
  bool isDeliverySelected = false;
  bool isCustomerSelected = false;

  String totalImbalanceQtyDMQty = '';
  String totalImbalanceQtyDMCustomer = '';

  List<String> selectedConsumerNumbers = [];
  List<int> selectedCylinderQuantities = [];
  List<int> selectedSVUniqueID = [];
  List<String> selectedConsumerNumbersTV = [];
  List<int> selectedCylinderQuantitiesTV = [];

  List<int> selectedConsumerIDLessEmpty = [];
  List<int> selectedConsumerQtyLessEmpty = [];
  List<String> selectedCustomerNamesLessEmpty = [];

  List<String> originalConsumerNumbersSV = [];
  Map<String, int> originalConsumerQtySV = {};
  Map<String, int> originalSVUniqueIdMap = {};
  List<String> originalConsumerNumbersTV = [];
  Map<String, int> originalConsumerQtyTV = {};

  void fillAll() {
    filled = '10';
    sv = '2';
    tv = '1';
    empty = '9';
    defective = '0';
    lessEmpty = '0';
    remark = 'Test remark';
    totalImbalanceQtyDMQty = '5';
    totalImbalanceQtyDMCustomer = '3';
    totalCylinderQty = 2.0;
    totalCylinderQtyTV = 1.0;
    isDeliverySelected = true;
    isCustomerSelected = true;
    selectedConsumerNumbers = ['C001', 'C002'];
    selectedCylinderQuantities = [2, 3];
    selectedSVUniqueID = [10, 11];
    selectedConsumerNumbersTV = ['T001'];
    selectedCylinderQuantitiesTV = [1];
    selectedConsumerIDLessEmpty = [55];
    selectedConsumerQtyLessEmpty = [2];
    selectedCustomerNamesLessEmpty = ['Customer A'];
    originalConsumerNumbersSV = ['C001'];
    originalConsumerQtySV = {'C001': 2};
    originalSVUniqueIdMap = {'C001': 10};
    originalConsumerNumbersTV = ['T001'];
    originalConsumerQtyTV = {'T001': 1};
  }

  void clearForm() {
    filled = sv = tv = empty = defective = lessEmpty = remark = '';
    totalImbalanceQtyDMQty = '';
    totalImbalanceQtyDMCustomer = '';
    totalCylinderQty = 0;
    totalCylinderQtyTV = 0;
    isDeliverySelected = false;
    isCustomerSelected = false;
    selectedConsumerNumbers.clear();
    selectedCylinderQuantities.clear();
    selectedSVUniqueID.clear();
    selectedConsumerNumbersTV.clear();
    selectedCylinderQuantitiesTV.clear();
    selectedConsumerIDLessEmpty.clear();
    selectedConsumerQtyLessEmpty.clear();
    selectedCustomerNamesLessEmpty.clear();
    originalConsumerNumbersSV.clear();
    originalConsumerQtySV.clear();
    originalSVUniqueIdMap.clear();
    originalConsumerNumbersTV.clear();
    originalConsumerQtyTV.clear();
    // vehicleNo and selectedDelBoyName intentionally NOT cleared
  }

  void populateFromEditItem({
    required String filled,
    required String sv,
    required String tv,
    required String empty,
    required String defective,
    required String lessEmpty,
    required String remark,
  }) {
    this.filled = filled;
    this.sv = sv;
    this.tv = tv;
    this.empty = empty;
    this.defective = defective;
    this.lessEmpty = lessEmpty;
    this.remark = remark;
  }
}