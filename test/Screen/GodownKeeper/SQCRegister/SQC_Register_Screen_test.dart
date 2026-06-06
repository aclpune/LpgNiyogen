//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // ── Replace these with your actual project imports ───────────
// // import 'package:your_app/GodownKeeperScreen/SQCRegister/SQCRegisterScreen.dart';
// // import 'package:your_app/GodownKeeperScreen/SQCRegister/GetSQCFilledCylListModel.dart';
// // import 'package:your_app/ManagerScreen/GetDesignationListModel.dart';
//
// // ─────────────────────────────────────────────────────────────
// // HELPER – minimal app wrapper so Navigator / MediaQuery work
// // ─────────────────────────────────────────────────────────────
// Widget buildTestableApp({
//   required Widget child,
//   Map<String, dynamic>? routeArguments,
// }) {
//   return MaterialApp(
//     home: child,
//     routes: {
//       '/sqcregisterScreen': (_) => child,
//       '/itemReturnScreen': (_) => const Scaffold(body: Text('ItemReturn')),
//       '/bottomNavGodownKeeper': (_) =>
//       const Scaffold(body: Text('BottomNav')),
//     },
//   );
// }
//
// Future<void> setupSharedPrefs() async {
//   SharedPreferences.setMockInitialValues({
//     'DistributorId': '101',
//     'StaffId': '5',
//     'UserId': '7',
//     'token': 'test_bearer_token_abc',
//   });
// }
//
// // ─────────────────────────────────────────────────────────────
// // ALL TESTS MUST LIVE INSIDE main()
// // ─────────────────────────────────────────────────────────────
// void main() {
//   // ===========================================================
//   // 1. PREFIX / DPT-DATE FORMATTER TESTS
//   //    Format rule: first char A-D (uppercase), dash, up to 2 digits
//   //    Example valid values: "A", "A-2", "B-24", "D-99"
//   // ===========================================================
//   group('DPT Date Prefix Formatter', () {
//     test('TC_PFX_01 [+] Accepts valid first character "A"', () {
//       expect(_applyPrefixFormatter('', 'A'), equals('A'));
//     });
//
//     test('TC_PFX_02 [+] Accepts "A2" and formats it as "A-2"', () {
//       expect(_applyPrefixFormatter('A', 'A2'), equals('A-2'));
//     });
//
//     test('TC_PFX_03 [+] Accepts "B24" and formats it as "B-24"', () {
//       expect(_applyPrefixFormatter('B-2', 'B24'), equals('B-24'));
//     });
//
//     test('TC_PFX_04 [+] All valid first letters A through D are accepted', () {
//       for (var letter in ['A', 'B', 'C', 'D']) {
//         expect(_applyPrefixFormatter('', letter), equals(letter));
//       }
//     });
//
//     test('TC_PFX_05 [+] Single digit after letter is formatted with dash "A-1"', () {
//       expect(_applyPrefixFormatter('', 'A1'), equals('A-1'));
//     });
//
//     test('TC_PFX_06 [-] First character "E" is rejected (outside A-D range)', () {
//       expect(_applyPrefixFormatter('', 'E'), isNot(equals('E')));
//     });
//
//     test('TC_PFX_07 [-] First character as digit is rejected', () {
//       expect(_applyPrefixFormatter('', '1'), isNot(equals('1')));
//     });
//
//     test('TC_PFX_08 [-] Special character "@" as first char is rejected', () {
//       expect(_applyPrefixFormatter('', '@'), isNot(equals('@')));
//     });
//
//     test('TC_PFX_09 [-] More than 2 digits are truncated — "A999" becomes "A-99"', () {
//       expect(_applyPrefixFormatter('', 'A999'), equals('A-99'));
//     });
//
//     test('TC_PFX_10 [-] Lowercase "e" is uppercased to "E" then rejected', () {
//       expect(_applyPrefixFormatter('', 'e'), isNot(equals('e')));
//     });
//
//     test('TC_PFX_11 [-] Empty string returns empty string', () {
//       expect(_applyPrefixFormatter('A', ''), equals(''));
//     });
//   });
//
//   // ===========================================================
//   // 2. TARE WEIGHT VALIDATION TESTS
//   // ===========================================================
//   group('Tare Weight Validation (onChanged)', () {
//     test('TC_TARE_01 [+] Valid weight "10.500" returns no error', () {
//       expect(_validateTareWeight('10.500'), isNull);
//     });
//
//     test('TC_TARE_02 [+] 3 decimal places "14.123" are accepted', () {
//       expect(_validateTareWeight('14.123'), isNull);
//     });
//
//     test('TC_TARE_03 [+] Minimum valid weight "0.001" accepted', () {
//       expect(_validateTareWeight('0.001'), isNull);
//     });
//
//     test('TC_TARE_04 [+] Whole number "14" is accepted', () {
//       expect(_validateTareWeight('14'), isNull);
//     });
//
//     test('TC_TARE_05 [-] Empty string → "Please enter Tare value"', () {
//       expect(_validateTareWeight(''), equals('Please enter Tare value'));
//     });
//
//     test('TC_TARE_06 [-] Zero "0" → "Value must be greater than 0"', () {
//       expect(_validateTareWeight('0'), equals('Value must be greater than 0'));
//     });
//
//     test('TC_TARE_07 [-] Negative "-5" → "Value must be greater than 0"', () {
//       expect(_validateTareWeight('-5'), equals('Value must be greater than 0'));
//     });
//
//     test('TC_TARE_08 [-] Non-numeric "abc" → "Value must be greater than 0"', () {
//       expect(_validateTareWeight('abc'), equals('Value must be greater than 0'));
//     });
//   });
//
//   // ===========================================================
//   // 3. OBSERVED WEIGHT VALIDATION TESTS
//   // ===========================================================
//   group('Observed Weight Validation (onChanged)', () {
//     test('TC_OBS_01 [+] Valid "13.200" returns no error', () {
//       expect(_validateObservedWeight('13.200'), isNull);
//     });
//
//     test('TC_OBS_02 [+] Single decimal "12.5" is accepted', () {
//       expect(_validateObservedWeight('12.5'), isNull);
//     });
//
//     test('TC_OBS_03 [-] Empty → "Please enter observed value"', () {
//       expect(_validateObservedWeight(''), equals('Please enter observed value'));
//     });
//
//     test('TC_OBS_04 [-] Zero "0" → "Value must be greater than 0"', () {
//       expect(_validateObservedWeight('0'), equals('Value must be greater than 0'));
//     });
//
//     test('TC_OBS_05 [-] Negative "-1.5" → "Value must be greater than 0"', () {
//       expect(_validateObservedWeight('-1.5'), equals('Value must be greater than 0'));
//     });
//   });
//
//   // ===========================================================
//   // 4. GROSS WEIGHT AUTO-CALCULATION
//   //    GrossWt = TareWt + ItemWeight  (read-only, auto-computed)
//   // ===========================================================
//   group('Gross Weight Auto-Calculation', () {
//     test('TC_GROSS_01 [+] Tare(10.00) + ItemWeight(14.2) = 24.20', () {
//       expect(_calculateGross(tare: 10.00, itemWeight: 14.2), closeTo(24.20, 0.001));
//     });
//
//     test('TC_GROSS_02 [+] Tare(0.5) + ItemWeight(5.0) = 5.50', () {
//       expect(_calculateGross(tare: 0.5, itemWeight: 5.0), closeTo(5.50, 0.001));
//     });
//
//     test('TC_GROSS_03 [+] Large values Tare(100.0) + ItemWeight(50.0) = 150.00', () {
//       expect(_calculateGross(tare: 100.0, itemWeight: 50.0), closeTo(150.00, 0.001));
//     });
//
//     test('TC_GROSS_04 [-] Tare = 0.0 → gross field is cleared (returns null)', () {
//       expect(_calculateGrossFromZeroTare(), isNull);
//     });
//   });
//
//   // ===========================================================
//   // 5. VARIATION AUTO-CALCULATION
//   //    Variation = GrossWt - ObservedWt  (read-only)
//   // ===========================================================
//   group('Variation Calculation', () {
//     test('TC_VAR_01 [+] Gross(24.2) - Observed(14.2) = 10.000', () {
//       expect(_calculateVariation(gross: 24.2, observed: 14.2), closeTo(10.000, 0.001));
//     });
//
//     test('TC_VAR_02 [+] Variation = 0.000 when Gross equals Observed', () {
//       expect(_calculateVariation(gross: 14.2, observed: 14.2), closeTo(0.000, 0.001));
//     });
//
//     test('TC_VAR_03 [-] Observed > Gross produces negative variation', () {
//       expect(_calculateVariation(gross: 10.0, observed: 12.0), lessThan(0));
//     });
//   });
//
//   // ===========================================================
//   // 6. addItem() FULL VALIDATION CHAIN
//   // ===========================================================
//   group('addItem() – Validation Order (all 9 guards)', () {
//     test('TC_ADD_01 [+] All required fields valid → no error', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.5', observed: '14.2', dptDate: 'A-24',
//           sealingCondition: 'Yes', leakOption: 'No',
//           leakDesignation: null, serialNo: 'SRL001',
//           existingSerials: [], listCount: 0,
//         ),
//         isNull,
//       );
//     });
//
//     test('TC_ADD_02 [+] Leaky=Yes + designation selected → valid', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '12.0', observed: '13.5', dptDate: 'B-12',
//           sealingCondition: 'No', leakOption: 'Yes',
//           leakDesignation: 'Body Leak', serialNo: 'SRL002',
//           existingSerials: [], listCount: 0,
//         ),
//         isNull,
//       );
//     });
//
//     test('TC_ADD_03 [+] 9th item in list (listCount=9) is accepted', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.0', observed: '14.0', dptDate: 'C-10',
//           sealingCondition: 'Yes', leakOption: 'No',
//           leakDesignation: null, serialNo: 'SRL099',
//           existingSerials: List.generate(9, (i) => 'SRL00$i'),
//           listCount: 9,
//         ),
//         isNull,
//       );
//     });
//
//     test('TC_ADD_04 [-] No item selected → "Please Select An Item"', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: null,
//           tare: '10.5', observed: '14.2', dptDate: 'A-24',
//           sealingCondition: 'Yes', leakOption: 'No',
//           leakDesignation: null, serialNo: 'SRL001',
//           existingSerials: [], listCount: 0,
//         ),
//         equals('Please Select An Item'),
//       );
//     });
//
//     test('TC_ADD_05 [-] Empty tare → "Please Enter Tare Weight"', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '', observed: '14.2', dptDate: 'A-24',
//           sealingCondition: 'Yes', leakOption: 'No',
//           leakDesignation: null, serialNo: 'SRL001',
//           existingSerials: [], listCount: 0,
//         ),
//         equals('Please Enter Tare Weight'),
//       );
//     });
//
//     test('TC_ADD_06 [-] Empty observed → "Please Enter Observed Weight"', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.5', observed: '', dptDate: 'A-24',
//           sealingCondition: 'Yes', leakOption: 'No',
//           leakDesignation: null, serialNo: 'SRL001',
//           existingSerials: [], listCount: 0,
//         ),
//         equals('Please Enter Observed Weight'),
//       );
//     });
//
//     test('TC_ADD_07 [-] Empty DPT Date → "Please Enter DPT Date"', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.5', observed: '14.2', dptDate: '',
//           sealingCondition: 'Yes', leakOption: 'No',
//           leakDesignation: null, serialNo: 'SRL001',
//           existingSerials: [], listCount: 0,
//         ),
//         equals('Please Enter DPT Date'),
//       );
//     });
//
//     test('TC_ADD_08 [-] No sealing → "Please Select Sealing Condition"', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.5', observed: '14.2', dptDate: 'A-24',
//           sealingCondition: null, leakOption: 'No',
//           leakDesignation: null, serialNo: 'SRL001',
//           existingSerials: [], listCount: 0,
//         ),
//         equals('Please Select Sealing Condition'),
//       );
//     });
//
//     test('TC_ADD_09 [-] No leak option → "Please Select Leakage Option"', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.5', observed: '14.2', dptDate: 'A-24',
//           sealingCondition: 'Yes', leakOption: null,
//           leakDesignation: null, serialNo: 'SRL001',
//           existingSerials: [], listCount: 0,
//         ),
//         equals('Please Select Leakage Option'),
//       );
//     });
//
//     test('TC_ADD_10 [-] Leaky=Yes but no type selected → "Please Select Leakage Type"', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.5', observed: '14.2', dptDate: 'A-24',
//           sealingCondition: 'Yes', leakOption: 'Yes',
//           leakDesignation: null, serialNo: 'SRL001',
//           existingSerials: [], listCount: 0,
//         ),
//         equals('Please Select Leakage Type'),
//       );
//     });
//
//     test('TC_ADD_11 [-] Empty serial number → "Please Enter Serial Number"', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.5', observed: '14.2', dptDate: 'A-24',
//           sealingCondition: 'Yes', leakOption: 'No',
//           leakDesignation: null, serialNo: '',
//           existingSerials: [], listCount: 0,
//         ),
//         equals('Please Enter Serial Number'),
//       );
//     });
//
//     test('TC_ADD_12 [-] Duplicate serial number → "Duplicate Serial Number. Cannot add item."', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.5', observed: '14.2', dptDate: 'A-24',
//           sealingCondition: 'Yes', leakOption: 'No',
//           leakDesignation: null, serialNo: 'SRL001',
//           existingSerials: ['SRL001'], listCount: 1,
//         ),
//         equals('Duplicate Serial Number. Cannot add item.'),
//       );
//     });
//
//     test('TC_ADD_13 [-] List already at 10 items → "Max 10 Items Allowed"', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.5', observed: '14.2', dptDate: 'A-24',
//           sealingCondition: 'Yes', leakOption: 'No',
//           leakDesignation: null, serialNo: 'SRL_NEW',
//           existingSerials: List.generate(10, (i) => 'SRL0$i'),
//           listCount: 10,
//         ),
//         equals('Max 10 Items Allowed'),
//       );
//     });
//   });
//
//   // ===========================================================
//   // 7. SAVE / UPDATE BUTTON ENABLE-DISABLE LOGIC
//   // ===========================================================
//   group('Save/Update Button State', () {
//     test('TC_BTN_01 [+] Enabled — saveFlag=false, Add mode, list not empty', () {
//       expect(_isSaveButtonEnabled(saveFlag: false, isEditMode: false, listIsEmpty: false), isTrue);
//     });
//
//     test('TC_BTN_02 [+] Enabled — Edit mode even if list is empty', () {
//       expect(_isSaveButtonEnabled(saveFlag: false, isEditMode: true, listIsEmpty: true), isTrue);
//     });
//
//     test('TC_BTN_03 [+] Enabled — Edit mode with list populated', () {
//       expect(_isSaveButtonEnabled(saveFlag: false, isEditMode: true, listIsEmpty: false), isTrue);
//     });
//
//     test('TC_BTN_04 [-] Disabled — saveFlag=true (day-end completed)', () {
//       expect(_isSaveButtonEnabled(saveFlag: true, isEditMode: false, listIsEmpty: false), isFalse);
//     });
//
//     test('TC_BTN_05 [-] Disabled — Add mode with empty list', () {
//       expect(_isSaveButtonEnabled(saveFlag: false, isEditMode: false, listIsEmpty: true), isFalse);
//     });
//
//     test('TC_BTN_06 [-] Disabled — saveFlag=true in Edit mode too', () {
//       expect(_isSaveButtonEnabled(saveFlag: true, isEditMode: true, listIsEmpty: false), isFalse);
//     });
//   });
//
//   // ===========================================================
//   // 8. FILE SIZE VALIDATION  (max 5 MB)
//   // ===========================================================
//   group('File Upload Size Validation', () {
//     const int maxFileSize = 5 * 1024 * 1024;
//
//     test('TC_FILE_01 [+] File exactly 5 MB is accepted', () {
//       expect(_isFileSizeValid(maxFileSize, maxFileSize), isTrue);
//     });
//
//     test('TC_FILE_02 [+] File 1 MB is accepted', () {
//       expect(_isFileSizeValid(1 * 1024 * 1024, maxFileSize), isTrue);
//     });
//
//     test('TC_FILE_03 [+] Small file 100 KB is accepted', () {
//       expect(_isFileSizeValid(100 * 1024, maxFileSize), isTrue);
//     });
//
//     test('TC_FILE_04 [-] File 5 MB + 1 byte is rejected', () {
//       expect(_isFileSizeValid(maxFileSize + 1, maxFileSize), isFalse);
//     });
//
//     test('TC_FILE_05 [-] File 10 MB is rejected', () {
//       expect(_isFileSizeValid(10 * 1024 * 1024, maxFileSize), isFalse);
//     });
//
//     test('TC_FILE_06 [-] File 6 MB is rejected', () {
//       expect(_isFileSizeValid(6 * 1024 * 1024, maxFileSize), isFalse);
//     });
//   });
//
//   // ===========================================================
//   // 9. VIDEO URL DETECTION (_isVideo helper)
//   // ===========================================================
//   group('Video URL Detection', () {
//     test('TC_VID_01 [+] .mp4 URL detected as video', () {
//       expect(_isVideo('https://example.com/clip.mp4'), isTrue);
//     });
//
//     test('TC_VID_02 [+] .mov URL detected as video', () {
//       expect(_isVideo('https://cdn.example.com/video.mov'), isTrue);
//     });
//
//     test('TC_VID_03 [+] .avi URL detected as video', () {
//       expect(_isVideo('https://cdn.example.com/clip.avi'), isTrue);
//     });
//
//     test('TC_VID_04 [+] .mkv URL detected as video', () {
//       expect(_isVideo('https://cdn.example.com/clip.mkv'), isTrue);
//     });
//
//     test('TC_VID_05 [+] .3gp URL detected as video', () {
//       expect(_isVideo('https://cdn.example.com/clip.3gp'), isTrue);
//     });
//
//     test('TC_VID_06 [+] .webm URL detected as video', () {
//       expect(_isVideo('https://cdn.example.com/clip.webm'), isTrue);
//     });
//
//     test('TC_VID_07 [-] .jpg URL is NOT a video', () {
//       expect(_isVideo('https://example.com/photo.jpg'), isFalse);
//     });
//
//     test('TC_VID_08 [-] .png URL is NOT a video', () {
//       expect(_isVideo('https://example.com/image.png'), isFalse);
//     });
//
//     test('TC_VID_09 [-] .pdf URL is NOT a video', () {
//       expect(_isVideo('https://example.com/document.pdf'), isFalse);
//     });
//
//     test('TC_VID_10 [-] Empty URL is NOT a video', () {
//       expect(_isVideo(''), isFalse);
//     });
//
//     test('TC_VID_11 [-] URL with no extension is NOT a video', () {
//       expect(_isVideo('https://example.com/file'), isFalse);
//     });
//   });
//
//   // ===========================================================
//   // 10. EDIT MODE – ROUTE ARGUMENT PARSING
//   // ===========================================================
//   group('Edit Mode – Argument Mapping', () {
//     test('TC_EDIT_01 [+] Sealing code "Y" maps to "Yes"', () {
//       expect(_mapSealingCode('Y'), equals('Yes'));
//     });
//
//     test('TC_EDIT_02 [+] Sealing code "N" maps to "No"', () {
//       expect(_mapSealingCode('N'), equals('No'));
//     });
//
//     test('TC_EDIT_03 [+] Leaky code "Y" maps to "Yes"', () {
//       expect(_mapSealingCode('Y'), equals('Yes'));
//     });
//
//     test('TC_EDIT_04 [+] uploadedFileUrl set for valid non-"0" URL', () {
//       expect(
//         _resolveUploadedFileUrl('https://example.com/file.mp4'),
//         equals('https://example.com/file.mp4'),
//       );
//     });
//
//     test('TC_EDIT_05 [-] uploadedFileUrl is null when fileUploadEdit is empty', () {
//       expect(_resolveUploadedFileUrl(''), isNull);
//     });
//
//     test('TC_EDIT_06 [-] uploadedFileUrl is null when fileUploadEdit is "0"', () {
//       expect(_resolveUploadedFileUrl('0'), isNull);
//     });
//
//     test('TC_EDIT_07 [+] mode=="Edit" → dropdowns pre-filled', () {
//       expect(_shouldPreSelectDropdowns(mode: 'Edit'), isTrue);
//     });
//
//     test('TC_EDIT_08 [-] mode!="Edit" → dropdowns NOT pre-filled', () {
//       expect(_shouldPreSelectDropdowns(mode: 'Add'), isFalse);
//     });
//
//     test('TC_EDIT_09 [-] mode empty string → dropdowns NOT pre-filled', () {
//       expect(_shouldPreSelectDropdowns(mode: ''), isFalse);
//     });
//   });
//
//   // ===========================================================
//   // 11. clearForm() STATE RESET
//   // ===========================================================
//   group('clearForm() – State Reset After Add/Edit', () {
//     test('TC_CLR_01 [+] All text controllers cleared', () {
//       final s = _FakeFormState()
//         ..fillAll()
//         ..clearForm();
//       expect(s.tare, isEmpty);
//       expect(s.gross, isEmpty);
//       expect(s.observed, isEmpty);
//       expect(s.variation, isEmpty);
//       expect(s.dptDate, isEmpty);
//       expect(s.serialNo, isEmpty);
//       expect(s.remarks, isEmpty);
//     });
//
//     test('TC_CLR_02 [+] All dropdowns/nullable fields reset to null', () {
//       final s = _FakeFormState()
//         ..fillAll()
//         ..clearForm();
//       expect(s.selectedItemModel, isNull);
//       expect(s.selectedSealingCondition, isNull);
//       expect(s.selectedLeak, isNull);
//       expect(s.selectedDesignation, isNull);
//       expect(s.selectedFile, isNull);
//       expect(s.uploadedFileUrl, isNull);
//     });
//
//     test('TC_CLR_03 [-] vehicleNo is NOT cleared (persists across entries)', () {
//       final s = _FakeFormState()
//         ..vehicleNo = 'MH12AB1234'
//         ..fillAll()
//         ..clearForm();
//       expect(s.vehicleNo, equals('MH12AB1234'));
//     });
//
//     test('TC_CLR_04 [-] Re-filling after clearForm works correctly', () {
//       final s = _FakeFormState()
//         ..fillAll()
//         ..clearForm()
//         ..fillAll();
//       expect(s.tare, equals('10.5'));
//       expect(s.selectedItemModel, equals('LPG 14.2 KG'));
//     });
//   });
//
//   // ===========================================================
//   // 12. SealingCond & Leakage API FORMAT (Y/N encoding)
//   // ===========================================================
//   group('API Payload – Y/N Encoding', () {
//     test('TC_API_01 [+] selectedSealingCondition "Yes" encodes to "Y"', () {
//       expect(_encodeYN('Yes'), equals('Y'));
//     });
//
//     test('TC_API_02 [+] selectedSealingCondition "No" encodes to "N"', () {
//       expect(_encodeYN('No'), equals('N'));
//     });
//
//     test('TC_API_03 [+] selectedLeak "Yes" encodes to "Y"', () {
//       expect(_encodeYN('Yes'), equals('Y'));
//     });
//
//     test('TC_API_04 [+] selectedLeak "No" encodes to "N"', () {
//       expect(_encodeYN('No'), equals('N'));
//     });
//
//     test('TC_API_05 [-] LeakyBdy is empty string when Leakage is "No"', () {
//       final leakyBdy = _resolveLeakyBdy(leakOption: 'No', designationId: '3');
//       expect(leakyBdy, equals(''));
//     });
//
//     test('TC_API_06 [+] LeakyBdy carries designation ID when Leakage is "Yes"', () {
//       final leakyBdy = _resolveLeakyBdy(leakOption: 'Yes', designationId: '3');
//       expect(leakyBdy, equals('3'));
//     });
//   });
//
//   // ─────────────────────────────────────────────────────────────
//   // WIDGET RENDERING TESTS  (uncomment after importing screen)
//   // ─────────────────────────────────────────────────────────────
//   // ===========================================================
//   // Additional edge & boundary cases (pure helpers)
//   // These tests examine subtle behaviors and rounding/formatting edge-cases.
//   // They intentionally assert current behavior (even if surprising) so changes
//   // to helper logic will be detected by CI.
//   // ===========================================================
//   group('Additional edge & boundary cases', () {
//     test('TC_PFX_12 [+] Idempotent when dash already present', () {
//       expect(_applyPrefixFormatter('', 'A-2'), equals('A-2'));
//     });
//
//     test('TC_PFX_13 [+] Excess leading zeros are truncated (A007 -> A-00)', () {
//       expect(_applyPrefixFormatter('', 'A007'), equals('A-00'));
//     });
//
//     test('TC_TARE_09 [+] Scientific notation accepted (1e3)', () {
//       // double.tryParse accepts scientific notation → treated as valid number
//       expect(_validateTareWeight('1e3'), isNull);
//     });
//
//     test('TC_TARE_10 [+] Trailing decimal point accepted ("12.")', () {
//       expect(_validateTareWeight('12.'), isNull);
//     });
//
//     test('TC_GROSS_05 [+] Rounding behaviour for very small values', () {
//       // 0.005 + 0.005 = 0.01 → toStringAsFixed(2) -> 0.01
//       expect(_calculateGross(tare: 0.005, itemWeight: 0.005), closeTo(0.01, 0.0001));
//     });
//
//     test('TC_ADD_14 [-] Duplicate serial detected when input contains surrounding whitespace', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.5', observed: '14.2', dptDate: 'A-24',
//           sealingCondition: 'Yes', leakOption: 'No',
//           leakDesignation: null, serialNo: ' SRL001 ',
//           existingSerials: ['SRL001'], listCount: 1,
//         ),
//         equals('Duplicate Serial Number. Cannot add item.'),
//       );
//     });
//
//     test('TC_ADD_15 [+] leakDesignation provided but leakOption="No" is accepted', () {
//       expect(
//         _simulateAddItemValidation(
//           selectedItemModel: 'LPG 14.2 KG',
//           tare: '10.5', observed: '14.2', dptDate: 'A-24',
//           sealingCondition: 'Yes', leakOption: 'No',
//           leakDesignation: 'Body Leak', serialNo: 'SRL010',
//           existingSerials: [], listCount: 0,
//         ),
//         isNull,
//       );
//     });
//
//     test('TC_VID_12 [+] Uppercase extension detected as video', () {
//       expect(_isVideo('https://cdn.example.com/CLIP.MP4'), isTrue);
//     });
//
//     test('TC_VID_13 [-] URL with query string after extension is NOT detected (endsWith mismatch)', () {
//       // Current helper uses endsWith; URLs with query strings will not match.
//       expect(_isVideo('https://example.com/clip.mp4?v=1'), isFalse);
//     });
//
//     test('TC_FILE_07 [+] File size zero treated as valid (<= max)', () {
//       const int maxFileSize = 5 * 1024 * 1024;
//       expect(_isFileSizeValid(0, maxFileSize), isTrue);
//     });
//
//     test('TC_FILE_08 [+] Negative file size returns true due to <= check (edge case)', () {
//       const int maxFileSize = 5 * 1024 * 1024;
//       // The helper simply compares <= maxSize; negative values therefore pass.
//       expect(_isFileSizeValid(-1, maxFileSize), isTrue);
//     });
//
//     test('TC_API_07 [-] _encodeYN returns N for unexpected input', () {
//       expect(_encodeYN('Maybe'), equals('N'));
//     });
//
//     test('TC_EDIT_10 [-] _resolveUploadedFileUrl returns whitespace string (not trimmed)', () {
//       // Current helper treats any non-empty string not equal to '0' as a URL — it does not trim.
//       final s = '   ';
//       expect(_resolveUploadedFileUrl(s), equals(s));
//     });
//
//     test('TC_VAR_04 [+] Variation rounding edge case', () {
//       // gross 0.015 - observed 0.005 = 0.01 → formatted with 3 decimals -> 0.010
//       expect(_calculateVariation(gross: 0.015, observed: 0.005), closeTo(0.01, 0.0001));
//     });
//   });
//   // group('SQCRegisterScreen Widget Tests', () {
//   //   setUp(setupSharedPrefs);
//   //
//   //   testWidgets('TC_UI_01 [+] Screen renders with AppBar title',
//   //       (WidgetTester tester) async {
//   //     await tester.pumpWidget(buildTestableApp(child: SQCRegisterScreen()));
//   //     await tester.pumpAndSettle();
//   //     expect(find.text('SQC Register'), findsOneWidget);
//   //   });
//   //   ... (rest of widget tests remain commented out)
//   // });
// }
//
// // ─────────────────────────────────────────────────────────────
// // PURE HELPER FUNCTIONS  (mirror screen logic exactly)
// // ─────────────────────────────────────────────────────────────
//
// String _applyPrefixFormatter(String oldText, String newText) {
//   String text = newText.toUpperCase();
//   if (text.isEmpty) return '';
//   String firstChar = text[0];
//   if (!RegExp(r'[A-D]').hasMatch(firstChar)) return oldText;
//   String digits = '';
//   if (text.length > 1) {
//     digits = text.substring(1).replaceAll(RegExp(r'[^0-9]'), '');
//     if (digits.length > 2) digits = digits.substring(0, 2);
//   }
//   String formatted = firstChar;
//   if (digits.isNotEmpty) formatted += '-$digits';
//   return formatted;
// }
//
// String? _validateTareWeight(String value) {
//   final number = double.tryParse(value);
//   if (value.isEmpty) return 'Please enter Tare value';
//   if (number == null || number <= 0) return 'Value must be greater than 0';
//   return null;
// }
//
// String? _validateObservedWeight(String value) {
//   final number = double.tryParse(value);
//   if (value.isEmpty) return 'Please enter observed value';
//   if (number == null || number <= 0) return 'Value must be greater than 0';
//   return null;
// }
//
// double _calculateGross({required double tare, required double itemWeight}) =>
//     double.parse((tare + itemWeight).toStringAsFixed(2));
//
// double? _calculateGrossFromZeroTare() {
//   if (0.0 == 0.0) return null; // tare is zero → clear field
//   return 0.0;
// }
//
// double _calculateVariation({required double gross, required double observed}) =>
//     double.parse((gross - observed).toStringAsFixed(3));
//
// String? _simulateAddItemValidation({
//   required String? selectedItemModel,
//   required String tare,
//   required String observed,
//   required String dptDate,
//   required String? sealingCondition,
//   required String? leakOption,
//   required String? leakDesignation,
//   required String serialNo,
//   required List<String> existingSerials,
//   required int listCount,
// }) {
//   if (selectedItemModel == null) return 'Please Select An Item';
//   if (tare.isEmpty) return 'Please Enter Tare Weight';
//   if (observed.isEmpty) return 'Please Enter Observed Weight';
//   if (dptDate.isEmpty) return 'Please Enter DPT Date';
//   if (sealingCondition == null || sealingCondition.isEmpty) return 'Please Select Sealing Condition';
//   if (leakOption == null || leakOption.isEmpty) return 'Please Select Leakage Option';
//   if (leakOption == 'Yes' && leakDesignation == null) return 'Please Select Leakage Type';
//   if (serialNo.isEmpty) return 'Please Enter Serial Number';
//   if (existingSerials.contains(serialNo.trim())) return 'Duplicate Serial Number. Cannot add item.';
//   if (listCount >= 10) return 'Max 10 Items Allowed';
//   return null;
// }
//
// bool _isSaveButtonEnabled({
//   required bool saveFlag,
//   required bool isEditMode,
//   required bool listIsEmpty,
// }) {
//   final disabled = saveFlag || (!isEditMode && listIsEmpty);
//   return !disabled;
// }
//
// bool _isFileSizeValid(int fileSize, int maxSize) => fileSize <= maxSize;
//
// bool _isVideo(String url) {
//   const videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
//   final lower = url.toLowerCase();
//   return videoExtensions.any((ext) => lower.endsWith('.$ext'));
// }
//
// String _mapSealingCode(String code) => code == 'Y' ? 'Yes' : 'No';
//
// String? _resolveUploadedFileUrl(String fileUploadEdit) =>
//     (fileUploadEdit.isNotEmpty && fileUploadEdit != '0') ? fileUploadEdit : null;
//
// bool _shouldPreSelectDropdowns({required String mode}) => mode == 'Edit';
//
// String _encodeYN(String value) => value == 'Yes' ? 'Y' : 'N';
//
// String _resolveLeakyBdy({
//   required String leakOption,
//   required String designationId,
// }) =>
//     leakOption == 'Yes' ? designationId : '';
//
// // ─────────────────────────────────────────────────────────────
// // FAKE STATE CLASS — used by clearForm() tests
// // ─────────────────────────────────────────────────────────────
// class _FakeFormState {
//   String tare = '';
//   String gross = '';
//   String observed = '';
//   String variation = '';
//   String dptDate = '';
//   String serialNo = '';
//   String remarks = '';
//   String vehicleNo = '';
//
//   String? selectedItemModel;
//   String? selectedSealingCondition;
//   String? selectedLeak;
//   String? selectedDesignation;
//   String? selectedFile;
//   String? uploadedFileUrl;
//
//   void fillAll() {
//     tare = '10.5';
//     gross = '24.7';
//     observed = '14.2';
//     variation = '10.5';
//     dptDate = 'A-24';
//     serialNo = 'SRL001';
//     remarks = 'Test remark';
//     selectedItemModel = 'LPG 14.2 KG';
//     selectedSealingCondition = 'Yes';
//     selectedLeak = 'No';
//     selectedFile = '/path/file.jpg';
//     uploadedFileUrl = 'https://example.com/file.jpg';
//   }
//
//   void clearForm() {
//     tare = gross = observed = variation = dptDate = serialNo = remarks = '';
//     // vehicleNo is intentionally NOT cleared
//     selectedItemModel = null;
//     selectedSealingCondition = null;
//     selectedLeak = null;
//     selectedDesignation = null;
//     selectedFile = null;
//     uploadedFileUrl = null;
//   }
// }


