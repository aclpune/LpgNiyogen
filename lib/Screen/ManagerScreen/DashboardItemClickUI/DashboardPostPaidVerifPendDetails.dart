// import 'dart:convert';
// import 'dart:core';
// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetDashboardPostpaidVarifiPendCntLstForMobListModel.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../ConstantScreen/widgets.dart';
// import '../../Utils/Styling.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/app_url.dart';
// import '../ClickModelClass/GetBankMappingDetailsListModel.dart';
// import 'DashboardPostPaidVerifPendDetailsUI.dart';
//
// class DashboardPostPaidVerifPendDetails extends StatefulWidget {
//   static const screenName = '/dashboardPostPaidVerifPendDetails';
//   @override
//   State<StatefulWidget> createState() {
//     return _DashboardPostPaidVerifPendDetails();
//   }
// }
//
// class _DashboardPostPaidVerifPendDetails extends State<DashboardPostPaidVerifPendDetails>{
//
//   List<GetDashboardPostpaidVarifiPendCntLstForMobListModel> postpaidverifipending = [];
//   List<GetDashboardPostpaidVarifiPendCntLstForMobListModel> filteredPostpaidModel = [];
//   List<GetBankMappingDetailsListModel> bankmappingModel = [];
//   String? flag;
//   String? selectedBank;
//   String? selectedBankName,selectedBankId;
//   int? isActive;
//   bool isLoading = true;
//   bool isChecked = false;
//   bool isSubmitEnabledBtn = false; // Initially disabled
//   List<String> getTransactionForList = ["All","Daily Sales","SV Sales","ARB Sales","Receipt"];
//   var argValue;
//   DateTime? _selectedDate;
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.delayed(Duration.zero, () {
//       setState(() {
//         argValue = ModalRoute
//             .of(context)
//             ?.settings
//             .arguments as Map;
//         flag = argValue["flag"];
//         fetchPrepaid(flag!);
//
//       });
//     });
//     fetchBank();
//   }
//
//   void filterSearchResults(String query) {
//     setState(() {
//       filteredPostpaidModel = postpaidverifipending
//           .where((item) => item.staffName!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   Future<void> fetchPrepaid(String flag) async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
//
//     //String formattedDate = DateFormat('yyyy-MM-dd').format(date! as DateTime);
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//
//     };
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetDashboardPostpaidVarifiPendCntLstForMob}/$distributorId/$flag'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetDashboardPostpaidVarifiPendCntLstForMobListModel : " + '${AppUrl.GetDashboardPostpaidVarifiPendCntLstForMob}/$distributorId/$flag');
//     debugPrint("GetDashboardPostpaidVarifiPendCntLstForMobListModelresponse : " + '${response.body}');
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//
//       setState(() {
//         postpaidverifipending = data.map((json) {
//           String dateString = json['TransDate'];
//           DateTime date = DateTime.parse(dateString);
//           String formattedDate = DateFormat('yyyy-MM-dd').format(date);
//           json['TransDate'] = formattedDate;
//
//           return GetDashboardPostpaidVarifiPendCntLstForMobListModel.fromJson(json);
//         }).toList();
//         isLoading = false;
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//   Future<void> fetchBank() async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//     };
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetBankMappingDetailsList}/$distributorId/1'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetBankMappingDetailsListModel : " + '${AppUrl.GetBankMappingDetailsList}/$distributorId/1');
//     debugPrint("GetBankMappingDetailsListModel : " + '${response.body}');
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//
//       setState(() {
//         bankmappingModel = data.map((json) {
//           return GetBankMappingDetailsListModel.fromJson(json);
//         }).toList();
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var postCount = postpaidverifipending.length;
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         surfaceTintColor: Color(0xFFECEFFF),
//         backgroundColor: Color(0xFFECEFFF),
//         flexibleSpace: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.black),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                         child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Postpaid Verification',
//                               style: TextStyle(fontSize: 14, color: Colors.black),
//                             ),
//                             Text(
//                               'Count: $postCount',
//                               style: TextStyle(fontSize: 12, color: Colors.black),
//                             ),
//                           ],
//                         ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body:
//       isLoading
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//           : Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child:
//               Row(
//                 children: [
//                   Text("Select Item :",style: Styling.blueClrText),
//                   Expanded(
//                     child: DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//                       ),
//                       style: Styling.itemBlackTest,
//                       items: getTransactionForList
//                           .map((String value) => DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       ))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           String? selectedPaymentMode = value;
//                           String? newValue = selectedPaymentMode?.replaceAll(' ', '');
//                           debugPrint(newValue);
//                           fetchPrepaid(newValue!);
//                         });
//                       },
//                       isExpanded: true,
//                       hint: Text('All'),
//                     ),
//                   ),
//                 ],
//               ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : postpaidverifipending.isNotEmpty
//                 ? ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               itemCount: postpaidverifipending.length,
//               itemBuilder: (context, index) {
//                 final sale = postpaidverifipending[index];
//                 debugPrint("Rendering Expense Item: $sale");
//                 return Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(flex: 1, child: countTextWidgetText(context, "Trans Time", nullToDash(sale.transTime))),
//                         Expanded(flex: 1, child: countTextWidgetText(context, "Amount", nullToDash(formatCurrency((sale.amount ?? 0.0).toDouble())))),
//                       ],
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Expanded(flex: 1, child: countTextWidgetText(context, "Trans For", nullToDash(sale.transFor))),
//                       ],
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Expanded(flex: 1, child: countTextWidgetText(context, "Trans Date", nullToDash(sale.transDate))),
//                       ],
//                     ),
//
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Expanded(flex: 1, child: countTextWidgetText(context, "Trans Code", nullToDash(sale.transCode))),
//                       ],
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Expanded(flex: 1, child: countTextWidgetText(context, "Staff Name", nullToDash(sale.staffName))),
//                       ],
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Expanded(flex: 1, child: countTextWidgetRemark(context, "Remark", sale.remark ?? '')),
//                       ],
//                     ),
//                     const Divider(),
//                   ],
//                 );
//               },
//             )
//                 : const Center(child: Text('No Records Found')),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String nullToDash(String? value) {
//     if (value == null || value.toLowerCase() == "null") {
//       return "-";
//     }
//     return value;
//   }
//
//   Future<void> _selectDate(BuildContext context, int index) async {
//     debugPrint("Current selectedDate: ${postpaidverifipending[index].selectedDate}");
//
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: postpaidverifipending[index].selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (picked != null) {
//       debugPrint("Picked date: $picked");
//       setState(() {
//         postpaidverifipending[index].selectedDate = picked;
//       });
//     } else {
//       debugPrint("Date is null or canceled");
//     }
//   }
//
// }
//
// String formatCurrency(double amount) {
//   if (amount == 0) {
//     return '0.00'; // Return "0.00" if the amount is zero
//   }
//   final format = NumberFormat('#,##,###.00', 'en_IN'); // Indian locale with comma separator
//
//   // Ensure the result always shows a leading zero before the decimal point
//   String formattedAmount = format.format(amount);
//
//   // If there's no integer part, it ensures that a leading zero is added before decimal
//   if (amount < 1 && formattedAmount.startsWith('.')) {
//     formattedAmount = '0' + formattedAmount;
//   }
//
//   return formattedAmount;
// }


import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetDashboardPostpaidVarifiPendCntLstForMobListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/BoxShadow/app_typography.dart';
import '../ClickModelClass/GetBankMappingDetailsListModel.dart';
import 'DashboardPostPaidVerifPendDetailsUI.dart';

// ─────────────────────────────────────────────────────────────────────────────
// POSTPAID VERIFICATION PENDING — LIST SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class DashboardPostPaidVerifPendDetails extends StatefulWidget {
  static const screenName = '/dashboardPostPaidVerifPendDetails';

  @override
  State<DashboardPostPaidVerifPendDetails> createState() =>
      _DashboardPostPaidVerifPendDetailsState();
}

