// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../ConstantScreen/widgets.dart';
// import '../../Utils/Styling.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/app_url.dart';
// import '../../Utils/constants.dart';
// import 'package:http/http.dart' as http;
//
// import '../DeliveryBoyModel/GetDefectiveStockListModel.dart';
//
// class MarkdefectiveItemUI extends StatefulWidget {
//   GetDefectiveStockListModel _listModel;
//
//   MarkdefectiveItemUI(this._listModel, {Key? key}) : super(key: key);
//
//   @override
//   State<MarkdefectiveItemUI> createState() => _MarkdefectiveItemUIState();
// }
//
// class _MarkdefectiveItemUIState extends State<MarkdefectiveItemUI> {
//   List<GetDefectiveStockListModel> _defectiveStockList = [];
//   bool saveFlag = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     checkAndSaveDayEndData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var value = widget._listModel;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                   flex: 2,
//                   child: Center(
//                     child: Text(
//                       DateFormat('dd-MM-yyyy')
//                           .format(DateTime.parse(value.defDate ?? '')),
//                       style: Styling.itemBlackTestSmall,
//                     ),
//                   )),
//               Expanded(
//                   flex: 2,
//                   child: Center(
//                     child: Text(
//                       value.itemName.toString(),
//                       style: Styling.itemBlackTestSmall,
//                     ),
//                   )),
//               Expanded(
//                   flex: 2,
//                   child: Center(
//                       child: Text(
//                     value.defQty.toString(),
//                     style: Styling.itemBlackTestSmall,
//                   ))),
//               Expanded(
//                   flex: 1,
//                   child: Center(
//                       child: GestureDetector(
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text("Confirm Deletion"),
//                             content: Text(
//                                 "Are you sure you want to delete this record?"),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context)
//                                       .pop(); // Close dialog without action
//                                 },
//                                 child: Text("No"),
//                               ),
//                               TextButton(
//                                 onPressed: () async {
//                                   Navigator.of(context).pop();
//                                   if (saveFlag) {
//                                     print('saveFlag $saveFlag');
//                                     showFlushBar(
//                                         context, Constants.dayEndCompleted);
//                                   } else {
//                                     deleteDefectiveToApi(value.defId!.toInt());
//                                   } // Close dialog
//                                 },
//                                 child: Text("Yes"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     child: Icon(
//                       Icons.delete,
//                       color: Colors.red,
//                       size: 20,
//                     ),
//                   ))),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> deleteDefectiveToApi(int defectiveId) async {
//     // Construct the request payload
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? godownId = prefs.getString('godownId');
//     String? addedBy = prefs.getString('StaffId');
//     String? godownKeeperId = prefs.getString('godownKeeperId');
//     String? token = prefs.getString('token'); // This is your bearer token
//
//     int dId = int.parse(distributorId!);
//     int gId = int.parse(godownId!);
//     DateTime now = DateTime.now();
//     // String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
//     String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now);
//
//     Map<String, dynamic> requestBody = {
//       "DefId": defectiveId,
//       "DistributorId": dId,
//       "DefDate": formattedDate,
//       "GodownId": gId,
//       "ItemId": 0,
//       "DefQty": 0,
//       "Remark": "",
//       "Action": "DELETE",
//       "AddedBy": 0
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse('${AppUrl.DefectiveMasterAdd_Mob}'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(requestBody), // Encode the request body as JSON
//       );
//
//       // Print the raw response for debugging
//       print(
//           "API Response Status Code DefectiveMasterAdd_Mob: ${response.statusCode}");
//       print("API Response Body DefectiveMasterAdd_Mob: ${response.body}");
//       print(
//           "API Response request DefectiveMasterAdd_Mob: ${response.request} ${requestBody}");
//
//       if (response.statusCode == 200) {
//         // Handle success
//         print("DefectiveMasterAdd_Mob quantity added successfully!");
//         Navigator.pushReplacementNamed(context, '/markDefectiveItemScreen');
//         EasyLoading.showToast(Constants.dataDeleted,
//             duration: const Duration(milliseconds: 3000));
//         _fetchDefectiveData();
//       } else {
//         // Handle error response
//         print("Failed to add imbalance quantity: ${response.statusCode}");
//       }
//     } catch (e) {
//       // Handle any exceptions
//       print("Error occurred: $e");
//     }
//   }
//
//   Future<void> _fetchDefectiveData() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? godownId = prefs.getString('godownId');
//     String? addedBy = prefs.getString('StaffId');
//     String? godownKeeperId = prefs.getString('godownKeeperId');
//     String? token = prefs.getString('token');
//     int dId = int.parse(distributorId!);
//     int gId = int.parse(godownId!); // This is your bearer token
//     DateTime now = DateTime.now();
//     String formattedDate =
//         DateFormat('yyyy-MM-dd').format(now); // Format selectedDate
//     // String formattedDate = "2025-03-20"; // Format selectedDate
//
//     try {
//       final response = await http.post(
//         Uri.parse(AppUrl.GetDefectiveList_Mob),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           // Adding token to the Authorization header
//         },
//         body: jsonEncode({
//           "DistributorId": dId,
//           "DefDate": formattedDate,
//           "GodownId": gId,
//         }),
//       );
//
//       debugPrint(
//           'jsonRequestBodyGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.request}');
//       debugPrint(
//           'responseGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.body}');
//
//       if (response.statusCode == 200) {
//         // Parse the response
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _defectiveStockList = data
//               .map((json) => GetDefectiveStockListModel.fromJson(json))
//               .toList();
//           EasyLoading.dismiss();
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
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
//           // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
//           //   saveFlag = true;
//           //   print("Data is valid, proceeding to save.");
//           // } else {
//           //   print("Data is incomplete. Cannot proceed to save.");
//           // }
//         }
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
// }



// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../ConstantScreen/widgets.dart';
// import '../../Utils/app_url.dart';
// import '../../Utils/constants.dart';
// import 'package:http/http.dart' as http;
//
// import '../DeliveryBoyModel/GetDefectiveStockListModel.dart';
//
// // ─── Design tokens (same as MarkDefectiveItemScreen) ────────────────────────
// abstract final class _C {
//   static const blue      = Color(0xFF1E3A8A);
//   static const blueLight = Color(0xFF2D52C5);
//   static const blueXL    = Color(0xFFEFF6FF);
//   static const red       = Color(0xFFEF4444);
//   static const redXL     = Color(0xFFFEF2F2);
//   static const text      = Color(0xFF111827);
//   static const textMid   = Color(0xFF374151);
//   static const textMuted = Color(0xFF6B7280);
//   static const white     = Color(0xFFFFFFFF);
//   static const bg        = Color(0xFFF1F5FE);
//   static const border    = Color(0xFFE2E8F0);
// }
//
// /// ─────────────────────────────────────────────────────────────────────────
// /// MARK DEFECTIVE ITEM UI
// /// Single row inside the Defective List card.
// /// Displays date / item name / qty and a delete action.
// /// ALL business logic (API call, saveFlag check, navigation) is UNCHANGED.
// /// ─────────────────────────────────────────────────────────────────────────
// class MarkdefectiveItemUI extends StatefulWidget {
//   GetDefectiveStockListModel _listModel;
//
//   MarkdefectiveItemUI(this._listModel, {Key? key}) : super(key: key);
//
//   @override
//   State<MarkdefectiveItemUI> createState() => _MarkdefectiveItemUIState();
// }
//
// class _MarkdefectiveItemUIState extends State<MarkdefectiveItemUI> {
//   List<GetDefectiveStockListModel> _defectiveStockList = []; // UNCHANGED
//   bool saveFlag = false;                                      // UNCHANGED
//
//   @override
//   void initState() {
//     super.initState();
//     checkAndSaveDayEndData(); // UNCHANGED
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final value = widget._listModel;
//
//     // Format date safely
//     String dateText = '—';
//     try {
//       dateText = DateFormat('dd-MM-yyyy')
//           .format(DateTime.parse(value.defDate ?? ''));
//     } catch (_) {}
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // ── Date badge ────────────────────────────────────────────
//           Expanded(
//             flex: 2,
//             child: _DateBadge(date: dateText),
//           ),
//
//           const SizedBox(width: 8),
//
//           // ── Item name ─────────────────────────────────────────────
//           Expanded(
//             flex: 3,
//             child: Text(
//               value.itemName?.toString() ?? '—',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: _C.textMid,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//
//           const SizedBox(width: 8),
//
//           // ── Qty badge ─────────────────────────────────────────────
//           Expanded(
//             flex: 2,
//             child: Center(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _C.redXL,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   value.defQty?.toString() ?? '0',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w800,
//                     color: _C.red,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 8),
//
//           // ── Delete action ─────────────────────────────────────────
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: Material(
//                 color: Colors.transparent,
//                 borderRadius: BorderRadius.circular(10),
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(10),
//                   splashColor: _C.redXL,
//                   onTap: () {
//                     // ORIGINAL onTap logic — unchanged
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return _DeleteConfirmDialog(
//                           onConfirm: () async {
//                             Navigator.of(context).pop();
//                             if (saveFlag) {
//                               print('saveFlag $saveFlag');
//                               showFlushBar(context, Constants.dayEndCompleted);
//                             } else {
//                               deleteDefectiveToApi(value.defId!.toInt());
//                             }
//                           },
//                           onCancel: () => Navigator.of(context).pop(),
//                         );
//                       },
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(6),
//                     child: Container(
//                       width: 32, height: 32,
//                       decoration: BoxDecoration(
//                         color: _C.redXL,
//                         borderRadius: BorderRadius.circular(9),
//                       ),
//                       child: const Icon(
//                         Icons.delete_outline_rounded,
//                         color: _C.red,
//                         size: 17,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── API methods (UNCHANGED) ────────────────────────────────────────────
//   Future<void> deleteDefectiveToApi(int defectiveId) async {
//     SharedPreferences prefs   = await SharedPreferences.getInstance();
//     String? distributorId     = prefs.getString('DistributorId');
//     String? godownId          = prefs.getString('godownId');
//     String? token             = prefs.getString('token');
//
//     int dId = int.parse(distributorId!);
//     int gId = int.parse(godownId!);
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now);
//
//     Map<String, dynamic> requestBody = {
//       "DefId": defectiveId,
//       "DistributorId": dId,
//       "DefDate": formattedDate,
//       "GodownId": gId,
//       "ItemId": 0,
//       "DefQty": 0,
//       "Remark": "",
//       "Action": "DELETE",
//       "AddedBy": 0
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse('${AppUrl.DefectiveMasterAdd_Mob}'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: json.encode(requestBody),
//       );
//       print("API Response Status Code DefectiveMasterAdd_Mob: ${response.statusCode}");
//       print("API Response Body DefectiveMasterAdd_Mob: ${response.body}");
//       if (response.statusCode == 200) {
//         print("DefectiveMasterAdd_Mob quantity added successfully!");
//         Navigator.pushReplacementNamed(context, '/markDefectiveItemScreen');
//         EasyLoading.showToast(Constants.dataDeleted,
//             duration: const Duration(milliseconds: 3000));
//         _fetchDefectiveData();
//       } else {
//         print("Failed to add imbalance quantity: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error occurred: $e");
//     }
//   }
//
//   Future<void> _fetchDefectiveData() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId   = prefs.getString('DistributorId');
//     String? godownId        = prefs.getString('godownId');
//     String? token           = prefs.getString('token');
//     int dId = int.parse(distributorId!);
//     int gId = int.parse(godownId!);
//     DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd').format(now);
//
//     try {
//       final response = await http.post(
//         Uri.parse(AppUrl.GetDefectiveList_Mob),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           "DistributorId": dId,
//           "DefDate": formattedDate,
//           "GodownId": gId,
//         }),
//       );
//       debugPrint('GetDefectiveList_Mob: ${response.body}');
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _defectiveStockList = data
//               .map((json) => GetDefectiveStockListModel.fromJson(json))
//               .toList();
//           EasyLoading.dismiss();
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   Future<void> checkAndSaveDayEndData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId   = prefs.getString('DistributorId');
//     String? bearerToken     = prefs.getString('token');
//     int? distributorIds     = int.parse(distributorId!);
//     try {
//       final response = await http.get(
//         Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken",
//         },
//       );
//       debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
//       if (response.statusCode == 200) {
//         List<dynamic> apiResponse = json.decode(response.body);
//         if (apiResponse.isEmpty) {
//           saveFlag = false;
//         } else {
//           saveFlag = true;
//           var dayEndData    = apiResponse[0];
//           int DSRSaved      = dayEndData['DSRSaved']      ?? 0;
//           int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
//           int OpClSaved     = dayEndData['OpClSaved']     ?? 0;
//         }
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
// }
//
// // ────────────────────────────────────────────────────────────────────────────
// // SMALL HELPERS
// // ────────────────────────────────────────────────────────────────────────────
//
// /// Compact date label pill
// class _DateBadge extends StatelessWidget {
//   const _DateBadge({required this.date});
//   final String date;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//       decoration: BoxDecoration(
//         color: _C.blueXL,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         date,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w700,
//           color: _C.blueLight,
//         ),
//       ),
//     );
//   }
// }
//
// /// Styled delete-confirmation dialog
// class _DeleteConfirmDialog extends StatelessWidget {
//   const _DeleteConfirmDialog({
//     required this.onConfirm,
//     required this.onCancel,
//   });
//   final VoidCallback onConfirm;
//   final VoidCallback onCancel;
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: _C.white,
//       icon: Container(
//         width: 52, height: 52,
//         decoration: BoxDecoration(
//           color: _C.redXL,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: const Icon(Icons.delete_outline_rounded, color: _C.red, size: 26),
//       ),
//       title: const Text(
//         'Delete Entry?',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 17,
//           fontWeight: FontWeight.w700,
//           color: _C.text,
//         ),
//       ),
//       content: const Text(
//         'This defective record will be permanently removed.',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 14,
//           color: _C.textMuted,
//           height: 1.5,
//         ),
//       ),
//       actionsAlignment: MainAxisAlignment.center,
//       actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//       actions: [
//         // Cancel
//         Expanded(
//           child: OutlinedButton(
//             onPressed: onCancel,
//             style: OutlinedButton.styleFrom(
//               foregroundColor: _C.textMid,
//               side: const BorderSide(color: _C.border),
//               minimumSize: const Size.fromHeight(46),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text('Cancel',
//                 style: TextStyle(fontWeight: FontWeight.w700)),
//           ),
//         ),
//         const SizedBox(width: 12),
//         // Confirm
//         Expanded(
//           child: ElevatedButton(
//             onPressed: onConfirm, // ORIGINAL handler wired here
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _C.red,
//               foregroundColor: _C.white,
//               elevation: 0,
//               minimumSize: const Size.fromHeight(46),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text('Delete',
//                 style: TextStyle(fontWeight: FontWeight.w700)),
//           ),
//         ),
//       ],
//     );
//   }
// }


// [Commented-out legacy code block omitted for brevity — unchanged from original]

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import 'package:http/http.dart' as http;
import '../DeliveryBoyModel/GetDefectiveStockListModel.dart';

class MarkdefectiveItemUI extends StatefulWidget {
  GetDefectiveStockListModel _listModel;

  MarkdefectiveItemUI(this._listModel, {Key? key}) : super(key: key);

  @override
  State<MarkdefectiveItemUI> createState() => _MarkdefectiveItemUIState();
}

class _MarkdefectiveItemUIState extends State<MarkdefectiveItemUI> {
  List<GetDefectiveStockListModel> _defectiveStockList = []; // UNCHANGED
  bool saveFlag = false;                                      // UNCHANGED

  @override
  void initState() {
    super.initState();
    checkAndSaveDayEndData(); // UNCHANGED
  }

  @override
  Widget build(BuildContext context) {
    final value = widget._listModel;

    // Format date safely
    String dateText = '—';
    try {
      dateText = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse(value.defDate ?? ''));
    } catch (_) {}

    return Padding(
      // CHANGED: was EdgeInsets.symmetric(horizontal: 16, vertical: 12)
      //          horizontal:16 == AppSpacing.lg, vertical:12 == AppSpacing.md
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Date badge ────────────────────────────────────────────
          Expanded(
            flex: 2,
            child: _DateBadge(date: dateText),
          ),

          const SizedBox(width: AppSpacing.sm),

          // ── Item name ─────────────────────────────────────────────
          Expanded(
            flex: 3,
            child: Text(
              value.itemName?.toString() ?? '—',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                // CHANGED: was _C.textMid → AppColors.textMid
                color: AppColors.textMid,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // ── Qty badge ─────────────────────────────────────────────
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                // CHANGED: was EdgeInsets.symmetric(horizontal: 10, vertical: 4)
                //          — horizontal:10, vertical:4 == AppSpacing.xs
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  // CHANGED: was _C.redXL → AppColors.redXL
                  color: AppColors.redXL,
                  // CHANGED: was BorderRadius.circular(20) → AppRadius.xmiStatusBadge (circular(20))
                  borderRadius: AppRadius.xmiStatusBadge,
                ),
                child: Text(
                  value.defQty?.toString() ?? '0',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    // CHANGED: was _C.red → AppColors.red
                    color: AppColors.red,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // ── Delete action ─────────────────────────────────────────
          Expanded(
            flex: 1,
            child: Center(
              child: Material(
                color: Colors.transparent,
                // CHANGED: was BorderRadius.circular(10) — AppRadius.md == 10
                borderRadius: AppRadius.heroBackBtn,
                child: InkWell(
                  borderRadius: AppRadius.heroBackBtn,
                  // CHANGED: was _C.redXL → AppColors.redXL
                  splashColor: AppColors.redXL,
                  onTap: () {
                    // ORIGINAL onTap logic — unchanged
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _DeleteConfirmDialog(
                          onConfirm: () async {
                            Navigator.of(context).pop();
                            if (saveFlag) {
                              print('saveFlag $saveFlag');
                              showFlushBar(context, Constants.dayEndCompleted);
                            } else {
                              deleteDefectiveToApi(value.defId!.toInt());
                            }
                          },
                          onCancel: () => Navigator.of(context).pop(),
                        );
                      },
                    );
                  },
                  child: Padding(
                    // CHANGED: was EdgeInsets.all(6) — AppSpacing.xs+xxs == 6
                    padding: const EdgeInsets.all(AppSpacing.xs + AppSpacing.xxs),
                    child: Container(
                      // CHANGED: was 32/32 — AppSpacing.sqcVehicleIconBox == 34 (close);
                      //           keeping explicit 32 to remain pixel-perfect
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        // CHANGED: was _C.redXL → AppColors.redXL
                        color: AppColors.redXL,
                        // CHANGED: was BorderRadius.circular(9) → AppRadius.markDefectiveDeleteBtn
                        borderRadius: AppRadius.markDefectiveDeleteBtn,
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        // CHANGED: was _C.red → AppColors.red
                        color: AppColors.red,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── API methods (UNCHANGED) ────────────────────────────────────────────
  Future<void> deleteDefectiveToApi(int defectiveId) async {
    SharedPreferences prefs   = await SharedPreferences.getInstance();
    String? distributorId     = prefs.getString('DistributorId');
    String? godownId          = prefs.getString('godownId');
    String? token             = prefs.getString('token');

    int dId = int.parse(distributorId!);
    int gId = int.parse(godownId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(now);

    Map<String, dynamic> requestBody = {
      "DefId": defectiveId,
      "DistributorId": dId,
      "DefDate": formattedDate,
      "GodownId": gId,
      "ItemId": 0,
      "DefQty": 0,
      "Remark": "",
      "Action": "DELETE",
      "AddedBy": 0
    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.DefectiveMasterAdd_Mob}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      print("API Response Status Code DefectiveMasterAdd_Mob: ${response.statusCode}");
      print("API Response Body DefectiveMasterAdd_Mob: ${response.body}");
      if (response.statusCode == 200) {
        print("DefectiveMasterAdd_Mob quantity added successfully!");
        Navigator.pushReplacementNamed(context, '/markDefectiveItemScreen');
        EasyLoading.showToast(Constants.dataDeleted,
            duration: const Duration(milliseconds: 3000));
        _fetchDefectiveData();
      } else {
        print("Failed to add imbalance quantity: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> _fetchDefectiveData() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId   = prefs.getString('DistributorId');
    String? godownId        = prefs.getString('godownId');
    String? token           = prefs.getString('token');
    int dId = int.parse(distributorId!);
    int gId = int.parse(godownId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetDefectiveList_Mob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "DistributorId": dId,
          "DefDate": formattedDate,
          "GodownId": gId,
        }),
      );
      debugPrint('GetDefectiveList_Mob: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _defectiveStockList = data
              .map((json) => GetDefectiveStockListModel.fromJson(json))
              .toList();
          EasyLoading.dismiss();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> checkAndSaveDayEndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId   = prefs.getString('DistributorId');
    String? bearerToken     = prefs.getString('token');
    int? distributorIds     = int.parse(distributorId!);
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> apiResponse = json.decode(response.body);
        if (apiResponse.isEmpty) {
          saveFlag = false;
        } else {
          saveFlag = true;
          var dayEndData    = apiResponse[0];
          int DSRSaved      = dayEndData['DSRSaved']      ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved     = dayEndData['OpClSaved']     ?? 0;
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}

// ────────────────────────────────────────────────────────────────────────────
// SMALL HELPERS
// ────────────────────────────────────────────────────────────────────────────

/// Compact date label pill
class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date});
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      // CHANGED: was EdgeInsets.symmetric(horizontal: 8, vertical: 5)
      //          horizontal:8 == AppSpacing.sm, vertical:5 (no exact token) — kept inline
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs + 1),
      decoration: BoxDecoration(
        // CHANGED: was _C.blueXL → AppColors.blueXL
        color: AppColors.blueXL,
        // CHANGED: was BorderRadius.circular(8) → AppRadius.sm == 8
        borderRadius: AppRadius.iconBadge,
      ),
      child: Text(
        date,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          // CHANGED: was _C.blueLight → AppColors.blueLight
          color: AppColors.blueLight,
        ),
      ),
    );
  }
}

/// Styled delete-confirmation dialog
class _DeleteConfirmDialog extends StatelessWidget {
  const _DeleteConfirmDialog({
    required this.onConfirm,
    required this.onCancel,
  });
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // CHANGED: was BorderRadius.circular(20) → AppRadius.xxl == 20
      shape: RoundedRectangleBorder(
          borderRadius: AppRadius.itemReturnDialog),
      // CHANGED: was _C.white → AppColors.white
      backgroundColor: AppColors.white,
      icon: Container(
        // CHANGED: was 52/52 — AppSpacing.itemReturnDialogIconBox == 36 (too small);
        //           kept explicit 52 for pixel-perfect match
        width: 52, height: 52,
        decoration: BoxDecoration(
          // CHANGED: was _C.redXL → AppColors.redXL
          color: AppColors.redXL,
          // CHANGED: was BorderRadius.circular(15) → AppRadius.markDefectiveDialogIcon
          borderRadius: AppRadius.markDefectiveDialogIcon,
        ),
        child: const Icon(Icons.delete_outline_rounded,
            // CHANGED: was _C.red → AppColors.red
            color: AppColors.red, size: 26),
      ),
      title: const Text(
        'Delete Entry?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          // CHANGED: was _C.text → AppColors.text
          color: AppColors.text,
        ),
      ),
      content: const Text(
        'This defective record will be permanently removed.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          // CHANGED: was _C.textMuted → AppColors.textMuted
          color: AppColors.textMuted,
          height: 1.5,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      // CHANGED: was EdgeInsets.fromLTRB(20, 0, 20, 20) — kept inline (no exact token match)
      actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg + AppSpacing.xs, 0,
          AppSpacing.lg + AppSpacing.xs, AppSpacing.lg + AppSpacing.xs),
      // actions: [
      //   // Cancel
      //   Expanded(
      //     child: OutlinedButton(
      //       onPressed: onCancel,
      //       style: OutlinedButton.styleFrom(
      //         // CHANGED: was _C.textMid → AppColors.textMid
      //         foregroundColor: AppColors.textMid,
      //         // CHANGED: was _C.border → AppColors.border
      //         side: const BorderSide(color: AppColors.border),
      //         minimumSize: const Size.fromHeight(46),
      //         shape: RoundedRectangleBorder(
      //           // CHANGED: was BorderRadius.circular(12) → AppRadius.markDefectiveInput
      //           borderRadius: AppRadius.markDefectiveInput,
      //         ),
      //       ),
      //       child: const Text('Cancel',
      //           style: TextStyle(fontWeight: FontWeight.w700)),
      //     ),
      //   ),
      //   const SizedBox(width: AppSpacing.md),
      //   // Confirm
      //   Expanded(
      //     child: ElevatedButton(
      //       onPressed: onConfirm, // ORIGINAL handler wired here
      //       style: ElevatedButton.styleFrom(
      //         // CHANGED: was _C.red → AppColors.red
      //         backgroundColor: AppColors.red,
      //         // CHANGED: was _C.white → AppColors.white
      //         foregroundColor: AppColors.white,
      //         elevation: 0,
      //         minimumSize: const Size.fromHeight(46),
      //         shape: RoundedRectangleBorder(
      //           // CHANGED: was BorderRadius.circular(12) → AppRadius.markDefectiveInput
      //           borderRadius: AppRadius.markDefectiveInput,
      //         ),
      //       ),
      //       child: const Text('Delete',
      //           style: TextStyle(fontWeight: FontWeight.w700)),
      //     ),
      //   ),
      // ],

      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textMid,
                  side: const BorderSide(color: AppColors.border),
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.markDefectiveInput,
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.markDefectiveInput,
                  ),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}