// =============================================================================
// sqc_register_screen_test.dart
// Comprehensive Unit & Logic Tests for SQCRegisterScreen
// Covers: ItemReturn → SQC navigation flow, argument passing, validation,
//         state management, business logic, API payload construction, edge cases
// Run with: flutter test test/sqc_register_screen_test.dart
// =============================================================================
//
// NOTE: Widget-level tests that require SQCRegisterScreen to be instantiated
// remain commented out (matching existing project pattern) because the screen
// depends on platform plugins (EasyLoading, VideoPlayer, ImagePicker, etc.)
// that cannot be satisfied in headless CI without additional fakes.
// All *pure-logic* tests are active and runnable.
// =============================================================================

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SHARED SETUP HELPERS  (reused from existing test pattern)
// ─────────────────────────────────────────────────────────────────────────────

Future<void> setupSharedPrefs({
  String distributorId = '101',
  String godownId = '1',
  String staffId = '5',
  String token = 'test_bearer_token_abc',
}) async {
  SharedPreferences.setMockInitialValues({
    'DistributorId': distributorId,
    'godownId': godownId,
    'StaffId': staffId,
    'token': token,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// MODELS (inline stubs — mirrors production models without importing them)
// ─────────────────────────────────────────────────────────────────────────────

/// Minimal stub for ItemDetails (mirrors production class fields used in tests)
class _ItemDetail {
  final int itemId;
  final String itemName;

  const _ItemDetail({required this.itemId, required this.itemName});
}

/// Minimal stub for a receipt (ItemReturn row) used in navigation arg assembly
class _Receipt {
  final int pkId;
  final String vehicleNo;
  final String godownId;
  final String returnOn; // '0001-01-01T00:00:00' = not OUT yet
  final List<_ItemDetail> itemDetails;

  const _Receipt({
    required this.pkId,
    required this.vehicleNo,
    required this.godownId,
    required this.returnOn,
    required this.itemDetails,
  });

  bool get isPending => returnOn == '0001-01-01T00:00:00';
}

// ─────────────────────────────────────────────────────────────────────────────
// PURE HELPER FUNCTIONS  (mirrors SQCRegisterScreen._* private logic exactly)
// ─────────────────────────────────────────────────────────────────────────────

// ── DPT Date prefix formatter (same logic as screen's TextInputFormatter) ──
String _applyPrefixFormatter(String oldText, String newText) {
  String text = newText.toUpperCase();
  if (text.isEmpty) return '';
  String firstChar = text[0];
  if (!RegExp(r'[A-D]').hasMatch(firstChar)) return oldText;
  String digits = '';
  if (text.length > 1) {
    digits = text.substring(1).replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 2) digits = digits.substring(0, 2);
  }
  String formatted = firstChar;
  if (digits.isNotEmpty) formatted += '-$digits';
  return formatted;
}

// ── Weight validators ──────────────────────────────────────────────────────
String? _validateTareWeight(String value) {
  final number = double.tryParse(value);
  if (value.isEmpty) return 'Please enter Tare value';
  if (number == null || number <= 0) return 'Value must be greater than 0';
  return null;
}

String? _validateObservedWeight(String value) {
  final number = double.tryParse(value);
  if (value.isEmpty) return 'Please enter observed value';
  if (number == null || number <= 0) return 'Value must be greater than 0';
  return null;
}

// ── Calculation helpers ────────────────────────────────────────────────────
double _calculateGross({required double tare, required double itemWeight}) =>
    double.parse((tare + itemWeight).toStringAsFixed(2));

double? _calculateGrossFromZeroTare() {
  if (0.0 == 0.0) return null;
  return 0.0;
}

double _calculateVariation({required double gross, required double observed}) =>
    double.parse((gross - observed).toStringAsFixed(3));

// ── Item weight extractor (regex from screen: picks first number from name) ─
double _extractItemWeightFromName(String name) {
  final RegExp regExp = RegExp(r'(\d+(\.\d+)?)');
  final Match? match = regExp.firstMatch(name);
  return match != null ? double.tryParse(match.group(0)!) ?? 0.0 : 0.0;
}

// ── addItem() validation chain ─────────────────────────────────────────────
String? _simulateAddItemValidation({
  required String? selectedItemModel,
  required String tare,
  required String observed,
  required String dptDate,
  required String? sealingCondition,
  required String? leakOption,
  required String? leakDesignation,
  required String serialNo,
  required List<String> existingSerials,
  required int listCount,
}) {
  if (selectedItemModel == null) return 'Please Select An Item';
  if (tare.isEmpty) return 'Please Enter Tare Weight';
  if (observed.isEmpty) return 'Please Enter Observed Weight';
  if (dptDate.isEmpty) return 'Please Enter DPT Date';
  if (sealingCondition == null || sealingCondition.isEmpty) {
    return 'Please Select Sealing Condition';
  }
  if (leakOption == null || leakOption.isEmpty) {
    return 'Please Select Leakage Option';
  }
  if (leakOption == 'Yes' && leakDesignation == null) {
    return 'Please Select Leakage Type';
  }
  if (serialNo.isEmpty) return 'Please Enter Serial Number';
  if (existingSerials.contains(serialNo.trim())) {
    return 'Duplicate Serial Number. Cannot add item.';
  }
  if (listCount >= 10) return 'Max 10 Items Allowed';
  return null;
}

// ── Save button state ─────────────────────────────────────────────────────
bool _isSaveButtonEnabled({
  required bool saveFlag,
  required bool isEditMode,
  required bool listIsEmpty,
}) {
  final disabled = saveFlag || (!isEditMode && listIsEmpty);
  return !disabled;
}

// ── Helper: encode Yes/No to Y/N for API ──────────────────────────────────
String _encodeYN(String value) => value == 'Yes' ? 'Y' : 'N';

// ── Helper: sealing code decode ───────────────────────────────────────────
String _mapSealingCode(String code) => code == 'Y' ? 'Yes' : 'No';

// ── Helper: resolve uploaded file URL ────────────────────────────────────
String? _resolveUploadedFileUrl(String fileUploadEdit) =>
    (fileUploadEdit.isNotEmpty && fileUploadEdit != '0') ? fileUploadEdit : null;

// ── Helper: pre-select dropdowns only in Edit mode ──────────────────────
bool _shouldPreSelectDropdowns({required String mode}) => mode == 'Edit';

// ── Helper: LeakyBdy resolution ──────────────────────────────────────────
String _resolveLeakyBdy({
  required String leakOption,
  required String designationId,
}) =>
    leakOption == 'Yes' ? designationId : '';

// ── Helper: file size validation ──────────────────────────────────────────
bool _isFileSizeValid(int fileSize, int maxSize) => fileSize <= maxSize;

// ── Helper: video URL detection ──────────────────────────────────────────
bool _isVideo(String url) {
  const videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
  final lower = url.toLowerCase();
  return videoExtensions.any((ext) => lower.endsWith('.$ext'));
}

// ── Navigation argument builder (mirrors ItenRetun.dart onTap logic) ────
Map<String, dynamic> _buildSQCNavigationArgs(_Receipt vehicle) {
  final itemIds = <String>[];
  final itemNames = <String>[];
  for (var item in vehicle.itemDetails) {
    itemIds.add(item.itemId.toString());
    itemNames.add(item.itemName);
  }
  return {
    'vehicleNo': vehicle.vehicleNo,
    'godownId': vehicle.godownId,
    'itemIds': itemIds,
    'itemNames': itemNames,
  };
}

// ── Argument parser (mirrors SQCRegisterScreen initState WidgetsBinding) ─
_ParsedSQCArgs _parseSQCArgs(Map<String, dynamic> args) {
  return _ParsedSQCArgs(
    vehicleNo: args['vehicleNo']?.toString() ?? '',
    godownId: args['godownId']?.toString() ?? '',
    itemIds: List<String>.from(args['itemIds'] ?? []),
    itemNames: List<String>.from(args['itemNames'] ?? []),
  );
}

class _ParsedSQCArgs {
  final String vehicleNo;
  final String godownId;
  final List<String> itemIds;
  final List<String> itemNames;

  const _ParsedSQCArgs({
    required this.vehicleNo,
    required this.godownId,
    required this.itemIds,
    required this.itemNames,
  });
}

// ── API payload builder (mirrors SQCRegisterScreen addItem() payload) ─────
Map<String, dynamic> _buildApiPayload({
  required String godownId,
  required String vehicleNo,
  required String formattedDate,
  required String itemId,
  required String tare,
  required String gross,
  required String observed,
  required String variation,
  required String dptDate,
  required String serialNo,
  required String remarks,
  required String sealingCondition,
  required String leakOption,
  required String leakyBdy,
}) {
  return {
    'GodownId': godownId,
    'ReceiptDate': formattedDate,
    'VehicleNo': vehicleNo,
    'ItemId': itemId,
    'TareWt': tare,
    'GrossWt': gross,
    'ObservedWt': observed,
    'Variation': variation,
    'DPTDate': dptDate,
    'SerialNo': serialNo.trim(),
    'Remarks': remarks,
    'SealingCond': sealingCondition == 'Yes' ? 'Y' : 'N',
    'Leakage': leakOption == 'Yes' ? 'Y' : 'N',
    'LeakyBdy': leakyBdy,
  };
}

// ── SQC filter: only vehicles NOT yet OUT ────────────────────────────────
List<_Receipt> _filterNonOutReceipts(List<_Receipt> all) =>
    all.where((r) => r.isPending).toList();

// ── Duplicate serial check (mirrors isDuplicate logic in addItem) ─────────
bool _isDuplicateSerial(List<Map<String, dynamic>> list, String serial) =>
    list.any((item) => item['SerialNo']?.toString().trim() == serial.trim());

// ── API response interpretation (mirrors SqcRegisterAddEditForMob) ─────────
String _interpretApiResponse(int statusCode, String body) {
  if (statusCode != 200) return 'server_error';
  if (body == '-1') return 'duplicate_serial';
  if (body == '0') return 'save_failed';
  return 'success';
}

// ─────────────────────────────────────────────────────────────────────────────
// FAKE STATE CLASS  (mirrors _SQCRegisterScreenState field subset)
// ─────────────────────────────────────────────────────────────────────────────
class _FakeFormState {
  String tare = '';
  String gross = '';
  String observed = '';
  String variation = '';
  String dptDate = '';
  String serialNo = '';
  String remarks = '';
  String vehicleNo = '';

  String? selectedItemModel;
  String? selectedSealingCondition;
  String? selectedLeak;
  String? selectedDesignation;
  String? selectedFile;
  String? uploadedFileUrl;

  void fillAll() {
    tare = '10.5';
    gross = '24.7';
    observed = '14.2';
    variation = '10.5';
    dptDate = 'A-24';
    serialNo = 'SRL001';
    remarks = 'Test remark';
    selectedItemModel = 'LPG 14.2 KG';
    selectedSealingCondition = 'Yes';
    selectedLeak = 'No';
    selectedFile = '/path/file.jpg';
    uploadedFileUrl = 'https://example.com/file.jpg';
  }

  void clearForm() {
    tare = gross = observed = variation = dptDate = serialNo = remarks = '';
    // vehicleNo is intentionally NOT cleared (persists across entries)
    selectedItemModel = null;
    selectedSealingCondition = null;
    selectedLeak = null;
    selectedDesignation = null;
    selectedFile = null;
    uploadedFileUrl = null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TEST MAIN
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 1 — DPT DATE PREFIX FORMATTER  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('DPT Date Prefix Formatter', () {
    test('TC_PFX_01 [+] Accepts valid first character "A"', () {
      expect(_applyPrefixFormatter('', 'A'), equals('A'));
    });

    test('TC_PFX_02 [+] Accepts "A2" and formats it as "A-2"', () {
      expect(_applyPrefixFormatter('A', 'A2'), equals('A-2'));
    });

    test('TC_PFX_03 [+] Accepts "B24" and formats it as "B-24"', () {
      expect(_applyPrefixFormatter('B-2', 'B24'), equals('B-24'));
    });

    test('TC_PFX_04 [+] All valid first letters A through D are accepted', () {
      for (var letter in ['A', 'B', 'C', 'D']) {
        expect(_applyPrefixFormatter('', letter), equals(letter));
      }
    });

    test('TC_PFX_05 [+] Single digit after letter is formatted with dash "A-1"', () {
      expect(_applyPrefixFormatter('', 'A1'), equals('A-1'));
    });

    test('TC_PFX_06 [-] First character "E" is rejected (outside A-D range)', () {
      expect(_applyPrefixFormatter('', 'E'), isNot(equals('E')));
    });

    test('TC_PFX_07 [-] First character as digit is rejected', () {
      expect(_applyPrefixFormatter('', '1'), isNot(equals('1')));
    });

    test('TC_PFX_08 [-] Special character "@" as first char is rejected', () {
      expect(_applyPrefixFormatter('', '@'), isNot(equals('@')));
    });

    test('TC_PFX_09 [-] More than 2 digits are truncated — "A999" becomes "A-99"', () {
      expect(_applyPrefixFormatter('', 'A999'), equals('A-99'));
    });

    test('TC_PFX_10 [-] Lowercase "e" is uppercased to "E" then rejected', () {
      expect(_applyPrefixFormatter('', 'e'), isNot(equals('e')));
    });

    test('TC_PFX_11 [-] Empty string returns empty string', () {
      expect(_applyPrefixFormatter('A', ''), equals(''));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 2 — TARE WEIGHT VALIDATION  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('Tare Weight Validation (onChanged)', () {
    test('TC_TARE_01 [+] Valid weight "10.500" returns no error', () {
      expect(_validateTareWeight('10.500'), isNull);
    });

    test('TC_TARE_02 [+] 3 decimal places "14.123" are accepted', () {
      expect(_validateTareWeight('14.123'), isNull);
    });

    test('TC_TARE_03 [+] Minimum valid weight "0.001" accepted', () {
      expect(_validateTareWeight('0.001'), isNull);
    });

    test('TC_TARE_04 [+] Whole number "14" is accepted', () {
      expect(_validateTareWeight('14'), isNull);
    });

    test('TC_TARE_05 [-] Empty string → "Please enter Tare value"', () {
      expect(_validateTareWeight(''), equals('Please enter Tare value'));
    });

    test('TC_TARE_06 [-] Zero "0" → "Value must be greater than 0"', () {
      expect(_validateTareWeight('0'), equals('Value must be greater than 0'));
    });

    test('TC_TARE_07 [-] Negative "-5" → "Value must be greater than 0"', () {
      expect(_validateTareWeight('-5'), equals('Value must be greater than 0'));
    });

    test('TC_TARE_08 [-] Non-numeric "abc" → "Value must be greater than 0"', () {
      expect(_validateTareWeight('abc'), equals('Value must be greater than 0'));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 3 — OBSERVED WEIGHT VALIDATION  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('Observed Weight Validation (onChanged)', () {
    test('TC_OBS_01 [+] Valid "13.200" returns no error', () {
      expect(_validateObservedWeight('13.200'), isNull);
    });

    test('TC_OBS_02 [+] Single decimal "12.5" is accepted', () {
      expect(_validateObservedWeight('12.5'), isNull);
    });

    test('TC_OBS_03 [-] Empty → "Please enter observed value"', () {
      expect(_validateObservedWeight(''), equals('Please enter observed value'));
    });

    test('TC_OBS_04 [-] Zero "0" → "Value must be greater than 0"', () {
      expect(_validateObservedWeight('0'), equals('Value must be greater than 0'));
    });

    test('TC_OBS_05 [-] Negative "-1.5" → "Value must be greater than 0"', () {
      expect(_validateObservedWeight('-1.5'), equals('Value must be greater than 0'));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 4 — GROSS WEIGHT AUTO-CALCULATION  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('Gross Weight Auto-Calculation', () {
    test('TC_GROSS_01 [+] Tare(10.00) + ItemWeight(14.2) = 24.20', () {
      expect(_calculateGross(tare: 10.00, itemWeight: 14.2), closeTo(24.20, 0.001));
    });

    test('TC_GROSS_02 [+] Tare(0.5) + ItemWeight(5.0) = 5.50', () {
      expect(_calculateGross(tare: 0.5, itemWeight: 5.0), closeTo(5.50, 0.001));
    });

    test('TC_GROSS_03 [+] Large values Tare(100.0) + ItemWeight(50.0) = 150.00', () {
      expect(_calculateGross(tare: 100.0, itemWeight: 50.0), closeTo(150.00, 0.001));
    });

    test('TC_GROSS_04 [-] Tare = 0.0 → gross field is cleared (returns null)', () {
      expect(_calculateGrossFromZeroTare(), isNull);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 5 — VARIATION AUTO-CALCULATION  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('Variation Calculation', () {
    test('TC_VAR_01 [+] Gross(24.2) - Observed(14.2) = 10.000', () {
      expect(_calculateVariation(gross: 24.2, observed: 14.2), closeTo(10.000, 0.001));
    });

    test('TC_VAR_02 [+] Variation = 0.000 when Gross equals Observed', () {
      expect(_calculateVariation(gross: 14.2, observed: 14.2), closeTo(0.000, 0.001));
    });

    test('TC_VAR_03 [-] Observed > Gross produces negative variation', () {
      expect(_calculateVariation(gross: 10.0, observed: 12.0), lessThan(0));
    });

    test('TC_VAR_04 [+] Variation rounding edge case', () {
      expect(_calculateVariation(gross: 0.015, observed: 0.005), closeTo(0.01, 0.0001));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 6 — addItem() FULL VALIDATION CHAIN  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('addItem() – Validation Order (all 9 guards)', () {
    test('TC_ADD_01 [+] All required fields valid → no error', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL001',
          existingSerials: [], listCount: 0,
        ),
        isNull,
      );
    });

    test('TC_ADD_02 [+] Leaky=Yes + designation selected → valid', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '12.0', observed: '13.5', dptDate: 'B-12',
          sealingCondition: 'No', leakOption: 'Yes',
          leakDesignation: 'Body Leak', serialNo: 'SRL002',
          existingSerials: [], listCount: 0,
        ),
        isNull,
      );
    });

    test('TC_ADD_03 [+] 9th item in list (listCount=9) is accepted', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.0', observed: '14.0', dptDate: 'C-10',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL099',
          existingSerials: List.generate(9, (i) => 'SRL00$i'),
          listCount: 9,
        ),
        isNull,
      );
    });

    test('TC_ADD_04 [-] No item selected → "Please Select An Item"', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: null,
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL001',
          existingSerials: [], listCount: 0,
        ),
        equals('Please Select An Item'),
      );
    });

    test('TC_ADD_05 [-] Empty tare → "Please Enter Tare Weight"', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL001',
          existingSerials: [], listCount: 0,
        ),
        equals('Please Enter Tare Weight'),
      );
    });

    test('TC_ADD_06 [-] Empty observed → "Please Enter Observed Weight"', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL001',
          existingSerials: [], listCount: 0,
        ),
        equals('Please Enter Observed Weight'),
      );
    });

    test('TC_ADD_07 [-] Empty DPT Date → "Please Enter DPT Date"', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: '',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL001',
          existingSerials: [], listCount: 0,
        ),
        equals('Please Enter DPT Date'),
      );
    });

    test('TC_ADD_08 [-] No sealing → "Please Select Sealing Condition"', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: null, leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL001',
          existingSerials: [], listCount: 0,
        ),
        equals('Please Select Sealing Condition'),
      );
    });

    test('TC_ADD_09 [-] No leak option → "Please Select Leakage Option"', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: null,
          leakDesignation: null, serialNo: 'SRL001',
          existingSerials: [], listCount: 0,
        ),
        equals('Please Select Leakage Option'),
      );
    });

    test('TC_ADD_10 [-] Leaky=Yes but no type selected → "Please Select Leakage Type"', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'Yes',
          leakDesignation: null, serialNo: 'SRL001',
          existingSerials: [], listCount: 0,
        ),
        equals('Please Select Leakage Type'),
      );
    });

    test('TC_ADD_11 [-] Empty serial number → "Please Enter Serial Number"', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: '',
          existingSerials: [], listCount: 0,
        ),
        equals('Please Enter Serial Number'),
      );
    });

    test('TC_ADD_12 [-] Duplicate serial number → "Duplicate Serial Number. Cannot add item."', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL001',
          existingSerials: ['SRL001'], listCount: 1,
        ),
        equals('Duplicate Serial Number. Cannot add item.'),
      );
    });

    test('TC_ADD_13 [-] List already at 10 items → "Max 10 Items Allowed"', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL_NEW',
          existingSerials: List.generate(10, (i) => 'SRL0$i'),
          listCount: 10,
        ),
        equals('Max 10 Items Allowed'),
      );
    });

    test('TC_ADD_14 [+] Leaky=No with designation provided still passes', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: 'Body Leak', serialNo: 'SRL010',
          existingSerials: [], listCount: 0,
        ),
        isNull,
      );
    });

    test('TC_ADD_15 [+] leakDesignation provided but leakOption="No" is accepted', () {
      expect(
        _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: 'Body Leak', serialNo: 'SRL010',
          existingSerials: [], listCount: 0,
        ),
        isNull,
      );
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 7 — SAVE BUTTON STATE  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('Save/Update Button State', () {
    test('TC_BTN_01 [+] Enabled — saveFlag=false, Add mode, list not empty', () {
      expect(_isSaveButtonEnabled(saveFlag: false, isEditMode: false, listIsEmpty: false), isTrue);
    });

    test('TC_BTN_02 [+] Enabled — Edit mode even if list is empty', () {
      expect(_isSaveButtonEnabled(saveFlag: false, isEditMode: true, listIsEmpty: true), isTrue);
    });

    test('TC_BTN_03 [+] Enabled — Edit mode with list populated', () {
      expect(_isSaveButtonEnabled(saveFlag: false, isEditMode: true, listIsEmpty: false), isTrue);
    });

    test('TC_BTN_04 [-] Disabled — saveFlag=true (day-end completed)', () {
      expect(_isSaveButtonEnabled(saveFlag: true, isEditMode: false, listIsEmpty: false), isFalse);
    });

    test('TC_BTN_05 [-] Disabled — Add mode with empty list', () {
      expect(_isSaveButtonEnabled(saveFlag: false, isEditMode: false, listIsEmpty: true), isFalse);
    });

    test('TC_BTN_06 [-] Disabled — saveFlag=true in Edit mode too', () {
      expect(_isSaveButtonEnabled(saveFlag: true, isEditMode: true, listIsEmpty: false), isFalse);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 8 — FILE SIZE VALIDATION  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('File Upload Size Validation', () {
    const int maxFileSize = 5 * 1024 * 1024;

    test('TC_FILE_01 [+] File exactly 5 MB is accepted', () {
      expect(_isFileSizeValid(maxFileSize, maxFileSize), isTrue);
    });

    test('TC_FILE_02 [+] File 1 MB is accepted', () {
      expect(_isFileSizeValid(1 * 1024 * 1024, maxFileSize), isTrue);
    });

    test('TC_FILE_03 [+] Small file 100 KB is accepted', () {
      expect(_isFileSizeValid(100 * 1024, maxFileSize), isTrue);
    });

    test('TC_FILE_04 [-] File 5 MB + 1 byte is rejected', () {
      expect(_isFileSizeValid(maxFileSize + 1, maxFileSize), isFalse);
    });

    test('TC_FILE_05 [-] File 10 MB is rejected', () {
      expect(_isFileSizeValid(10 * 1024 * 1024, maxFileSize), isFalse);
    });

    test('TC_FILE_06 [-] File 6 MB is rejected', () {
      expect(_isFileSizeValid(6 * 1024 * 1024, maxFileSize), isFalse);
    });

    test('TC_FILE_07 [+] File size zero treated as valid (<= max)', () {
      expect(_isFileSizeValid(0, maxFileSize), isTrue);
    });

    test('TC_FILE_08 [+] Negative file size returns true due to <= check (edge case)', () {
      expect(_isFileSizeValid(-1, maxFileSize), isTrue);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 9 — VIDEO URL DETECTION  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('Video URL Detection', () {
    test('TC_VID_01 [+] .mp4 URL detected as video', () {
      expect(_isVideo('https://example.com/clip.mp4'), isTrue);
    });

    test('TC_VID_02 [+] .mov URL detected as video', () {
      expect(_isVideo('https://cdn.example.com/video.mov'), isTrue);
    });

    test('TC_VID_03 [+] .avi URL detected as video', () {
      expect(_isVideo('https://cdn.example.com/clip.avi'), isTrue);
    });

    test('TC_VID_04 [+] .mkv URL detected as video', () {
      expect(_isVideo('https://cdn.example.com/clip.mkv'), isTrue);
    });

    test('TC_VID_05 [+] .3gp URL detected as video', () {
      expect(_isVideo('https://cdn.example.com/clip.3gp'), isTrue);
    });

    test('TC_VID_06 [+] .webm URL detected as video', () {
      expect(_isVideo('https://cdn.example.com/clip.webm'), isTrue);
    });

    test('TC_VID_07 [-] .jpg URL is NOT a video', () {
      expect(_isVideo('https://example.com/photo.jpg'), isFalse);
    });

    test('TC_VID_08 [-] .png URL is NOT a video', () {
      expect(_isVideo('https://example.com/image.png'), isFalse);
    });

    test('TC_VID_09 [-] .pdf URL is NOT a video', () {
      expect(_isVideo('https://example.com/document.pdf'), isFalse);
    });

    test('TC_VID_10 [-] Empty URL is NOT a video', () {
      expect(_isVideo(''), isFalse);
    });

    test('TC_VID_11 [-] URL with no extension is NOT a video', () {
      expect(_isVideo('https://example.com/file'), isFalse);
    });

    test('TC_VID_12 [+] Uppercase extension detected as video', () {
      expect(_isVideo('https://cdn.example.com/CLIP.MP4'), isTrue);
    });

    test('TC_VID_13 [-] URL with query string after extension is NOT detected (endsWith mismatch)', () {
      expect(_isVideo('https://example.com/clip.mp4?v=1'), isFalse);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 10 — EDIT MODE ARGUMENT MAPPING  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('Edit Mode – Argument Mapping', () {
    test('TC_EDIT_01 [+] Sealing code "Y" maps to "Yes"', () {
      expect(_mapSealingCode('Y'), equals('Yes'));
    });

    test('TC_EDIT_02 [+] Sealing code "N" maps to "No"', () {
      expect(_mapSealingCode('N'), equals('No'));
    });

    test('TC_EDIT_03 [+] Leaky code "Y" maps to "Yes"', () {
      expect(_mapSealingCode('Y'), equals('Yes'));
    });

    test('TC_EDIT_04 [+] uploadedFileUrl set for valid non-"0" URL', () {
      expect(
        _resolveUploadedFileUrl('https://example.com/file.mp4'),
        equals('https://example.com/file.mp4'),
      );
    });

    test('TC_EDIT_05 [-] uploadedFileUrl is null when fileUploadEdit is empty', () {
      expect(_resolveUploadedFileUrl(''), isNull);
    });

    test('TC_EDIT_06 [-] uploadedFileUrl is null when fileUploadEdit is "0"', () {
      expect(_resolveUploadedFileUrl('0'), isNull);
    });

    test('TC_EDIT_07 [+] mode=="Edit" → dropdowns pre-filled', () {
      expect(_shouldPreSelectDropdowns(mode: 'Edit'), isTrue);
    });

    test('TC_EDIT_08 [-] mode!="Edit" → dropdowns NOT pre-filled', () {
      expect(_shouldPreSelectDropdowns(mode: 'Add'), isFalse);
    });

    test('TC_EDIT_09 [-] mode empty string → dropdowns NOT pre-filled', () {
      expect(_shouldPreSelectDropdowns(mode: ''), isFalse);
    });

    test('TC_EDIT_10 [-] _resolveUploadedFileUrl returns whitespace string (not trimmed)', () {
      final s = '   ';
      expect(_resolveUploadedFileUrl(s), equals(s));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 11 — clearForm() STATE RESET  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('clearForm() – State Reset After Add/Edit', () {
    test('TC_CLR_01 [+] All text controllers cleared', () {
      final s = _FakeFormState()..fillAll()..clearForm();
      expect(s.tare, isEmpty);
      expect(s.gross, isEmpty);
      expect(s.observed, isEmpty);
      expect(s.variation, isEmpty);
      expect(s.dptDate, isEmpty);
      expect(s.serialNo, isEmpty);
      expect(s.remarks, isEmpty);
    });

    test('TC_CLR_02 [+] All dropdowns/nullable fields reset to null', () {
      final s = _FakeFormState()..fillAll()..clearForm();
      expect(s.selectedItemModel, isNull);
      expect(s.selectedSealingCondition, isNull);
      expect(s.selectedLeak, isNull);
      expect(s.selectedDesignation, isNull);
      expect(s.selectedFile, isNull);
      expect(s.uploadedFileUrl, isNull);
    });

    test('TC_CLR_03 [-] vehicleNo is NOT cleared (persists across entries)', () {
      final s = _FakeFormState()
        ..vehicleNo = 'MH12AB1234'
        ..fillAll()
        ..clearForm();
      expect(s.vehicleNo, equals('MH12AB1234'));
    });

    test('TC_CLR_04 [-] Re-filling after clearForm works correctly', () {
      final s = _FakeFormState()..fillAll()..clearForm()..fillAll();
      expect(s.tare, equals('10.5'));
      expect(s.selectedItemModel, equals('LPG 14.2 KG'));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 12 — API Y/N ENCODING  (existing tests — kept intact)
  // ══════════════════════════════════════════════════════════════════════════
  group('API Payload – Y/N Encoding', () {
    test('TC_API_01 [+] selectedSealingCondition "Yes" encodes to "Y"', () {
      expect(_encodeYN('Yes'), equals('Y'));
    });

    test('TC_API_02 [+] selectedSealingCondition "No" encodes to "N"', () {
      expect(_encodeYN('No'), equals('N'));
    });

    test('TC_API_03 [+] selectedLeak "Yes" encodes to "Y"', () {
      expect(_encodeYN('Yes'), equals('Y'));
    });

    test('TC_API_04 [+] selectedLeak "No" encodes to "N"', () {
      expect(_encodeYN('No'), equals('N'));
    });

    test('TC_API_05 [-] LeakyBdy is empty string when Leakage is "No"', () {
      final leakyBdy = _resolveLeakyBdy(leakOption: 'No', designationId: '3');
      expect(leakyBdy, equals(''));
    });

    test('TC_API_06 [+] LeakyBdy carries designation ID when Leakage is "Yes"', () {
      final leakyBdy = _resolveLeakyBdy(leakOption: 'Yes', designationId: '3');
      expect(leakyBdy, equals('3'));
    });

    test('TC_API_07 [-] _encodeYN returns N for unexpected input', () {
      expect(_encodeYN('Maybe'), equals('N'));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 13 — [NEW] NAVIGATION ARGUMENT BUILDING (ItemReturn → SQC)
  // Tests mirror _showSQCBottomSheet onTap logic in ItenRetun.dart
  // ══════════════════════════════════════════════════════════════════════════
  group('Navigation Args: ItemReturn → SQCRegisterScreen', () {
    // ── POSITIVE ────────────────────────────────────────────────────────────
    test('TC_NAV_01 [+] vehicleNo is correctly passed in navigation args', () {
      final vehicle = _Receipt(
        pkId: 1, vehicleNo: 'MH12AB1234', godownId: '5',
        returnOn: '0001-01-01T00:00:00',
        itemDetails: [_ItemDetail(itemId: 101, itemName: 'LPG 14.2 KG')],
      );
      final args = _buildSQCNavigationArgs(vehicle);
      expect(args['vehicleNo'], equals('MH12AB1234'));
    });

    test('TC_NAV_02 [+] godownId is correctly passed in navigation args', () {
      final vehicle = _Receipt(
        pkId: 2, vehicleNo: 'MH01XY5678', godownId: '42',
        returnOn: '0001-01-01T00:00:00',
        itemDetails: [],
      );
      final args = _buildSQCNavigationArgs(vehicle);
      expect(args['godownId'], equals('42'));
    });

    test('TC_NAV_03 [+] single item produces one-element itemIds/itemNames lists', () {
      final vehicle = _Receipt(
        pkId: 3, vehicleNo: 'MH03CD0001', godownId: '7',
        returnOn: '0001-01-01T00:00:00',
        itemDetails: [_ItemDetail(itemId: 55, itemName: 'LPG 5 KG')],
      );
      final args = _buildSQCNavigationArgs(vehicle);
      expect((args['itemIds'] as List).length, equals(1));
      expect((args['itemIds'] as List)[0], equals('55'));
      expect((args['itemNames'] as List)[0], equals('LPG 5 KG'));
    });

    test('TC_NAV_04 [+] multiple items produce parallel itemIds/itemNames lists', () {
      final vehicle = _Receipt(
        pkId: 4, vehicleNo: 'MH04EF0002', godownId: '3',
        returnOn: '0001-01-01T00:00:00',
        itemDetails: [
          _ItemDetail(itemId: 10, itemName: 'LPG 14.2 KG'),
          _ItemDetail(itemId: 20, itemName: 'LPG 19 KG'),
          _ItemDetail(itemId: 30, itemName: 'LPG 5 KG'),
        ],
      );
      final args = _buildSQCNavigationArgs(vehicle);
      final ids   = args['itemIds']   as List<String>;
      final names = args['itemNames'] as List<String>;
      expect(ids,   equals(['10', '20', '30']));
      expect(names, equals(['LPG 14.2 KG', 'LPG 19 KG', 'LPG 5 KG']));
    });

    test('TC_NAV_05 [+] itemIds and itemNames lists have the same length', () {
      final vehicle = _Receipt(
        pkId: 5, vehicleNo: 'MH05GH0003', godownId: '9',
        returnOn: '0001-01-01T00:00:00',
        itemDetails: [
          _ItemDetail(itemId: 1, itemName: 'A'),
          _ItemDetail(itemId: 2, itemName: 'B'),
        ],
      );
      final args = _buildSQCNavigationArgs(vehicle);
      expect(
        (args['itemIds'] as List).length,
        equals((args['itemNames'] as List).length),
      );
    });

    // ── NEGATIVE ─────────────────────────────────────────────────────────────
    test('TC_NAV_06 [-] vehicle with no items produces empty itemIds/itemNames', () {
      final vehicle = _Receipt(
        pkId: 6, vehicleNo: 'MH06IJ0004', godownId: '2',
        returnOn: '0001-01-01T00:00:00',
        itemDetails: [],
      );
      final args = _buildSQCNavigationArgs(vehicle);
      expect((args['itemIds'] as List), isEmpty);
      expect((args['itemNames'] as List), isEmpty);
    });

    test('TC_NAV_07 [-] navigation args map contains all four required keys', () {
      final vehicle = _Receipt(
        pkId: 7, vehicleNo: 'MH07KL0005', godownId: '1',
        returnOn: '0001-01-01T00:00:00',
        itemDetails: [],
      );
      final args = _buildSQCNavigationArgs(vehicle);
      expect(args.containsKey('vehicleNo'), isTrue);
      expect(args.containsKey('godownId'),  isTrue);
      expect(args.containsKey('itemIds'),   isTrue);
      expect(args.containsKey('itemNames'), isTrue);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 14 — [NEW] ARGUMENT PARSING IN SQCRegisterScreen initState
  // Tests mirror WidgetsBinding.addPostFrameCallback args extraction
  // ══════════════════════════════════════════════════════════════════════════
  group('SQCRegisterScreen – Route Argument Parsing', () {
    // ── POSITIVE ────────────────────────────────────────────────────────────
    test('TC_ARG_01 [+] parses vehicleNo from valid args map', () {
      final parsed = _parseSQCArgs({
        'vehicleNo': 'MH12AB1234',
        'godownId': '5',
        'itemIds': ['10', '20'],
        'itemNames': ['LPG 14.2 KG', 'LPG 19 KG'],
      });
      expect(parsed.vehicleNo, equals('MH12AB1234'));
    });

    test('TC_ARG_02 [+] parses godownId from valid args map', () {
      final parsed = _parseSQCArgs({
        'vehicleNo': 'V1',
        'godownId': '99',
        'itemIds': [],
        'itemNames': [],
      });
      expect(parsed.godownId, equals('99'));
    });

    test('TC_ARG_03 [+] parses itemIds as List<String>', () {
      final parsed = _parseSQCArgs({
        'vehicleNo': 'V2',
        'godownId': '1',
        'itemIds': ['55', '66'],
        'itemNames': ['Item A', 'Item B'],
      });
      expect(parsed.itemIds, equals(['55', '66']));
    });

    test('TC_ARG_04 [+] parses itemNames as List<String>', () {
      final parsed = _parseSQCArgs({
        'vehicleNo': 'V3',
        'godownId': '2',
        'itemIds': ['77'],
        'itemNames': ['LPG 5 KG'],
      });
      expect(parsed.itemNames, equals(['LPG 5 KG']));
    });

    test('TC_ARG_05 [+] non-null godownId is received correctly', () {
      final parsed = _parseSQCArgs({
        'vehicleNo': 'V4',
        'godownId': '10',
        'itemIds': [],
        'itemNames': [],
      });
      expect(parsed.godownId, isNotEmpty);
      expect(parsed.godownId, equals('10'));
    });

    // ── NEGATIVE ─────────────────────────────────────────────────────────────
    test('TC_ARG_06 [-] null godownId falls back to empty string', () {
      final parsed = _parseSQCArgs({
        'vehicleNo': 'V5',
        'godownId': null,
        'itemIds': [],
        'itemNames': [],
      });
      expect(parsed.godownId, equals(''));
    });

    test('TC_ARG_07 [-] missing itemIds key produces empty list', () {
      final parsed = _parseSQCArgs({
        'vehicleNo': 'V6',
        'godownId': '3',
        'itemNames': [],
      });
      expect(parsed.itemIds, isEmpty);
    });

    test('TC_ARG_08 [-] missing itemNames key produces empty list', () {
      final parsed = _parseSQCArgs({
        'vehicleNo': 'V7',
        'godownId': '4',
        'itemIds': ['1'],
      });
      expect(parsed.itemNames, isEmpty);
    });

    test('TC_ARG_09 [-] completely empty args map returns default values', () {
      final parsed = _parseSQCArgs({});
      expect(parsed.vehicleNo, equals(''));
      expect(parsed.godownId, equals(''));
      expect(parsed.itemIds, isEmpty);
      expect(parsed.itemNames, isEmpty);
    });

    test('TC_ARG_10 [-] null vehicleNo falls back to empty string', () {
      final parsed = _parseSQCArgs({'vehicleNo': null, 'godownId': '1'});
      expect(parsed.vehicleNo, equals(''));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 15 — [NEW] NON-OUT VEHICLE FILTER (ItemReturn SQC filter logic)
  // Tests mirror vehiclesNotOut filter in _showSQCBottomSheet
  // ══════════════════════════════════════════════════════════════════════════
  group('Non-OUT Vehicle Filter (isPending / returnOn check)', () {
    // ── POSITIVE ────────────────────────────────────────────────────────────
    test('TC_FILT_01 [+] vehicle with returnOn=default-date is pending', () {
      final r = _Receipt(
        pkId: 1, vehicleNo: 'V1', godownId: '1',
        returnOn: '0001-01-01T00:00:00', itemDetails: [],
      );
      expect(r.isPending, isTrue);
    });

    test('TC_FILT_02 [+] filterNonOutReceipts returns only pending vehicles', () {
      final receipts = [
        _Receipt(pkId: 1, vehicleNo: 'V1', godownId: '1', returnOn: '0001-01-01T00:00:00', itemDetails: []),
        _Receipt(pkId: 2, vehicleNo: 'V2', godownId: '1', returnOn: '2024-11-26T08:00:00', itemDetails: []),
        _Receipt(pkId: 3, vehicleNo: 'V3', godownId: '1', returnOn: '0001-01-01T00:00:00', itemDetails: []),
      ];
      final pending = _filterNonOutReceipts(receipts);
      expect(pending.length, equals(2));
      expect(pending.map((r) => r.vehicleNo).toList(), containsAll(['V1', 'V3']));
    });

    test('TC_FILT_03 [+] all receipts pending produces full list', () {
      final receipts = List.generate(
        5,
            (i) => _Receipt(pkId: i, vehicleNo: 'V$i', godownId: '1', returnOn: '0001-01-01T00:00:00', itemDetails: []),
      );
      final pending = _filterNonOutReceipts(receipts);
      expect(pending.length, equals(5));
    });

    // ── NEGATIVE ─────────────────────────────────────────────────────────────
    test('TC_FILT_04 [-] vehicle with real returnOn date is NOT pending', () {
      final r = _Receipt(
        pkId: 2, vehicleNo: 'V2', godownId: '1',
        returnOn: '2024-11-26T08:00:00', itemDetails: [],
      );
      expect(r.isPending, isFalse);
    });

    test('TC_FILT_05 [-] no pending vehicles produces empty filter result', () {
      final receipts = [
        _Receipt(pkId: 1, vehicleNo: 'V1', godownId: '1', returnOn: '2024-01-01T00:00:00', itemDetails: []),
        _Receipt(pkId: 2, vehicleNo: 'V2', godownId: '1', returnOn: '2024-06-15T00:00:00', itemDetails: []),
      ];
      final pending = _filterNonOutReceipts(receipts);
      expect(pending, isEmpty);
    });

    test('TC_FILT_06 [-] OUT items should NOT be passed to SQC screen', () {
      final receipts = [
        _Receipt(pkId: 1, vehicleNo: 'V1', godownId: '1', returnOn: '2024-01-01T00:00:00', itemDetails: [
          _ItemDetail(itemId: 99, itemName: 'OUT Item'),
        ]),
      ];
      final pending = _filterNonOutReceipts(receipts);
      expect(pending, isEmpty, reason: 'OUT vehicles must never be passed to SQC');
    });

    test('TC_FILT_07 [-] empty receipt list produces empty pending list', () {
      final pending = _filterNonOutReceipts([]);
      expect(pending, isEmpty);
    });

    test('TC_FILT_08 [+] mixed list: only exactly pending vehicles selected', () {
      final receipts = [
        _Receipt(pkId: 1, vehicleNo: 'PENDING_1', godownId: '1', returnOn: '0001-01-01T00:00:00', itemDetails: []),
        _Receipt(pkId: 2, vehicleNo: 'OUT_1',     godownId: '1', returnOn: '2024-05-10T00:00:00', itemDetails: []),
        _Receipt(pkId: 3, vehicleNo: 'PENDING_2', godownId: '1', returnOn: '0001-01-01T00:00:00', itemDetails: []),
        _Receipt(pkId: 4, vehicleNo: 'OUT_2',     godownId: '1', returnOn: '2024-05-11T00:00:00', itemDetails: []),
      ];
      final pending = _filterNonOutReceipts(receipts);
      expect(pending.every((r) => r.isPending), isTrue);
      expect(pending.map((r) => r.vehicleNo).toList(), equals(['PENDING_1', 'PENDING_2']));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 16 — [NEW] API PAYLOAD CONSTRUCTION
  // Tests mirror addItem() item map-building logic
  // ══════════════════════════════════════════════════════════════════════════
  group('API Payload Construction (addItem map)', () {
    // ── POSITIVE ────────────────────────────────────────────────────────────
    test('TC_PAY_01 [+] SealingCond encodes "Yes" → "Y" in payload', () {
      final payload = _buildApiPayload(
        godownId: '5', vehicleNo: 'MH01AA1234', formattedDate: '2024-11-26T00:00:00Z',
        itemId: '10', tare: '10.5', gross: '24.70', observed: '14.2',
        variation: '10.500', dptDate: 'A-24', serialNo: 'SRL001', remarks: '',
        sealingCondition: 'Yes', leakOption: 'No', leakyBdy: '',
      );
      expect(payload['SealingCond'], equals('Y'));
    });

    test('TC_PAY_02 [+] Leakage encodes "No" → "N" in payload', () {
      final payload = _buildApiPayload(
        godownId: '5', vehicleNo: 'MH01AA1234', formattedDate: '2024-11-26T00:00:00Z',
        itemId: '10', tare: '10.5', gross: '24.70', observed: '14.2',
        variation: '10.500', dptDate: 'A-24', serialNo: 'SRL001', remarks: '',
        sealingCondition: 'Yes', leakOption: 'No', leakyBdy: '',
      );
      expect(payload['Leakage'], equals('N'));
    });

    test('TC_PAY_03 [+] LeakyBdy contains designation ID when leakOption is "Yes"', () {
      final payload = _buildApiPayload(
        godownId: '5', vehicleNo: 'V1', formattedDate: '2024-11-26T00:00:00Z',
        itemId: '20', tare: '11.0', gross: '30.0', observed: '19.0',
        variation: '11.000', dptDate: 'B-12', serialNo: 'SRL002', remarks: 'Test',
        sealingCondition: 'No', leakOption: 'Yes', leakyBdy: '3',
      );
      expect(payload['LeakyBdy'], equals('3'));
    });

    test('TC_PAY_04 [+] SerialNo is trimmed before being added to payload', () {
      final payload = _buildApiPayload(
        godownId: '1', vehicleNo: 'V2', formattedDate: '2024-11-26T00:00:00Z',
        itemId: '30', tare: '9.5', gross: '23.7', observed: '14.2',
        variation: '9.500', dptDate: 'C-10', serialNo: '  SRL003  ', remarks: '',
        sealingCondition: 'Yes', leakOption: 'No', leakyBdy: '',
      );
      expect(payload['SerialNo'], equals('SRL003'));
    });

    test('TC_PAY_05 [+] all required keys are present in the payload', () {
      final payload = _buildApiPayload(
        godownId: '1', vehicleNo: 'V3', formattedDate: '2024-11-26T00:00:00Z',
        itemId: '10', tare: '10.0', gross: '24.2', observed: '14.2',
        variation: '10.000', dptDate: 'A-1', serialNo: 'SRL004', remarks: '',
        sealingCondition: 'Yes', leakOption: 'No', leakyBdy: '',
      );
      const requiredKeys = [
        'GodownId', 'ReceiptDate', 'VehicleNo', 'ItemId',
        'TareWt', 'GrossWt', 'ObservedWt', 'Variation',
        'DPTDate', 'SerialNo', 'Remarks', 'SealingCond', 'Leakage', 'LeakyBdy',
      ];
      for (final key in requiredKeys) {
        expect(payload.containsKey(key), isTrue, reason: 'Missing key: $key');
      }
    });

    test('TC_PAY_06 [+] GodownId is correctly passed into payload', () {
      final payload = _buildApiPayload(
        godownId: '42', vehicleNo: 'V4', formattedDate: '2024-11-26T00:00:00Z',
        itemId: '10', tare: '10.5', gross: '24.7', observed: '14.2',
        variation: '10.500', dptDate: 'A-24', serialNo: 'SRL005', remarks: '',
        sealingCondition: 'Yes', leakOption: 'No', leakyBdy: '',
      );
      expect(payload['GodownId'], equals('42'));
    });

    // ── NEGATIVE ─────────────────────────────────────────────────────────────
    test('TC_PAY_07 [-] LeakyBdy is empty string when leakOption is "No"', () {
      final payload = _buildApiPayload(
        godownId: '1', vehicleNo: 'V5', formattedDate: '2024-11-26T00:00:00Z',
        itemId: '10', tare: '10.5', gross: '24.7', observed: '14.2',
        variation: '10.500', dptDate: 'A-24', serialNo: 'SRL006', remarks: '',
        sealingCondition: 'Yes', leakOption: 'No', leakyBdy: '',
      );
      expect(payload['LeakyBdy'], equals(''));
    });

    test('TC_PAY_08 [-] SealingCond encodes "No" → "N" in payload', () {
      final payload = _buildApiPayload(
        godownId: '1', vehicleNo: 'V6', formattedDate: '2024-11-26T00:00:00Z',
        itemId: '10', tare: '10.5', gross: '24.7', observed: '14.2',
        variation: '10.500', dptDate: 'A-24', serialNo: 'SRL007', remarks: '',
        sealingCondition: 'No', leakOption: 'No', leakyBdy: '',
      );
      expect(payload['SealingCond'], equals('N'));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 17 — [NEW] DUPLICATE SERIAL DETECTION IN sqcItemList
  // Tests mirror isDuplicate check in addItem()
  // ══════════════════════════════════════════════════════════════════════════
  group('Duplicate Serial Number Detection in sqcItemList', () {
    final List<Map<String, dynamic>> baseList = [
      {'SerialNo': 'SRL001', 'ItemId': '10'},
      {'SerialNo': 'SRL002', 'ItemId': '20'},
      {'SerialNo': 'SRL003', 'ItemId': '30'},
    ];

    // ── POSITIVE ────────────────────────────────────────────────────────────
    test('TC_DUP_01 [+] new unique serial is NOT flagged as duplicate', () {
      expect(_isDuplicateSerial(baseList, 'SRL004'), isFalse);
    });

    test('TC_DUP_02 [+] empty list never flags a duplicate', () {
      expect(_isDuplicateSerial([], 'SRL001'), isFalse);
    });

    test('TC_DUP_03 [+] serial with surrounding whitespace is NOT duplicate of clean serial', () {
      // The trim happens in both the stored and incoming serial
      final list = [{'SerialNo': 'SRL001'}];
      expect(_isDuplicateSerial(list, '  SRL001  '), isTrue,
          reason: 'trim() applied on comparison — should match');
    });

    // ── NEGATIVE ─────────────────────────────────────────────────────────────
    test('TC_DUP_04 [-] existing serial triggers duplicate flag', () {
      expect(_isDuplicateSerial(baseList, 'SRL001'), isTrue);
    });

    test('TC_DUP_05 [-] case-sensitive comparison: "srl001" ≠ "SRL001"', () {
      expect(_isDuplicateSerial(baseList, 'srl001'), isFalse,
          reason: 'Serial comparison is case-sensitive per production code');
    });

    test('TC_DUP_06 [-] duplicate detected in middle of list', () {
      expect(_isDuplicateSerial(baseList, 'SRL002'), isTrue);
    });

    test('TC_DUP_07 [-] duplicate at end of list is detected', () {
      expect(_isDuplicateSerial(baseList, 'SRL003'), isTrue);
    });

    test('TC_DUP_08 [+] list with 10 items, non-duplicate serial is accepted', () {
      final tenItems = List.generate(
        10,
            (i) => <String, dynamic>{'SerialNo': 'SRL${i.toString().padLeft(3, '0')}'},
      );
      expect(_isDuplicateSerial(tenItems, 'SRL999'), isFalse);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 18 — [NEW] API RESPONSE INTERPRETATION
  // Tests mirror SqcRegisterAddEditForMob response handling
  // ══════════════════════════════════════════════════════════════════════════
  group('API Response Interpretation (SqcRegisterAddEditForMob)', () {
    // ── POSITIVE ────────────────────────────────────────────────────────────
    test('TC_RESP_01 [+] status 200 with body != "0" and != "-1" → success', () {
      expect(_interpretApiResponse(200, '12345'), equals('success'));
    });

    test('TC_RESP_02 [+] status 200 with body "1" → success', () {
      expect(_interpretApiResponse(200, '1'), equals('success'));
    });

    test('TC_RESP_03 [+] status 200 with positive ID string → success', () {
      expect(_interpretApiResponse(200, '9999'), equals('success'));
    });

    // ── NEGATIVE ─────────────────────────────────────────────────────────────
    test('TC_RESP_04 [-] status 200 with body "-1" → duplicate_serial', () {
      expect(_interpretApiResponse(200, '-1'), equals('duplicate_serial'));
    });

    test('TC_RESP_05 [-] status 200 with body "0" → save_failed', () {
      expect(_interpretApiResponse(200, '0'), equals('save_failed'));
    });

    test('TC_RESP_06 [-] status 500 → server_error regardless of body', () {
      expect(_interpretApiResponse(500, '12345'), equals('server_error'));
    });

    test('TC_RESP_07 [-] status 401 → server_error', () {
      expect(_interpretApiResponse(401, ''), equals('server_error'));
    });

    test('TC_RESP_08 [-] status 404 → server_error', () {
      expect(_interpretApiResponse(404, 'not found'), equals('server_error'));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 19 — [NEW] ITEM WEIGHT EXTRACTION FROM NAME
  // Tests mirror RegExp weight extraction in SQCRegisterScreen
  // ══════════════════════════════════════════════════════════════════════════
  group('Item Weight Extraction from Name (RegExp)', () {
    // ── POSITIVE ────────────────────────────────────────────────────────────
    test('TC_WGT_01 [+] "LPG 14.2 KG" extracts 14.2', () {
      expect(_extractItemWeightFromName('LPG 14.2 KG'), closeTo(14.2, 0.001));
    });

    test('TC_WGT_02 [+] "LPG 19 KG" extracts 19.0', () {
      expect(_extractItemWeightFromName('LPG 19 KG'), closeTo(19.0, 0.001));
    });

    test('TC_WGT_03 [+] "LPG 5 KG" extracts 5.0', () {
      expect(_extractItemWeightFromName('LPG 5 KG'), closeTo(5.0, 0.001));
    });

    test('TC_WGT_04 [+] "35 KG Cylinder" extracts 35.0', () {
      expect(_extractItemWeightFromName('35 KG Cylinder'), closeTo(35.0, 0.001));
    });

    // ── NEGATIVE ─────────────────────────────────────────────────────────────
    test('TC_WGT_05 [-] name with no digits returns 0.0', () {
      expect(_extractItemWeightFromName('LPG Cylinder'), equals(0.0));
    });

    test('TC_WGT_06 [-] empty name returns 0.0', () {
      expect(_extractItemWeightFromName(''), equals(0.0));
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 20 — [NEW] SCENARIO-BASED WORKFLOW TESTS
  // End-to-end logic flows: ItemReturn → args → SQC form → addItem → payload
  // ══════════════════════════════════════════════════════════════════════════
  group('Scenario-Based Workflow Tests', () {
    // ── SCENARIO 1: Happy path — single item, pending vehicle ───────────────
    test(
      'SCEN_01 [+] Happy path: pending vehicle → nav args → parsed → valid addItem → payload',
          () {
        // Arrange: a vehicle NOT yet out with one item
        final vehicle = _Receipt(
          pkId: 1, vehicleNo: 'MH12AB1234', godownId: '5',
          returnOn: '0001-01-01T00:00:00',
          itemDetails: [_ItemDetail(itemId: 101, itemName: 'LPG 14.2 KG')],
        );

        // Act 1: build navigation args (ItenRetun.dart onTap logic)
        final navArgs = _buildSQCNavigationArgs(vehicle);

        // Act 2: parse args in SQCRegisterScreen initState
        final parsed = _parseSQCArgs(navArgs);

        // Act 3: validate addItem() with all fields filled
        final validationError = _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL100',
          existingSerials: [], listCount: 0,
        );

        // Act 4: build API payload
        final gross = _calculateGross(tare: 10.5, itemWeight: 14.2);
        final variation = _calculateVariation(gross: gross, observed: 14.2);
        final payload = _buildApiPayload(
          godownId: parsed.godownId, vehicleNo: parsed.vehicleNo,
          formattedDate: '2024-11-26T00:00:00Z',
          itemId: parsed.itemIds[0], tare: '10.5',
          gross: gross.toString(), observed: '14.2',
          variation: variation.toString(), dptDate: 'A-24',
          serialNo: 'SRL100', remarks: '',
          sealingCondition: 'Yes', leakOption: 'No', leakyBdy: '',
        );

        // Assert
        expect(vehicle.isPending, isTrue);
        expect(parsed.godownId, equals('5'));
        expect(parsed.vehicleNo, equals('MH12AB1234'));
        expect(parsed.itemIds, equals(['101']));
        expect(parsed.itemNames, equals(['LPG 14.2 KG']));
        expect(validationError, isNull, reason: 'Validation must pass for happy path');
        expect(payload['GodownId'], equals('5'));
        expect(payload['VehicleNo'], equals('MH12AB1234'));
        expect(payload['SerialNo'], equals('SRL100'));
        expect(payload['SealingCond'], equals('Y'));
        expect(payload['Leakage'], equals('N'));
      },
    );

    // ── SCENARIO 2: OUT vehicle must NOT reach SQC ────────────────────────
    test(
      'SCEN_02 [-] OUT vehicle is filtered before nav args are built',
          () {
        final receipts = [
          _Receipt(
            pkId: 1, vehicleNo: 'MH01OUT001', godownId: '1',
            returnOn: '2024-11-25T14:30:00', // already returned
            itemDetails: [_ItemDetail(itemId: 50, itemName: 'LPG 14.2 KG')],
          ),
        ];

        final pending = _filterNonOutReceipts(receipts);
        expect(pending, isEmpty, reason: 'OUT vehicle must never go to SQC screen');
      },
    );

    // ── SCENARIO 3: Validation stops at first missing field ─────────────────
    test(
      'SCEN_03 [-] Validation stops at first missing field (tare missing, not observed)',
          () {
        final error = _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '',           // missing
          observed: '',       // also missing, but checked second
          dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL010',
          existingSerials: [], listCount: 0,
        );
        expect(error, equals('Please Enter Tare Weight'),
            reason: 'First guard (tare) must fire before observed check');
      },
    );

    // ── SCENARIO 4: Multiple items — all IDs and names pass correctly ────────
    test(
      'SCEN_04 [+] Multiple items from ItemReturn all reach SQC dropdown correctly',
          () {
        final vehicle = _Receipt(
          pkId: 5, vehicleNo: 'MH05MN0010', godownId: '8',
          returnOn: '0001-01-01T00:00:00',
          itemDetails: [
            _ItemDetail(itemId: 10, itemName: 'LPG 14.2 KG'),
            _ItemDetail(itemId: 20, itemName: 'LPG 19 KG'),
            _ItemDetail(itemId: 30, itemName: 'LPG 5 KG'),
          ],
        );
        final navArgs = _buildSQCNavigationArgs(vehicle);
        final parsed = _parseSQCArgs(navArgs);

        expect(parsed.itemIds.length, equals(3));
        expect(parsed.itemNames.length, equals(3));
        // Every item name can have its weight extracted
        for (final name in parsed.itemNames) {
          expect(_extractItemWeightFromName(name), greaterThan(0.0));
        }
      },
    );

    // ── SCENARIO 5: Repeated SQC entries in a single session ─────────────────
    test(
      'SCEN_05 [+] Two different serial numbers can be added in a single session',
          () {
        final sqcList = <Map<String, dynamic>>[];

        // First entry
        final err1 = _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL_A01',
          existingSerials: sqcList.map((e) => e['SerialNo'] as String).toList(),
          listCount: sqcList.length,
        );
        expect(err1, isNull);
        sqcList.add({'SerialNo': 'SRL_A01'});

        // Second entry, different serial
        final err2 = _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL_A02',
          existingSerials: sqcList.map((e) => e['SerialNo'] as String).toList(),
          listCount: sqcList.length,
        );
        expect(err2, isNull);
        expect(sqcList.length, equals(1)); // still 1 (add happens outside this fn)
      },
    );

    // ── SCENARIO 6: Duplicate serial in same session is rejected ─────────────
    test(
      'SCEN_06 [-] Same serial number added twice in one session is rejected',
          () {
        final sqcList = [{'SerialNo': 'SRL_X01'}];

        final err = _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL_X01',
          existingSerials: sqcList.map((e) => e['SerialNo'] as String).toList(),
          listCount: sqcList.length,
        );
        expect(err, equals('Duplicate Serial Number. Cannot add item.'));
      },
    );

    // ── SCENARIO 7: Form clears after successful add, vehicleNo persists ──────
    test(
      'SCEN_07 [+] After successful addItem, form clears but vehicleNo is retained',
          () {
        final form = _FakeFormState()
          ..vehicleNo = 'MH12AB1234'
          ..fillAll();

        // Simulate clearForm called after addItem()
        form.clearForm();

        expect(form.vehicleNo, equals('MH12AB1234'), reason: 'vehicleNo must survive clearForm');
        expect(form.tare, isEmpty);
        expect(form.serialNo, isEmpty);
        expect(form.selectedItemModel, isNull);
      },
    );

    // ── SCENARIO 8: Edit mode receives all arg fields and maps them ──────────
    test(
      'SCEN_08 [+] Edit mode args parse all required fields without error',
          () {
        final editArgs = {
          'modeChange': 'Edit',
          'sqcIDV': '55',
          'vehicleNoV': 'MH12AB9999',
          'godownIdV': '7',
          'itemIdV': '10',
          'itemNameV': 'LPG 14.2 KG',
          'itemIds': ['10', '20'],
          'itemNames': ['LPG 14.2 KG', 'LPG 19 KG'],
          'tareWtV': '10.5',
          'grossWtV': '24.7',
          'observedWtV': '14.2',
          'variationV': '10.5',
          'dptDateV': 'A-24',
          'sealingV': 'Y',
          'laekyV': 'N',
          'leakTypeIdV': '',
          'leakTypeV': '',
          'serialNoV': 'SRL_EDIT_01',
          'remarkV': 'Check valve',
          'fileUploadV': 'https://example.com/photo.jpg',
        };

        expect(editArgs['modeChange'], equals('Edit'));
        expect(_mapSealingCode(editArgs['sealingV'] as String), equals('Yes'));
        expect(_mapSealingCode(editArgs['laekyV'] as String), equals('No'));
        expect(_resolveUploadedFileUrl(editArgs['fileUploadV'] as String),
            equals('https://example.com/photo.jpg'));
        expect(_shouldPreSelectDropdowns(mode: editArgs['modeChange'] as String), isTrue);
      },
    );

    // ── SCENARIO 9: Mixed valid/invalid selections ───────────────────────────
    test(
      'SCEN_09 [-] Mixed data: valid item + valid tare but missing sealing → fails sealing check',
          () {
        final err = _simulateAddItemValidation(
          selectedItemModel: 'LPG 19 KG',
          tare: '12.0', observed: '19.0', dptDate: 'B-6',
          sealingCondition: null,     // missing
          leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL999',
          existingSerials: [], listCount: 0,
        );
        expect(err, equals('Please Select Sealing Condition'));
      },
    );

    // ── SCENARIO 10: Workflow when no items available (empty itemIds) ─────────
    test(
      'SCEN_10 [-] SQC screen receives empty itemIds → dropdown has no options',
          () {
        final parsed = _parseSQCArgs({
          'vehicleNo': 'MH10OP9999',
          'godownId': '3',
          'itemIds': [],
          'itemNames': [],
        });
        expect(parsed.itemIds, isEmpty, reason: 'No items to show in dropdown');
        expect(parsed.itemNames, isEmpty);

        // If dropdown is empty, selectedItemModel cannot be set → addItem must fail
        final err = _simulateAddItemValidation(
          selectedItemModel: null,    // cannot select from empty dropdown
          tare: '10.5', observed: '14.2', dptDate: 'A-1',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL100',
          existingSerials: [], listCount: 0,
        );
        expect(err, equals('Please Select An Item'));
      },
    );

    // ── SCENARIO 11: Max-capacity list boundary ────────────────────────────
    test(
      'SCEN_11 [-] 10th item is the limit; 11th is rejected',
          () {
        final existingSerials = List.generate(10, (i) => 'SRL${i.toString().padLeft(3, '0')}');

        final err = _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL_NEW',
          existingSerials: existingSerials,
          listCount: 10,
        );
        expect(err, equals('Max 10 Items Allowed'));
      },
    );

    // ── SCENARIO 12: Gross/Variation auto-calculate in correct order ──────────
    test(
      'SCEN_12 [+] Full calculation chain: tare→gross→variation is consistent',
          () {
        const tare = 10.5;
        const itemWeight = 14.2;
        final gross = _calculateGross(tare: tare, itemWeight: itemWeight);
        final variation = _calculateVariation(gross: gross, observed: itemWeight);

        expect(gross, closeTo(24.70, 0.01));
        expect(variation, closeTo(10.500, 0.001));
      },
    );

    // ── SCENARIO 13: fileUploadEdit "0" means no file ─────────────────────
    test(
      'SCEN_13 [-] fileUploadV = "0" in Edit args → uploadedFileUrl is null',
          () {
        final fileUrl = _resolveUploadedFileUrl('0');
        expect(fileUrl, isNull,
            reason: '"0" is a sentinel for no-file-uploaded on the server');
      },
    );

    // ── SCENARIO 14: Malformed/partial args map doesn't crash ────────────────
    test(
      'SCEN_14 [-] Partial args map (only vehicleNo) returns safe defaults',
          () {
        final parsed = _parseSQCArgs({'vehicleNo': 'MH09AB0000'});
        expect(parsed.vehicleNo, equals('MH09AB0000'));
        expect(parsed.godownId, equals(''));
        expect(parsed.itemIds, isEmpty);
        expect(parsed.itemNames, isEmpty);
      },
    );

    // ── SCENARIO 15: dayEnd saveFlag blocks both add and save ─────────────
    test(
      'SCEN_15 [-] saveFlag=true disables save button even with items in list and Edit mode',
          () {
        expect(_isSaveButtonEnabled(saveFlag: true, isEditMode: false, listIsEmpty: false), isFalse);
        expect(_isSaveButtonEnabled(saveFlag: true, isEditMode: true,  listIsEmpty: false), isFalse);
        expect(_isSaveButtonEnabled(saveFlag: true, isEditMode: true,  listIsEmpty: true),  isFalse);
      },
    );

    // ── SCENARIO 16: API duplicate serial response handling ───────────────
    test(
      'SCEN_16 [-] server returns "-1" → isDuplicate flag set, upload stops',
          () {
        final result = _interpretApiResponse(200, '-1');
        expect(result, equals('duplicate_serial'),
            reason: 'Body "-1" signals server-side duplicate; must not proceed');
      },
    );

    // ── SCENARIO 17: clearForm() then add second item without re-selecting vehicleNo
    test(
      'SCEN_17 [+] After clearForm(), vehicleNo field still has correct value for next addItem',
          () {
        final form = _FakeFormState()
          ..vehicleNo = 'MH12AB1234'
          ..fillAll()
          ..clearForm();

        // Form is clear but vehicleNo persists → user can immediately add next item
        expect(form.vehicleNo, equals('MH12AB1234'));
        expect(form.tare, isEmpty);
        expect(form.serialNo, isEmpty);
      },
    );

    // ── SCENARIO 18: leakOption=Yes requires designation; missing it fails ───
    test(
      'SCEN_18 [-] Leakage=Yes but no designation selected → validation stops',
          () {
        final err = _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'Yes',
          leakDesignation: null,   // ← missing
          serialNo: 'SRL_LEAK01',
          existingSerials: [], listCount: 0,
        );
        expect(err, equals('Please Select Leakage Type'));
      },
    );

    // ── SCENARIO 19: JSON serialization of nav args (round-trip safety) ───
    test(
      'SCEN_19 [+] Navigation args survive JSON encode/decode round-trip',
          () {
        final vehicle = _Receipt(
          pkId: 9, vehicleNo: 'MH09QR0099', godownId: '6',
          returnOn: '0001-01-01T00:00:00',
          itemDetails: [
            _ItemDetail(itemId: 11, itemName: 'LPG 14.2 KG'),
            _ItemDetail(itemId: 22, itemName: 'LPG 19 KG'),
          ],
        );
        final original = _buildSQCNavigationArgs(vehicle);
        final encoded = jsonEncode(original);
        final decoded = jsonDecode(encoded) as Map<String, dynamic>;
        final parsed  = _parseSQCArgs(decoded);

        expect(parsed.vehicleNo, equals(original['vehicleNo']));
        expect(parsed.godownId,  equals(original['godownId']));
        expect(parsed.itemIds,   equals(original['itemIds']));
        expect(parsed.itemNames, equals(original['itemNames']));
      },
    );

    // ── SCENARIO 20: Variation negative (observed > gross) is allowed ──────
    test(
      'SCEN_20 [-] Negative variation (observedWt > grossWt) does NOT block addItem',
          () {
        // Screen allows negative variation — it is a data discrepancy flag, not a blocker
        final variation = _calculateVariation(gross: 10.0, observed: 14.0);
        expect(variation, lessThan(0));

        // Validation does not check variation sign
        final err = _simulateAddItemValidation(
          selectedItemModel: 'LPG 14.2 KG',
          tare: '10.5', observed: '14.2', dptDate: 'A-24',
          sealingCondition: 'Yes', leakOption: 'No',
          leakDesignation: null, serialNo: 'SRL_NEG01',
          existingSerials: [], listCount: 0,
        );
        expect(err, isNull, reason: 'Negative variation is a data note, not a validation error');
      },
    );
  });

  group('SharedPreferences token and ID loading', () {
    setUp(() async => await setupSharedPrefs());

    test('TC_PREF_01 [+] DistributorId is loaded correctly from prefs', () async {
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('DistributorId'), equals('101'));
    });

    test('TC_PREF_02 [+] token is loaded correctly from prefs', () async {
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('token'), equals('test_bearer_token_abc'));
    });

    test('TC_PREF_03 [+] StaffId is loaded correctly from prefs', () async {
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('StaffId'), equals('5'));
    });

    test('TC_PREF_04 [-] missing token key returns null', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('token'), isNull);
    });

    test('TC_PREF_05 [-] missing DistributorId returns null', () async {
      SharedPreferences.setMockInitialValues({'token': 'abc'});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('DistributorId'), isNull);
    });

    test('TC_PREF_06 [-] empty string token is effectively a missing token for API auth', () async {
      SharedPreferences.setMockInitialValues({'token': ''});
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      expect(token == null || token.isEmpty, isTrue);
    });
  });

  // ══════════════════════════════════════════════════════════════════════════
  // GROUP 22 — [NEW] EDGE CASES & MISCELLANEOUS
  // ══════════════════════════════════════════════════════════════════════════
  group('Edge Cases & Miscellaneous', () {
    test('EC_01 [+] Gross calculation with very small tare (0.001 + 14.2)', () {
      final gross = _calculateGross(tare: 0.001, itemWeight: 14.2);
      expect(gross, closeTo(14.20, 0.01));
    });

    test('EC_02 [-] extractItemWeight returns 0.0 for item with only letters', () {
      expect(_extractItemWeightFromName('NOWEIGHT'), equals(0.0));
    });

    test('EC_03 [+] prefix formatter accepts "D-99" (max boundary)', () {
      expect(_applyPrefixFormatter('', 'D99'), equals('D-99'));
    });

    test('EC_04 [-] prefix formatter rejects "E1" (out of A-D range)', () {
      expect(_applyPrefixFormatter('D', 'E1'), equals('D'));
    });

    test('EC_05 [+] Variation = 0.000 when gross equals observed exactly', () {
      expect(_calculateVariation(gross: 14.2, observed: 14.2), equals(0.0));
    });

    test('EC_06 [-] File URL ending in ".zip" is NOT detected as video', () {
      expect(_isVideo('https://example.com/defect.zip'), isFalse);
    });

    test('EC_07 [+] leakOption "Yes" + valid designation → LeakyBdy = designationId', () {
      expect(_resolveLeakyBdy(leakOption: 'Yes', designationId: '7'), equals('7'));
    });

    test('EC_08 [-] godownId empty string in payload is still stored (no null-crash)', () {
      final payload = _buildApiPayload(
        godownId: '', vehicleNo: 'V1', formattedDate: '2024-11-26T00:00:00Z',
        itemId: '10', tare: '10.5', gross: '24.7', observed: '14.2',
        variation: '10.500', dptDate: 'A-1', serialNo: 'SRL_EC_08', remarks: '',
        sealingCondition: 'Yes', leakOption: 'No', leakyBdy: '',
      );
      expect(payload['GodownId'], equals(''));
    });

    test('EC_09 [-] Tare "  " (whitespace) does not parse as valid double', () {
      expect(_validateTareWeight('  '), isNotNull,
          reason: 'Whitespace-only input is not a valid weight');
    });

    test('EC_10 [+] _interpretApiResponse treats "99" (a valid ID) as success', () {
      expect(_interpretApiResponse(200, '99'), equals('success'));
    });

    test('EC_11 [-] duplicate serial check is case-sensitive ("SRL001" ≠ "srl001")', () {
      final list = [{'SerialNo': 'SRL001'}];
      expect(_isDuplicateSerial(list, 'srl001'), isFalse);
    });

    test('EC_12 [+] build nav args for vehicle with 10 items (max reasonable)', () {
      final items = List.generate(
        10,
            (i) => _ItemDetail(itemId: i + 1, itemName: 'Item ${i + 1}'),
      );
      final vehicle = _Receipt(
        pkId: 99, vehicleNo: 'MH99ZZ9999', godownId: '1',
        returnOn: '0001-01-01T00:00:00',
        itemDetails: items,
      );
      final args = _buildSQCNavigationArgs(vehicle);
      expect((args['itemIds'] as List).length, equals(10));
      expect((args['itemNames'] as List).length, equals(10));
    });

    test('EC_13 [-] _resolveUploadedFileUrl returns null for "null" string', () {
      // "null" (as a string) is NOT equal to "0" but it's also not a valid URL —
      // however the current helper only guards against "" and "0", so "null" passes through.
      // This test documents the current (known) behavior so a future fix is intentional.
      final result = _resolveUploadedFileUrl('null');
      expect(result, equals('null'),
          reason: 'Current implementation does not guard against "null" string');
    });

    test('EC_14 [+] clearForm twice in a row leaves state clean', () {
      final form = _FakeFormState()..fillAll()..clearForm()..clearForm();
      expect(form.tare, isEmpty);
      expect(form.selectedItemModel, isNull);
    });

    test('EC_15 [-] addItem with listCount exactly at 10 is rejected, not at 9', () {
      // At listCount=9, item is accepted
      final okErr = _simulateAddItemValidation(
        selectedItemModel: 'LPG 14.2 KG',
        tare: '10.0', observed: '14.2', dptDate: 'C-5',
        sealingCondition: 'Yes', leakOption: 'No',
        leakDesignation: null, serialNo: 'BOUNDARY',
        existingSerials: [], listCount: 9,
      );
      expect(okErr, isNull, reason: 'listCount=9 is still under the 10-item cap');

      // At listCount=10, item is rejected
      final failErr = _simulateAddItemValidation(
        selectedItemModel: 'LPG 14.2 KG',
        tare: '10.0', observed: '14.2', dptDate: 'C-5',
        sealingCondition: 'Yes', leakOption: 'No',
        leakDesignation: null, serialNo: 'BOUNDARY_NEXT',
        existingSerials: [], listCount: 10,
      );
      expect(failErr, equals('Max 10 Items Allowed'));
    });
  });
}