class _DashboardPostPaidVerifPendDetailsState
    extends State<DashboardPostPaidVerifPendDetails> {
  // ── State ──────────────────────────────────────────────────────────────────
  List<GetDashboardPostpaidVarifiPendCntLstForMobListModel>
  postpaidverifipending = [];
  List<GetDashboardPostpaidVarifiPendCntLstForMobListModel>
  filteredPostpaidModel = [];
  List<GetBankMappingDetailsListModel> bankmappingModel = [];

  String? flag;
  String? selectedBank;
  String? selectedBankName, selectedBankId;
  int? isActive;
  bool isLoading = true;
  bool isChecked = false;
  bool isSubmitEnabledBtn = false;
  String _selectedFilter = 'All'; // tracks the currently selected filter

  final List<String> getTransactionForList = [
    'All',
    'Daily Sales',
    'SV Sales',
    'ARB Sales',
    'Receipt',
  ];

  var argValue;
  DateTime? _selectedDate;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        flag = argValue['flag'];
        fetchPrepaid(flag!);
      });
    });
    fetchBank();
  }

  // ── Filtering ──────────────────────────────────────────────────────────────
  void filterSearchResults(String query) {
    setState(() {
      filteredPostpaidModel = postpaidverifipending
          .where((item) =>
          item.staffName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // ── API calls (unchanged) ──────────────────────────────────────────────────
  Future<void> fetchPrepaid(String flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse(
          '${AppUrl.GetDashboardPostpaidVarifiPendCntLstForMob}/$distributorId/$flag'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint(
        'GetDashboardPostpaidVarifiPendCntLstForMobListModel : ${AppUrl.GetDashboardPostpaidVarifiPendCntLstForMob}/$distributorId/$flag');
    debugPrint(
        'GetDashboardPostpaidVarifiPendCntLstForMobListModelresponse : ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        postpaidverifipending = data.map((json) {
          String dateString = json['TransDate'];
          DateTime date = DateTime.parse(dateString);
          String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          json['TransDate'] = formattedDate;
          return GetDashboardPostpaidVarifiPendCntLstForMobListModel.fromJson(
              json);
        }).toList();
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> fetchBank() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse('${AppUrl.GetBankMappingDetailsList}/$distributorId/1'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint(
        'GetBankMappingDetailsListModel : ${AppUrl.GetBankMappingDetailsList}/$distributorId/1');
    debugPrint('GetBankMappingDetailsListModel : ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        bankmappingModel = data
            .map((json) => GetBankMappingDetailsListModel.fromJson(json))
            .toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    debugPrint(
        'Current selectedDate: ${postpaidverifipending[index].selectedDate}');

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: postpaidverifipending[index].selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      debugPrint('Picked date: $picked');
      setState(() {
        postpaidverifipending[index].selectedDate = picked;
      });
    } else {
      debugPrint('Date is null or canceled');
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  static String nullToDash(String? value) {
    if (value == null || value.toLowerCase() == 'null') return '–';
    return value;
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // appBar: _buildAppBar(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppGradientHeader(
          title: 'Postpaid Verification',
          subtitle: 'Count: ${postpaidverifipending.length}',
          icon: Icons.receipt_long_rounded,
          // onBack: () => Navigator.pushReplacementNamed(context, '/bottomNavBarExample'),
          onBack: () => Navigator.pop(context)
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : Column(
        children: [
          _FilterBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradHero),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 4),

                // Title + count
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Postpaid Verification',
                        style: AppTypography.heroTitle,
                      ),
                      Text(
                        'Count: ${postpaidverifipending.length}',
                        style: AppTypography.heroSubtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (postpaidverifipending.isEmpty) {
      return _EmptyState();
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: postpaidverifipending.length,
      itemBuilder: (context, index) {
        return DashboardPostPaidVeriPendDetailsUI(
          postpaidverifipending[index],
        );
      },
    );
  }

  /// Filter dropdown bar — "Select Item" with the transaction-for list.
  Widget _FilterBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          // Label
          const Text(
            'Filter by:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 10),

          // Dropdown
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.background2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryXXLight),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedFilter,
                  hint: Text(
                    'All',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary, size: 20),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  items: getTransactionForList
                      .map(
                        (value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedFilter = value;
                      final newValue = value.replaceAll(' ', '');
                      debugPrint(newValue);
                      fetchPrepaid(newValue);
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryXLight,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.inbox_rounded,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No Records Found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No pending verification transactions.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CURRENCY FORMATTER  (unchanged — business logic)
// ─────────────────────────────────────────────────────────────────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final format = NumberFormat('#,##,###.00', 'en_IN');
  String formattedAmount = format.format(amount);
  if (amount < 1 && formattedAmount.startsWith('.')) {
    formattedAmount = '0$formattedAmount';
  }
  return formattedAmount;
}