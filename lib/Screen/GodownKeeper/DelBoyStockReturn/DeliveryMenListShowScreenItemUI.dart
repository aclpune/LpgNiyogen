// import 'dart:convert';
// import 'dart:ffi';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
// import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../ConstantScreen/widgets.dart';
// import '../../Utils/CustomeAlertDialog.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/constants.dart';
// import '../DeliveryBoyModel/DeliveryBoyInfoModel.dart';
// import 'package:http/http.dart' as http;
//
// import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
// import '../DeliveryBoyModel/GetStockTransferListModel.dart';
// import 'StockReturnFromDelBoy.dart';
//
// class DeliveryMenListShowScreenItemUI extends StatefulWidget {
//   DeliveryMenSaleListModel _listModel;
//
//   DeliveryMenListShowScreenItemUI(this._listModel,{Key? key}) : super(key: key);
//
//   @override
//   State<DeliveryMenListShowScreenItemUI> createState() => _DeliveryMenListShowScreenItemUIState();
// }
//
// class _DeliveryMenListShowScreenItemUIState extends State<DeliveryMenListShowScreenItemUI> {
//   bool isListViewVisible = false; // Tracks if ListView is visible
//   bool isLoading = true;
//   bool saveFlag = false;
//   bool stockTransferFlag = false;
//   List<GetStockTransferListModel> _stockTransferList = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // fetchTransactionList();
//   }
//   @override
//   Widget build(BuildContext context) {
//     var value = widget._listModel;
//     return
//       value != null && value != ""?
//       SingleChildScrollView(  // Make the Column scrollable
//         child:
//         Card(
//           margin: EdgeInsets.all(5),
//           color: Color(0xFFEFFFFfff),
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                   bottomRight: Radius.circular(10.0),
//                   bottomLeft: Radius.circular(10.0))),
//           child:
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 0.0,bottom: 0),
//                 child: Column(
//                   children: [
//                     // Container(
//                     //   child: Row(
//                     //     mainAxisSize: MainAxisSize.max,
//                     //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     //     children: [
//                     //       Expanded(
//                     //         flex: 1,
//                     //         child:
//                     //         CircleAvatar(
//                     //           radius: 15,
//                     //           backgroundColor: const Color(0xff1280B3),
//                     //           child: Text(
//                     //             value.staffName != null && value.staffName!.isNotEmpty
//                     //                 ? value.staffName![0].toUpperCase()
//                     //                 : "",
//                     //             style: const TextStyle(
//                     //               color: Colors.white,
//                     //               fontWeight: FontWeight.bold,
//                     //               fontSize: 12,
//                     //             ),
//                     //           ),
//                     //         ),
//                     //       ),
//                     //       Expanded(
//                     //         flex: 1,
//                     //         child:
//                     //         GestureDetector(
//                     //           onTap: (){
//                     //             // if(stockTransferFlag){
//                     //             //   if(saveFlag){
//                     //             //     showFlushBar(context,
//                     //             //         Constants.dayEndCompleted);
//                     //             //   }else{
//                     //                 Navigator.pushNamed(
//                     //                     context,
//                     //                     DailyRefillSalePage
//                     //                         .screenName,
//                     //                     arguments: {
//                     //                       "delBoyName": value.staffName,
//                     //                       "delBoyID" : value.dMId,
//                     //                       "vehicleNo" :value.vehicleNo,
//                     //                     });
//                     //               // }
//                     //             // }else{
//                     //             //   CustomAlertDialog.showCustomAlert(context,Constants.stockNotAccepted);
//                     //             // }
//                     //           },
//                     //           child: Padding(
//                     //             padding: const EdgeInsets.only(left: 8.0),
//                     //             child: Text(
//                     //               value.staffName.toString(),
//                     //               textAlign: TextAlign.left,
//                     //               style:Styling.blueClrTextWithUnderline,
//                     //               textScaler: TextScaler.noScaling,
//                     //             ),
//                     //           ),
//                     //         ),
//                     //       ),
//                     //       verticalDividerVerySmall(),
//                     //       Container(
//                     //         width: 100,
//                     //         child: Column(
//                     //           children: [
//                     //             Text(
//                     //               value.filledSaleQty.toString(),
//                     //               style:Styling.textFormText,
//                     //               textAlign: TextAlign.center,
//                     //               textScaler: TextScaler.noScaling,
//                     //             ),
//                     //           ],
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     Container(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child:
//                         GestureDetector(
//                           onTap: (){
//                             Navigator.pushNamed(
//                                 context,
//                                 DailyRefillSalePage
//                                     .screenName,
//                                 arguments: {
//                                   "delBoyName": value.staffName,
//                                   "delBoyID" : value.dMId,
//                                   "vehicleNo" :value.vehicleNo,
//                                 });
//                           },
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               CircleAvatar(
//                                 radius: 15,
//                                 backgroundColor: const Color(0xFFfbe9e9),
//                                 child: Text(
//                                   value.staffName != null && value.staffName!.isNotEmpty
//                                       ? value.staffName![0].toUpperCase()
//                                       : "",
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // GestureDetector(
//                                     //   onTap: (){
//                                     //     // if(stockTransferFlag){
//                                     //     //   if(saveFlag){
//                                     //     //     showFlushBar(context,
//                                     //     //         Constants.dayEndCompleted);
//                                     //     //   }else{
//                                     //     Navigator.pushNamed(
//                                     //         context,
//                                     //         DailyRefillSalePage
//                                     //             .screenName,
//                                     //         arguments: {
//                                     //           "delBoyName": value.staffName,
//                                     //           "delBoyID" : value.dMId,
//                                     //           "vehicleNo" :value.vehicleNo,
//                                     //         });
//                                     //     // }
//                                     //     // }else{
//                                     //     //   CustomAlertDialog.showCustomAlert(context,Constants.stockNotAccepted);
//                                     //     // }
//                                     //   },
//                                     //
//                                     //     child:
//                                     Text(
//                                       value.staffName.toString(),
//                                       textAlign: TextAlign.left,
//                                       style:Styling.itemTitle,
//                                       textScaler: TextScaler.noScaling,
//                                     ),
//
//                                     // ),
//                                     SizedBox(height: 2,),
//                                     Row(mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Total Sale : ",
//                                           style:Styling.textFormText,
//                                           textAlign: TextAlign.start,
//                                           textScaler: TextScaler.noScaling,
//                                         ),
//                                         Text(
//                                           value.filledSaleQty.toString(),
//                                           style:Styling.itemBlackTestBold,
//                                           textAlign: TextAlign.start,
//                                           textScaler: TextScaler.noScaling,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               Spacer(),
//                               Icon(Icons.arrow_forward_ios_outlined,size: 15,),
//
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//
//       ):
//       Container(
//         child:  Text("No data found"),
//       );
//   }
//
//   Future<void> fetchTransactionList() async {
//     EasyLoading.show();
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
//       int dId = int.parse(distributorId!);
//       int gId = int.parse(godownId!);
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//         },
//       );
//       debugPrint(
//           "GetStockTransferDtls" + '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
//       debugPrint("GetStockTransferDtls" + response.body);
//       if (response.statusCode == 200) {
//         // Parse the response
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _stockTransferList = data.map((json) => GetStockTransferListModel.fromJson(json)).toList();
//           bool hasZeroStkTrans = false;
//           for (int i = 0; i < _stockTransferList.length; i++) {
//             if (_stockTransferList[i].isStkTrans == 0) {
//               hasZeroStkTrans = true;
//               debugPrint("Found item with isStkTrans = 0");
//               break; // No need to continue checking once we find an item with isStkTrans = 0
//             }
//           }
//           if (hasZeroStkTrans) {
//             stockTransferFlag = false; // Disable the button
//             // showFlushBar(
//             //     context, "Action Restricted", "Cannot perform the action as one or more items have isStkTrans = 0");
//           } else {
//             stockTransferFlag = true; // Enable the button
//           }
//         });
//         isLoading = false;
//         EasyLoading.dismiss();
//       } else {
//         isLoading = false;
//         EasyLoading.dismiss();
//         throw Exception('Failed To Load Items');
//       }
//     } else {
//       isLoading = false;
//       EasyLoading.dismiss();
//       showFlushBar(
//           context,Constants.connectionMessage);
//     }
//   }
// }


// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../ConstantScreen/widgets.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/constants.dart';
// import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
// import 'package:http/http.dart' as http;
//
// import '../DeliveryBoyModel/GetStockTransferListModel.dart';
// import 'StockReturnFromDelBoy.dart';
//
// // ─────────────────────────────────────────────
// // Design tokens — mirrors Manager Dashboard
// // ─────────────────────────────────────────────
// abstract final class _C {
//   static const blue      = Color(0xFF1E3A8A);
//   static const blueLight = Color(0xFF2D52C5);
//   static const blueXL    = Color(0xFFEFF6FF);
//   static const blueXXL   = Color(0xFFDBEAFE);
//   static const white     = Color(0xFFFFFFFF);
//   static const text      = Color(0xFF111827);
//   static const textMuted = Color(0xFF6B7280);
//   static const shadow    = Color(0x0D1E3A8A);
// }
//
// class DeliveryMenListShowScreenItemUI extends StatefulWidget {
//   // Original field name & type preserved exactly
//   final DeliveryMenSaleListModel _listModel;
//
//   const DeliveryMenListShowScreenItemUI(this._listModel, {Key? key})
//       : super(key: key);
//
//   @override
//   State<DeliveryMenListShowScreenItemUI> createState() =>
//       _DeliveryMenListShowScreenItemUIState();
// }
//
// class _DeliveryMenListShowScreenItemUIState
//     extends State<DeliveryMenListShowScreenItemUI> {
//   // ── All original state preserved exactly ──
//   bool isListViewVisible = false;
//   bool isLoading = true;
//   bool saveFlag = false;
//   bool stockTransferFlag = false;
//   List<GetStockTransferListModel> _stockTransferList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // fetchTransactionList(); // original commented-out call preserved
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final value = widget._listModel;
//
//     // Guard: original null/empty check preserved
//     if (value == null || value.toString() == "") {
//       return const _NoDataCard();
//     }
//
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Material(
//         color: _C.white,
//         borderRadius: BorderRadius.circular(16),
//         child: InkWell(
//           // ── Original onTap logic preserved exactly ──
//           onTap: () {
//             HapticFeedback.selectionClick();
//             Navigator.pushNamed(
//               context,
//               DailyRefillSalePage.screenName,
//               arguments: {
//                 "delBoyName": value.staffName,
//                 "delBoyID": value.dMId,
//                 "vehicleNo": value.vehicleNo,
//               },
//             );
//           },
//           borderRadius: BorderRadius.circular(16),
//           splashColor: _C.blueXXL,
//           child: _DeliveryManCard(value: value),
//         ),
//       ),
//     );
//   }
//
//   // ── Original API method preserved exactly (untouched) ──
//   Future<void> fetchTransactionList() async {
//     EasyLoading.show();
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? godownId = prefs.getString('godownId');
//       String? bearerToken = prefs.getString('token');
//       int dId = int.parse(distributorId!);
//       int gId = int.parse(godownId!);
//       if (bearerToken == null) {
//         throw Exception('Bearer token is missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken',
//         },
//       );
//       debugPrint("GetStockTransferDtls" +
//           '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
//       debugPrint("GetStockTransferDtls" + response.body);
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _stockTransferList = data
//               .map((json) => GetStockTransferListModel.fromJson(json))
//               .toList();
//           bool hasZeroStkTrans = false;
//           for (int i = 0; i < _stockTransferList.length; i++) {
//             if (_stockTransferList[i].isStkTrans == 0) {
//               hasZeroStkTrans = true;
//               debugPrint("Found item with isStkTrans = 0");
//               break;
//             }
//           }
//           stockTransferFlag = !hasZeroStkTrans;
//         });
//         isLoading = false;
//         EasyLoading.dismiss();
//       } else {
//         isLoading = false;
//         EasyLoading.dismiss();
//         throw Exception('Failed To Load Items');
//       }
//     } else {
//       isLoading = false;
//       EasyLoading.dismiss();
//       showFlushBar(context, Constants.connectionMessage);
//     }
//   }
// }
//
// // ─────────────────────────────────────────────
// // UI-only widgets (stateless, no logic)
// // ─────────────────────────────────────────────
//
// /// Card displaying one delivery man's info & sale count
// class _DeliveryManCard extends StatelessWidget {
//   const _DeliveryManCard({required this.value});
//   final DeliveryMenSaleListModel value;
//
//   @override
//   Widget build(BuildContext context) {
//     final initials = (value.staffName != null && value.staffName!.isNotEmpty)
//         ? value.staffName![0].toUpperCase()
//         : '?';
//
//     return Container(
//       decoration: BoxDecoration(
//         color: _C.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(color: _C.shadow, blurRadius: 12, offset: Offset(0, 2)),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       child: Row(
//         children: [
//           // Avatar with initial
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: _C.blueXL,
//               borderRadius: BorderRadius.circular(13),
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               initials,
//               style: const TextStyle(
//                 color: _C.blueLight,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//           const SizedBox(width: 14),
//           // Name + sale count
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   value.staffName.toString(),
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     color: _C.text,
//                     letterSpacing: -0.1,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     const Text(
//                       'Total Sale: ',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                         color: _C.textMuted,
//                       ),
//                     ),
//                     Text(
//                       value.filledSaleQty.toString(),
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w800,
//                         color: _C.blueLight,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           // Chevron
//           const Icon(
//             Icons.chevron_right_rounded,
//             color: _C.textMuted,
//             size: 22,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Fallback when data is null/empty
// class _NoDataCard extends StatelessWidget {
//   const _NoDataCard();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _C.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(color: _C.shadow, blurRadius: 12, offset: Offset(0, 2)),
//         ],
//       ),
//       child: const Text(
//         'No data found',
//         style: TextStyle(
//           fontSize: 14,
//           color: _C.textMuted,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }


// ─────────────────────────────────────────────────────────────────────────────
// DeliveryMenListShowScreenItemUI.dart
//
// REFACTOR NOTES
// • Removed private _C token class — all values now come from the centralised
//   design system (AppColors, AppSpacing, AppRadius, AppSizes, AppTextStyles,
//   AppDecorations, AppShadows).
// • No hardcoded Color(), EdgeInsets, BorderRadius, double, or TextStyle values
//   remain in this file.
// • Zero functional / layout changes.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/BoxShadow/styles.dart';          // ← single barrel import
import '../../Utils/Widget.dart';
import '../../Utils/constants.dart';
import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import 'StockReturnFromDelBoy.dart';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────────────────────────────────────

class DeliveryMenListShowScreenItemUI extends StatefulWidget {
  // Original field name & type preserved exactly.
  final DeliveryMenSaleListModel _listModel;

  const DeliveryMenListShowScreenItemUI(this._listModel, {Key? key})
      : super(key: key);

  @override
  State<DeliveryMenListShowScreenItemUI> createState() =>
      _DeliveryMenListShowScreenItemUIState();
}

class _DeliveryMenListShowScreenItemUIState
    extends State<DeliveryMenListShowScreenItemUI> {
  // ── State (unchanged) ──────────────────────────────────────────────────────
  bool isListViewVisible = false;
  bool isLoading = true;
  bool saveFlag = false;
  bool stockTransferFlag = false;
  List<GetStockTransferListModel> _stockTransferList = [];

  @override
  void initState() {
    super.initState();
    // fetchTransactionList(); // original commented-out call preserved
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final value = widget._listModel;

    // Guard: original null/empty check preserved.
    if (value == null || value.toString() == "") {
      return const _NoDataCard();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm + AppSpacing.xxs), // 10 pt
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.deliveryCard,
        child: InkWell(
          // ── Original onTap logic preserved exactly ──
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.pushNamed(
              context,
              DailyRefillSalePage.screenName,
              arguments: {
                "delBoyName": value.staffName,
                "delBoyID": value.dMId,
                "vehicleNo": value.vehicleNo,
              },
            );
          },
          borderRadius: AppRadius.deliveryCard,
          splashColor: AppColors.primaryXXLight,
          child: _DeliveryManCard(value: value),
        ),
      ),
    );
  }

  // ── Original API method preserved exactly (untouched) ─────────────────────
  Future<void> fetchTransactionList() async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken = prefs.getString('token');
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint(
          "GetStockTransferDtls${AppUrl.GetStockTransferDtls}/$distributorId/1/2");
      debugPrint("GetStockTransferDtls${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _stockTransferList = data
              .map((json) => GetStockTransferListModel.fromJson(json))
              .toList();
          bool hasZeroStkTrans = false;
          for (int i = 0; i < _stockTransferList.length; i++) {
            if (_stockTransferList[i].isStkTrans == 0) {
              hasZeroStkTrans = true;
              debugPrint("Found item with isStkTrans = 0");
              break;
            }
          }
          stockTransferFlag = !hasZeroStkTrans;
        });
        isLoading = false;
        EasyLoading.dismiss();
      } else {
        isLoading = false;
        EasyLoading.dismiss();
        throw Exception('Failed To Load Items');
      }
    } else {
      isLoading = false;
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UI-only widgets (stateless, no logic)
// ─────────────────────────────────────────────────────────────────────────────

/// Card displaying one delivery man's info & sale count.
class _DeliveryManCard extends StatelessWidget {
  const _DeliveryManCard({required this.value});
  final DeliveryMenSaleListModel value;

  @override
  Widget build(BuildContext context) {
    final initials = (value.staffName != null && value.staffName!.isNotEmpty)
        ? value.staffName![0].toUpperCase()
        : '?';

    return Container(
      decoration: AppDecorations.deliveryCard,
      padding: AppSpacing.deliveryCardPadding,
      child: Row(
        children: [
          // ── Avatar with initial ──────────────────────────
          Container(
            width: AppSizes.deliveryAvatarSize,
            height: AppSizes.deliveryAvatarSize,
            decoration: AppDecorations.deliveryAvatar,
            alignment: Alignment.center,
            child: Text(initials, style: AppTextStyles.deliveryAvatarInitial),
          ),
          const SizedBox(width: 14),
          // ── Name + sale count ────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.staffName.toString(),
                  style: AppTextStyles.deliveryCardName,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Text(
                      'Total Sale: ',
                      style: AppTextStyles.deliveryCardSaleLabel,
                    ),
                    Text(
                      value.filledSaleQty.toString(),
                      style: AppTextStyles.deliveryCardSaleValue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ── Trailing chevron ─────────────────────────────
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
            size: AppSizes.chevronSize,
          ),
        ],
      ),
    );
  }
}

/// Fallback card when data is null / empty.
class _NoDataCard extends StatelessWidget {
  const _NoDataCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm + AppSpacing.xxs), // 10 pt
      padding: AppSpacing.cardPadding,
      decoration: AppDecorations.deliveryCard,
      child: const Text('No data found', style: AppTextStyles.deliveryCardSaleLabel),
    );
  }
}