// import 'dart:convert';
// import 'dart:core';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:intl/intl.dart';
// import 'package:lpgsalesandinventory/Screen/ManagerScreen/DashboardItemClickUI/DashboardSVDetailUI.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../ConstantScreen/widgets.dart';
// import '../../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
// import '../../Utils/Styling.dart';
// import '../../Utils/Widget.dart';
// import '../../Utils/app_url.dart';
// import '../../Utils/constants.dart';
// import '../ClickModelClass/GetDashboardSVStockPendCtnListForMobListModel.dart';
//
// class DashboardSVDetails extends StatefulWidget {
//   static const screenName = '/dashboardSVDetails';
//   @override
//   State<StatefulWidget> createState() {
//     return _DashboardSVDetails();
//   }
// }
//
// class _DashboardSVDetails extends State<DashboardSVDetails>{
//   List<GetDashboardSvStockPendCtnListForMobListModel> svmodel = [];
//   bool isLoading = true;
//   String todayDate = DateTime.now().toString();
//   int? flag;
//   DateTime? date;
//   List<CylItemListModel> _items = [];
//   CylItemListModel? _selectedItemModel;
//   String? _selectedItem;
//   int? selectedItemId;
//   var argValue;
//   final CylItemListModel allItem = CylItemListModel(itemId: -1, itemName: "ALL");
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
//         fetchSV(flag!);
//       });
//     });
//     fetchItems();
//     _selectedItemModel = allItem;
//   }
//
//   Future<void> fetchSV(int flag) async {
//     EasyLoading.show();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
//
//     if (bearerToken == null) {
//       throw Exception('Bearer token is missing');
//     }
//
//     final response = await http.get(
//       Uri.parse('${AppUrl.GetDashboardSVStockPendCtnListForMob}/$distributorId/$flag'),
//       headers: {
//         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//       },
//     );
//     debugPrint("GetDashboardSvStockPendCtnListForMobListModel : " + '${AppUrl.GetDashboardSVStockPendCtnListForMob}/$distributorId/$flag');
//     debugPrint("GetDashboardSvStockPendCtnListForMobListModelresponsebody " + '${response.body}');
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       setState(() {
//         svmodel = data.map((json) {
//           // String dateString = json[''];
//           // DateTime date = DateTime.parse(dateString);
//           // String formattedDate = DateFormat('yyyy-MM-dd').format(date);
//           // json[''] = formattedDate;
//
//
//          // Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(value.stkTransDate ?? '')),
//
//           //     String formattedDate = DateFormat('yyyy-MM-dd').format(date!);
//           // debugPrint("formattedDate :- ${formattedDate.toString()}");
//           return GetDashboardSvStockPendCtnListForMobListModel.fromJson(json);
//         }).toList();
//         isLoading = false;
//         EasyLoading.dismiss();
//       });
//     } else {
//       EasyLoading.dismiss();
//       throw Exception('Failed to load items');
//     }
//   }
//
//   Future<void> fetchItems() async {
//     Constants.isNetworkAvailable =
//     await InternetConnectionChecker().hasConnection;
//     if (Constants.isNetworkAvailable) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? distributorId = prefs.getString('DistributorId');
//       String? bearerToken =
//       prefs.getString('token'); // Assuming the token is stored here
//
//       if (bearerToken == null) {
//         throw Exception('Bearer Token Is Missing');
//       }
//
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/c'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken', // Add Bearer token here
//         },
//       );
//       debugPrint("item" + '${AppUrl.GetItemMasterList}/$distributorId/1/c');
//       debugPrint("item" + response.body);
//       if (response.statusCode == 200) {
//         // Parse the response
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
//         });
//       } else {
//         throw Exception('Unable To Load Data At This Time. Please Try Again');
//       }
//     } else {
//       showFlushBar(
//           context,Constants.connectionMessage);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     final totalCylQty = svmodel.fold<num>(0, (sum, item) => sum + (item.cylQty ?? 0));
//     final totalAmount = svmodel.fold<double>(0.0, (sum, item) => sum + (item.totalAmount ?? 0.0));
//     final formattedAmount = formatCurrency(totalAmount);
//     var svCount = svmodel.length;
//
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
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('SV Stock Movement',
//                             style: TextStyle(fontSize: 14, color: Colors.black),
//                           ),
//                           Text(
//                             'Count: $svCount',
//                             style: TextStyle(fontSize: 12, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       // appBar: AppBar(
//       //   title: Column(
//       //     crossAxisAlignment: CrossAxisAlignment.start,
//       //     children: [
//       //       Text('Postpaid Verification'),
//       //       Text(
//       //         'Count: $svCount',
//       //         style: TextStyle(fontSize: 14, color: Colors.white70),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//       body: isLoading
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
//                     child: DropdownButtonFormField<CylItemListModel>(
//                       decoration: buildInputBorderUpdateStatus("ALL", context),
//                       value: _selectedItemModel,
//                       items: [
//                         DropdownMenuItem<CylItemListModel>(
//                           value: allItem,
//                           child: Text(
//                             "ALL",
//                             style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
//                           ),
//                         ),
//                         ..._items.map((CylItemListModel item) {
//                           return DropdownMenuItem<CylItemListModel>(
//                             value: item,
//                             child: Text(
//                               item.itemName ?? '',
//                               style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
//                             ),
//                           );
//                         }).toList(),
//                       ],
//                       onChanged: (CylItemListModel? selectedItem) {
//                         if (selectedItem != null) {
//                           setState(() {
//                             _selectedItemModel = selectedItem;
//
//                             if (selectedItem.itemId == -1) {
//                               _selectedItem = "ALL";
//                               selectedItemId = -1;
//
//                               fetchSV(flag!); // ← Add this to fetch all again
//                             } else {
//                               _selectedItem = selectedItem.itemName!;
//                               selectedItemId = selectedItem.itemId?.toInt();
//                               fetchSV(selectedItemId!);
//                             }
//                           });
//                         }
//                       },
//                       hint: Text('ALL'),
//                     ),
//                   ),
//                 ],
//               ),
//
//           ),
//           Expanded(
//             child: svmodel.isNotEmpty
//                 ? ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: svmodel.length,
//               itemBuilder: (context, index) {
//                 debugPrint(
//                     "Rendering Expense Item: ${svmodel[index]}");
//                 return DashboardSVDetailUI(
//                   svmodel[index],
//                 );
//               },
//             )
//                 : Center(
//               child: Text('No Records Found'),
//             ),
//           ),
//           //if (svmodel.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                    // 'Cyl. Qty: $totalCylQty',
//                     'Cyl. Qty: ${svmodel.isNotEmpty ? totalCylQty : 0}',
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Text(
//                    // 'Amount: ₹${formattedAmount}',
//                     'Amount: ${svmodel.isNotEmpty ? formattedAmount : '0.00'}',
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
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
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DashboardItemClickUI/DashboardSVDetailUI.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../GodownKeeper/ItemReceipt/CylItemList/CylItemListModel.dart';
import '../../Utils/BoxShadow/app_typography.dart';
import '../../Utils/BoxShadow/section_header.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import '../ClickModelClass/GetDashboardSVStockPendCtnListForMobListModel.dart';

// =============================================================================
// DashboardSVDetails
// Full-screen list of SV Stock Movement records.
//
//   • Gradient AppBar (AppColors.gradPrimary) with count + cyl-qty badges
//   • Pill-style item filter bar using the design-system dropdown decoration
//   • SectionHeader with teal dot (reuses SectionHeader widget)
//   • Scrollable card list → DashboardSVDetailUI per record
//   • Pinned summary footer (Total Cyl. Qty + Total Amount)
//   • _EmptyState and _SummaryTile follow AlertActionCard visual language
//
// Constraints: API calls, business logic, navigation are UNCHANGED.
// Only the UI layer has been refactored.
// =============================================================================

class DashboardSVDetails extends StatefulWidget {
  static const screenName = '/dashboardSVDetails';

  @override
  State<StatefulWidget> createState() => _DashboardSVDetailsState();
}

class _DashboardSVDetailsState extends State<DashboardSVDetails> {

  // ── State ──────────────────────────────────────────────────────────────────
  List<GetDashboardSvStockPendCtnListForMobListModel> svmodel = [];
  bool isLoading = true;
  String todayDate = DateTime.now().toString();
  int? flag;
  DateTime? date;
  List<CylItemListModel> _items = [];
  CylItemListModel? _selectedItemModel;
  String? _selectedItem;
  int? selectedItemId;
  var argValue;
  final CylItemListModel allItem =
  CylItemListModel(itemId: -1, itemName: 'ALL');

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        flag = argValue['flag'];
        fetchSV(flag!);
      });
    });
    fetchItems();
    _selectedItemModel = allItem;
  }

  // ── API calls — UNCHANGED ──────────────────────────────────────────────────
  Future<void> fetchSV(int flag) async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');

    if (bearerToken == null) throw Exception('Bearer token is missing');

    final response = await http.get(
      Uri.parse(
          '${AppUrl.GetDashboardSVStockPendCtnListForMob}/$distributorId/$flag'),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );
    debugPrint(
        'GetDashboardSvStockPendCtnListForMobListModel : '
            '${AppUrl.GetDashboardSVStockPendCtnListForMob}/$distributorId/$flag');
    debugPrint(
        'GetDashboardSvStockPendCtnListForMobListModelresponsebody ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        svmodel = data
            .map((json) =>
            GetDashboardSvStockPendCtnListForMobListModel.fromJson(json))
            .toList();
        isLoading = false;
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> fetchItems() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) throw Exception('Bearer Token Is Missing');

      final response = await http.get(
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/c'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint('item ${AppUrl.GetItemMasterList}/$distributorId/1/c');
      debugPrint('item ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _items =
              data.map((json) => CylItemListModel.fromJson(json)).toList();
        });
      } else {
        throw Exception(
            'Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final totalCylQty = svmodel.fold<num>(
        0, (sum, item) => sum + (item.cylQty ?? 0));
    final totalAmount = svmodel.fold<double>(
        0.0, (sum, item) => sum + (item.totalAmount ?? 0.0));
    final formattedAmount = formatCurrency(totalAmount);
    final svCount = svmodel.length;

    return Scaffold(
      backgroundColor: AppColors.background2,
      // appBar: _buildAppBar(svCount, totalCylQty),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppGradientHeader(
          title: 'SV Stock Movement',
          // subtitle: _selectedItem != null && _selectedItem != 'ALL'
          //     ? '$_selectedItem'
          //     : 'All Items',
          subtitle: 'Count: ${svmodel.length}',
          icon: Icons.receipt_long_rounded,
          // onBack: () => Navigator.pushReplacementNamed(context, '/bottomNavBarExample'),
          onBack: () => Navigator.pop(context)
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Item filter bar ────────────────────────────────────
          _buildFilterBar(),

          // ── Section header ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, 0),
            child: SectionHeader(
              title: 'SV Stock Records',
              dotColor: AppColors.teal,
            ),
          ),

          // ── Scrollable list ────────────────────────────────────
          Expanded(child: _buildList()),

          // ── Pinned summary footer ──────────────────────────────
          _buildSummaryFooter(totalCylQty, formattedAmount),
        ],
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────
  // Gradient header matching the dashboard's hero bar.
  // Frosted-glass pill badges for count and cyl qty (see _AppBarBadge).
  PreferredSizeWidget _buildAppBar(int svCount, num totalCylQty) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.gradPrimary),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),

                // Title + subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SV Stock Movement',
                        style: AppTypography.heroTitle,
                        textScaler: TextScaler.noScaling,
                      ),
                      Text(
                        _selectedItem != null && _selectedItem != 'ALL'
                            ? 'Item: $_selectedItem'
                            : 'All Items',
                        style: AppTypography.heroSubtitle,
                        textScaler: TextScaler.noScaling,
                      ),
                    ],
                  ),
                ),

                // Count badge
                _AppBarBadge(
                  icon: Icons.list_alt_rounded,
                  label: '$svCount',
                ),
                const SizedBox(width: AppSpacing.sm - 2), // 6

                // Cyl qty badge
                _AppBarBadge(
                  icon: Icons.propane_tank_rounded,
                  label: '${svCount > 0 ? totalCylQty : 0} Cyl',
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Filter bar ─────────────────────────────────────────────────────────────
  // White surface strip with a teal label chip and a themed dropdown.
  Widget _buildFilterBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          // Label chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm + 2,  // 10
              vertical: AppSpacing.sm - 2,    //  6
            ),
            decoration: BoxDecoration(
              color: AppColors.tealXLight,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.propane_tank_rounded,
                  size: 15,
                  color: AppColors.teal,
                ),
                const SizedBox(width: AppSpacing.sm - 2), // 6
                Text(
                  'Item',
                  style: AppTypography.labelMD.copyWith(
                    color: AppColors.teal,
                  ),
                  textScaler: TextScaler.noScaling,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Dropdown — uses design-system border + shadow tokens
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                BorderRadius.circular(AppSpacing.sm + 2), // 10
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadowCard,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<CylItemListModel>(
                  isExpanded: true,
                  value: _selectedItemModel,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.teal,
                    size: 22,
                  ),
                  style: AppTypography.cardTitle.copyWith(fontSize: 14),
                  items: [
                    _dropdownItem(allItem, 'ALL'),
                    ..._items.map(
                          (item) => _dropdownItem(item, item.itemName ?? ''),
                    ),
                  ],
                  onChanged: (CylItemListModel? selectedItem) {
                    if (selectedItem != null) {
                      setState(() {
                        _selectedItemModel = selectedItem;
                        if (selectedItem.itemId == -1) {
                          _selectedItem = 'ALL';
                          selectedItemId = -1;
                          fetchSV(flag!);
                        } else {
                          _selectedItem = selectedItem.itemName!;
                          selectedItemId = selectedItem.itemId?.toInt();
                          fetchSV(selectedItemId!);
                        }
                      });
                    }
                  },
                  hint: Text(
                    'ALL',
                    style: AppTypography.labelMD,
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single themed dropdown menu item.
  DropdownMenuItem<CylItemListModel> _dropdownItem(
      CylItemListModel item, String label) {
    return DropdownMenuItem<CylItemListModel>(
      value: item,
      child: Text(
        label,
        style: AppTypography.cardTitle.copyWith(fontSize: 14),
        textScaler: TextScaler.noScaling,
      ),
    );
  }

  // ── List ───────────────────────────────────────────────────────────────────
  Widget _buildList() {
    if (svmodel.isEmpty) {
      return const _EmptyState(
        icon: Icons.local_shipping_rounded,
        message: 'No SV stock movement records\nfound for the selected filter.',
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      itemCount: svmodel.length,
      itemBuilder: (context, index) {
        debugPrint('Rendering SV Item: ${svmodel[index]}');
        return DashboardSVDetailUI(svmodel[index], index: index);
      },
    );
  }

  // ── Summary footer ─────────────────────────────────────────────────────────
  // Pinned at the bottom — mirrors the BottomSheet shape token (rounded top).
  Widget _buildSummaryFooter(num totalCylQty, String formattedAmount) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xl - 4), // 20
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowCard,
            blurRadius: AppSpacing.lg,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Row(
        children: [
          // Total Cyl. Qty
          Expanded(
            child: _SummaryTile(
              icon: Icons.propane_tank_rounded,
              label: 'Total Cyl. Qty',
              value: '${svmodel.isNotEmpty ? totalCylQty : 0}',
              accentColor: AppColors.teal,
              accentBg: AppColors.tealXLight,
            ),
          ),

          // Vertical separator
          Container(
            width: 1,
            height: 48,
            color: AppColors.divider,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          ),

          // Total Amount
          Expanded(
            child: _SummaryTile(
              icon: Icons.currency_rupee_rounded,
              label: 'Total Amount',
              value:
              '₹${svmodel.isNotEmpty ? formattedAmount : '0.00'}',
              accentColor: AppColors.primary,
              accentBg: AppColors.primaryXLight,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _SummaryTile
// One KPI cell in the summary footer: icon badge · label · value.
// Visual language matches AlertActionCard's icon container.
// =============================================================================
class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.accentBg,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;
  final Color accentBg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon badge — 40×40, matches AlertActionCard icon container size
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: accentBg,
            borderRadius:
            BorderRadius.circular(AppSpacing.sm + 2), // 10
          ),
          child: Icon(icon, color: accentColor, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm + 2), // 10

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelSM,
                textScaler: TextScaler.noScaling,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.alertValue.copyWith(
                  color: accentColor,
                  fontSize: 15,
                ),
                textScaler: TextScaler.noScaling,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// _AppBarBadge
// Frosted-glass pill badge in the gradient AppBar — count / cyl qty.
// Opacity constants come from AppOpacity to avoid magic numbers.
// =============================================================================
class _AppBarBadge extends StatelessWidget {
  const _AppBarBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,  // 10
        vertical: AppSpacing.sm - 2,    //  6
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(AppOpacity.heroBadgeBg),     // 0.18
        borderRadius: BorderRadius.circular(AppSpacing.xl - 4),      // 20
        border: Border.all(
          color: Colors.white.withOpacity(AppOpacity.heroBadgeBorder), // 0.30
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 13),
          const SizedBox(width: AppSpacing.xs + 1), // 5
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.1,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// _EmptyState
// Shown when svmodel is empty after loading.
// Icon badge shape matches the dashboard empty-state pattern (rounded square).
// =============================================================================
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon badge — matches AppDecorations.emptyStateIconBlue shape
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryXLight,
                borderRadius: BorderRadius.circular(AppSpacing.xl - 4), // 20
              ),
              child: Icon(icon, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Records Found',
              style: AppTypography.cardTitle,
              textScaler: TextScaler.noScaling,
            ),
            const SizedBox(height: AppSpacing.sm - 2), // 6
            Text(
              message,
              style: AppTypography.cardSubtitle,
              textAlign: TextAlign.center,
              textScaler: TextScaler.noScaling,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// formatCurrency — preserved exactly from original
// =============================================================================
String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final format = NumberFormat('#,##,###.00', 'en_IN');
  String formattedAmount = format.format(amount);
  if (amount < 1 && formattedAmount.startsWith('.')) {
    formattedAmount = '0' + formattedAmount;
  }
  return formattedAmount;
}