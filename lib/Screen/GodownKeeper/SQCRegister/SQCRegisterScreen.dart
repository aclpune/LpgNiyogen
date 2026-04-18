// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:mime/mime.dart';
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../ConstantScreen/widgets.dart';
// import '../../ManagerScreen/GetDesignationListModel.dart';
// import '../../ManagerScreen/SVSaleModel/GetRSPDetailsListModel.dart';
// import '../../Utils/CustomAppBar.dart';
// import '../../Utils/Styling.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/app_url.dart';
// import '../../Utils/constants.dart';
// import '../BottomNavigationForGodownKeeper.dart';
// import '../ItemReceipt/CylItemList/CylItemListModel.dart';
//
// import '../ItemReceipt/ItemReturn/ItenRetun.dart';
// import 'GetSQCFilledCylListModel.dart';
// import 'GetSQCFilledCylListModel.dart';
// const int maxFileSize = 5 * 1024 * 1024; // 5MB
//
// class SQCRegisterScreen extends StatefulWidget {
//   static const screenName = '/sqcregisterScreen';
//
//   const SQCRegisterScreen({super.key});
//
//   @override
//   State<SQCRegisterScreen> createState() =>
//       _SQCRegisterScreenState();
// }
//
// class _SQCRegisterScreenState extends State<SQCRegisterScreen> {
//
//   final _formKey = GlobalKey<FormState>();
//   final ImagePicker _picker = ImagePicker();
//
//   // TextEditingController tareController = TextEditingController();
//   final tareController = TextEditingController();
//   final grossController = TextEditingController();
//   final observedController = TextEditingController();
//   final variationController = TextEditingController();
//   final serialNoController = TextEditingController();
//   final remarksController = TextEditingController();
//   // final vehicleNoController = TextEditingController();
//   final TextEditingController vehicleNoController = TextEditingController();
//   late var prefixController = TextEditingController();
//   String? _selectedItem;
//   int? selectedItemId;
//   String? selectedItemNamee;
//   bool _isinvoiceEmpty = false;
//   String? selectedDptDate;
//   // String? selectedSealingCondition;
//   List<String> regulatorReceived = ["Yes", "No"];
//   String? selectedSealingCondition;
//   List<String> leakReceived = ["Yes", "No"];
//   String? selectedLeak;
//   String? selectedLeaky;
//   String? formattedDate;
//   String? tareError;
//   String? obsError;
//   bool saveFlag = false;
//   final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
//   DateTime selectedDate = DateTime.now();
//   String selectedWeight = "14.2KG";
//   double _selectedItemWeight = 0.0;
//   File? selectedFile;
//   VideoPlayerController? _videoController;
//   File? selectedZip;
//   double grossWeight = 0.0;
//   double observedWeight = 0.0;
//   String? godownId;
//   String? vehicleNo;
//   List<GetDesignationListModel> getdesignationListmodel = [];
//   GetDesignationListModel? selecteddesignation;
//   int? selectedItemIdd;
//   String? selectedItemName;
//   List<GetSqcFilledCylListModel> receiptList = [];
//   bool isLoading = true;
//   var argValue;
//   String? modes;
//   int? SQCIdEdit;
//   String? uploadedFileUrl;
//   List<String> itemIds = [];
//   List<String> itemNames = [];
//   String? selectedItemNameee;
//   int? selectedItemIddd;
//   String? _selectedItemModel;
//   List<Map<String, dynamic>> sqcItemList = [];
//
//   // @override
//   // void dispose() {
//   //   _videoController?.dispose();
//   //   super.dispose();
//   // }
//
//   void calculateObserved() {
//     double gross = double.tryParse(grossController.text) ?? 0.0;
//     double tar = double.tryParse(tareController.text) ?? 0.0;
//
//     double result = gross - tar;
//
//     setState(() {
//       observedController.text = result.toStringAsFixed(3);
//     });
//   }
//
//   void calculateVariation() {
//     grossWeight = double.tryParse(grossController.text) ?? 0.0;
//     observedWeight = double.tryParse(observedController.text) ?? 0.0;
//
//     double variation = grossWeight - observedWeight;
//
//     setState(() {
//       variationController.text = variation.toStringAsFixed(3);
//     });
//   }
//
//   final prefixFormatter = TextInputFormatter.withFunction(
//         (oldValue, newValue) {
//       String text = newValue.text.toUpperCase();
//
//       if (text.isEmpty) {
//         return TextEditingValue(
//           text: '',
//           selection: TextSelection.collapsed(offset: 0),
//         );
//       }
//
//       //First character must be A-Z
//       String firstChar = text[0];
//       if (!RegExp(r'[A-D]').hasMatch(firstChar)) {
//         return oldValue; // Ignore invalid first character
//       }
//
//       // Extract the rest and keep only digits
//       String digits = '';
//       if (text.length > 1) {
//         digits = text.substring(1).replaceAll(RegExp(r'[^0-9]'), '');
//         if (digits.length > 2) digits = digits.substring(0, 2); // max 2 digits
//       }
//
//       // Combine first char + dash + digits
//       String formatted = firstChar;
//       if (digits.isNotEmpty) formatted += "-$digits";
//
//       return TextEditingValue(
//         text: formatted,
//         selection: TextSelection.collapsed(offset: formatted.length),
//       );
//     },
//   );
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     prefixController = TextEditingController();
//     // fetchItems();
//     DateTime now = DateTime.now().toUtc();
//     formattedDate = now.toIso8601String();
//     print(formattedDate);
//     print("wqdf$formattedDate");
//     getDesignationList();
//
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args = ModalRoute.of(this.context)?.settings.arguments as Map?;
//
//       fetchItemSQCAddEditList(this.context);
//
//       loadUploadedVideo();
//       checkAndSaveDayEndData();
//
//       if (args != null) {
//         vehicleNoController.text = args['vehicleNo']?.toString() ?? '';
//         godownId = args['godownId'] ?? '';
//
//         //  Get item IDs and names
//         itemIds = List<String>.from(args['itemIds'] ?? []);
//         itemNames = List<String>.from(args['itemNames'] ?? []);
//
//         // Example usage
//         for (int i = 0; i < itemIds.length; i++) {
//           print("ID: ${itemIds[i]}, Name: ${itemNames[i]}");
//         }
//       }
//     });
//
//     Future.delayed(Duration.zero, ()  async {
//       argValue = ModalRoute.of(this.context)?.settings.arguments as Map?;
//       modes = argValue?["modeChange"] ?? '';
//       print("modes value: $modes");
//       if (argValue != null) {
//         SQCIdEdit = int.tryParse((argValue["sqcIDV"] ?? "0").toString());
//         String itemIdEdit = (argValue["itemIdV"] ?? "").toString();
//         String itemNameEdit = (argValue["itemNameV"] ?? "").toString();
//         String tareWtEdit = (argValue["tareWtV"] ?? "").toString();
//         String grossWtEdit = (argValue["grossWtV"] ?? "").toString();
//         String observedWtEdit = argValue["observedWtV"]?.toString() ?? '';
//         String variationEdit = (argValue["variationV"] ?? 0).toString();
//         String dptDateEdit = (argValue["dptDateV"] ?? "").toString();
//         String sealingEdit = (argValue["sealingV"] ?? "").toString();
//         String leakyEdit = (argValue["laekyV"] ?? "").toString();
//         String leakTypeEdit = (argValue["leakTypeV"] ?? "").toString();
//         String leaktTypeIdEdit = (argValue["leakTypeIdV"] ?? "").toString();
//         String serialNoEdit = (argValue["serialNoV"] ?? "").toString();
//         String remarkEdit = (argValue["remarkV"] ?? "").toString();
//         String fileUploadEdit = (argValue["fileUploadV"] ?? "").toString();
//
//         if (modes == "Edit") {
//           selectedSealingCondition = sealingEdit == "Y" ? "Yes" : "No";
//           selectedLeak = leakyEdit == "Y" ? "Yes" : "No";
//
//           print("Selected Sealing Condition set to: $selectedSealingCondition");
//           print("Selected Leak set to: $selectedLeak");
//         } else {
//           selectedSealingCondition = null;
//           selectedLeak = null;
//           print("Not edit mode, Sealing/Leak set to null");
//         }
//
//         uploadedFileUrl = fileUploadEdit.isNotEmpty && fileUploadEdit != "0" ? fileUploadEdit : null;
//
//         grossWeight = grossWtEdit.isNotEmpty
//             ? double.tryParse(grossWtEdit.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0
//             : 0.0;
//         observedWeight = observedWtEdit.isNotEmpty
//             ? double.tryParse(observedWtEdit.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0
//             : 0.0;
//         if (argValue != null) {
//           String vehicleNoEdit = argValue["vehicleNoV"]?.toString() ?? '';
//           String godownIdEdit = argValue["godownIdV"]?.toString() ?? '';
//           String itemIdEdit = argValue["itemIdV"]?.toString() ?? '';
//           String itemNameEdit = argValue["itemNameV"]?.toString() ?? '';
//
//           // Create lists if empty
//           if ((itemIds.isEmpty || itemNames.isEmpty)) {
//             if (itemIdEdit.isNotEmpty && itemNameEdit.isNotEmpty) {
//               itemIds = [itemIdEdit];
//               itemNames = [itemNameEdit];
//               print("List created from edit data");
//             }
//           }
//
//           setState(() {
//             if (vehicleNoEdit.isNotEmpty && vehicleNoEdit != "null") {
//               vehicleNoController.text = vehicleNoEdit;
//             }
//
//             if (godownIdEdit.isNotEmpty && godownIdEdit != "null") {
//               godownId = godownIdEdit;
//             }
//
//             // Only pre-select if in edit mode and valid item exists
//             if (modes == "Edit" && itemNames.isNotEmpty && itemIds.isNotEmpty) {
//               int index = itemNames.indexWhere((e) => e == itemNameEdit);
//
//               if (index != -1) {
//                 _selectedItemModel = itemNames[index];
//                 selectedItemNameee = itemNames[index];
//                 selectedItemIddd = int.tryParse(itemIds[index]);
//                 print("Pre-selected item index: $index");
//               } else {
//                 // If edit mode but item not found, leave dropdown empty
//                 _selectedItemModel = null;
//                 selectedItemNameee = null;
//                 selectedItemIddd = null;
//                 print("Edit mode but item not found, dropdown left empty");
//               }
//             } else {
//               // Not edit mode, leave dropdown empty
//               _selectedItemModel = null;
//               selectedItemNameee = null;
//               selectedItemIddd = null;
//               print("New entry mode, dropdown left empty");
//             }
//
//             print('Selected Item ID: $selectedItemIddd');
//             print('Selected Item Name: $selectedItemNameee');
//             print('Dropdown model: $_selectedItemModel');
//           });
//         }
//         tareController.text = tareWtEdit;
//         grossController.text = grossWtEdit;
//         observedController.text = observedWtEdit;
//         variationController.text = variationEdit;
//         serialNoController.text = serialNoEdit;
//         remarksController.text = remarkEdit;
//         prefixController.text = dptDateEdit;
//
//         await getDesignationList();
//         await getDesignationList();
//         debugPrint("leaktTypeIdEdit:$leaktTypeIdEdit");
//         if (leaktTypeIdEdit != null && leaktTypeIdEdit.isNotEmpty && leaktTypeIdEdit != "null") {
//           setState(() {
//             selecteddesignation = getdesignationListmodel.firstWhere(
//                   (item) => item.designationId.toString() == leaktTypeIdEdit.toString(),
//               orElse: () => getdesignationListmodel.first,
//             );
//
//             selectedItemName = selecteddesignation?.masterName ?? "";
//             selectedItemIdd = selecteddesignation?.designationId?.toInt();
//
//           });
//         }
//       }
//
//     });
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }
//
//   void calculateGross() {
//     double tareValue = double.tryParse(tareController.text) ?? 0.0;
//     if (tareValue == 0.0) {
//       grossController.clear();
//       return;
//     }
//
//     double gross = tareValue + _selectedItemWeight;
//
//     grossController.text = gross.toStringAsFixed(2);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var argLRAdd = ModalRoute
//         .of(context)
//         ?.settings
//         .arguments;
//
//     return WillPopScope(
//       onWillPop: () async {
//         // Show a confirmation dialog
//         if (argLRAdd == "fromDrawer") {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//
//           return false;
//         } else {
//           Navigator.pushReplacementNamed(
//               context, BottomNavigationForGodownKeeper.screenName);
//           return false;
//         } // In case `null` is returned, return `false`
//       },
//       child:
//       Scaffold(
//         appBar: CustomAppBar(
//           title: 'SQC Register', // Title or hint text for the text field
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child:
//                         textWidgetBlueColorWithStar(
//                           'SQC Vehicle',
//                           "*",
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: TextFormField(
//                           controller:vehicleNoController,
//                           readOnly: true,
//                           decoration: buildInputBorderUpdateStatus1(
//                               "Vehicle No", context
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child:
//                         textWidgetBlueColorWithStar(
//                           'Select Item',
//                           "*",
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child:
//                         DropdownButtonFormField<String>(
//                           value: itemNames.contains(_selectedItemModel) ? _selectedItemModel : null,
//                           isDense: true,
//                           decoration: buildInputBorderUpdateStatus1(
//                               "Select Item", context
//                           ),
//                           items: itemNames.map((name) {
//                             return DropdownMenuItem<String>(
//                               value: name,
//                               child: Text(name),
//                             );
//                           }).toList(),
//                           onChanged: (String? value) {
//                             if (value != null) {
//                               setState(() {
//                                 // clearForm();
//
//                                 _selectedItemModel = value;
//                                 int index = itemNames.indexOf(value);
//                                 selectedItemIddd = int.tryParse(itemIds[index]);
//                                 selectedItemNameee = itemNames[index];
//
//                                 // Extract weight (your logic)
//                                 RegExp regExp = RegExp(r'(\d+(\.\d+)?)');
//                                 Match? match = regExp.firstMatch(selectedItemNameee!);
//
//                                 if (match != null) {
//                                   _selectedItemWeight =
//                                       double.tryParse(match.group(0)!) ?? 0.0;
//                                 } else {
//                                   _selectedItemWeight = 0.0;
//                                 }
//                                 calculateGross();
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child:
//                         textWidgetBlueColorWithStar(
//                           'Tare Weight',
//                           "*",
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child:
//                         TextFormField(
//                           controller: tareController,
//                           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                           inputFormatters: [
//                             FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
//                           ],
//                           decoration: buildInputBorderUpdateStatus1(
//                               "Tare Weight", context),
//                           onChanged: (value) {
//                             final number = double.tryParse(value);
//
//                             setState(() {
//                               if (value.isEmpty) {
//                                 tareError = "Please enter Tare value";
//                               } else if (number == null || number <= 0) {
//                                 tareError = "Value must be greater than 0";
//                               } else {
//                                 tareError = null;
//                               }
//                             });
//
//                             calculateGross();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child:
//                         textWidgetBlueColorWithStar(
//                           'Gross Weight',
//                           "*",
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: TextFormField(
//                           controller: grossController,
//                           readOnly: true,
//                           keyboardType:
//                           const TextInputType.numberWithOptions(decimal: true),
//                           inputFormatters: [
//                             FilteringTextInputFormatter.allow(
//                               RegExp(r'^\d*\.?\d{0,3}'),
//                             ),
//                           ],
//                           decoration: buildInputBorderUpdateStatus1(
//                               "Gross Weight", context),
//                           onChanged: (_) => calculateVariation(),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child:
//                         textWidgetBlueColorWithStar(
//                           'Observed Weight',
//                           "*",
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: TextFormField(
//                             controller: observedController,
//                             keyboardType:
//                             const TextInputType.numberWithOptions(decimal: true),
//                             inputFormatters: [
//                               FilteringTextInputFormatter.allow(
//                                 RegExp(r'^\d*\.?\d{0,3}'),
//                               ),
//                             ],
//                             decoration: buildInputBorderUpdateStatus1(
//                                 "Enter Observed Weight", context,
//                                 errorText: obsError),
//                             // onChanged: (_) => calculateVariation(),
//                             onChanged: (value){
//                               final number = double.tryParse(value);
//
//                               setState(() {
//                                 if (value.isEmpty) {
//                                   obsError = "Please enter observed value";
//                                 } else if (number == null || number <= 0) {
//                                   obsError = "Value must be greater than 0";
//                                 } else {
//                                   obsError = null;
//                                 }
//                               });
//                               calculateVariation();
//                             }
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child:
//                         textWidgetBlueColorWithStar(
//                           'Variation',
//                           "*",
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: TextFormField(
//                           controller: variationController,
//                           readOnly: true,
//                           decoration: buildInputBorderUpdateStatus1(
//                               "Variation", context),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child:
//                         textWidgetBlueColorWithStar(
//                           'DPT Date.',
//                           "*",
//                         ),
//                       ),
//                       Expanded(
//                           flex: 3,
//                           child:
//                           TextFormField(
//                             controller: prefixController, // Empty initially
//                             inputFormatters: [prefixFormatter],
//                             decoration: buildInputBorderUpdateStatus1(
//                                 "A-24", context),
//                           )
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child:
//                         textWidgetBlueColorWithStar(
//                           'Sealing',
//                           "*",
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: DropdownButtonFormField<String>(
//                           value: regulatorReceived.contains(selectedSealingCondition) ? selectedSealingCondition : null,                          isDense: true,
//                           decoration: buildInputBorderUpdateStatus1(
//                               "Sealing", context
//                           ),
//                           items: regulatorReceived.map((value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedSealingCondition = value;
//                             });
//                           },
//                         ),
//
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: textWidgetBlueColorWithStar(
//                               'Leaky',
//                               "*",
//                             ),
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child:
//                             DropdownButtonFormField<String>(
//                               // value: selectedLeak,
//                               value: leakReceived.contains(selectedLeak) ? selectedLeak : null,
//                               isDense: true,
//                               decoration: buildInputBorderUpdateStatus1(
//                                   "Leaky", context
//                               ),
//                               items: leakReceived.map((value) {
//                                 return DropdownMenuItem<String>(
//                                   value: value,
//                                   child: Text(value),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedLeak = value;
//                                   // Reset second dropdown if No selected
//                                   if (value == "No") {
//                                     selectedLeaky = null;
//                                   }
//                                 });
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       if (selectedLeak == "Yes") ...[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: textWidgetBlueColorWithStar(
//                                 'Leak Type',
//                                 "*",
//                               ),
//                             ),
//                             Expanded(
//                               flex: 3,
//                               child:
//                               DropdownButtonFormField<GetDesignationListModel>(
//                                 key: formKey1,
//                                 value: getdesignationListmodel.contains(selecteddesignation) ? selecteddesignation : null,
//                                 decoration: buildInputBorderUpdateStatus1(
//                                     "Select Leaky Type", context
//                                 ),
//                                 items: getdesignationListmodel.map((GetDesignationListModel staff) {
//                                   return DropdownMenuItem<GetDesignationListModel>(
//                                     value: staff,
//                                     child: Text(staff.masterName ?? "-"),
//                                   );
//                                 }).toList(),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selecteddesignation = value;
//                                     selectedItemName = value?.masterName ?? "";
//                                     selectedItemIdd = value?.designationId?.toInt();
//                                     // selectedPermossion = selecteddesignation
//                                   });
//                                 },
//                                 isExpanded: true,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ]
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child:
//                         textWidgetBlueColorWithStar(
//                           'Serial Number',
//                           "*",
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child:
//                         TextField(
//                           controller: serialNoController,
//                           maxLengthEnforcement: MaxLengthEnforcement.enforced,
//                           inputFormatters: <TextInputFormatter>[
//                             LengthLimitingTextInputFormatter(20),
//                             FilteringTextInputFormatter.allow(
//                               RegExp(r'[a-zA-Z0-9]'),
//                             ),
//                           ],
//                           decoration: buildInputBorderUpdateStatus1(
//                             "Serial No", context,
//                             errorText: _isinvoiceEmpty ? 'Serial No. Is Required' : null,
//                           ),
//                           onChanged: (value) {
//                             setState(() {
//                               _isinvoiceEmpty = value.isEmpty;
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: textWidgetBlueColorWithStar(
//                           'Remark',
//                           "",
//                         ),
//                       ),
//                       Expanded(
//                         flex: 3,
//                         child: TextFormField(
//                           controller: remarksController,
//                           decoration: buildInputBorderUpdateStatus1(
//                             "Remark", context,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   SizedBox(height: 8),
//                   if (selectedLeak == "Yes" ||
//                       observedWeight < grossWeight) ...[
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               flex: 2,
//                               child: textWidgetBlueColorWithStar('Defect Upload', ""),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.upload, color: Colors.blue),
//                               onPressed: () {
//                                 showCameraOptions(context);
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//
//                         if (selectedFile != null || uploadedFileUrl != null)
//                           Builder(
//                             builder: (_) {
//                               if (selectedFile != null) {
//                                 String ext = selectedFile!.path.split('.').last.toLowerCase();
//                                 final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
//
//                                 if (videoExtensions.contains(ext)) {
//                                   return (_videoController != null &&
//                                       _videoController!.value.isInitialized)
//                                       ? buildVideoPlayer(_videoController!)
//                                       : Container(
//                                     height: 250,
//                                     child: Center(child: CircularProgressIndicator()),
//                                   );
//                                 } else {
//                                   return Image.file(
//                                     selectedFile!,
//                                     width: double.infinity,
//                                     height: 250,
//                                     fit: BoxFit.cover,
//                                   );
//                                 }
//                               }
//
//                               else if (uploadedFileUrl != null) {
//
//                                 String ext = uploadedFileUrl!.split('.').last.toLowerCase();
//                                 final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
//                                 // if (uploadedFileUrl!.endsWith('.mp4')) {
//                                 if (videoExtensions.contains(ext)) {
//
//                                   return (_videoController != null &&
//                                       _videoController!.value.isInitialized)
//                                       ? buildVideoPlayer(_videoController!)
//                                       : Container(
//                                     height: 250,
//                                     color: Colors.black12,
//                                     child: Center(
//                                       child: Text(
//                                         "Loading Video...",
//                                         style: TextStyle(color: Colors.black),
//                                       ),
//                                     ),
//                                   );
//                                 } else {
//                                   return Image.network(
//                                     uploadedFileUrl!,
//                                     width: double.infinity,
//                                     height: 250,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       // return Center(child: Text("Failed to load file"));
//                                       return Center(child: Text(""));
//                                     },
//                                   );
//                                 }
//                               }
//
//                               return SizedBox.shrink();
//                             },
//                           ),
//
//                         if (selectedZip != null || (uploadedFileUrl?.endsWith('.zip') ?? false))
//                           Container(
//                             padding: const EdgeInsets.all(10),
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.folder_zip, color: Colors.orange),
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: Text(
//                                     selectedZip != null
//                                         ? selectedZip!.path.split('/').last
//                                         : uploadedFileUrl!.split('/').last,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                   SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: addItem,
//                     child: Text("Add Item"),
//                   ),
//                   SizedBox(height: 10),
//                   if (sqcItemList.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20.0, bottom: 15),
//                       child: Container(
//                         decoration: BoxDecoration(border: Border.all(width: 1)),
//                         child: Column(
//                           children: [
//                             // Header Row with equal width for all columns using Expanded
//                             Row(
//                               children: [
//                                 Expanded(
//                                     flex: 1,
//                                     child: Center(
//                                         child: Text(
//                                           "DPT Date",
//                                           style: Styling.itemBlackTestSmall,
//                                         ))),
//                                 verticalDividerVerySmall(),
//                                 Expanded(
//                                     flex: 2,
//                                     child: Center(
//                                         child: Text(
//                                           "Tare Wt",
//                                           style: Styling.itemBlackTestSmall,
//                                         ))),
//                                 verticalDividerVerySmall(),
//                                 Expanded(
//                                     flex: 2,
//                                     child: Center(
//                                         child: Text(
//                                           "Gross Wt",
//                                           style: Styling.itemBlackTestSmall,
//                                         ))),
//                                 verticalDividerVerySmall(),
//                                 Expanded(
//                                     flex: 2,
//                                     child: Center(
//                                         child: Text(
//                                           "Observed Wt",
//                                           style: Styling.itemBlackTestSmall,
//                                         ))),
//                                 verticalDividerVerySmall(),
//                                 Expanded(
//                                   flex: 1,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         "Action",
//                                         style: Styling.itemBlackTestSmall,
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                             // Divider between header and data rows
//                             Container(
//                               color: const Color(0xff1280B3),
//                               height: 1.5,
//                               width: MediaQuery.of(context).size.width,
//                             ),
//                             // Container to display data rows
//                             Container(
//                               child: sqcItemList.isNotEmpty
//                                   ? ListView.builder(
//                                 physics: const BouncingScrollPhysics(),
//                                 itemCount: sqcItemList.length,
//                                 shrinkWrap: true,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   var item = sqcItemList[index];
//                                   return Column(
//                                     children: [
//                                       Container(
//                                         child:
//                                         Row(
//                                           children: [
//                                             Expanded(
//                                               flex: 1,
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(left: 5.0),
//                                                 child: Text(
//                                                   item["DPTDate"] ?? '',
//                                                   style: TextStyle(fontSize: 14, color: Colors.black54),
//                                                 ),
//                                               ),
//                                             ),
//                                             verticalDividerBig(),
//                                             // Column 2: Tare Wt
//                                             Expanded(
//                                               flex: 2,
//                                               child: Text(
//                                                 item["TareWt"] ?? '',
//                                                 style: TextStyle(fontSize: 14, color: Colors.black54),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                             verticalDividerBig(),
//                                             // Column 3: Gross Wt
//                                             Expanded(
//                                               flex: 2,
//                                               child: Text(
//                                                 item["GrossWt"] ?? '',
//                                                 style: TextStyle(fontSize: 14, color: Colors.black54),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                             verticalDividerBig(),
//                                             // Column 4: Observed Wt
//                                             Expanded(
//                                               flex: 2,
//                                               child: Text(
//                                                 item["ObservedWt"] ?? '',
//                                                 style: TextStyle(fontSize: 14, color: Colors.black54),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                             verticalDividerBig(),
//                                             // Expanded(
//                                             //   flex: 0,
//                                             //   child: Row(
//                                             //     mainAxisAlignment: MainAxisAlignment.start,  // Aligns the child at the start
//                                             //     children: [
//                                             //       Padding(
//                                             //         padding: EdgeInsets.only(right: 0.0),  // Adjust padding if needed
//                                             //         child: IconButton(
//                                             //           icon: Icon(Icons.delete, color: Colors.red),
//                                             //           iconSize: 20.0,
//                                             //           onPressed: () {
//                                             //             setState(() {
//                                             //               sqcItemList.removeAt(index);
//                                             //             });
//                                             //           },
//                                             //         ),
//                                             //       ),
//                                             //     ],
//                                             //   ),
//                                             // ),
//                                             Expanded(
//                                               flex: 0,
//                                               child: Row(
//                                                 mainAxisAlignment: MainAxisAlignment.start,
//                                                 children: [
//                                                   Padding(
//                                                     padding: EdgeInsets.only(right: 0.0),
//                                                     child: IconButton(
//                                                       icon: Icon(Icons.delete, color: Colors.red),
//                                                       iconSize: 20.0,
//                                                       onPressed: () async {
//                                                         final shouldDelete = await showDialog<bool>(
//                                                           context: context,
//                                                           builder: (BuildContext context) {
//                                                             return AlertDialog(
//                                                               title: Text("Confirm Delete"),
//                                                               content: Text("Do you want to delete this item?"),
//                                                               actions: [
//                                                                 TextButton(
//                                                                   onPressed: () {
//                                                                     Navigator.of(context).pop(false);
//                                                                   },
//                                                                   child: Text("No"),
//                                                                 ),
//                                                                 TextButton(
//                                                                   onPressed: () {
//                                                                     Navigator.of(context).pop(true);
//                                                                   },
//                                                                   child: Text("Yes"),
//                                                                 ),
//                                                               ],
//                                                             );
//                                                           },
//                                                         );
//
//                                                         if (shouldDelete == true) {
//                                                           setState(() {
//                                                             sqcItemList.removeAt(index);
//                                                           });
//                                                         }
//                                                       },
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               )
//                                   : Container(
//                                 padding: EdgeInsets.all(5),
//                                 child: const Center(child: Text("No Pending Data..!")),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   SizedBox(width: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           cancelAction(context);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: 20,
//                               vertical: 10),
//                         ),
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       GestureDetector(
//                         onTap: () {
//                           if (saveFlag) {
//                             print('saveFlag $saveFlag');
//                             showFlushBar(context, Constants.dayEndCompleted);
//                           }
//                         },
//                         child: ElevatedButton(
//                           onPressed: (sqcItemList.isEmpty || saveFlag)
//                               ? null
//                               : () async {
//                             EasyLoading.show(
//                                 status: modes == "Edit"
//                                     ? "Updating items..."
//                                     : "Saving items...");
//
//                             bool allSuccess = true;
//
//                             for (var item in sqcItemList) {
//                               bool success = await SqcRegisterAddEditForMob(
//                                 context,
//                                 item,
//                                 modes == "Edit" ? SQCIdEdit! : 0,
//                                 modes == "Edit" ? "EDIT" : "ADD",
//                               );
//
//                               if (!success) allSuccess = false;
//                             }
//
//                             EasyLoading.dismiss();
//
//                             if (allSuccess) {
//                               EasyLoading.showToast(
//                                 modes == "Edit"
//                                     ? "All items updated successfully"
//                                     : "All items added successfully",
//                               );
//
//                               setState(() {
//                                 sqcItemList.clear();
//                               });
//
//                               Navigator.pushNamed(context, ItemReturnScreen.screenName);
//
//                               setState(() {
//                                 fetchItemSQCAddEditList(context);
//                               });
//                             } else {
//                               EasyLoading.showToast("Some items failed to upload");
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: (sqcItemList.isEmpty || saveFlag)
//                                 ? Colors.grey
//                                 : (modes == "Edit" ? Colors.orange : Colors.blue),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                           ),
//                           child: Text(
//                             modes == "Edit" ? 'Update' : 'Save',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   SizedBox(height: 5),
//
//                   Card(
//                     child: receiptList.isNotEmpty
//                         ? ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       // Filter the list here
//                       itemCount: receiptList
//                           .where((sale) =>
//                       sale.vehicleNo.toString() == vehicleNoController.text)
//                           .toList()
//                           .length,
//                       itemBuilder: (context, index) {
//                         // Get the filtered sale for this index
//                         final filteredList = receiptList
//                             .where((sale) =>
//                         sale.vehicleNo.toString() == vehicleNoController.text)
//                             .toList();
//                         GetSqcFilledCylListModel sale = filteredList[index];
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                       flex: 1,
//                                       child: Text(
//                                         sale.dPTDate.toString(),
//                                         style: Styling.blueClrText,
//                                       )),
//                                   Expanded(
//                                       flex: 1,
//                                       child: Text(
//                                         sale.itemName.toString() ?? '',
//                                         style: Styling.blueClrText,
//                                       )),
//                                   Expanded(
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(Icons.edit,
//                                               color: saveFlag
//                                                   ? Colors.blueGrey
//                                                   : Colors.blue),
//                                           onPressed: () {
//                                             var sqcID = sale.sQCId.toString();
//                                             var sQCDate = sale.receiptDate.toString();
//                                             var sqcVehicle = sale.vehicleNo.toString();
//                                             var godownId = sale.godownId.toString();
//                                             var itemId = sale.itemId.toString();
//                                             var itemName = sale.itemName.toString();
//                                             var tareWt = sale.tareWt.toString();
//                                             var grossWt = sale.grossWt.toString();
//                                             var observedWt = sale.observedWt.toString();
//                                             var variation = sale.variation.toString();
//                                             var dptDate = sale.dPTDate.toString();
//                                             var sealing = sale.sealingCond.toString();
//                                             var leaky = sale.leakage.toString();
//                                             var leakBdy = sale.leakyBdy.toString();
//                                             var leakBdyName = sale.leakName.toString();
//                                             var serialNo = sale.serialNo.toString();
//                                             var remark = sale.remarks.toString();
//                                             var uploadFile = sale.uploadFilePath.toString();
//
//                                             if (saveFlag) {
//                                               showFlushBar(
//                                                   context, Constants.dayEndCompleted);
//                                             } else {
//                                               Navigator.pushNamed(
//                                                 context,
//                                                 SQCRegisterScreen.screenName,
//                                                 arguments: {
//                                                   'sqcIDV': sqcID,
//                                                   'sqcDateV': sQCDate,
//                                                   'vehicleNoV': sqcVehicle,
//                                                   'godownIdV': godownId,
//                                                   'itemIdV': itemId,
//                                                   'itemNameV': itemName,
//                                                   'itemIds': itemIds,
//                                                   'itemNames': itemNames,
//                                                   'tareWtV': tareWt,
//                                                   'grossWtV': grossWt,
//                                                   'observedWtV': observedWt,
//                                                   'variationV': variation,
//                                                   'dptDateV': dptDate,
//                                                   'sealingV': sealing,
//                                                   'laekyV': leaky,
//                                                   'leakTypeIdV': leakBdy,
//                                                   'leakTypeV': leakBdyName,
//                                                   'serialNoV': serialNo,
//                                                   'remarkV': remark,
//                                                   'fileUploadV': uploadFile,
//                                                   'modeChange': "Edit"
//                                                 },
//                                               );
//                                             }
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               // Rest of your existing rows for weights, dates, etc.
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         Text("Tare Weight : ",
//                                             style: Styling.itemGreyTextSmall),
//                                         Text(sale.tareWt.toString(),
//                                             style: Styling.itemBlackTestSmall),
//                                       ],
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         Text("Gross Weight : ",
//                                             style: Styling.itemGreyTextSmall),
//                                         Text(sale.grossWt.toString(),
//                                             style: Styling.itemBlackTestSmall),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         Text("Observed Weight : ",
//                                             style: Styling.itemGreyTextSmall),
//                                         Text(sale.observedWt.toString(),
//                                             style: Styling.itemBlackTestSmall),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         Text("Variation : ",
//                                             style: Styling.itemGreyTextSmall),
//                                         Text(sale.variation.toString(),
//                                             style: Styling.itemBlackTestSmall),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Row(
//                                       children: [
//                                         Text("Serial No: ",
//                                             style: Styling.itemGreyTextSmall),
//                                         Text(sale.serialNo.toString(),
//                                             style: Styling.itemBlackTestSmall),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     )
//                         : Center(
//                       child: Text('No Records Found'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // void initNetworkVideo(String url) async {
//   //   _videoController?.dispose(); // clean old
//   //
//   //   _videoController = VideoPlayerController.network(url);
//   //
//   //   try {
//   //     await _videoController!.initialize();
//   //     setState(() {});
//   //   } catch (e) {
//   //     print("Video load error: $e");
//   //   }
//   // }
//
//   // Future<void> _initializeNetworkVideo(String url) async {
//   //   print("Initializing video controller with URL: $url");
//   //   try {
//   //     _videoController?.dispose();
//   //
//   //     _videoController = VideoPlayerController.network(url);
//   //
//   //     await _videoController!.initialize();
//   //     print("Video initialized");
//   //
//   //     _videoController!.setLooping(true);
//   //     _videoController!.play();
//   //
//   //     setState(() {}); // rebuild to show player
//   //   } catch (e) {
//   //     print("Error initializing video: $e");
//   //   }
//   // }
//
//   Widget buildVideoPlayer(VideoPlayerController controller) {
//     return Container(
//       width: double.infinity,
//       height: 250,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           AspectRatio(
//             aspectRatio: controller.value.aspectRatio,
//             child: VideoPlayer(controller),
//           ),
//           IconButton(
//             iconSize: 50,
//             color: Colors.white,
//             icon: Icon(
//               controller.value.isPlaying
//                   ? Icons.pause_circle
//                   : Icons.play_circle,
//             ),
//             onPressed: () {
//               controller.value.isPlaying ? controller.pause() : controller.play();
//               setState(() {});
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<bool> isFileValid(File file) async {
//     int size = await file.length();
//
//     if (size > maxFileSize) {
//       ScaffoldMessenger.of(this.context).showSnackBar(
//         const SnackBar(content: Text("File must be less than 5MB")),
//       );
//       return false;
//     }
//     return true;
//   }
//
//   Future<void> captureMedia(String mediaType) async {
//     try {
//       XFile? file;
//
//       if (mediaType == 'image') {
//         file = await _picker.pickImage(source: ImageSource.camera);
//       } else if (mediaType == 'video') {
//         file = await _picker.pickVideo(source: ImageSource.camera);
//       }
//
//       if (file != null) {
//         final File pickedFile = File(file.path);
//
//         // ✅ File size validation
//         if (!await isFileValid(pickedFile)) return;
//
//         String ext = pickedFile.path.split('.').last.toLowerCase();
//
//         final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
//         final imageExtensions = ['jpg', 'jpeg', 'png', 'heic', 'webp', 'bmp'];
//
//         // Clear ZIP
//         selectedZip = null;
//
//         if (videoExtensions.contains(ext)) {
//           // 🎥 VIDEO
//           _videoController?.dispose();
//           _videoController = VideoPlayerController.file(pickedFile);
//
//           WidgetsBinding.instance.addPostFrameCallback((_) async {
//             await _videoController!.initialize();
//
//             setState(() {
//               selectedFile = pickedFile;
//             });
//
//             _videoController!.play();
//           });
//
//         } else if (imageExtensions.contains(ext)) {
//           // 🖼 IMAGE
//           setState(() {
//             selectedFile = pickedFile;
//           });
//
//         } else {
//           // ❌ Unsupported
//           ScaffoldMessenger.of(this.context).showSnackBar(
//             const SnackBar(content: Text("Unsupported file type")),
//           );
//         }
//       }
//     } catch (e) {
//       print("Error picking media: $e");
//     }
//   }
//
//   Future<void> pickZipFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['zip'],
//     );
//
//     if (result != null) {
//       File file = File(result.files.single.path!);
//
//       // ADD THIS VALIDATION
//       if (!await isFileValid(file)) return;
//
//       setState(() {
//         selectedZip = file;
//
//         // Clear image/video
//         selectedFile = null;
//         _videoController?.dispose();
//         _videoController = null;
//       });
//     }
//   }
//
//   Widget textWidgetBlueColorWithoutStar(String text) {
//     return Text(
//       text,
//       style: TextStyle(
//         color: Colors.blue,
//         fontSize: 16,
//       ),
//     );
//   }
//
//   void showCameraOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text("Capture Image"),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await captureMedia('image');
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.videocam),
//                 title: const Text("Capture Video"),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await captureMedia('video');
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.archive), // Icon for ZIP files
//                 title: const Text("Upload ZIP File"),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await pickZipFile();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget buildPreview() {
//     if (selectedFile == null) {
//       return const Text("No file selected");
//     }
//
//     if (_videoController != null &&
//         _videoController!.value.isInitialized) {
//       return SizedBox(
//         height: 200,
//         child: VideoPlayer(_videoController!),
//       );
//     } else {
//       return Image.file(
//         selectedFile!,
//         height: 200,
//         fit: BoxFit.cover,
//       );
//     }
//   }
//
//   void cancelAction(BuildContext context) {
//     final currentVehicleNo = vehicleNoController.text;
//     final currentGodownId = godownId;
//     // Close current dialog
//     Navigator.pop(context);
//     // Navigate to SQCRegisterScreen
//     // Navigator.pushNamed(
//     //   context,
//     //   SQCRegisterScreen.screenName, // This opens the third tab
//     // );
//     Navigator.pushNamed(
//       context,
//       SQCRegisterScreen.screenName,
//       arguments: {
//         'vehicleNo': currentVehicleNo,
//         'godownId': currentGodownId,
//         'itemIds': itemIds,
//         'itemNames': itemNames,
//       },
//     );
//   }
//
//   // Future<void> SqcRegisterAddEditForMob(int SQCId ,String action, {File? mediaFile}) async {
//   //
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? distributorId = prefs.getString('DistributorId');
//   //   String? bearerToken = prefs.getString('token');
//   //   String? staffId = prefs.getString('StaffId');
//   //   String? userId = prefs.getString("UserId");
//   //   int? addedBys = int.parse(staffId!);
//   //   int? distributorIds = int.parse(distributorId!);
//   //
//   //   String? tController;
//   //   String? gController;
//   //   String? oController;
//   //   String? vController;
//   //   String? dptController;
//   //   String? serialController;
//   //   String? remarkController;
//   //
//   //
//   //   if (tareController.text.isNotEmpty) {
//   //     tController = tareController.text;
//   //   }
//   //
//   //   if (grossController.text.isNotEmpty) {
//   //     gController = grossController.text;
//   //   }
//   //   if (observedController.text.isNotEmpty) {
//   //     oController = observedController.text;
//   //   }
//   //   if (variationController.text.isNotEmpty) {
//   //     vController = variationController.text;
//   //   }
//   //   if (prefixController.text.isNotEmpty) {
//   //     dptController = prefixController.text;
//   //   }
//   //   if (serialNoController.text.isNotEmpty) {
//   //     serialController = serialNoController.text;
//   //   }
//   //   if (remarksController.text.isNotEmpty) {
//   //     remarkController = remarksController.text;
//   //   }
//   //
//   //   final Map<String, dynamic> requestBody =
//   //   {
//   //     "SQCId": SQCId,
//   //     "DistributorId":distributorId,
//   //     "GodownId": godownId,
//   //     "ReceiptDate": formattedDate,
//   //     "VehicleNo": vehicleNo,
//   //     "ItemId": selectedItemId,
//   //     "TareWt": tController,
//   //     "GrossWt": gController,
//   //     "ObservedWt": oController,
//   //     "Variation": vController,
//   //     "DPTDate": dptController,
//   //     "SealingCond": selectedSealingCondition ,
//   //     "Leakage": selectedLeak,
//   //     // "LeakyBdy": selectedLeaky,
//   //     "LeakyBdy": 1,
//   //     "SerialNo":serialController,
//   //     "Remarks":remarkController,
//   //     "UploadFileName": mediaFile != null ? mediaFile.path.split('/').last : null,
//   //     "UpdatedBy":"dfd",
//   //     "AddedBy": addedBys,
//   //     "Platform": 'MOB',
//   //     "Action": action,
//   //   };
//   //   print("DepositCashAddEdit: ${requestBody}");
//   //   requestBody.forEach((key, value) {
//   //     print('$key: $value');
//   //   });
//   //   // try {
//   //   final response = await http.post(
//   //     Uri.parse('${AppUrl.SQCFilledCylAddEdit}'),
//   //     headers: {
//   //       "Content-Type": "application/json",
//   //       "Authorization": "Bearer $bearerToken",
//   //     },
//   //     body: json.encode(requestBody),
//   //   );
//   //
//   //   print(
//   //       "requestBody SQCFilledCylAddEdit: ${response.statusCode} - ${response.request}${requestBody}");
//   //
//   //   print("Response Status Code: ${response.statusCode}");
//   //   print("Response SQCFilledCylAddEdit: ${response.body}");
//   //
//   //   if (response.statusCode == 200) {
//   //     if (response.body == '0') {
//   //       // Show a user-friendly error if the response body is 0
//   //       EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
//   //       print("Error: Response returned 0");
//   //     } else {
//   //
//   //       print("Response SQCFilledCylAddEdit: ${response.body}");
//   //
//   //       Navigator.pushNamed(
//   //         context as BuildContext,
//   //         SQCRegisterScreen.screenName,
//   //       );
//   //
//   //       Future.delayed(Duration(milliseconds: 300), () {
//   //         if (action == "DELETE") {
//   //           EasyLoading.showToast(
//   //             Constants.expenseSendMgrDelete,
//   //             duration: const Duration(milliseconds: 3000),
//   //           );
//   //         }else if(action == "EDIT") {
//   //           EasyLoading.showToast(
//   //             Constants.expenseSendMgrEdit,
//   //             duration: const Duration(milliseconds: 3000),
//   //           );
//   //         }else {
//   //           EasyLoading.showToast(
//   //             Constants.expenseSendMgr,
//   //             duration: const Duration(milliseconds: 3000),
//   //           );
//   //         }
//   //       });
//   //       setState(() {
//   //         // getARBSalesItemPurList();
//   //       });
//   //     }
//   //   } else {
//   //     print("Error ARBSalesAddEdit: ${response.statusCode} - ${response.body}");
//   //     EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
//   //   }
//   // }
//
//
// //   Future<void> SqcRegisterAddEditForMob(int SQCId, String action, {File? mediaFile}) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     String? distributorId = prefs.getString('DistributorId');
// //     String? bearerToken = prefs.getString('token');
// //     String? staffId = prefs.getString('StaffId');
// //
// //     int addedBys = int.parse(staffId!);
// //
// //     // Read your controllers
// //     String tController = tareController.text;
// //     String gController = grossController.text;
// //     String oController = observedController.text;
// //     String vController = variationController.text;
// //     String dptController = prefixController.text;
// //     String serialController = serialNoController.text;
// //     String remarkController = remarksController.text;
// //
// //
// //
// //     try {
// //       // Prepare multipart request
// //       // var request = http.MultipartRequest(
// //       //   'POST',
// //       //   Uri.parse(AppUrl.SQCFilledCylAddEdit),
// //       // );
// //       //
// //       // request.headers['Authorization'] = "Bearer $bearerToken";
// //       //
// //       // // Add form fields
// //       // request.fields.addAll({
// //       //   "SQCId": SQCId.toString(),
// //       //   "DistributorId": distributorId!,
// //       //   "GodownId": godownId.toString(),
// //       //   "ReceiptDate": formattedDate ?? '',
// //       //   "VehicleNo": vehicleNo ?? '',
// //       //   "ItemId": selectedItemId.toString(),
// //       //   "TareWt": tController,
// //       //   "GrossWt": gController,
// //       //   "ObservedWt": oController,
// //       //   "Variation": vController,
// //       //   "DPTDate": dptController,
// //       //   "SealingCond": selectedSealingCondition ?? "",
// //       //   "Leakage": selectedLeak ?? "",
// //       //   "LeakyBdy": "1",
// //       //   "SerialNo": serialController,
// //       //   "Remarks": remarkController,
// //       //   "UpdatedBy": "dfd",
// //       //   "AddedBy": addedBys.toString(),
// //       //   "Platform": "MOB",
// //       //   "Action": action,
// //       // });
// //       //
// //       // // Add file if provided
// //       // if (mediaFile != null) {
// //       //   request.files.add(await http.MultipartFile.fromPath(
// //       //     "UploadFileName",
// //       //     mediaFile.path,
// //       //   ));
// //       // }
// //       //
// //       // // Send request
// //       // var response = await request.send();
// //       // var responseBody = await response.stream.bytesToString();
// //       //
// //       // print("Status Code: ${response.statusCode}");
// //       // print("Response: $responseBody");
// //
// //       File mediaFile = File(r"C:\Users\user\Pictures\exception.png");
// //
// //       if (!await mediaFile.exists()) {
// //         print("File not found at path: ${mediaFile.path}");
// //         EasyLoading.showToast("File not found. Please check the path.");
// //         return;
// //       }
// //
// //       var request = http.MultipartRequest(
// //         'POST',
// //         Uri.parse(AppUrl.SQCFilledCylAddEdit),
// //       );
// //
// //       request.headers['Authorization'] = "Bearer $bearerToken";
// //
// // // Add all your fields
// //       request.fields.addAll({
// //         "SQCId": SQCId.toString(),
// //         "DistributorId": distributorId!,
// //         "GodownId": godownId.toString(),
// //         "ReceiptDate": formattedDate ?? "",
// //         "VehicleNo": vehicleNo ?? "",
// //         "ItemId": selectedItemId.toString(),
// //         "TareWt": tController ?? "",
// //         "GrossWt": gController ?? "",
// //         "ObservedWt": oController ?? "",
// //         "Variation": vController ?? "",
// //         "DPTDate": dptController ?? "",
// //         "SealingCond": selectedSealingCondition ?? "",
// //         "Leakage": selectedLeak ?? "",
// //         "LeakyBdy": "1",
// //         "SerialNo": serialController ?? "",
// //         "Remarks": remarkController ?? "",
// //         "UpdatedBy": "dfd",
// //         "AddedBy": addedBys.toString(),
// //         "Platform": "MOB",
// //         "Action": action,
// //       });
// //
// //       request.files.add(
// //         await http.MultipartFile.fromPath(
// //           "UploadFileName",
// //           mediaFile.path,
// //           contentType: MediaType('image', 'png'),
// //         ),
// //       );
// //
// // // Send request
// //       var response = await request.send();
// //       var responseBody = await response.stream.bytesToString();
// //
// //       print("Status Code: ${response.statusCode}");
// //       print("Response: $responseBody");
// //
// //       if (response.statusCode == 200) {
// //         if (responseBody == '0') {
// //           EasyLoading.showToast("Something went wrong. Please try again.",
// //               duration: const Duration(milliseconds: 3000));
// //         } else {
// //           Navigator.pushNamed(context as BuildContext, SQCRegisterScreen.screenName);
// //           Future.delayed(const Duration(milliseconds: 300), () {
// //             if (action == "DELETE") {
// //               EasyLoading.showToast(Constants.expenseSendMgrDelete);
// //             } else if (action == "EDIT") {
// //               EasyLoading.showToast(Constants.expenseSendMgrEdit);
// //             } else {
// //               EasyLoading.showToast(Constants.expenseSendMgr);
// //             }
// //           });
// //           setState(() {});
// //         }
// //       } else {
// //         EasyLoading.showToast(
// //             "Request failed. Please try again.",
// //             duration: const Duration(milliseconds: 3000));
// //       }
// //     } catch (e) {
// //       print("Error: $e");
// //       EasyLoading.showToast("Something went wrong. Please try again.",
// //           duration: const Duration(milliseconds: 3000));
// //     }
// //   }
//
//   // Future<void> SqcRegisterAddEditForMob(String action, {File? mediaFile}) async {
//   //
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? distributorId = prefs.getString('DistributorId');
//   //   String? bearerToken = prefs.getString('token');
//   //   String? staffId = prefs.getString('StaffId');
//   //   String? userId = prefs.getString("UserId");
//   //   int? addedBys = int.parse(staffId!);
//   //   int? distributorIds = int.parse(distributorId!);
//   //
//   //   String? tController;
//   //   String? gController;
//   //   String? oController;
//   //   String? vController;
//   //   String? dptController;
//   //   String? serialController;
//   //   String? remarkController;
//   //
//   //
//   //   if (tareController.text.isNotEmpty) {
//   //     tController = tareController.text;
//   //   }
//   //
//   //   if (grossController.text.isNotEmpty) {
//   //     gController = grossController.text;
//   //   }
//   //   if (observedController.text.isNotEmpty) {
//   //     oController = observedController.text;
//   //   }
//   //   if (variationController.text.isNotEmpty) {
//   //     vController = variationController.text;
//   //   }
//   //   if (prefixController.text.isNotEmpty) {
//   //     dptController = prefixController.text;
//   //   }
//   //   if (serialNoController.text.isNotEmpty) {
//   //     serialController = serialNoController.text;
//   //   }
//   //   if (remarksController.text.isNotEmpty) {
//   //     remarkController = remarksController.text;
//   //   }
//   //
//   //   final Map<String, dynamic> requestBody =
//   //   {
//   //     // "SQCId": SQCId,
//   //     "DistributorId":distributorId,
//   //     "GodownId": godownId,
//   //     "ReceiptDate": formattedDate,
//   //     "VehicleNo": vehicleNo,
//   //     "ItemId": selectedItemId,
//   //     "TareWt": tController,
//   //     "GrossWt": gController,
//   //     "ObservedWt": oController,
//   //     "Variation": vController,
//   //     "DPTDate": dptController,
//   //     "SealingCond": selectedSealingCondition ,
//   //     "Leakage": selectedLeak,
//   //     // "LeakyBdy": selectedLeaky,
//   //     "LeakyBdy": 1,
//   //     "SerialNo":serialController,
//   //     "Remarks":remarkController,
//   //     // "UploadFileName": mediaFile != null ? mediaFile.path.split('/').last : null,
//   //     "UploadFileName": "ABCD",
//   //     "UpdatedBy":"dfd",
//   //     "AddedBy": addedBys,
//   //     "Platform": 'MOB',
//   //     "Action": action,
//   //   };
//   //   print("DepositCashAddEdit: ${requestBody}");
//   //   requestBody.forEach((key, value) {
//   //     print('$key: $value');
//   //   });
//   //   // try {
//   //   final response = await http.post(
//   //     Uri.parse('${AppUrl.SQCFilledCylAddEdit}'),
//   //     headers: {
//   //       "Content-Type": "application/json",
//   //       "Authorization": "Bearer $bearerToken",
//   //     },
//   //     body: json.encode(requestBody),
//   //   );
//   //
//   //   print(
//   //       "requestBody SQCFilledCylAddEdit: ${response.statusCode} - ${response.request}${requestBody}");
//   //
//   //   print("Response Status Code: ${response.statusCode}");
//   //   print("Response SQCFilledCylAddEdit: ${response.body}");
//   //
//   //   if (response.statusCode == 200) {
//   //     if (response.body == '0') {
//   //       // Show a user-friendly error if the response body is 0
//   //       EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
//   //       print("Error: Response returned 0");
//   //     } else {
//   //
//   //       print("Response SQCFilledCylAddEdit: ${response.body}");
//   //
//   //       Navigator.pushNamed(
//   //         context as BuildContext,
//   //         SQCRegisterScreen.screenName,
//   //       );
//   //
//   //       Future.delayed(Duration(milliseconds: 300), () {
//   //         if (action == "DELETE") {
//   //           EasyLoading.showToast(
//   //             Constants.expenseSendMgrDelete,
//   //             duration: const Duration(milliseconds: 3000),
//   //           );
//   //         }else if(action == "EDIT") {
//   //           EasyLoading.showToast(
//   //             Constants.expenseSendMgrEdit,
//   //             duration: const Duration(milliseconds: 3000),
//   //           );
//   //         }else {
//   //           EasyLoading.showToast(
//   //             Constants.expenseSendMgr,
//   //             duration: const Duration(milliseconds: 3000),
//   //           );
//   //         }
//   //       });
//   //       setState(() {
//   //         // getARBSalesItemPurList();
//   //       });
//   //     }
//   //   } else {
//   //     print("Error ARBSalesAddEdit: ${response.statusCode} - ${response.body}");
//   //     EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
//   //   }
//   // }
//
//   // Future<void> SqcRegisterAddEditForMob(BuildContext context,
//   //     int SQCId, String action, {File? mediaFile}) async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? distributorId = prefs.getString('DistributorId');
//   //   String? bearerToken = prefs.getString('token');
//   //   String? staffId = prefs.getString('StaffId');
//   //   int addedBys = int.parse(staffId!);
//   //
//   //   String? tController;
//   //   String? gController;
//   //   String? oController;
//   //   String? vController;
//   //   String? dptController;
//   //   String? serialController;
//   //   String? remarkController;
//   //   String? vehicleController;
//   //
//   //
//   //   if (tareController.text.isNotEmpty) {
//   //     tController = tareController.text;
//   //   }
//   //
//   //   if (vehicleNoController.text.isNotEmpty) {
//   //     vehicleController = vehicleNoController.text;
//   //   }
//   //
//   //   if (grossController.text.isNotEmpty) {
//   //     gController = grossController.text;
//   //   }
//   //   if (observedController.text.isNotEmpty) {
//   //     oController = observedController.text;
//   //   }
//   //   if (variationController.text.isNotEmpty) {
//   //     vController = variationController.text;
//   //   }
//   //   if (prefixController.text.isNotEmpty) {
//   //     dptController = prefixController.text;
//   //   }
//   //   if (serialNoController.text.isNotEmpty) {
//   //     serialController = serialNoController.text;
//   //   }
//   //   if (remarksController.text.isNotEmpty) {
//   //     remarkController = remarksController.text;
//   //   }
//   //
//   //   if (_selectedItemModel == null) {
//   //     showFlushBar(context, "Please Select Item");
//   //     return;
//   //   }
//   //
//   //   if (!tareController.text.isNotEmpty) {
//   //     showFlushBar(context, "please enter Tare weight");
//   //     return;
//   //   }
//   //
//   //
//   //   if (!observedController.text.isNotEmpty) {
//   //     showFlushBar(context, "please Enter Observed weight");
//   //     return;
//   //   }
//   //
//   //   if (!prefixController.text.isNotEmpty) {
//   //     showFlushBar(context, "please Enter DPT Date");
//   //     return;
//   //   }
//   //
//   //
//   //   if (selectedSealingCondition == null || selectedSealingCondition!.isEmpty) {
//   //     showFlushBar(context, "Please Select Sealing Condition");
//   //     return;
//   //   }
//   //
//   //   // if (selectedLeak == null || selectedLeak!.isEmpty) {
//   //   //   showFlushBar(context, "Please Select Leaky Option");
//   //   //   return;
//   //   // }
//   //   //
//   //   // if (selectedLeak == "Yes") {
//   //   //   if (selecteddesignation == null) {
//   //   //     showFlushBar(context, "Please Select Leakage Type");
//   //   //     return;
//   //   //   }
//   //   // }
//   //
//   //   if (selectedLeak == null || selectedLeak!.isEmpty) {
//   //     showFlushBar(context, "Please Select Leaky Option");
//   //     return;
//   //   }
//   //
//   //   if (selectedLeak == "Yes" && selecteddesignation == null) {
//   //     showFlushBar(context, "Please Select Leakage Type");
//   //     return;
//   //   }
//   //
//   //   if (!serialNoController.text.isNotEmpty) {
//   //     showFlushBar(context, "please Enter Serial Number");
//   //     return;
//   //   }
//   //
//   //   // Initialize multipart request
//   //   final request = http.MultipartRequest(
//   //       'POST', Uri.parse(AppUrl.SQCFilledCylAddEdit));
//   //
//   //   request.headers['Authorization'] = 'Bearer $bearerToken';
//   //
//   //   // Add fields
//   //   request.fields.addAll({
//   //     "SQCId": SQCId.toString(),
//   //     "DistributorId": distributorId!,
//   //     "GodownId": godownId.toString(),
//   //     "ReceiptDate": formattedDate ?? '',
//   //     "VehicleNo": vehicleController ?? '',
//   //     "ItemId": selectedItemIddd.toString(),
//   //     "TareWt": tController ?? '',
//   //     "GrossWt":gController ?? '',
//   //     "ObservedWt": oController ?? '',
//   //     "Variation":vController ?? '',
//   //     "DPTDate": dptController ?? '',
//   //     "SerialNo":serialController ?? '',
//   //     "Remarks": remarkController ?? '',
//   //     "SealingCond": selectedSealingCondition ?? '',
//   //     "Leakage": selectedLeak ?? '',
//   //     // "LeakyBdy": selectedItemIdd.toString() ?? '',
//   //     "LeakyBdy": selectedItemIdd?.toString() ?? '',
//   //     "UpdatedBy": addedBys.toString(),
//   //     "AddedBy": addedBys.toString(),
//   //     "Platform": "MOB",
//   //     "Action": action,
//   //     // // Add optional numeric/text fields only if available
//   //     // if (tareController.text.isNotEmpty)
//   //     //   "TareWt": tareController.text,
//   //     // if (grossController.text.isNotEmpty)
//   //     //   "GrossWt": grossController.text,
//   //     // if (observedController.text.isNotEmpty)
//   //     //   "ObservedWt": observedController.text,
//   //     // if (variationController.text.isNotEmpty)
//   //     //   "Variation": variationController.text,
//   //     // if (prefixController.text.isNotEmpty)
//   //     //   "DPTDate": prefixController.text,
//   //     // if (serialNoController.text.isNotEmpty)
//   //     //   "SerialNo": serialNoController.text,
//   //     // if (remarksController.text.isNotEmpty)
//   //     //   "Remarks": remarksController.text,
//   //   });
//   //
//   //   // Attach file if exists
//   //   if (mediaFile != null) {
//   //     final mimeTypeData =
//   //         lookupMimeType(mediaFile.path)?.split('/') ?? ['application', 'octet-stream'];
//   //
//   //     request.files.add(await http.MultipartFile.fromPath(
//   //       'UploadFile',
//   //       mediaFile.path,
//   //       contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
//   //     ));
//   //
//   //   }
//   //   try {
//   //
//   //     debugPrint("===== SQC API REQUEST =====");
//   //
//   //     debugPrint("URL: ${request.url}");
//   //
//   //     debugPrint("Headers:");
//   //     request.headers.forEach((k, v) => debugPrint("$k : $v"));
//   //
//   //     debugPrint("Fields:");
//   //     request.fields.forEach((k, v) => debugPrint("$k : $v"));
//   //
//   //     debugPrint("Files:");
//   //     for (var file in request.files) {
//   //       debugPrint("Field: ${file.field}");
//   //       debugPrint("FileName: ${file.filename}");
//   //       debugPrint("ContentType: ${file.contentType}");
//   //     }
//   //
//   //     debugPrint("===========================");
//   //     final streamedResponse = await request.send();
//   //     final response = await http.Response.fromStream(streamedResponse);
//   //
//   //     debugPrint("Response Status: ${response.statusCode}");
//   //     debugPrint("Response Body: ${response.body}");
//   //
//   //     if (response.statusCode == 200 && response.body != '0') {
//   //       EasyLoading.showToast("SQC data added successfully",
//   //           duration: const Duration(seconds: 2));
//   //       // Navigator.pushNamed(context as BuildContext, SQCRegisterScreen.screenName);
//   //       Navigator.pushNamed(
//   //         context,
//   //         ItemReturnScreen.screenName,
//   //       );
//   //       setState(() {
//   //         fetchItemSQCAddEditList(context);
//   //       });
//   //     } else {
//   //       EasyLoading.showToast("Failed to add SQC data",
//   //           duration: const Duration(seconds: 2));
//   //     }
//   //   } catch (e) {
//   //     debugPrint("Error uploading SQC: $e");
//   //     EasyLoading.showToast("Something went wrong", duration: const Duration(seconds: 2));
//   //   }
//   // }
//
//   Future<bool> SqcRegisterAddEditForMob(
//       BuildContext context,
//       Map<String, dynamic> item,
//       int SQCId,
//       String action,
//       ) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken = prefs.getString('token');
//       String? staffId = prefs.getString('StaffId');
//       int addedBys = int.parse(staffId!);
//
//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse(AppUrl.SQCFilledCylAddEdit),
//       );
//
//       request.headers['Authorization'] = 'Bearer $bearerToken';
//
//       // Add all item fields
//       request.fields.addAll({
//         "SQCId": SQCId.toString(),
//         "DistributorId": distributorId ?? '',
//         "GodownId": item["GodownId"] ?? '',
//         "ReceiptDate": item["ReceiptDate"] ?? '',
//         "VehicleNo": item["VehicleNo"] ?? '',
//         "ItemId": item["ItemId"] ?? '',
//         "TareWt": item["TareWt"] ?? '',
//         "GrossWt": item["GrossWt"] ?? '',
//         "ObservedWt": item["ObservedWt"] ?? '',
//         "Variation": item["Variation"] ?? '',
//         "DPTDate": item["DPTDate"] ?? '',
//         "SerialNo": item["SerialNo"] ?? '',
//         "Remarks": item["Remarks"] ?? '',
//         "SealingCond": item["SealingCond"] ?? '',
//         "Leakage": item["Leakage"] ?? '',
//         "LeakyBdy": item["LeakyBdy"] ?? '',
//         "UpdatedBy": addedBys.toString(),
//         "AddedBy": addedBys.toString(),
//         "Platform": "MOB",
//         "Action": action,
//       });
//
//       // Attach file if available
//       File? file = item["file"];
//       if (file != null) {
//         debugPrint("File path to upload: ${file.path}");
//         final mimeTypeData =
//             lookupMimeType(file.path)?.split('/') ?? ['application', 'octet-stream'];
//
//         request.files.add(await http.MultipartFile.fromPath(
//           'UploadFile',
//           file.path,
//           contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
//         ));
//       }
//
//       debugPrint("----- REQUEST BODY -----");
//       request.fields.forEach((key, value) {
//         debugPrint("$key : $value");
//       });
//
//       final response = await http.Response.fromStream(await request.send());
//
//       debugPrint("Response Status: ${response.statusCode}");
//       debugPrint("Response Body: ${response.body}");
//
//       if (response.statusCode == 200 && response.body != '0') {
//         debugPrint("Item uploaded successfully: ${item["ItemId"]}");
//         return true;
//       } else {
//         debugPrint("Failed to upload item: ${item["ItemId"]}, Response: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       debugPrint("Error uploading item: $e");
//       return false;
//     }
//   }
//
//   Future<void> getDesignationList() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken =
//     prefs.getString('token'); // Assuming the token is stored here
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//     };
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetDesignationList}/1/LeakageType'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetDesignationList : " +
//         '${AppUrl.GetDesignationList}/1/LeakageType');
//     debugPrint("GetDesignationList : " + '${response.body}');
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       setState(() {
//         getdesignationListmodel = data.map((json) => GetDesignationListModel.fromJson(json)).toList();
//
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
//     EasyLoading.instance
//       ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
//       ..loadingStyle = EasyLoadingStyle.light
//       ..dismissOnTap = false // Disable dismissing the loader by tapping
//       ..userInteractions = false;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     int? distributorIds = int.parse(distributorId!);
//     try {
//       final response = await http.get(
//         Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken",
//           // Pass bearer token in headers
//         },
//       );
//       debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
//       debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
//       if (response.statusCode == 200) {
//         List<dynamic> apiResponse = json.decode(response.body);
//         if (apiResponse.isEmpty) {
//           saveFlag = false;
//           print("The list is empty, no data to save.");
//         } else {
//           saveFlag = true;
//           var dayEndData = apiResponse[0];
//           int DSRSaved = dayEndData['DSRSaved'] ?? 0;
//           int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
//           int OpClSaved = dayEndData['OpClSaved'] ?? 0;
//
//         }
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
//
//   // Future<void> fetchItemSQCAddEditList(BuildContext context) async {
//   //   Constants.isNetworkAvailable =
//   //   await InternetConnectionChecker().hasConnection;
//   //   if (!Constants.isNetworkAvailable) {
//   //     showFlushBar(context, Constants.connectionMessage);
//   //     return;
//   //   }
//   //
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? distributorId = prefs.getString('DistributorId');
//   //   String? token = prefs.getString('token'); // Bearer token
//   //
//   //   if (distributorId == null || distributorId.isEmpty) {
//   //     showFlushBar(context, "Distributor ID is missing.");
//   //     return;
//   //   }
//   //   if (token == null || token.isEmpty) {
//   //     showFlushBar(context, "Authentication token is missing.");
//   //     return;
//   //   }
//   //
//   //   final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//   //
//   //   try {
//   //     // Construct JSON body
//   //     final Map<String, String> requestBody = {
//   //       "DistributorId": distributorId,
//   //       "FromDate": formattedDate,
//   //       "ToDate": formattedDate,
//   //     };
//   //
//   //     print("Request body: $requestBody");
//   //
//   //     final response = await http.post(
//   //       Uri.parse('${AppUrl.GetSQCFilledCylList}'),
//   //       headers: {
//   //         "Content-Type": "application/json",
//   //         "Authorization": "Bearer $token",
//   //       },
//   //       body: json.encode(requestBody),
//   //     );
//   //
//   //     print("API Status: ${response.statusCode}");
//   //     print("API Response: ${response.body}");
//   //
//   //     if (response.statusCode == 200) {
//   //       final List<dynamic> data = json.decode(response.body);
//   //       setState(() {
//   //         receiptList =
//   //             data.map((json) => GetSqcFilledCylListModel.fromJson(json)).toList();
//   //         isLoading = false;
//   //       });
//   //     } else {
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //       showFlushBar(context, Constants.listGettingFail);
//   //     }
//   //   } catch (e) {
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //     print("Error fetching SQC list: $e");
//   //     showFlushBar(context, Constants.listGettingFail);
//   //   }
//   // }
//
//   Future<void> fetchItemSQCAddEditList(BuildContext context) async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (!Constants.isNetworkAvailable) {
//       showFlushBar(context, Constants.connectionMessage);
//       return;
//     }
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? token = prefs.getString('token'); // Bearer token
//
//     if (distributorId == null || distributorId.isEmpty) {
//       showFlushBar(context, "Distributor ID is missing.");
//       return;
//     }
//     if (token == null || token.isEmpty) {
//       showFlushBar(context, "Authentication token is missing.");
//       return;
//     }
//
//     final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//
//     try {
//       // Construct JSON body
//       final Map<String, String> requestBody = {
//         "DistributorId": distributorId,
//         "FromDate": formattedDate,
//         "ToDate": formattedDate,
//       };
//
//       print("Request body: $requestBody");
//
//       final response = await http.post(
//         Uri.parse('${AppUrl.GetSQCFilledCylList}'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: json.encode(requestBody),
//       );
//
//       print("API Status: ${response.statusCode}");
//       print("API Response GetSQCFilledCylList: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         setState(() {
//           receiptList =
//               data.map((json) => GetSqcFilledCylListModel.fromJson(json)).toList();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         showFlushBar(context, Constants.listGettingFail);
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print("Error fetching SQC list: $e");
//       showFlushBar(context, Constants.listGettingFail);
//     }
//   }
//   Future<void> _initializeNetworkVideo(String url) async {
//     print("Initializing video controller with URL: $url");
//     try {
//       _videoController?.dispose();
//
//       _videoController = VideoPlayerController.network(url);
//
//       await _videoController!.initialize();
//       print("Video initialized");
//
//       _videoController!.setLooping(true);
//       _videoController!.play();
//
//       setState(() {});
//     } catch (e) {
//       print("Error initializing video: $e");
//     }
//   }
//   // Future<void> loadUploadedVideo() async {
//   //   await fetchItemSQCAddEditList(this.context); // sets uploadedFileUrl internally
//   //
//   //   // Now uploadedFileUrl is set
//   //   if (uploadedFileUrl != null) {
//   //     print("Initializing video controller for: $uploadedFileUrl");
//   //     _initializeNetworkVideo(uploadedFileUrl!);
//   //   }
//   //   // if (uploadedFileUrl != null) {
//   //   //   String videoUrl = uploadedFileUrl!.replaceFirst("https://", "http://");
//   //   //
//   //   //   print("Using video URL: $videoUrl");
//   //   //
//   //   //   _initializeNetworkVideo(videoUrl);
//   //   // }
//   // }
//
//   Future<void> loadUploadedVideo() async {
//     await fetchItemSQCAddEditList(this.context);
//
//     if (uploadedFileUrl == null) return;
//
//     final url = uploadedFileUrl!;
//     print("Received URL: $url");
//
//     if (_isVideo(url)) {
//       print("Valid video → initializing player");
//       await _initializeNetworkVideo(url);
//     } else {
//       print("Not a video → skipping player init");
//     }
//   }
//
//   final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
//
//   bool _isVideo(String url) {
//     final lowerUrl = url.toLowerCase();
//
//     return videoExtensions.any((ext) => lowerUrl.endsWith('.$ext'));
//   }
//
//
//   void addItem() {
//     // Validate required fields before adding
//     if (_selectedItemModel == null) {
//       showFlushBar(this.context, "Please Select An Item");
//       return;
//     }
//     if (tareController.text.isEmpty) {
//       showFlushBar(this.context, "Please Enter Tare Weight");
//       return;
//     }
//     if (observedController.text.isEmpty) {
//       showFlushBar(this.context, "Please Enter Observed Weight");
//       return;
//     }
//     if (prefixController.text.isEmpty) {
//       showFlushBar(this.context, "Please Enter DPT Date");
//       return;
//     }
//     if (selectedSealingCondition == null || selectedSealingCondition!.isEmpty) {
//       showFlushBar(this.context, "Please Select Sealing Condition");
//       return;
//     }
//     if (selectedLeak == null || selectedLeak!.isEmpty) {
//       showFlushBar(this.context, "Please Select Leakage Option");
//       return;
//     }
//     if (selectedLeak == "Yes" && selecteddesignation == null) {
//       showFlushBar(this.context, "Please Select Leakage Type");
//       return;
//     }
//     if (serialNoController.text.isEmpty) {
//       showFlushBar(this.context, "Please Enter Serial Number");
//       return;
//     }
//
//     if (sqcItemList.length >= 10) {
//       ScaffoldMessenger.of(this.context).showSnackBar(
//         const SnackBar(content: Text("Max 10 Items Allowed")),
//       );
//       return;
//     }
//
//
//     Map<String, dynamic> item = {
//       "GodownId": godownId.toString(),
//       "ReceiptDate": formattedDate ?? '',
//       "VehicleNo": vehicleNoController.text,
//       "ItemId": selectedItemIddd.toString(),
//       "TareWt": tareController.text,
//       "GrossWt": grossController.text,
//       "ObservedWt": observedController.text,
//       "Variation": variationController.text,
//       "DPTDate": prefixController.text,
//       "SerialNo": serialNoController.text,
//       "Remarks": remarksController.text,
//       "SealingCond": selectedSealingCondition ?? '',
//       "Leakage": selectedLeak ?? '',
//       "LeakyBdy": selectedItemIdd?.toString() ?? '',
//       "file": selectedFile ?? selectedZip, // attach uploaded file
//     };
//
//     setState(() {
//       sqcItemList.add(item);
//     });
//
//
//     clearForm();
//   }
//
//   Future<void> sendAllSQCItems() async {
//     if (sqcItemList.isEmpty) {
//       showFlushBar(this.context, "No Items To Upload");
//       return;
//     }
//
//     EasyLoading.show(status: "Uploading Items...");
//
//     bool allSuccess = true;
//
//     for (var item in sqcItemList) {
//       bool success = await SqcRegisterAddEditForMob(this.context, item, 0, "ADD");
//       if (!success) {
//         allSuccess = false;
//       }
//     }
//
//     EasyLoading.dismiss();
//
//     if (allSuccess) {
//       EasyLoading.showToast("All Items Uploaded Successfully");
//       setState(() {
//         sqcItemList.clear();
//       });
//     } else {
//       EasyLoading.showToast("Items Failed To Upload");
//     }
//   }
//
//   void clearForm() {
//     tareController.clear();
//     grossController.clear();
//     observedController.clear();
//     variationController.clear();
//     prefixController.clear();
//     serialNoController.clear();
//     remarksController.clear();
//
//     setState(() {
//       _selectedItemModel = null;
//       selectedSealingCondition = null;
//       selectedLeak = null;
//       selecteddesignation = null;
//       selectedFile = null;
//       uploadedFileUrl = null;
//       selectedZip = null;
//       if (_videoController != null) {
//         _videoController!.dispose();
//         _videoController = null;
//       }
//     });
//   }
//
// }
//


import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../ConstantScreen/widgets.dart';
import '../../ManagerScreen/GetDesignationListModel.dart';
import '../../ManagerScreen/SVSaleModel/GetRSPDetailsListModel.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../BottomNavigationForGodownKeeper.dart';
import '../ItemReceipt/CylItemList/CylItemListModel.dart';

import '../ItemReceipt/ItemReturn/ItenRetun.dart';
import 'GetSQCFilledCylListModel.dart';
const int maxFileSize = 5 * 1024 * 1024; // 5MB

class SQCRegisterScreen extends StatefulWidget {
  static const screenName = '/sqcregisterScreen';

  const SQCRegisterScreen({super.key});

  @override
  State<SQCRegisterScreen> createState() =>
      _SQCRegisterScreenState();
}

class _SQCRegisterScreenState extends State<SQCRegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // TextEditingController tareController = TextEditingController();
  final tareController = TextEditingController();
  final grossController = TextEditingController();
  final observedController = TextEditingController();
  final variationController = TextEditingController();
  final serialNoController = TextEditingController();
  final remarksController = TextEditingController();
  final TextEditingController vehicleNoController = TextEditingController();
  late var prefixController = TextEditingController();
  String? _selectedItem;
  int? selectedItemId;
  String? selectedItemNamee;
  bool _isinvoiceEmpty = false;
  String? selectedDptDate;
  List<String> regulatorReceived = ["Yes", "No"];
  String? selectedSealingCondition;
  List<String> leakReceived = ["Yes", "No"];
  String? selectedLeak;
  String? selectedLeaky;
  String? formattedDate;
  String? tareError;
  String? obsError;
  bool saveFlag = false;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String selectedWeight = "14.2KG";
  double _selectedItemWeight = 0.0;
  File? selectedFile;
  VideoPlayerController? _videoController;
  File? selectedZip;
  double grossWeight = 0.0;
  double observedWeight = 0.0;
  String? godownId;
  String? vehicleNo;
  List<GetDesignationListModel> getdesignationListmodel = [];
  GetDesignationListModel? selecteddesignation;
  int? selectedItemIdd;
  String? selectedItemName;
  List<GetSqcFilledCylListModel> receiptList = [];
  bool isLoading = true;
  var argValue;
  String? modes;
  int? SQCIdEdit;
  String? uploadedFileUrl;
  List<String> itemIds = [];
  List<String> itemNames = [];
  String? selectedItemNameee;
  int? selectedItemIddd;
  String? _selectedItemModel;
  List<Map<String, dynamic>> sqcItemList = [];
  late Map<String, dynamic> editItem;

  // @override
  // void dispose() {
  //   _videoController?.dispose();
  //   super.dispose();
  // }

  void calculateObserved() {
    double gross = double.tryParse(grossController.text) ?? 0.0;
    double tar = double.tryParse(tareController.text) ?? 0.0;

    double result = gross - tar;

    setState(() {
      observedController.text = result.toStringAsFixed(3);
    });
  }

  void calculateVariation() {
    grossWeight = double.tryParse(grossController.text) ?? 0.0;
    observedWeight = double.tryParse(observedController.text) ?? 0.0;

    double variation = grossWeight - observedWeight;

    setState(() {
      variationController.text = variation.toStringAsFixed(3);
    });
  }

  final prefixFormatter = TextInputFormatter.withFunction(
        (oldValue, newValue) {
      String text = newValue.text.toUpperCase();

      if (text.isEmpty) {
        return TextEditingValue(
          text: '',
          selection: TextSelection.collapsed(offset: 0),
        );
      }

      //First character must be A-Z
      String firstChar = text[0];
      if (!RegExp(r'[A-D]').hasMatch(firstChar)) {
        return oldValue; // Ignore invalid first character
      }

      // Extract the rest and keep only digits
      String digits = '';
      if (text.length > 1) {
        digits = text.substring(1).replaceAll(RegExp(r'[^0-9]'), '');
        if (digits.length > 2) digits = digits.substring(0, 2); // max 2 digits
      }

      String formatted = firstChar;
      if (digits.isNotEmpty) formatted += "-$digits";

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    },
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prefixController = TextEditingController();
    DateTime now = DateTime.now().toUtc();
    formattedDate = now.toIso8601String();
    print(formattedDate);
    print("wqdf$formattedDate");
    getDesignationList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(this.context)?.settings.arguments as Map?;

      fetchItemSQCAddEditList(this.context);

      loadUploadedVideo();
      checkAndSaveDayEndData();

      if (args != null) {
        vehicleNoController.text = args['vehicleNo']?.toString() ?? '';
        godownId = args['godownId'] ?? '';

        itemIds = List<String>.from(args['itemIds'] ?? []);
        itemNames = List<String>.from(args['itemNames'] ?? []);


        for (int i = 0; i < itemIds.length; i++) {
          print("ID: ${itemIds[i]}, Name: ${itemNames[i]}");
        }
      }
    });

    Future.delayed(Duration.zero, ()  async {
      argValue = ModalRoute.of(this.context)?.settings.arguments as Map?;
      modes = argValue?["modeChange"] ?? '';
      print("modes value: $modes");
      if (argValue != null) {
        SQCIdEdit = int.tryParse((argValue["sqcIDV"] ?? "0").toString());
        String itemIdEdit = (argValue["itemIdV"] ?? "").toString();
        String itemNameEdit = (argValue["itemNameV"] ?? "").toString();
        String tareWtEdit = (argValue["tareWtV"] ?? "").toString();
        String grossWtEdit = (argValue["grossWtV"] ?? "").toString();
        String observedWtEdit = argValue["observedWtV"]?.toString() ?? '';
        String variationEdit = (argValue["variationV"] ?? 0).toString();
        String dptDateEdit = (argValue["dptDateV"] ?? "").toString();
        String sealingEdit = (argValue["sealingV"] ?? "").toString();
        String leakyEdit = (argValue["laekyV"] ?? "").toString();
        String leakTypeEdit = (argValue["leakTypeV"] ?? "").toString();
        String leaktTypeIdEdit = (argValue["leakTypeIdV"] ?? "").toString();
        String serialNoEdit = (argValue["serialNoV"] ?? "").toString();
        String remarkEdit = (argValue["remarkV"] ?? "").toString();
        String fileUploadEdit = (argValue["fileUploadV"] ?? "").toString();

        if (modes == "Edit") {
          if (mounted) {
            setState(() {
              selectedSealingCondition = sealingEdit == "Y" ? "Yes" : "No";
              selectedLeak = leakyEdit == "Y" ? "Yes" : "No";

              sqcItemList = [{
                "GodownId": godownId, // Ensure this variable is already set
                "ReceiptDate": dptDateEdit,
                "VehicleNo": vehicleNo, // Ensure this variable is already set
                "ItemId": itemIdEdit,
                "TareWt": tareWtEdit,
                "GrossWt": grossWtEdit,
                "ObservedWt": observedWtEdit,
                "Variation": variationEdit,
                "DPTDate": dptDateEdit,
                "SerialNo": serialNoEdit,
                "Remarks": remarkEdit,
                "SealingCond": sealingEdit == "Y" ? "Yes" : "No",
                "Leakage": leakyEdit == "Y" ? "Yes" : "No",
                "LeakyBdy": leaktTypeIdEdit,
                "file": fileUploadEdit,
              }];
            });
          }
        }

        if (modes == "Edit") {
          selectedSealingCondition = sealingEdit == "Y" ? "Yes" : "No";
          selectedLeak = leakyEdit == "Y" ? "Yes" : "No";


          print("Selected Sealing Condition set to: $selectedSealingCondition");
          print("Selected Leak set to: $selectedLeak");
        } else {
          selectedSealingCondition = null;
          selectedLeak = null;
          print("Not edit mode, Sealing/Leak set to null");
        }

        uploadedFileUrl = fileUploadEdit.isNotEmpty && fileUploadEdit != "0" ? fileUploadEdit : null;

        grossWeight = grossWtEdit.isNotEmpty
            ? double.tryParse(grossWtEdit.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0
            : 0.0;
        observedWeight = observedWtEdit.isNotEmpty
            ? double.tryParse(observedWtEdit.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0
            : 0.0;
        if (argValue != null) {
          String vehicleNoEdit = argValue["vehicleNoV"]?.toString() ?? '';
          String godownIdEdit = argValue["godownIdV"]?.toString() ?? '';
          String itemIdEdit = argValue["itemIdV"]?.toString() ?? '';
          String itemNameEdit = argValue["itemNameV"]?.toString() ?? '';

          // Create lists if empty
          if ((itemIds.isEmpty || itemNames.isEmpty)) {
            if (itemIdEdit.isNotEmpty && itemNameEdit.isNotEmpty) {
              itemIds = [itemIdEdit];
              itemNames = [itemNameEdit];
              print("List created from edit data");
            }
          }

          setState(() {
            if (vehicleNoEdit.isNotEmpty && vehicleNoEdit != "null") {
              vehicleNoController.text = vehicleNoEdit;
            }

            if (godownIdEdit.isNotEmpty && godownIdEdit != "null") {
              godownId = godownIdEdit;
            }

            if (modes == "Edit" && itemNames.isNotEmpty && itemIds.isNotEmpty) {
              int index = itemNames.indexWhere((e) => e == itemNameEdit);

              if (index != -1) {
                _selectedItemModel = itemNames[index];
                selectedItemNameee = itemNames[index];
                selectedItemIddd = int.tryParse(itemIds[index]);
                print("Pre-selected item index: $index");

                // --- ADD THIS LOGIC HERE ---
                // This extracts the weight from "14.2 kg Item"
                RegExp regExp = RegExp(r'(\d+(\.\d+)?)');
                Match? match = regExp.firstMatch(selectedItemNameee!);

                if (match != null) {
                  _selectedItemWeight = double.tryParse(match.group(0)!) ?? 0.0;
                  print("Extracted Weight for Edit: $_selectedItemWeight");
                } else {
                  _selectedItemWeight = 0.0;
                }

                // Now that we have the weight, calculate the Gross
                calculateGross();
              } else {
                _selectedItemModel = null;
                selectedItemNameee = null;
                selectedItemIddd = null;
                print("Edit mode but item not found, dropdown left empty");
              }
            } else {
              _selectedItemModel = null;
              selectedItemNameee = null;
              selectedItemIddd = null;
              print("New entry mode, dropdown left empty");
            }


            print('Selected Item ID: $selectedItemIddd');
            print('Selected Item Name: $selectedItemNameee');
            print('Dropdown model: $_selectedItemModel');
          });
        }
        tareController.text = tareWtEdit;
        grossController.text = grossWtEdit;
        observedController.text = observedWtEdit;
        variationController.text = variationEdit;
        serialNoController.text = serialNoEdit;
        remarksController.text = remarkEdit;
        prefixController.text = dptDateEdit;


        // if (modes == "Edit") {
        //   // Prepare a single item map with existing values
        //   Map<String, dynamic> editItem = {
        //     "GodownId": godownId.toString(),
        //     "ReceiptDate": prefixController.text,
        //     "VehicleNo": vehicleNoController.text,
        //     "ItemId": selectedItemIddd.toString(),
        //     "TareWt": tareController.text,
        //     "GrossWt": grossController.text,
        //     "ObservedWt": observedController.text,
        //     "Variation": variationController.text,
        //     "DPTDate": prefixController.text,
        //     "SerialNo": serialNoController.text,
        //     "Remarks": remarksController.text,
        //     "SealingCond": selectedSealingCondition ?? '',
        //     "Leakage": selectedLeak ?? '',
        //     "LeakyBdy": selectedItemIdd?.toString() ?? '',
        //     "file": uploadedFileUrl,  // or selectedFile if file exists
        //   };
        //
        //   setState(() {
        //     sqcItemList = [editItem]; // Populate list with current item
        //   });
        // }

        await getDesignationList();
        await getDesignationList();
        debugPrint("leaktTypeIdEdit:$leaktTypeIdEdit");
        if (leaktTypeIdEdit != null && leaktTypeIdEdit.isNotEmpty && leaktTypeIdEdit != "null") {
          setState(() {
            selecteddesignation = getdesignationListmodel.firstWhere(
                  (item) => item.designationId.toString() == leaktTypeIdEdit.toString(),
              orElse: () => getdesignationListmodel.first,
            );

            selectedItemName = selecteddesignation?.masterName ?? "";
            selectedItemIdd = selecteddesignation?.designationId?.toInt();

          });
        }
      }

    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void calculateGross() {
    double tareValue = double.tryParse(tareController.text) ?? 0.0;
    if (tareValue == 0.0) {
      grossController.clear();
      return;
    }

    double gross = tareValue + _selectedItemWeight;
    // grossController.text = gross.toStringAsFixed(2);

    setState(() {
      grossController.text = gross.toStringAsFixed(2);
    });

    calculateVariation();
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute
        .of(context)
        ?.settings
        .arguments;

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName);

          return false;
        } else {
          Navigator.pushReplacementNamed(
            context,
            ItemReturnScreen.screenName,
            arguments: argLRAdd, // pass args if needed
          );
        }

        return false;
        // else {
        //   Navigator.pushReplacementNamed(
        //       context, BottomNavigationForGodownKeeper.screenName);
        //   return false;
        // }
        // In case `null` is returned, return `false`
      },
      // onWillPop: () async {
      //   var argLRAdd = ModalRoute.of(context)?.settings.arguments;
      //
      //   if (argLRAdd == "fromDrawer") {
      //     // If coming from drawer, go to BottomNavigation
      //     Navigator.pushReplacementNamed(
      //       context,
      //       BottomNavigationForGodownKeeper.screenName,
      //       arguments: "onBack",
      //     );
      //   } else {
      //     // Otherwise, go to ItemReturnScreen
      //     Navigator.pushReplacementNamed(
      //       context,
      //       ItemReturnScreen.screenName,
      //       arguments: argLRAdd, // pass args if needed
      //     );
      //   }
      //
      //   // Prevent default back behavior
      //   return false;
      // },
      child:
      Scaffold(
        appBar: CustomAppBar(
          title: 'SQC Register', // Title or hint text for the text field
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                        textWidgetBlueColorWithStar(
                          'SQC Vehicle',
                          "*",
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller:vehicleNoController,
                          readOnly: true,
                          decoration: buildInputBorderUpdateStatus1(
                              "Vehicle No", context
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                        textWidgetBlueColorWithStar(
                          'Select Item',
                          "*",
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child:
                        DropdownButtonFormField<String>(
                          value: itemNames.contains(_selectedItemModel) ? _selectedItemModel : null,
                          isDense: true,
                          decoration: buildInputBorderUpdateStatus1(
                              "Select Item", context
                          ),
                          items: itemNames.map((name) {
                            return DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            if (value != null) {
                              setState(() {

                                // clearForm();
                                _selectedItemModel = value;
                                int index = itemNames.indexOf(value);
                                selectedItemIddd = int.tryParse(itemIds[index]);
                                selectedItemNameee = itemNames[index];

                                RegExp regExp = RegExp(r'(\d+(\.\d+)?)');
                                Match? match = regExp.firstMatch(selectedItemNameee!);

                                if (match != null) {
                                  _selectedItemWeight =
                                      double.tryParse(match.group(0)!) ?? 0.0;
                                } else {
                                  _selectedItemWeight = 0.0;
                                }
                                calculateGross();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                        textWidgetBlueColorWithStar(
                          'Tare Weight',
                          "*",
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child:
                        TextFormField(
                          controller: tareController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
                          ],
                          decoration: buildInputBorderUpdateStatus1(
                              "Tare Weight", context),
                          onChanged: (value) {
                            final number = double.tryParse(value);

                            setState(() {
                              if (value.isEmpty) {
                                tareError = "Please enter Tare value";
                              } else if (number == null || number <= 0) {
                                tareError = "Value must be greater than 0";
                              } else {
                                tareError = null;
                              }
                            });

                            calculateGross();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                        textWidgetBlueColorWithStar(
                          'Gross Weight',
                          "*",
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: grossController,
                          readOnly: true,
                          keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,3}'),
                            ),
                          ],
                          decoration: buildInputBorderUpdateStatus1(
                              "Gross Weight", context),
                          onChanged: (_) => calculateVariation(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                        textWidgetBlueColorWithStar(
                          'Observed Weight',
                          "*",
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                            controller: observedController,
                            keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,3}'),
                              ),
                            ],
                            decoration: buildInputBorderUpdateStatus1(
                                "Enter Observed Weight", context,
                                errorText: obsError),
                            onChanged: (value){
                              final number = double.tryParse(value);

                              setState(() {
                                if (value.isEmpty) {
                                  obsError = "Please enter observed value";
                                } else if (number == null || number <= 0) {
                                  obsError = "Value must be greater than 0";
                                } else {
                                  obsError = null;
                                }
                              });
                              calculateVariation();
                            }
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                        textWidgetBlueColorWithStar(
                          'Variation',
                          "*",
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: variationController,
                          readOnly: true,
                          decoration: buildInputBorderUpdateStatus1(
                              "Variation", context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                        textWidgetBlueColorWithStar(
                          'DPT Date.',
                          "*",
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child:
                          TextFormField(
                            controller: prefixController, // Empty initially
                            inputFormatters: [prefixFormatter],
                            decoration: buildInputBorderUpdateStatus1(
                                "A-24", context),
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                        textWidgetBlueColorWithStar(
                          'Sealing',
                          "*",
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          value: regulatorReceived.contains(selectedSealingCondition) ? selectedSealingCondition : null,                          isDense: true,
                          decoration: buildInputBorderUpdateStatus1(
                              "Sealing", context
                          ),
                          items: regulatorReceived.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSealingCondition = value;
                            });
                          },
                        ),

                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: textWidgetBlueColorWithStar(
                              'Leaky',
                              "*",
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child:
                            DropdownButtonFormField<String>(
                              value: leakReceived.contains(selectedLeak) ? selectedLeak : null,
                              isDense: true,
                              decoration: buildInputBorderUpdateStatus1(
                                  "Leaky", context
                              ),
                              items: leakReceived.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedLeak = value;
                                  if (value == "No") {
                                    selectedLeaky = null;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (selectedLeak == "Yes") ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: textWidgetBlueColorWithStar(
                                'Leak Type',
                                "*",
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child:
                              DropdownButtonFormField<GetDesignationListModel>(
                                key: formKey1,
                                value: getdesignationListmodel.contains(selecteddesignation) ? selecteddesignation : null,
                                decoration: buildInputBorderUpdateStatus1(
                                    "Select Leaky Type", context
                                ),
                                items: getdesignationListmodel.map((GetDesignationListModel staff) {
                                  return DropdownMenuItem<GetDesignationListModel>(
                                    value: staff,
                                    child: Text(staff.masterName ?? "-"),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selecteddesignation = value;
                                    selectedItemName = value?.masterName ?? "";
                                    selectedItemIdd = value?.designationId?.toInt();
                                  });
                                },
                                isExpanded: true,
                              ),
                            ),
                          ],
                        ),
                      ]
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                        textWidgetBlueColorWithStar(
                          'Serial Number',
                          "*",
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child:
                        TextField(
                          controller: serialNoController,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(20),
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9]'),
                            ),
                          ],
                          decoration: buildInputBorderUpdateStatus1(
                            "Serial No", context,
                            errorText: _isinvoiceEmpty ? 'Serial No. Is Required' : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _isinvoiceEmpty = value.isEmpty;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: textWidgetBlueColorWithStar(
                          'Remark',
                          "",
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: remarksController,
                          maxLength: 250,
                          decoration: buildInputBorderUpdateStatus1(
                            "Remark", context,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SizedBox(height: 8),
                  if (selectedLeak == "Yes" ||
                      observedWeight < grossWeight) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: textWidgetBlueColorWithStar('Defect Upload', ""),
                            ),
                            IconButton(
                              icon: const Icon(Icons.upload, color: Colors.blue),
                              onPressed: () {
                                showCameraOptions(context);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        if (selectedFile != null || uploadedFileUrl != null)
                          Builder(
                            builder: (_) {
                              if (selectedFile != null) {
                                String ext = selectedFile!.path.split('.').last.toLowerCase();
                                final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];

                                if (videoExtensions.contains(ext)) {
                                  return (_videoController != null &&
                                      _videoController!.value.isInitialized)
                                      ? buildVideoPlayer(_videoController!)
                                      : Container(
                                    height: 250,
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                } else {
                                  return Image.file(
                                    selectedFile!,
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  );
                                }
                              }
                              else if (uploadedFileUrl != null) {
                                String ext = uploadedFileUrl!.split('.').last.toLowerCase();
                                final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
                                // if (uploadedFileUrl!.endsWith('.mp4')) {
                                if (videoExtensions.contains(ext)) {

                                  return (_videoController != null &&
                                      _videoController!.value.isInitialized)
                                      ? buildVideoPlayer(_videoController!)
                                      : Container(
                                    height: 250,
                                    color: Colors.black12,
                                    child: Center(
                                      child: Text(
                                        "Loading Video...",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Image.network(
                                    uploadedFileUrl!,
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      // return Center(child: Text("Failed to load file"));
                                      return Center(child: Text(""));
                                    },
                                  );
                                }
                              }
                              return SizedBox.shrink();
                            },
                          ),

                        if (selectedZip != null || (uploadedFileUrl?.endsWith('.zip') ?? false))
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(Icons.folder_zip, color: Colors.orange),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    selectedZip != null
                                        ? selectedZip!.path.split('/').last
                                        : uploadedFileUrl!.split('/').last,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                  SizedBox(height: 8),
                  // ElevatedButton(
                  //   // onPressed: addItem,
                  //   onPressed: modes == "Edit" ? null : addItem,
                  //   child: Text("Add Item"),
                  // ),
                  if (modes != "Edit")
                    ElevatedButton(
                      onPressed: () => addItem(),
                      child: Text("Add Item"),
                    ),
                  SizedBox(height: 10),
                  // if (sqcItemList.isNotEmpty)
                  if (sqcItemList.isNotEmpty && modes != "Edit")
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20.0, bottom: 15),
                  //   child: Container(
                  //     decoration: BoxDecoration(border: Border.all(width: 1)),
                  //     child: Column(
                  //       children: [
                  //         // Header Row with equal width for all columns using Expanded
                  //         Row(
                  //           children: [
                  //             Expanded(
                  //                 flex: 1,
                  //                 child: Center(
                  //                     child: Text(
                  //                       "DPT Date",
                  //                       style: Styling.itemBlackTestSmall,
                  //                     ))),
                  //             verticalDividerVerySmall(),
                  //             Expanded(
                  //                 flex: 2,
                  //                 child: Center(
                  //                     child: Text(
                  //                       "Tare Wt",
                  //                       style: Styling.itemBlackTestSmall,
                  //                     ))),
                  //             verticalDividerVerySmall(),
                  //             Expanded(
                  //                 flex: 2,
                  //                 child: Center(
                  //                     child: Text(
                  //                       "Gross Wt",
                  //                       style: Styling.itemBlackTestSmall,
                  //                     ))),
                  //             verticalDividerVerySmall(),
                  //             Expanded(
                  //                 flex: 2,
                  //                 child: Center(
                  //                     child: Text(
                  //                       "Observed Wt",
                  //                       style: Styling.itemBlackTestSmall,
                  //                     ))),
                  //             verticalDividerVerySmall(),
                  //             Expanded(
                  //               flex: 1,
                  //               child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 crossAxisAlignment: CrossAxisAlignment.center,
                  //                 children: [
                  //                   Text(
                  //                     "Action",
                  //                     style: Styling.itemBlackTestSmall,
                  //                   ),
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //         // Divider between header and data rows
                  //         Container(
                  //           color: const Color(0xff1280B3),
                  //           height: 1.5,
                  //           width: MediaQuery.of(context).size.width,
                  //         ),
                  //         // Container to display data rows
                  //         Container(
                  //           child: sqcItemList.isNotEmpty
                  //               ? ListView.builder(
                  //             physics: const BouncingScrollPhysics(),
                  //             itemCount: sqcItemList.length,
                  //             shrinkWrap: true,
                  //             itemBuilder: (BuildContext context, int index) {
                  //               var item = sqcItemList[index];
                  //               return Column(
                  //                 children: [
                  //                   Container(
                  //                     child:
                  //                       Row(
                  //                         children: [
                  //                           Expanded(
                  //                             flex: 1,
                  //                             child: Padding(
                  //                               padding: const EdgeInsets.only(left: 5.0),
                  //                               child: Text(
                  //                                 item["DPTDate"] ?? '',
                  //                                 style: TextStyle(fontSize: 14, color: Colors.black54),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                           verticalDividerBig(),
                  //                           // Column 2: Tare Wt
                  //                           Expanded(
                  //                             flex: 2,
                  //                             child: Text(
                  //                               item["TareWt"] ?? '',
                  //                               style: TextStyle(fontSize: 14, color: Colors.black54),
                  //                               textAlign: TextAlign.center,
                  //                             ),
                  //                           ),
                  //                           verticalDividerBig(),
                  //                           // Column 3: Gross Wt
                  //                           Expanded(
                  //                             flex: 2,
                  //                             child: Text(
                  //                               item["GrossWt"] ?? '',
                  //                               style: TextStyle(fontSize: 14, color: Colors.black54),
                  //                               textAlign: TextAlign.center,
                  //                             ),
                  //                           ),
                  //                           verticalDividerBig(),
                  //                           // Column 4: Observed Wt
                  //                           Expanded(
                  //                             flex: 2,
                  //                             child: Text(
                  //                               item["ObservedWt"] ?? '',
                  //                               style: TextStyle(fontSize: 14, color: Colors.black54),
                  //                               textAlign: TextAlign.center,
                  //                             ),
                  //                           ),
                  //                           verticalDividerBig(),
                  //                           // Expanded(
                  //                           //   flex: 0,
                  //                           //   child: Row(
                  //                           //     mainAxisAlignment: MainAxisAlignment.start,  // Aligns the child at the start
                  //                           //     children: [
                  //                           //       Padding(
                  //                           //         padding: EdgeInsets.only(right: 0.0),  // Adjust padding if needed
                  //                           //         child: IconButton(
                  //                           //           icon: Icon(Icons.delete, color: Colors.red),
                  //                           //           iconSize: 20.0,
                  //                           //           onPressed: () {
                  //                           //             setState(() {
                  //                           //               sqcItemList.removeAt(index);
                  //                           //             });
                  //                           //           },
                  //                           //         ),
                  //                           //       ),
                  //                           //     ],
                  //                           //   ),
                  //                           // ),
                  //                           // Expanded(
                  //                           //   flex: 0,
                  //                           //   child: Row(
                  //                           //     mainAxisAlignment: MainAxisAlignment.start,
                  //                           //     children: [
                  //                           //       Padding(
                  //                           //         padding: EdgeInsets.only(right: 0.0),
                  //                           //         child: IconButton(
                  //                           //           icon: Icon(Icons.delete, color: Colors.red),
                  //                           //           iconSize: 20.0,
                  //                           //           onPressed: () async {
                  //                           //             final shouldDelete = await showDialog<bool>(
                  //                           //               context: context,
                  //                           //               builder: (BuildContext context) {
                  //                           //                 return AlertDialog(
                  //                           //                   title: Text("Confirm Delete"),
                  //                           //                   content: Text("Do you want to delete this item?"),
                  //                           //                   actions: [
                  //                           //                     TextButton(
                  //                           //                       onPressed: () {
                  //                           //                         Navigator.of(context).pop(false);
                  //                           //                       },
                  //                           //                       child: Text("No"),
                  //                           //                     ),
                  //                           //                     TextButton(
                  //                           //                       onPressed: () {
                  //                           //                         Navigator.of(context).pop(true);
                  //                           //                       },
                  //                           //                       child: Text("Yes"),
                  //                           //                     ),
                  //                           //                   ],
                  //                           //                 );
                  //                           //               },
                  //                           //             );
                  //                           //             if (shouldDelete == true) {
                  //                           //               setState(() {
                  //                           //                 sqcItemList.removeAt(index);
                  //                           //               });
                  //                           //             }
                  //                           //           },
                  //                           //         ),
                  //                           //       ),
                  //                           //     ],
                  //                           //   ),
                  //                           // ),
                  //
                  //                           Expanded(
                  //                             flex: 0,
                  //                             child: Row(
                  //                               mainAxisSize: MainAxisSize.min, // Takes only as much space as needed
                  //                               children: [
                  //                                 // --- EDIT BUTTON ---
                  //                                 IconButton(
                  //                                   icon: const Icon(Icons.edit, color: Colors.blue),
                  //                                   iconSize: 20.0,
                  //                                   onPressed: () {
                  //                                     var item = sqcItemList[index];
                  //                                     setState(() {
                  //                                       // 1. Basic Controllers
                  //                                       serialNoController.text = item["SerialNo"] ?? '';
                  //                                       tareController.text = item["TareWt"] ?? '';
                  //                                       grossController.text = item["GrossWt"] ?? '';
                  //                                       observedController.text = item["ObservedWt"] ?? '';
                  //                                       variationController.text = item["Variation"] ?? '';
                  //                                       prefixController.text = item["DPTDate"] ?? '';
                  //                                       remarksController.text = item["Remarks"] ?? '';
                  //
                  //                                       // 2. Dropdowns (Yes/No)
                  //                                       selectedSealingCondition = item["SealingCond"] == "Y" ? "Yes" : "No";
                  //                                       selectedLeak = item["Leakage"] == "Y" ? "Yes" : "No";
                  //
                  //                                       // 3. Main Item Selection
                  //                                       _selectedItemModel = itemNames.firstWhere(
                  //                                             (name) => itemIds[itemNames.indexOf(name)] == item["ItemId"],
                  //                                         orElse: () => '',
                  //                                       );
                  //                                       selectedItemIddd = int.tryParse(item["ItemId"].toString());
                  //
                  //                                       // --- 4. BIND LEAKAGE TYPE (Designation) ---
                  //                                       if (selectedLeak == "Yes" && item["LeakyBdy"] != null && item["LeakyBdy"] != '') {
                  //                                         try {
                  //                                           selecteddesignation = getdesignationListmodel.firstWhere(
                  //                                                 (element) => element.designationId.toString() == item["LeakyBdy"].toString(),
                  //                                           );
                  //                                           selectedItemIdd = selecteddesignation?.designationId?.toInt();
                  //                                           selectedItemName = selecteddesignation?.masterName ?? "";
                  //                                         } catch (e) {
                  //                                           debugPrint("Leakage Type not found in list: $e");
                  //                                           selecteddesignation = null;
                  //                                         }
                  //                                       } else {
                  //                                         selecteddesignation = null;
                  //                                         selectedItemIdd = null;
                  //                                       }
                  //
                  //                                       // --- 5. BIND DEFECT IMAGE/FILE ---
                  //                                       var fileData = item["file"];
                  //                                       if (fileData != null) {
                  //                                         if (fileData is File) {
                  //                                           // If it was a newly picked file that hasn't been uploaded yet
                  //                                           selectedFile = fileData;
                  //                                           uploadedFileUrl = null;
                  //                                         } else if (fileData is String) {
                  //                                           // If it's a URL from the server
                  //                                           uploadedFileUrl = fileData;
                  //                                           selectedFile = null;
                  //                                         }
                  //                                       } else {
                  //                                         selectedFile = null;
                  //                                         uploadedFileUrl = null;
                  //                                       }
                  //
                  //                                       // 6. Remove from list so user can edit and "Add" it back
                  //                                       sqcItemList.removeAt(index);
                  //                                     });
                  //
                  //                                     showFlushBar(context, "Item moved to form for editing");
                  //                                   },
                  //                                 ),
                  //
                  //                                 // --- DELETE BUTTON ---
                  //                                 IconButton(
                  //                                   icon: Icon(Icons.delete, color: Colors.red),
                  //                                   iconSize: 20.0,
                  //                                   onPressed: () async {
                  //                                     final shouldDelete = await showDialog<bool>(
                  //                                       context: context,
                  //                                       builder: (BuildContext context) {
                  //                                         return AlertDialog(
                  //                                           title: Text("Confirm Delete"),
                  //                                           content: Text("Do you want to delete this item?"),
                  //                                           actions: [
                  //                                             TextButton(
                  //                                               onPressed: () => Navigator.of(context).pop(false),
                  //                                               child: Text("No"),
                  //                                             ),
                  //                                             TextButton(
                  //                                               onPressed: () => Navigator.of(context).pop(true),
                  //                                               child: Text("Yes"),
                  //                                             ),
                  //                                           ],
                  //                                         );
                  //                                       },
                  //                                     );
                  //                                     if (shouldDelete == true) {
                  //                                       setState(() {
                  //                                         sqcItemList.removeAt(index);
                  //                                       });
                  //                                     }
                  //                                   },
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                   ),
                  //                 ],
                  //               );
                  //             },
                  //           )
                  //               : Container(
                  //             padding: EdgeInsets.all(5),
                  //             child: const Center(child: Text("No Pending Data..!")),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 15),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: Column(
                          children: [
                            // Header Row with equal width for all columns using Expanded
                            Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Center(
                                        child: Text(
                                          "DPT Date",
                                          style: Styling.itemBlackTestSmall,
                                        ))),
                                verticalDividerVerySmall(),
                                Expanded(
                                    flex: 3,
                                    child: Center(
                                        child: Text(
                                          "Serial No",
                                          style: Styling.itemBlackTestSmall,
                                        ))),
                                verticalDividerVerySmall(),
                                // Expanded(
                                //     flex: 2,
                                //     child: Center(
                                //         child: Text(
                                //           "Gross Wt",
                                //           style: Styling.itemBlackTestSmall,
                                //         ))),
                                // verticalDividerVerySmall(),
                                // Expanded(
                                //     flex: 2,
                                //     child: Center(
                                //         child: Text(
                                //           "Observed Wt",
                                //           style: Styling.itemBlackTestSmall,
                                //         ))),
                                // verticalDividerVerySmall(),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Action",
                                        style: Styling.itemBlackTestSmall,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            // Divider between header and data rows
                            Container(
                              color: const Color(0xff1280B3),
                              height: 1.5,
                              width: MediaQuery.of(context).size.width,
                            ),
                            // Container to display data rows
                            Container(
                              child: sqcItemList.isNotEmpty
                                  ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: sqcItemList.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  var item = sqcItemList[index];
                                  return Column(
                                    children: [
                                      Container(
                                        child:
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  item["DPTDate"] ?? '',
                                                  style: TextStyle(fontSize: 14, color: Colors.black54),
                                                ),
                                              ),
                                            ),
                                            verticalDividerBig(),
                                            // Column 2: Tare Wt
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                item["SerialNo"] ?? '',
                                                style: TextStyle(fontSize: 14, color: Colors.black54),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            verticalDividerBig(),
                                            // // Column 3: Gross Wt
                                            // Expanded(
                                            //   flex: 2,
                                            //   child: Text(
                                            //     item["GrossWt"] ?? '',
                                            //     style: TextStyle(fontSize: 14, color: Colors.black54),
                                            //     textAlign: TextAlign.center,
                                            //   ),
                                            // ),
                                            // verticalDividerBig(),
                                            // // Column 4: Observed Wt
                                            // Expanded(
                                            //   flex: 2,
                                            //   child: Text(
                                            //     item["ObservedWt"] ?? '',
                                            //     style: TextStyle(fontSize: 14, color: Colors.black54),
                                            //     textAlign: TextAlign.center,
                                            //   ),
                                            // ),
                                            // verticalDividerBig(),
                                            // Expanded(
                                            //   flex: 0,
                                            //   child: Row(
                                            //     mainAxisAlignment: MainAxisAlignment.start,  // Aligns the child at the start
                                            //     children: [
                                            //       Padding(
                                            //         padding: EdgeInsets.only(right: 0.0),  // Adjust padding if needed
                                            //         child: IconButton(
                                            //           icon: Icon(Icons.delete, color: Colors.red),
                                            //           iconSize: 20.0,
                                            //           onPressed: () {
                                            //             setState(() {
                                            //               sqcItemList.removeAt(index);
                                            //             });
                                            //           },
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            // Expanded(
                                            //   flex: 0,
                                            //   child: Row(
                                            //     mainAxisAlignment: MainAxisAlignment.start,
                                            //     children: [
                                            //       Padding(
                                            //         padding: EdgeInsets.only(right: 0.0),
                                            //         child: IconButton(
                                            //           icon: Icon(Icons.delete, color: Colors.red),
                                            //           iconSize: 20.0,
                                            //           onPressed: () async {
                                            //             final shouldDelete = await showDialog<bool>(
                                            //               context: context,
                                            //               builder: (BuildContext context) {
                                            //                 return AlertDialog(
                                            //                   title: Text("Confirm Delete"),
                                            //                   content: Text("Do you want to delete this item?"),
                                            //                   actions: [
                                            //                     TextButton(
                                            //                       onPressed: () {
                                            //                         Navigator.of(context).pop(false);
                                            //                       },
                                            //                       child: Text("No"),
                                            //                     ),
                                            //                     TextButton(
                                            //                       onPressed: () {
                                            //                         Navigator.of(context).pop(true);
                                            //                       },
                                            //                       child: Text("Yes"),
                                            //                     ),
                                            //                   ],
                                            //                 );
                                            //               },
                                            //             );
                                            //             if (shouldDelete == true) {
                                            //               setState(() {
                                            //                 sqcItemList.removeAt(index);
                                            //               });
                                            //             }
                                            //           },
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),

                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min, // Takes only as much space as needed
                                                children: [
                                                  // --- EDIT BUTTON ---
                                                  IconButton(
                                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                                    iconSize: 20.0,
                                                    onPressed: () {
                                                      var item = sqcItemList[index];
                                                      setState(() {
                                                        // 1. Basic Controllers
                                                        serialNoController.text = item["SerialNo"] ?? '';
                                                        tareController.text = item["TareWt"] ?? '';
                                                        grossController.text = item["GrossWt"] ?? '';
                                                        observedController.text = item["ObservedWt"] ?? '';
                                                        variationController.text = item["Variation"] ?? '';
                                                        prefixController.text = item["DPTDate"] ?? '';
                                                        remarksController.text = item["Remarks"] ?? '';

                                                        // 2. Dropdowns (Yes/No)
                                                        selectedSealingCondition = item["SealingCond"] == "Y" ? "Yes" : "No";
                                                        selectedLeak = item["Leakage"] == "Y" ? "Yes" : "No";

                                                        // 3. Main Item Selection
                                                        _selectedItemModel = itemNames.firstWhere(
                                                              (name) => itemIds[itemNames.indexOf(name)] == item["ItemId"],
                                                          orElse: () => '',
                                                        );
                                                        selectedItemIddd = int.tryParse(item["ItemId"].toString());

                                                        // --- 4. BIND LEAKAGE TYPE (Designation) ---
                                                        if (selectedLeak == "Yes" && item["LeakyBdy"] != null && item["LeakyBdy"] != '') {
                                                          try {
                                                            selecteddesignation = getdesignationListmodel.firstWhere(
                                                                  (element) => element.designationId.toString() == item["LeakyBdy"].toString(),
                                                            );
                                                            selectedItemIdd = selecteddesignation?.designationId?.toInt();
                                                            selectedItemName = selecteddesignation?.masterName ?? "";
                                                          } catch (e) {
                                                            debugPrint("Leakage Type not found in list: $e");
                                                            selecteddesignation = null;
                                                          }
                                                        } else {
                                                          selecteddesignation = null;
                                                          selectedItemIdd = null;
                                                        }

                                                        // --- 5. BIND DEFECT IMAGE/FILE ---
                                                        var fileData = item["file"];
                                                        if (fileData != null) {
                                                          if (fileData is File) {
                                                            // If it was a newly picked file that hasn't been uploaded yet
                                                            selectedFile = fileData;
                                                            uploadedFileUrl = null;
                                                          } else if (fileData is String) {
                                                            // If it's a URL from the server
                                                            uploadedFileUrl = fileData;
                                                            selectedFile = null;
                                                          }
                                                        } else {
                                                          selectedFile = null;
                                                          uploadedFileUrl = null;
                                                        }

                                                        // 6. Remove from list so user can edit and "Add" it back
                                                        sqcItemList.removeAt(index);
                                                      });

                                                      showFlushBar(context, "Item moved to form for editing");
                                                    },
                                                  ),

                                                  // --- DELETE BUTTON ---
                                                  IconButton(
                                                    icon: Icon(Icons.delete, color: Colors.red),
                                                    iconSize: 20.0,
                                                    onPressed: () async {
                                                      final shouldDelete = await showDialog<bool>(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text("Confirm Delete"),
                                                            content: Text("Do you want to delete this item?"),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () => Navigator.of(context).pop(false),
                                                                child: Text("No"),
                                                              ),
                                                              TextButton(
                                                                onPressed: () => Navigator.of(context).pop(true),
                                                                child: Text("Yes"),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      if (shouldDelete == true) {
                                                        setState(() {
                                                          sqcItemList.removeAt(index);
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                                  : Container(
                                padding: EdgeInsets.all(5),
                                child: const Center(child: Text("No Pending Data..!")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(width: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          cancelAction(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20,
                              vertical: 10),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // GestureDetector(
                      //   onTap: () {
                      //     if (saveFlag) {
                      //       print('saveFlag $saveFlag');
                      //       showFlushBar(context, Constants.dayEndCompleted);
                      //     }
                      //   },
                      //   child: ElevatedButton(
                      //     // onPressed: (sqcItemList.isEmpty || saveFlag)
                      //     //     ? null
                      //     //     : () async {
                      //     //   EasyLoading.show(
                      //     //       status: modes == "Edit"
                      //     //           ? "Updating items..."
                      //     //           : "Saving items...");
                      //     //
                      //     //   bool allSuccess = true;
                      //     //
                      //     //   for (var item in sqcItemList) {
                      //     //     bool success = await SqcRegisterAddEditForMob(
                      //     //       context,
                      //     //       item,
                      //     //       modes == "Edit" ? SQCIdEdit! : 0,
                      //     //       modes == "Edit" ? "EDIT" : "ADD",
                      //     //     );
                      //     //
                      //     //     if (!success) allSuccess = false;
                      //     //   }
                      //     //
                      //     //   EasyLoading.dismiss();
                      //     //
                      //     //   if (allSuccess) {
                      //     //     EasyLoading.showToast(
                      //     //       modes == "Edit"
                      //     //           ? "All items updated successfully"
                      //     //           : "All items added successfully",
                      //     //     );
                      //     //
                      //     //     setState(() {
                      //     //       sqcItemList.clear();
                      //     //     });
                      //     //
                      //     //     Navigator.pushNamed(context, ItemReturnScreen.screenName);
                      //     //
                      //     //     setState(() {
                      //     //       fetchItemSQCAddEditList(context);
                      //     //     });
                      //     //   } else {
                      //     //     EasyLoading.showToast("Some items failed to upload");
                      //     //   }
                      //     // },
                      //
                      //     onPressed: (sqcItemList.isEmpty || saveFlag)
                      //         ? null
                      //         : () async {
                      //       EasyLoading.show(
                      //         status: modes == "Edit"
                      //             ? "Updating items..."
                      //             : "Saving items...",
                      //       );
                      //
                      //       bool allSuccess = true;
                      //
                      //       for (var item in sqcItemList) {
                      //         bool success = await SqcRegisterAddEditForMob(
                      //           context,
                      //           item,
                      //           modes == "Edit" ? SQCIdEdit! : 0,
                      //           modes == "Edit" ? "EDIT" : "ADD",
                      //         );
                      //
                      //         if (!success) {
                      //           allSuccess = false;
                      //
                      //           // 🚨 STOP immediately if duplicate found
                      //           if (item['isDuplicate'] == true) {
                      //             EasyLoading.dismiss();
                      //             return;
                      //           }
                      //         }
                      //       }
                      //
                      //       EasyLoading.dismiss();
                      //
                      //       if (allSuccess) {
                      //         EasyLoading.showToast(
                      //           modes == "Edit"
                      //               ? "All items updated successfully"
                      //               : "All items added successfully",
                      //         );
                      //
                      //         setState(() {
                      //           sqcItemList.clear();
                      //         });
                      //
                      //         Navigator.pushNamed(context, ItemReturnScreen.screenName);
                      //
                      //         fetchItemSQCAddEditList(context);
                      //       } else {
                      //         EasyLoading.showToast("Some items failed to upload");
                      //       }
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: (sqcItemList.isEmpty || saveFlag)
                      //           ? Colors.grey
                      //           : (modes == "Edit" ? Colors.orange : Colors.blue),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(50),
                      //       ),
                      //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      //     ),
                      //     child: Text(
                      //       modes == "Edit" ? 'Update' : 'Save',
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 16,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          if (saveFlag) {
                            showFlushBar(context, Constants.dayEndCompleted);
                          }
                        },
                        child: ElevatedButton(
                          // 1. Logic Update: In Edit mode, we allow the button even if sqcItemList is empty
                          // because we will populate it on the fly.
                          onPressed: (saveFlag || (modes != "Edit" && sqcItemList.isEmpty))
                              ? null
                              : () async {

                            // 2. Direct Sync for Edit Mode
                            if (modes == "Edit") {
                              String currentIsoDate = DateTime.now().toUtc().toIso8601String();
                              // We create the list right here from the current screen controllers
                              Map<String, dynamic> directEditItem = {
                                "GodownId": godownId.toString(),
                                "ReceiptDate": currentIsoDate,
                                "VehicleNo": vehicleNoController.text,
                                "ItemId": selectedItemIddd.toString(),
                                "TareWt": tareController.text,
                                "GrossWt": grossController.text,
                                "ObservedWt": observedController.text,
                                "Variation": variationController.text,
                                "DPTDate": prefixController.text,
                                "SerialNo": serialNoController.text.trim(),
                                "Remarks": remarksController.text,
                                "SealingCond": selectedSealingCondition == "Yes" ? "Y" : "N",
                                "Leakage": selectedLeak == "Yes" ? "Y" : "N",
                                // "LeakyBdy": selectedItemIdd?.toString() ?? '',
                                "LeakyBdy": (selectedLeak == "Yes") ? (selectedItemIdd?.toString() ?? '') : '',
                                "file": selectedFile ?? selectedZip ?? uploadedFileUrl,
                              };

                              setState(() {
                                sqcItemList = [directEditItem];
                              });
                            }

                            // Re-verify list isn't empty after the Edit sync
                            if (sqcItemList.isEmpty) {
                              showFlushBar(context, "Please add an item first");
                              return;
                            }

                            EasyLoading.show(
                              status: modes == "Edit" ? "Updating..." : "Saving...",
                            );

                            bool allSuccess = true;

                            for (var item in sqcItemList) {
                              bool success = await SqcRegisterAddEditForMob(
                                context,
                                item,
                                modes == "Edit" ? SQCIdEdit! : 0,
                                modes == "Edit" ? "EDIT" : "ADD",
                              );

                              if (!success) {
                                allSuccess = false;
                                if (item['isDuplicate'] == true) {
                                  EasyLoading.dismiss();
                                  return;
                                }
                              }
                            }

                            EasyLoading.dismiss();

                            if (allSuccess) {
                              EasyLoading.showToast(
                                modes == "Edit" ? "Updated successfully" : "Saved successfully",
                              );

                              setState(() {
                                sqcItemList.clear();
                              });

                              Navigator.pushNamed(context, ItemReturnScreen.screenName);
                              fetchItemSQCAddEditList(context);
                            } else {
                              EasyLoading.showToast("Update failed");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            // 3. UI Update: Grey out only if saveFlag is true OR (it's Add mode and list is empty)
                            backgroundColor: (saveFlag || (modes != "Edit" && sqcItemList.isEmpty))
                                ? Colors.grey
                                : (modes == "Edit" ? Colors.blue : Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: Text(
                            modes == "Edit" ? 'Update' : 'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),

                  SizedBox(height: 5),

                  Card(
                    child: receiptList.isNotEmpty
                        ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      // Filter the list here
                      itemCount: receiptList
                          .where((sale) =>
                      sale.vehicleNo.toString() == vehicleNoController.text)
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        // Get the filtered sale for this index
                        final filteredList = receiptList
                            .where((sale) =>
                        sale.vehicleNo.toString() == vehicleNoController.text)
                            .toList();
                        GetSqcFilledCylListModel sale = filteredList[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Expanded(
                                  //     flex: 1,
                                  //     child: Text(
                                  //       sale.dPTDate.toString(),
                                  //       style: Styling.blueClrText,
                                  //     )),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Text("Serial No: ",
                                            style: Styling.itemGreyTextSmall),
                                        Text(sale.serialNo.toString(),
                                            style: Styling.blueClrText),
                                      ],
                                    ),
                                    // Text(
                                    //   // sale.serialNo.toString() ?? '',
                                    //   '409586893203485345',
                                    //   style: Styling.blueClrText,
                                    // ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: saveFlag
                                                  ? Colors.blueGrey
                                                  : Colors.blue),
                                          onPressed: () {
                                            var sqcID = sale.sQCId.toString();
                                            var sQCDate = sale.receiptDate.toString();
                                            var sqcVehicle = sale.vehicleNo.toString();
                                            var godownId = sale.godownId.toString();
                                            var itemId = sale.itemId.toString();
                                            var itemName = sale.itemName.toString();
                                            var tareWt = sale.tareWt.toString();
                                            var grossWt = sale.grossWt.toString();
                                            var observedWt = sale.observedWt.toString();
                                            var variation = sale.variation.toString();
                                            var dptDate = sale.dPTDate.toString();
                                            var sealing = sale.sealingCond.toString();
                                            var leaky = sale.leakage.toString();
                                            var leakBdy = sale.leakyBdy.toString();
                                            var leakBdyName = sale.leakName.toString();
                                            var serialNo = sale.serialNo.toString();
                                            var remark = sale.remarks.toString();
                                            var uploadFile = sale.uploadFilePath.toString();

                                            if (saveFlag) {
                                              showFlushBar(
                                                  context, Constants.dayEndCompleted);
                                            } else {
                                              Navigator.pushNamed(
                                                context,
                                                SQCRegisterScreen.screenName,
                                                arguments: {
                                                  'sqcIDV': sqcID,
                                                  'sqcDateV': sQCDate,
                                                  'vehicleNoV': sqcVehicle,
                                                  'godownIdV': godownId,
                                                  'itemIdV': itemId,
                                                  'itemNameV': itemName,
                                                  'itemIds': itemIds,
                                                  'itemNames': itemNames,
                                                  'tareWtV': tareWt,
                                                  'grossWtV': grossWt,
                                                  'observedWtV': observedWt,
                                                  'variationV': variation,
                                                  'dptDateV': dptDate,
                                                  'sealingV': sealing,
                                                  'laekyV': leaky,
                                                  'leakTypeIdV': leakBdy,
                                                  'leakTypeV': leakBdyName,
                                                  'serialNoV': serialNo,
                                                  'remarkV': remark,
                                                  'fileUploadV': uploadFile,
                                                  'modeChange': "Edit"
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Rest of your existing rows for weights, dates, etc.
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text("Tare Weight : ",
                                            style: Styling.itemGreyTextSmall),
                                        Text(sale.tareWt.toString(),
                                            style: Styling.itemBlackTestSmall),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text("Gross Weight : ",
                                            style: Styling.itemGreyTextSmall),
                                        Text(sale.grossWt.toString(),
                                            style: Styling.itemBlackTestSmall),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text("Observation Weight : ",
                                            style: Styling.itemGreyTextSmall),
                                        Text(sale.observedWt.toString(),
                                            style: Styling.itemBlackTestSmall),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text("Variation : ",
                                            style: Styling.itemGreyTextSmall),
                                        Text(sale.variation.toString(),
                                            style: Styling.itemBlackTestSmall),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Row(
                              //         children: [
                              //           Text("Serial No: ",
                              //               style: Styling.itemGreyTextSmall),
                              //           Text(sale.serialNo.toString(),
                              //               style: Styling.itemBlackTestSmall),
                              //         ],
                              //       ),
                              //     )
                              //   ],
                              // ),
                            ],
                          ),
                        );
                      },
                    )
                        : Center(
                      child: Text('No Records Found'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void initNetworkVideo(String url) async {
  //   _videoController?.dispose(); // clean old
  //
  //   _videoController = VideoPlayerController.network(url);
  //
  //   try {
  //     await _videoController!.initialize();
  //     setState(() {});
  //   } catch (e) {
  //     print("Video load error: $e");
  //   }
  // }

  // Future<void> _initializeNetworkVideo(String url) async {
  //   print("Initializing video controller with URL: $url");
  //   try {
  //     _videoController?.dispose();
  //
  //     _videoController = VideoPlayerController.network(url);
  //
  //     await _videoController!.initialize();
  //     print("Video initialized");
  //
  //     _videoController!.setLooping(true);
  //     _videoController!.play();
  //
  //     setState(() {}); // rebuild to show player
  //   } catch (e) {
  //     print("Error initializing video: $e");
  //   }
  // }

  Widget buildVideoPlayer(VideoPlayerController controller) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          IconButton(
            iconSize: 50,
            color: Colors.white,
            icon: Icon(
              controller.value.isPlaying
                  ? Icons.pause_circle
                  : Icons.play_circle,
            ),
            onPressed: () {
              controller.value.isPlaying ? controller.pause() : controller.play();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Future<bool> isFileValid(File file) async {
    int size = await file.length();

    if (size > maxFileSize) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(content: Text("File must be less than 5MB")),
      );
      return false;
    }
    return true;
  }

  Future<void> captureMedia(String mediaType) async {
    try {
      XFile? file;

      if (mediaType == 'image') {
        file = await _picker.pickImage(source: ImageSource.camera);
      } else if (mediaType == 'video') {
        file = await _picker.pickVideo(source: ImageSource.camera);
      }

      if (file != null) {
        final File pickedFile = File(file.path);

        // ✅ File size validation
        if (!await isFileValid(pickedFile)) return;

        String ext = pickedFile.path.split('.').last.toLowerCase();

        final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
        final imageExtensions = ['jpg', 'jpeg', 'png', 'heic', 'webp', 'bmp'];

        // Clear ZIP
        selectedZip = null;

        if (videoExtensions.contains(ext)) {
          //  VIDEO
          _videoController?.dispose();
          _videoController = VideoPlayerController.file(pickedFile);

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await _videoController!.initialize();

            setState(() {
              selectedFile = pickedFile;
            });

            _videoController!.play();
          });

        } else if (imageExtensions.contains(ext)) {
          //  IMAGE
          setState(() {
            selectedFile = pickedFile;
          });

        } else {
          //  Unsupported
          ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(content: Text("Unsupported file type")),
          );
        }
      }
    } catch (e) {
      print("Error picking media: $e");
    }
  }

  Future<void> pickZipFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      // ADD THIS VALIDATION
      if (!await isFileValid(file)) return;

      setState(() {
        selectedZip = file;

        // Clear image/video
        selectedFile = null;
        _videoController?.dispose();
        _videoController = null;
      });
    }
  }

  Widget textWidgetBlueColorWithoutStar(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 16,
      ),
    );
  }

  void showCameraOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Capture Image"),
                onTap: () async {
                  Navigator.pop(context);
                  await captureMedia('image');
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text("Capture Video"),
                onTap: () async {
                  Navigator.pop(context);
                  await captureMedia('video');
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive), // Icon for ZIP files
                title: const Text("Upload ZIP File"),
                onTap: () async {
                  Navigator.pop(context);
                  await pickZipFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildPreview() {
    if (selectedFile == null) {
      return const Text("No file selected");
    }

    if (_videoController != null &&
        _videoController!.value.isInitialized) {
      return SizedBox(
        height: 200,
        child: VideoPlayer(_videoController!),
      );
    } else {
      return Image.file(
        selectedFile!,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  void cancelAction(BuildContext context) {
    final currentVehicleNo = vehicleNoController.text;
    final currentGodownId = godownId;
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      SQCRegisterScreen.screenName,
      arguments: {
        'vehicleNo': currentVehicleNo,
        'godownId': currentGodownId,
        'itemIds': itemIds,
        'itemNames': itemNames,
      },
    );
  }

  // Future<void> SqcRegisterAddEditForMob(int SQCId ,String action, {File? mediaFile}) async {
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? bearerToken = prefs.getString('token');
  //   String? staffId = prefs.getString('StaffId');
  //   String? userId = prefs.getString("UserId");
  //   int? addedBys = int.parse(staffId!);
  //   int? distributorIds = int.parse(distributorId!);
  //
  //   String? tController;
  //   String? gController;
  //   String? oController;
  //   String? vController;
  //   String? dptController;
  //   String? serialController;
  //   String? remarkController;
  //
  //
  //   if (tareController.text.isNotEmpty) {
  //     tController = tareController.text;
  //   }
  //
  //   if (grossController.text.isNotEmpty) {
  //     gController = grossController.text;
  //   }
  //   if (observedController.text.isNotEmpty) {
  //     oController = observedController.text;
  //   }
  //   if (variationController.text.isNotEmpty) {
  //     vController = variationController.text;
  //   }
  //   if (prefixController.text.isNotEmpty) {
  //     dptController = prefixController.text;
  //   }
  //   if (serialNoController.text.isNotEmpty) {
  //     serialController = serialNoController.text;
  //   }
  //   if (remarksController.text.isNotEmpty) {
  //     remarkController = remarksController.text;
  //   }
  //
  //   final Map<String, dynamic> requestBody =
  //   {
  //     "SQCId": SQCId,
  //     "DistributorId":distributorId,
  //     "GodownId": godownId,
  //     "ReceiptDate": formattedDate,
  //     "VehicleNo": vehicleNo,
  //     "ItemId": selectedItemId,
  //     "TareWt": tController,
  //     "GrossWt": gController,
  //     "ObservedWt": oController,
  //     "Variation": vController,
  //     "DPTDate": dptController,
  //     "SealingCond": selectedSealingCondition ,
  //     "Leakage": selectedLeak,
  //     // "LeakyBdy": selectedLeaky,
  //     "LeakyBdy": 1,
  //     "SerialNo":serialController,
  //     "Remarks":remarkController,
  //     "UploadFileName": mediaFile != null ? mediaFile.path.split('/').last : null,
  //     "UpdatedBy":"dfd",
  //     "AddedBy": addedBys,
  //     "Platform": 'MOB',
  //     "Action": action,
  //   };
  //   print("DepositCashAddEdit: ${requestBody}");
  //   requestBody.forEach((key, value) {
  //     print('$key: $value');
  //   });
  //   // try {
  //   final response = await http.post(
  //     Uri.parse('${AppUrl.SQCFilledCylAddEdit}'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $bearerToken",
  //     },
  //     body: json.encode(requestBody),
  //   );
  //
  //   print(
  //       "requestBody SQCFilledCylAddEdit: ${response.statusCode} - ${response.request}${requestBody}");
  //
  //   print("Response Status Code: ${response.statusCode}");
  //   print("Response SQCFilledCylAddEdit: ${response.body}");
  //
  //   if (response.statusCode == 200) {
  //     if (response.body == '0') {
  //       // Show a user-friendly error if the response body is 0
  //       EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
  //       print("Error: Response returned 0");
  //     } else {
  //
  //       print("Response SQCFilledCylAddEdit: ${response.body}");
  //
  //       Navigator.pushNamed(
  //         context as BuildContext,
  //         SQCRegisterScreen.screenName,
  //       );
  //
  //       Future.delayed(Duration(milliseconds: 300), () {
  //         if (action == "DELETE") {
  //           EasyLoading.showToast(
  //             Constants.expenseSendMgrDelete,
  //             duration: const Duration(milliseconds: 3000),
  //           );
  //         }else if(action == "EDIT") {
  //           EasyLoading.showToast(
  //             Constants.expenseSendMgrEdit,
  //             duration: const Duration(milliseconds: 3000),
  //           );
  //         }else {
  //           EasyLoading.showToast(
  //             Constants.expenseSendMgr,
  //             duration: const Duration(milliseconds: 3000),
  //           );
  //         }
  //       });
  //       setState(() {
  //         // getARBSalesItemPurList();
  //       });
  //     }
  //   } else {
  //     print("Error ARBSalesAddEdit: ${response.statusCode} - ${response.body}");
  //     EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
  //   }
  // }


//   Future<void> SqcRegisterAddEditForMob(int SQCId, String action, {File? mediaFile}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? staffId = prefs.getString('StaffId');
//
//     int addedBys = int.parse(staffId!);
//
//     // Read your controllers
//     String tController = tareController.text;
//     String gController = grossController.text;
//     String oController = observedController.text;
//     String vController = variationController.text;
//     String dptController = prefixController.text;
//     String serialController = serialNoController.text;
//     String remarkController = remarksController.text;
//
//
//
//     try {
//       // Prepare multipart request
//       // var request = http.MultipartRequest(
//       //   'POST',
//       //   Uri.parse(AppUrl.SQCFilledCylAddEdit),
//       // );
//       //
//       // request.headers['Authorization'] = "Bearer $bearerToken";
//       //
//       // // Add form fields
//       // request.fields.addAll({
//       //   "SQCId": SQCId.toString(),
//       //   "DistributorId": distributorId!,
//       //   "GodownId": godownId.toString(),
//       //   "ReceiptDate": formattedDate ?? '',
//       //   "VehicleNo": vehicleNo ?? '',
//       //   "ItemId": selectedItemId.toString(),
//       //   "TareWt": tController,
//       //   "GrossWt": gController,
//       //   "ObservedWt": oController,
//       //   "Variation": vController,
//       //   "DPTDate": dptController,
//       //   "SealingCond": selectedSealingCondition ?? "",
//       //   "Leakage": selectedLeak ?? "",
//       //   "LeakyBdy": "1",
//       //   "SerialNo": serialController,
//       //   "Remarks": remarkController,
//       //   "UpdatedBy": "dfd",
//       //   "AddedBy": addedBys.toString(),
//       //   "Platform": "MOB",
//       //   "Action": action,
//       // });
//       //
//       // // Add file if provided
//       // if (mediaFile != null) {
//       //   request.files.add(await http.MultipartFile.fromPath(
//       //     "UploadFileName",
//       //     mediaFile.path,
//       //   ));
//       // }
//       //
//       // // Send request
//       // var response = await request.send();
//       // var responseBody = await response.stream.bytesToString();
//       //
//       // print("Status Code: ${response.statusCode}");
//       // print("Response: $responseBody");
//
//       File mediaFile = File(r"C:\Users\user\Pictures\exception.png");
//
//       if (!await mediaFile.exists()) {
//         print("File not found at path: ${mediaFile.path}");
//         EasyLoading.showToast("File not found. Please check the path.");
//         return;
//       }
//
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(AppUrl.SQCFilledCylAddEdit),
//       );
//
//       request.headers['Authorization'] = "Bearer $bearerToken";
//
// // Add all your fields
//       request.fields.addAll({
//         "SQCId": SQCId.toString(),
//         "DistributorId": distributorId!,
//         "GodownId": godownId.toString(),
//         "ReceiptDate": formattedDate ?? "",
//         "VehicleNo": vehicleNo ?? "",
//         "ItemId": selectedItemId.toString(),
//         "TareWt": tController ?? "",
//         "GrossWt": gController ?? "",
//         "ObservedWt": oController ?? "",
//         "Variation": vController ?? "",
//         "DPTDate": dptController ?? "",
//         "SealingCond": selectedSealingCondition ?? "",
//         "Leakage": selectedLeak ?? "",
//         "LeakyBdy": "1",
//         "SerialNo": serialController ?? "",
//         "Remarks": remarkController ?? "",
//         "UpdatedBy": "dfd",
//         "AddedBy": addedBys.toString(),
//         "Platform": "MOB",
//         "Action": action,
//       });
//
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           "UploadFileName",
//           mediaFile.path,
//           contentType: MediaType('image', 'png'),
//         ),
//       );
//
// // Send request
//       var response = await request.send();
//       var responseBody = await response.stream.bytesToString();
//
//       print("Status Code: ${response.statusCode}");
//       print("Response: $responseBody");
//
//       if (response.statusCode == 200) {
//         if (responseBody == '0') {
//           EasyLoading.showToast("Something went wrong. Please try again.",
//               duration: const Duration(milliseconds: 3000));
//         } else {
//           Navigator.pushNamed(context as BuildContext, SQCRegisterScreen.screenName);
//           Future.delayed(const Duration(milliseconds: 300), () {
//             if (action == "DELETE") {
//               EasyLoading.showToast(Constants.expenseSendMgrDelete);
//             } else if (action == "EDIT") {
//               EasyLoading.showToast(Constants.expenseSendMgrEdit);
//             } else {
//               EasyLoading.showToast(Constants.expenseSendMgr);
//             }
//           });
//           setState(() {});
//         }
//       } else {
//         EasyLoading.showToast(
//             "Request failed. Please try again.",
//             duration: const Duration(milliseconds: 3000));
//       }
//     } catch (e) {
//       print("Error: $e");
//       EasyLoading.showToast("Something went wrong. Please try again.",
//           duration: const Duration(milliseconds: 3000));
//     }
//   }

  // Future<void> SqcRegisterAddEditForMob(String action, {File? mediaFile}) async {
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? bearerToken = prefs.getString('token');
  //   String? staffId = prefs.getString('StaffId');
  //   String? userId = prefs.getString("UserId");
  //   int? addedBys = int.parse(staffId!);
  //   int? distributorIds = int.parse(distributorId!);
  //
  //   String? tController;
  //   String? gController;
  //   String? oController;
  //   String? vController;
  //   String? dptController;
  //   String? serialController;
  //   String? remarkController;
  //
  //
  //   if (tareController.text.isNotEmpty) {
  //     tController = tareController.text;
  //   }
  //
  //   if (grossController.text.isNotEmpty) {
  //     gController = grossController.text;
  //   }
  //   if (observedController.text.isNotEmpty) {
  //     oController = observedController.text;
  //   }
  //   if (variationController.text.isNotEmpty) {
  //     vController = variationController.text;
  //   }
  //   if (prefixController.text.isNotEmpty) {
  //     dptController = prefixController.text;
  //   }
  //   if (serialNoController.text.isNotEmpty) {
  //     serialController = serialNoController.text;
  //   }
  //   if (remarksController.text.isNotEmpty) {
  //     remarkController = remarksController.text;
  //   }
  //
  //   final Map<String, dynamic> requestBody =
  //   {
  //     // "SQCId": SQCId,
  //     "DistributorId":distributorId,
  //     "GodownId": godownId,
  //     "ReceiptDate": formattedDate,
  //     "VehicleNo": vehicleNo,
  //     "ItemId": selectedItemId,
  //     "TareWt": tController,
  //     "GrossWt": gController,
  //     "ObservedWt": oController,
  //     "Variation": vController,
  //     "DPTDate": dptController,
  //     "SealingCond": selectedSealingCondition ,
  //     "Leakage": selectedLeak,
  //     // "LeakyBdy": selectedLeaky,
  //     "LeakyBdy": 1,
  //     "SerialNo":serialController,
  //     "Remarks":remarkController,
  //     // "UploadFileName": mediaFile != null ? mediaFile.path.split('/').last : null,
  //     "UploadFileName": "ABCD",
  //     "UpdatedBy":"dfd",
  //     "AddedBy": addedBys,
  //     "Platform": 'MOB',
  //     "Action": action,
  //   };
  //   print("DepositCashAddEdit: ${requestBody}");
  //   requestBody.forEach((key, value) {
  //     print('$key: $value');
  //   });
  //   // try {
  //   final response = await http.post(
  //     Uri.parse('${AppUrl.SQCFilledCylAddEdit}'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $bearerToken",
  //     },
  //     body: json.encode(requestBody),
  //   );
  //
  //   print(
  //       "requestBody SQCFilledCylAddEdit: ${response.statusCode} - ${response.request}${requestBody}");
  //
  //   print("Response Status Code: ${response.statusCode}");
  //   print("Response SQCFilledCylAddEdit: ${response.body}");
  //
  //   if (response.statusCode == 200) {
  //     if (response.body == '0') {
  //       // Show a user-friendly error if the response body is 0
  //       EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
  //       print("Error: Response returned 0");
  //     } else {
  //
  //       print("Response SQCFilledCylAddEdit: ${response.body}");
  //
  //       Navigator.pushNamed(
  //         context as BuildContext,
  //         SQCRegisterScreen.screenName,
  //       );
  //
  //       Future.delayed(Duration(milliseconds: 300), () {
  //         if (action == "DELETE") {
  //           EasyLoading.showToast(
  //             Constants.expenseSendMgrDelete,
  //             duration: const Duration(milliseconds: 3000),
  //           );
  //         }else if(action == "EDIT") {
  //           EasyLoading.showToast(
  //             Constants.expenseSendMgrEdit,
  //             duration: const Duration(milliseconds: 3000),
  //           );
  //         }else {
  //           EasyLoading.showToast(
  //             Constants.expenseSendMgr,
  //             duration: const Duration(milliseconds: 3000),
  //           );
  //         }
  //       });
  //       setState(() {
  //         // getARBSalesItemPurList();
  //       });
  //     }
  //   } else {
  //     print("Error ARBSalesAddEdit: ${response.statusCode} - ${response.body}");
  //     EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
  //   }
  // }

  // Future<void> SqcRegisterAddEditForMob(BuildContext context,
  //     int SQCId, String action, {File? mediaFile}) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? bearerToken = prefs.getString('token');
  //   String? staffId = prefs.getString('StaffId');
  //   int addedBys = int.parse(staffId!);
  //
  //   String? tController;
  //   String? gController;
  //   String? oController;
  //   String? vController;
  //   String? dptController;
  //   String? serialController;
  //   String? remarkController;
  //   String? vehicleController;
  //
  //
  //   if (tareController.text.isNotEmpty) {
  //     tController = tareController.text;
  //   }
  //
  //   if (vehicleNoController.text.isNotEmpty) {
  //     vehicleController = vehicleNoController.text;
  //   }
  //
  //   if (grossController.text.isNotEmpty) {
  //     gController = grossController.text;
  //   }
  //   if (observedController.text.isNotEmpty) {
  //     oController = observedController.text;
  //   }
  //   if (variationController.text.isNotEmpty) {
  //     vController = variationController.text;
  //   }
  //   if (prefixController.text.isNotEmpty) {
  //     dptController = prefixController.text;
  //   }
  //   if (serialNoController.text.isNotEmpty) {
  //     serialController = serialNoController.text;
  //   }
  //   if (remarksController.text.isNotEmpty) {
  //     remarkController = remarksController.text;
  //   }
  //
  //   if (_selectedItemModel == null) {
  //     showFlushBar(context, "Please Select Item");
  //     return;
  //   }
  //
  //   if (!tareController.text.isNotEmpty) {
  //     showFlushBar(context, "please enter Tare weight");
  //     return;
  //   }
  //
  //
  //   if (!observedController.text.isNotEmpty) {
  //     showFlushBar(context, "please Enter Observed weight");
  //     return;
  //   }
  //
  //   if (!prefixController.text.isNotEmpty) {
  //     showFlushBar(context, "please Enter DPT Date");
  //     return;
  //   }
  //
  //
  //   if (selectedSealingCondition == null || selectedSealingCondition!.isEmpty) {
  //     showFlushBar(context, "Please Select Sealing Condition");
  //     return;
  //   }
  //
  //   // if (selectedLeak == null || selectedLeak!.isEmpty) {
  //   //   showFlushBar(context, "Please Select Leaky Option");
  //   //   return;
  //   // }
  //   //
  //   // if (selectedLeak == "Yes") {
  //   //   if (selecteddesignation == null) {
  //   //     showFlushBar(context, "Please Select Leakage Type");
  //   //     return;
  //   //   }
  //   // }
  //
  //   if (selectedLeak == null || selectedLeak!.isEmpty) {
  //     showFlushBar(context, "Please Select Leaky Option");
  //     return;
  //   }
  //
  //   if (selectedLeak == "Yes" && selecteddesignation == null) {
  //     showFlushBar(context, "Please Select Leakage Type");
  //     return;
  //   }
  //
  //   if (!serialNoController.text.isNotEmpty) {
  //     showFlushBar(context, "please Enter Serial Number");
  //     return;
  //   }
  //
  //   // Initialize multipart request
  //   final request = http.MultipartRequest(
  //       'POST', Uri.parse(AppUrl.SQCFilledCylAddEdit));
  //
  //   request.headers['Authorization'] = 'Bearer $bearerToken';
  //
  //   // Add fields
  //   request.fields.addAll({
  //     "SQCId": SQCId.toString(),
  //     "DistributorId": distributorId!,
  //     "GodownId": godownId.toString(),
  //     "ReceiptDate": formattedDate ?? '',
  //     "VehicleNo": vehicleController ?? '',
  //     "ItemId": selectedItemIddd.toString(),
  //     "TareWt": tController ?? '',
  //     "GrossWt":gController ?? '',
  //     "ObservedWt": oController ?? '',
  //     "Variation":vController ?? '',
  //     "DPTDate": dptController ?? '',
  //     "SerialNo":serialController ?? '',
  //     "Remarks": remarkController ?? '',
  //     "SealingCond": selectedSealingCondition ?? '',
  //     "Leakage": selectedLeak ?? '',
  //     // "LeakyBdy": selectedItemIdd.toString() ?? '',
  //     "LeakyBdy": selectedItemIdd?.toString() ?? '',
  //     "UpdatedBy": addedBys.toString(),
  //     "AddedBy": addedBys.toString(),
  //     "Platform": "MOB",
  //     "Action": action,
  //     // // Add optional numeric/text fields only if available
  //     // if (tareController.text.isNotEmpty)
  //     //   "TareWt": tareController.text,
  //     // if (grossController.text.isNotEmpty)
  //     //   "GrossWt": grossController.text,
  //     // if (observedController.text.isNotEmpty)
  //     //   "ObservedWt": observedController.text,
  //     // if (variationController.text.isNotEmpty)
  //     //   "Variation": variationController.text,
  //     // if (prefixController.text.isNotEmpty)
  //     //   "DPTDate": prefixController.text,
  //     // if (serialNoController.text.isNotEmpty)
  //     //   "SerialNo": serialNoController.text,
  //     // if (remarksController.text.isNotEmpty)
  //     //   "Remarks": remarksController.text,
  //   });
  //
  //   // Attach file if exists
  //   if (mediaFile != null) {
  //     final mimeTypeData =
  //         lookupMimeType(mediaFile.path)?.split('/') ?? ['application', 'octet-stream'];
  //
  //     request.files.add(await http.MultipartFile.fromPath(
  //       'UploadFile',
  //       mediaFile.path,
  //       contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
  //     ));
  //
  //   }
  //   try {
  //
  //     debugPrint("===== SQC API REQUEST =====");
  //
  //     debugPrint("URL: ${request.url}");
  //
  //     debugPrint("Headers:");
  //     request.headers.forEach((k, v) => debugPrint("$k : $v"));
  //
  //     debugPrint("Fields:");
  //     request.fields.forEach((k, v) => debugPrint("$k : $v"));
  //
  //     debugPrint("Files:");
  //     for (var file in request.files) {
  //       debugPrint("Field: ${file.field}");
  //       debugPrint("FileName: ${file.filename}");
  //       debugPrint("ContentType: ${file.contentType}");
  //     }
  //
  //     debugPrint("===========================");
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //
  //     debugPrint("Response Status: ${response.statusCode}");
  //     debugPrint("Response Body: ${response.body}");
  //
  //     if (response.statusCode == 200 && response.body != '0') {
  //       EasyLoading.showToast("SQC data added successfully",
  //           duration: const Duration(seconds: 2));
  //       // Navigator.pushNamed(context as BuildContext, SQCRegisterScreen.screenName);
  //       Navigator.pushNamed(
  //         context,
  //         ItemReturnScreen.screenName,
  //       );
  //       setState(() {
  //         fetchItemSQCAddEditList(context);
  //       });
  //     } else {
  //       EasyLoading.showToast("Failed to add SQC data",
  //           duration: const Duration(seconds: 2));
  //     }
  //   } catch (e) {
  //     debugPrint("Error uploading SQC: $e");
  //     EasyLoading.showToast("Something went wrong", duration: const Duration(seconds: 2));
  //   }
  // }

  Future<bool> SqcRegisterAddEditForMob(
      BuildContext context,
      Map<String, dynamic> item,
      int SQCId,
      String action,
      ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      String? staffId = prefs.getString('StaffId');
      int addedBys = int.parse(staffId!);

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.SQCFilledCylAddEdit),
      );

      request.headers['Authorization'] = 'Bearer $bearerToken';

      // Add all item fields
      request.fields.addAll({
        "SQCId": SQCId.toString(),
        "DistributorId": distributorId ?? '',
        "GodownId": item["GodownId"] ?? '',
        "ReceiptDate": item["ReceiptDate"] ?? '',
        "VehicleNo": item["VehicleNo"] ?? '',
        "ItemId": item["ItemId"] ?? '',
        "TareWt": item["TareWt"] ?? '',
        "GrossWt": item["GrossWt"] ?? '',
        "ObservedWt": item["ObservedWt"] ?? '',
        "Variation": item["Variation"] ?? '',
        "DPTDate": item["DPTDate"] ?? '',
        "SerialNo": item["SerialNo"] ?? '',
        "Remarks": item["Remarks"] ?? '',
        "SealingCond": item["SealingCond"] ?? '',
        "Leakage": item["Leakage"] ?? '',
        "LeakyBdy": item["LeakyBdy"] ?? '',
        "UpdatedBy": addedBys.toString(),
        "AddedBy": addedBys.toString(),
        "Platform": "MOB",
        "Action": action,
      });

      // Attach file if available
      // File? file = item["file"];
      // if (file != null) {
      //
      //   debugPrint("File path to upload: ${file.path}");
      //
      //   final mimeTypeData =
      //       lookupMimeType(file.path)?.split('/') ?? ['application', 'octet-stream'];
      //
      //   request.files.add(await http.MultipartFile.fromPath(
      //     'UploadFile',
      //     file.path,
      //     contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      //   ));
      // }else{
      //   debugPrint("No file attached for this item.");
      // }


      // --- UPDATED FILE ATTACHMENT LOGIC ---
      var fileData = item["file"];

      if (fileData != null) {
        if (fileData is File) {
          // CASE 1: User picked a NEW file (Image/Gallery)
          debugPrint("Uploading NEW file from path: ${fileData.path}");

          final mimeTypeData = lookupMimeType(fileData.path)?.split('/') ?? ['application', 'octet-stream'];

          request.files.add(await http.MultipartFile.fromPath(
            'UploadFile', // The key your API expects
            fileData.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ));
        } else if (fileData is String && fileData.isNotEmpty && fileData != "0" && fileData != "null") {
          // CASE 2: Existing file URL from Database (Edit Mode)
          debugPrint("Sending EXISTING file string: $fileData");

          // We send the filename back as a field so the server knows to keep it
          request.fields['UploadFile'] = fileData;
        }
      } else {
        debugPrint("No file or string attached for this item.");
      }
      // -------------------------------------

      debugPrint("----- REQUEST BODY -----");
      request.fields.forEach((key, value) {
        debugPrint("$key : $value");
      });

      final response = await http.Response.fromStream(await request.send());

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      //   if (response.statusCode == 200 && response.body != '0') {
      //     debugPrint("Item uploaded successfully: ${item["ItemId"]}");
      //     return true;
      //   } else {
      //     debugPrint("Failed to upload item: ${item["ItemId"]}, Response: ${response.body}");
      //     return false;
      //   }
      // }
      //   if (response.statusCode == 200) {
      //     if (response.body == '-1') {
      //       // Duplicate serial number
      //       String serial = item["SerialNo"]?.toString() ?? "";
      //
      //       debugPrint("Duplicate Serial Number from API: $serial");
      //
      //       EasyLoading.showToast(
      //         "Duplicate Serial Number: $serial",
      //       );
      //
      //       return false; // Treat as failed
      //     } else if (response.body != '0') {
      //       debugPrint("Item uploaded successfully: ${item["ItemId"]}");
      //       return true;
      //     } else {
      //       debugPrint("Failed to upload item: ${item["ItemId"]}, Response: ${response.body}");
      //       EasyLoading.showToast("Failed to upload item");
      //       return false;
      //     }
      //   } else {
      //     debugPrint("Failed to upload item: ${item["ItemId"]}, Status Code: ${response.statusCode}");
      //     EasyLoading.showToast("Server error: ${response.statusCode}");
      //     return false;
      //   }

      if (response.statusCode == 200) {
        if (response.body == '-1') {
          item['isDuplicate'] = true;

          EasyLoading.showToast(
            "${item["SerialNo"]} This serial number already exists",
          );

          return false;
        } else if (response.body != '0') {
          debugPrint("Item uploaded successfully: ${item["ItemId"]}");
          item['isDuplicate'] = false;
          return true;
        } else {
          debugPrint("Failed to upload item: ${item["ItemId"]}");
          item['isDuplicate'] = false;
          return false;
        }
      } else {
        debugPrint("Server error: ${response.statusCode}");
        EasyLoading.showToast("Server error: ${response.statusCode}");
        return false;
      }

    }
    catch (e) {
      debugPrint("Error uploading item: $e");
      return false;
    }
  }

  Future<void> getDesignationList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetDesignationList}/1/LeakageType'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetDesignationList : " +
        '${AppUrl.GetDesignationList}/1/LeakageType');
    debugPrint("GetDesignationList : " + '${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        getdesignationListmodel = data.map((json) => GetDesignationListModel.fromJson(json)).toList();

        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> checkAndSaveDayEndData() async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black // This creates a modal blocking interaction
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false // Disable dismissing the loader by tapping
      ..userInteractions = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    int? distributorIds = int.parse(distributorId!);
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
          // Pass bearer token in headers
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
      if (response.statusCode == 200) {
        List<dynamic> apiResponse = json.decode(response.body);
        if (apiResponse.isEmpty) {
          saveFlag = false;
          print("The list is empty, no data to save.");
        } else {
          saveFlag = true;
          var dayEndData = apiResponse[0];
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;

        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  // Future<void> fetchItemSQCAddEditList(BuildContext context) async {
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if (!Constants.isNetworkAvailable) {
  //     showFlushBar(context, Constants.connectionMessage);
  //     return;
  //   }
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? token = prefs.getString('token'); // Bearer token
  //
  //   if (distributorId == null || distributorId.isEmpty) {
  //     showFlushBar(context, "Distributor ID is missing.");
  //     return;
  //   }
  //   if (token == null || token.isEmpty) {
  //     showFlushBar(context, "Authentication token is missing.");
  //     return;
  //   }
  //
  //   final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //
  //   try {
  //     // Construct JSON body
  //     final Map<String, String> requestBody = {
  //       "DistributorId": distributorId,
  //       "FromDate": formattedDate,
  //       "ToDate": formattedDate,
  //     };
  //
  //     print("Request body: $requestBody");
  //
  //     final response = await http.post(
  //       Uri.parse('${AppUrl.GetSQCFilledCylList}'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: json.encode(requestBody),
  //     );
  //
  //     print("API Status: ${response.statusCode}");
  //     print("API Response: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       setState(() {
  //         receiptList =
  //             data.map((json) => GetSqcFilledCylListModel.fromJson(json)).toList();
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       showFlushBar(context, Constants.listGettingFail);
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print("Error fetching SQC list: $e");
  //     showFlushBar(context, Constants.listGettingFail);
  //   }
  // }

  Future<void> fetchItemSQCAddEditList(BuildContext context) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? token = prefs.getString('token'); // Bearer token

    if (distributorId == null || distributorId.isEmpty) {
      showFlushBar(context, "Distributor ID is missing.");
      return;
    }
    if (token == null || token.isEmpty) {
      showFlushBar(context, "Authentication token is missing.");
      return;
    }

    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      // Construct JSON body
      final Map<String, String> requestBody = {
        "DistributorId": distributorId,
        "FromDate": formattedDate,
        "ToDate": formattedDate,
      };

      print("Request body: $requestBody");

      final response = await http.post(
        Uri.parse('${AppUrl.GetSQCFilledCylList}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(requestBody),
      );

      print("API Status: ${response.statusCode}");
      print("API Response GetSQCFilledCylList: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          receiptList =
              data.map((json) => GetSqcFilledCylListModel.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showFlushBar(context, Constants.listGettingFail);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching SQC list: $e");
      showFlushBar(context, Constants.listGettingFail);
    }
  }

  Future<void> _initializeNetworkVideo(String url) async {
    print("Initializing video controller with URL: $url");
    try {
      _videoController?.dispose();

      _videoController = VideoPlayerController.network(url);

      await _videoController!.initialize();
      print("Video initialized");

      _videoController!.setLooping(true);
      _videoController!.play();

      setState(() {});
    } catch (e) {
      print("Error initializing video: $e");
    }
  }

  //For UAT
  // Future<void> loadUploadedVideo() async {
  //   await fetchItemSQCAddEditList(this.context); // sets uploadedFileUrl internally
  //
  //   // Now uploadedFileUrl is set
  //   // if (uploadedFileUrl != null) {
  //   //   print("Initializing video controller for: $uploadedFileUrl");
  //   //   _initializeNetworkVideo(uploadedFileUrl!);
  //   // }
  //   if (uploadedFileUrl != null) {
  //     String videoUrl = uploadedFileUrl!.replaceFirst("https://", "http://");
  //
  //     print("Using video URL: $videoUrl");
  //
  //     _initializeNetworkVideo(videoUrl);
  //   }
  // }

  Future<void> loadUploadedVideo() async {
    await fetchItemSQCAddEditList(this.context);

    if (uploadedFileUrl == null) return;

    final url = uploadedFileUrl!;
    print("Received URL: $url");

    if (_isVideo(url)) {
      print("Valid video → initializing player");
      await _initializeNetworkVideo(url);
    } else {
      print("Not a video → skipping player init");
    }
  }

  final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];

  bool _isVideo(String url) {
    final lowerUrl = url.toLowerCase();

    return videoExtensions.any((ext) => lowerUrl.endsWith('.$ext'));
  }

  // void addItem() {
  //   // Validate required fields before adding
  //   if (_selectedItemModel == null) {
  //     showFlushBar(this.context, "Please Select An Item");
  //     return;
  //   }
  //   if (tareController.text.isEmpty) {
  //     showFlushBar(this.context, "Please Enter Tare Weight");
  //     return;
  //   }
  //   if (observedController.text.isEmpty) {
  //     showFlushBar(this.context, "Please Enter Observed Weight");
  //     return;
  //   }
  //   if (prefixController.text.isEmpty) {
  //     showFlushBar(this.context, "Please Enter DPT Date");
  //     return;
  //   }
  //   if (selectedSealingCondition == null || selectedSealingCondition!.isEmpty) {
  //     showFlushBar(this.context, "Please Select Sealing Condition");
  //     return;
  //   }
  //   if (selectedLeak == null || selectedLeak!.isEmpty) {
  //     showFlushBar(this.context, "Please Select Leakage Option");
  //     return;
  //   }
  //   if (selectedLeak == "Yes" && selecteddesignation == null) {
  //     showFlushBar(this.context, "Please Select Leakage Type");
  //     return;
  //   }
  //   if (serialNoController.text.isEmpty) {
  //     showFlushBar(this.context, "Please Enter Serial Number");
  //     return;
  //   }
  //
  //   // bool isDuplicate = sqcItemList.any(
  //   //       (item) => item["SerialNo"]?.toString().trim() == serialNoController.text.trim(),
  //   // );
  //
  //   // If in Edit mode, we don't treat the existing item as a duplicate of itself
  //   bool isDuplicate = sqcItemList.any((item) {
  //     bool isSameSerial = item["SerialNo"]?.toString().trim() == serialNoController.text.trim();
  //     // If we are in Edit mode, we allow it if it's the only item in the list
  //     return isSameSerial && modes != "Edit";
  //   });
  //
  //   if (isDuplicate) {
  //     showFlushBar(this.context, "Duplicate Serial Number. Cannot add item.");
  //     return;
  //   }
  //
  //   // Limit total items
  //   if (sqcItemList.length >= 10) {
  //     ScaffoldMessenger.of(this.context).showSnackBar(
  //       const SnackBar(content: Text("Max 10 Items Allowed")),
  //     );
  //     return;
  //   }
  //
  //   // Prepare item map
  //   Map<String, dynamic> item = {
  //     "GodownId": godownId.toString(),
  //     "ReceiptDate": formattedDate ?? '',
  //     "VehicleNo": vehicleNoController.text,
  //     "ItemId": selectedItemIddd.toString(),
  //     "TareWt": tareController.text,
  //     "GrossWt": grossController.text,
  //     "ObservedWt": observedController.text,
  //     "Variation": variationController.text,
  //     "DPTDate": prefixController.text,
  //     "SerialNo": serialNoController.text,
  //     "Remarks": remarksController.text,
  //     "SealingCond": selectedSealingCondition ?? '',
  //     "Leakage": selectedLeak ?? '',
  //     "LeakyBdy": selectedItemIdd?.toString() ?? '',
  //     // "file": selectedFile, // attach uploaded file
  //     // "file": selectedFile ?? selectedZip, // attach uploaded file
  //     "file": selectedFile ?? selectedZip ?? (modes == "Edit" ? uploadedFileUrl : null),
  //   };
  //
  //   // // Add item to the list
  //   // setState(() {
  //   //   sqcItemList.add(item);
  //   // });
  //
  //
  //   setState(() {
  //     // --- ADD THIS BLOCK ---
  //     if (modes == "Edit") {
  //       // Clear the "old" version of the item before adding the "new" edited version
  //       sqcItemList.clear();
  //     }
  //     // ----------------------
  //
  //     sqcItemList.add(item);
  //   });
  //   // Reset form for next entry
  //   clearForm();
  //   showFlushBar(this.context, modes == "Edit" ? "Item Updated" : "Item Added");
  //
  // }

  void addItem() {
    // 1. Validations
    // if (_selectedItemModel == null) {
    //   showFlushBar(this.context, "Please Select An Item");
    //   return;
    // }
    // if (tareController.text.isEmpty || observedController.text.isEmpty) {
    //   showFlushBar(this.context, "Please enter weights");
    //   return;
    // }
    // if (serialNoController.text.isEmpty) {
    //   showFlushBar(this.context, "Serial No. is required");
    //   return;
    // }
    // if (selectedLeak == "Yes" && selecteddesignation == null) {
    //   showFlushBar(this.context, "Please Select Leakage Type");
    //   return;
    // }


    if (_selectedItemModel == null) {
      showFlushBar(this.context, "Please Select An Item");
      return;
    }
    if (tareController.text.isEmpty) {
      showFlushBar(this.context, "Please Enter Tare Weight");
      return;
    }
    if (observedController.text.isEmpty) {
      showFlushBar(this.context, "Please Enter Observed Weight");
      return;
    }
    if (prefixController.text.isEmpty) {
      showFlushBar(this.context, "Please Enter DPT Date");
      return;
    }
    if (selectedSealingCondition == null || selectedSealingCondition!.isEmpty) {
      showFlushBar(this.context, "Please Select Sealing Condition");
      return;
    }
    if (selectedLeak == null || selectedLeak!.isEmpty) {
      showFlushBar(this.context, "Please Select Leakage Option");
      return;
    }
    if (selectedLeak == "Yes" && selecteddesignation == null) {
      showFlushBar(this.context, "Please Select Leakage Type");
      return;
    }
    if (serialNoController.text.isEmpty) {
      showFlushBar(this.context, "Please Enter Serial Number");
      return;
    }

    bool isDuplicate = sqcItemList.any(
          (item) => item["SerialNo"]?.toString().trim() == serialNoController.text.trim(),
    );

    if (isDuplicate) {
      showFlushBar(this.context, "Duplicate Serial Number. Cannot add item.");
      return;
    }

    // Limit total items
    if (sqcItemList.length >= 10) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(content: Text("Max 10 Items Allowed")),
      );
      return;
    }

    // 2. Prepare the item map (Using "Y"/"N" formatting which the API requires)
    Map<String, dynamic> item = {
      "GodownId": godownId.toString(),
      "ReceiptDate": formattedDate ?? '',
      "VehicleNo": vehicleNoController.text,
      "ItemId": selectedItemIddd.toString(),
      "TareWt": tareController.text,
      "GrossWt": grossController.text,
      "ObservedWt": observedController.text,
      "Variation": variationController.text,
      "DPTDate": prefixController.text,
      "SerialNo": serialNoController.text.trim(),
      "Remarks": remarksController.text,
      // CRITICAL: API expects Y/N, not Yes/No
      "SealingCond": selectedSealingCondition == "Yes" ? "Y" : "N",
      "Leakage": selectedLeak == "Yes" ? "Y" : "N",
      "LeakyBdy": selectedItemIdd?.toString() ?? '',
      "file": selectedFile ?? selectedZip ?? (modes == "Edit" ? uploadedFileUrl : null),
    };

    setState(() {
      if (modes == "Edit") {
        // In Edit mode, we replace the item in the list
        sqcItemList = [item];
      } else {
        // In Add mode, check for duplicates in the local list
        bool isDuplicate = sqcItemList.any(
              (e) => e["SerialNo"]?.toString().trim() == serialNoController.text.trim(),
        );
        if (isDuplicate) {
          showFlushBar(this.context, "Duplicate Serial Number in list.");
          return;
        }
        sqcItemList.add(item);
      }
    });

    clearForm();
    showFlushBar(this.context, modes == "Edit" ? "Item Updated" : "Item Added");
  }

  Future<void> sendAllSQCItems() async {
    if (sqcItemList.isEmpty) {
      showFlushBar(this.context, "No Items To Upload");
      return;
    }

    EasyLoading.show(status: "Uploading Items...");

    bool allSuccess = true;

    for (var item in sqcItemList) {
      bool success = await SqcRegisterAddEditForMob(this.context, item, 0, "ADD");
      if (!success) {
        allSuccess = false;
      }
    }

    EasyLoading.dismiss();

    if (allSuccess) {
      EasyLoading.showToast("All Items Uploaded Successfully");
      setState(() {
        sqcItemList.clear();
      });
    } else {
      EasyLoading.showToast("Items Failed To Upload");
    }
  }


  void clearForm() {
    tareController.clear();
    grossController.clear();
    observedController.clear();
    variationController.clear();
    prefixController.clear();
    serialNoController.clear();
    remarksController.clear();

    setState(() {
      _selectedItemModel = null;
      selectedSealingCondition = null;
      selectedLeak = null;
      selecteddesignation = null;
      selectedFile = null;
      uploadedFileUrl = null;
      selectedZip = null;
      if (_videoController != null) {
        _videoController!.dispose();
        _videoController = null;
      }
    });
  }

}

