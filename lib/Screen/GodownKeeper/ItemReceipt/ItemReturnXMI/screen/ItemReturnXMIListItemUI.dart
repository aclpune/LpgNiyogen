
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../ConstantScreen/widgets.dart';
import '../../../../Utils/app_url.dart';
import '../../../../Utils/constants.dart';
import '../../../../Utils/styles/app_colors.dart';
import '../../../../Utils/styles/app_spacing.dart';
import '../../../../Utils/styles/app_text_styles.dart';
import '../../../BottomNavigationForGodownKeeper.dart';
import '../../CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
import 'package:http/http.dart' as http;

import '../model/GetEXMIListModel.dart';
import 'AddReturnItemXMIScreen.dart';

// ─────────────────────────────────────────────
// ITEM RETURN XMI LIST ITEM UI
// Refactored UI — logic/API/state UNCHANGED
// ─────────────────────────────────────────────
class ItemReturnXMIListItemUI extends StatefulWidget {
  // ignore: library_private_types_in_public_api
  GetExmiListModel _listModel;

  ItemReturnXMIListItemUI(this._listModel, {Key? key}) : super(key: key);

  @override
  State<ItemReturnXMIListItemUI> createState() =>
      _ItemReturnXMIListItemUIState();
}

class _ItemReturnXMIListItemUIState extends State<ItemReturnXMIListItemUI> {
  // ── State — UNCHANGED ──
  bool isListViewVisible = false;
  List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
  bool isLoading = true;
  bool saveFlag = false;

  @override
  void initState() {
    super.initState();
    fetchCurrentStock();
    checkAndSaveDayEndData();
  }

  @override
  Widget build(BuildContext context) {
    final value = widget._listModel;

    if (value == null || value == "") {
      return const SizedBox.shrink();
    }

    final bool isReceived = value.receiptOn != "0001-01-01T00:00:00";
    final String dateStr = value.returnDate != null
        ? DateFormat('dd MMM yyyy').format(DateTime.parse(value.returnDate!))
        : '—';

    return AnimatedSize(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      child: Container(
        decoration: AppDecorations.xmiCard,              // was: inline BoxDecoration(color:Colors.white, borderRadius:circular(18), boxShadow:[BoxShadow(color:Color(0x0D1E3A8A), blurRadius:12, offset:Offset(0,2))])
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Card Header ──
            _CardHeader(
              vehicleNo: value.vehicleNo?.toString() ?? '—',
              dateStr: dateStr,
              isReceived: isReceived,
            ),

            Divider(height: 1, color: AppColors.divider), // was: Color(0xFFF1F5F9)

            // ── Expandable Item Details ──
            if (isListViewVisible) ...[
              _ItemDetailList(
                itemDetails: value.itemDetails ?? [],
                stockList: getCurrentStcOfGodownKeeper,
                isReceived: isReceived,
              ),
              // ── Action buttons — ONLY visible when expanded ──
              if (!isReceived)
                _ActionButtonRow(
                  saveFlag: saveFlag,
                  onInPressed: () {
                    if (saveFlag) {
                      showFlushBar(context, Constants.dayEndCompleted);
                    } else {
                      final itemsToShow = value.itemDetails
                          ?.where((item) => item.emptyReturnQty != 0)
                          .toList();
                      if (itemsToShow != null && itemsToShow.isNotEmpty) {
                        showDetailsDialog(context, itemsToShow, value.returnId);
                      } else {
                        showFlushBar(context, Constants.nodataFound);
                      }
                    }
                  },
                  onEditPressed: () {
                    if (saveFlag) {
                      showFlushBar(context, Constants.dayEndCompleted);
                    } else {
                      final itemsToShow = value.itemDetails?.toList();
                      final receiptId = value.returnId;
                      final vehicleNo = value.vehicleNo.toString();
                      final receiptDate = value.returnDate.toString();
                      if (itemsToShow != null && itemsToShow.isNotEmpty) {
                        Navigator.pushNamed(
                          context,
                          AddReturnItemXMIScreen.screenName,
                          arguments: {
                            'vehicleNo': vehicleNo,
                            'receiptDate': receiptDate,
                            'itemsToShow': itemsToShow,
                            'modeChange': "Edit",
                            'receiptID': receiptId,
                          },
                        );
                      } else {
                        showFlushBar(context, Constants.nodataFound);
                      }
                    }
                  },
                ),
            ],

            // ── Footer: expand toggle (always visible) ──
            _ExpandToggle(
              isExpanded: isListViewVisible,
              onToggle: () =>
                  setState(() => isListViewVisible = !isListViewVisible),
            ),
          ],
        ),
      ),
    );
  }

  // ── showDetailsDialog — UNCHANGED ──
  void showDetailsDialog(
      BuildContext context, List<ItemDetails> items, num? receiptId) {
    final List<TextEditingController> returnQtyControllers = [];
    final List<TextEditingController> defectiveQtyControllers = [];

    for (var item in items) {
      returnQtyControllers
          .add(TextEditingController(text: item.emptyReturnQty.toString()));
      defectiveQtyControllers.add(TextEditingController(text: "0"));
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.xmiDialog,           // was: BorderRadius.circular(18)
          ),
          title: Text(
            'Details for Items Receipt',
            style: AppTextStyles.xmiDialogTitle,         // was: inline TextStyle(fontSize:16, w700, color:Color(0xFF111827))
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items.asMap().map((index, item) {
                return MapEntry(
                  index,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Item Name: ${item.itemName}",
                        style: AppTextStyles.xmiDialogItemName, // was: inline TextStyle(fontSize:14, w600, color:Color(0xFF374151))
                      ),
                      TextFormField(
                        controller: returnQtyControllers[index],
                        decoration:
                        const InputDecoration(labelText: 'Receive Qty'),
                        keyboardType: TextInputType.number,
                        enabled: false,
                      ),
                    ],
                  ),
                );
              }).values.toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Close",
                style: AppTextStyles.itemReturnDialogClose, // was: inline TextStyle(fontWeight:bold, fontSize:14)
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final List<Map<String, dynamic>> updatedItemDetails = [];

                for (int i = 0; i < items.length; i++) {
                  final int returnQty =
                      int.tryParse(returnQtyControllers[i].text) ?? 0;
                  updatedItemDetails.add({
                    "ItemId": items[i].itemId,
                    "FilledQty": returnQty,
                  });
                }

                await sendItemDetailsToApi(updatedItemDetails, receiptId);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.xmiDialogInBtnBg,  // was: Color(0xFF1E3A8A)
                foregroundColor: AppColors.surface,            // was: Colors.white
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.xmiActionBtn,        // was: BorderRadius.circular(50)
                ),
              ),
              child: Text(
                "In",
                style: AppTextStyles.xmiActionBtnLabel.copyWith(
                  color: AppColors.surface,                    // was: inline TextStyle(color:Colors.white, fontSize:14)
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── API: fetchCurrentStock — UNCHANGED ──
  Future<void> fetchCurrentStock() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? token = prefs.getString('token');

      try {
        final response = await http.get(
          Uri.parse(
              '${AppUrl.ItemCurrentStkList}/$distributorId/$godownId'),
          headers: {'Authorization': 'Bearer $token'},
        );
        print("Request URL ItemCurrentStkList: ${response.request}");
        print("API Response Status ItemCurrentStkList: ${response.statusCode}");
        print("API Response ItemCurrentStkList: ${response.body}");

        if (!mounted) return;

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getCurrentStcOfGodownKeeper = data
                .map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json))
                .toList();
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          showFlushBar(context, Constants.listGettingFail);
        }
      } catch (e) {

        if (!mounted) return;

        setState(() => isLoading = false);
        showFlushBar(context, Constants.listGettingFail);
      }
    } else {

      if (!mounted) return;

      showFlushBar(context, Constants.connectionMessage);
    }
  }

  // ── sendItemDetailsToApi — UNCHANGED ──
  Future<void> sendItemDetailsToApi(
      List<Map<String, dynamic>> itemDetails, num? receiptId) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String distributorId = preferences.getString('DistributorId') ?? '';
      String? addedBy = preferences.getString('StaffId');
      String? token = preferences.getString('token');

      final requestBody = json.encode({
        "ReturnId": receiptId,
        "DistributorId": distributorId,
        "AddedBy": addedBy,
        "ItemDetails": itemDetails,
      });

      final response = await http.post(
        Uri.parse(AppUrl.ItemReceiptEXMIAddEdit),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: requestBody,
      );

      print("Request requestBody: $requestBody");
      if (response.statusCode == 200) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName);
        });
        print("Request successful: ${response.body}");
      } else {
        print("Request failed: ${response.statusCode}");
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  // ── checkAndSaveDayEndData — UNCHANGED ──
  Future<void> checkAndSaveDayEndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);
    try {
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
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
}

// ─────────────────────────────────────────────
// CARD HEADER
// Vehicle icon + Vehicle No + date + status badge
// ─────────────────────────────────────────────
class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.vehicleNo,
    required this.dateStr,
    required this.isReceived,
  });

  final String vehicleNo;
  final String dateStr;
  final bool isReceived;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.xmiCardHeaderPadding,          // was: fromLTRB(16,14,16,12)
      child: Row(
        children: [
          // Vehicle icon container
          Container(
            width: AppSizes.xmiVehicleIconBox,           // was: 44
            height: AppSizes.xmiVehicleIconBox,          // was: 44
            decoration: AppDecorations.xmiVehicleIconBadge, // was: inline BoxDecoration(color:Color(0xFFEFF6FF), borderRadius:circular(13))
            child: Icon(
              Icons.local_shipping_rounded,
              color: AppColors.primaryLight,             // was: Color(0xFF2D52C5)
              size: AppSizes.xmiVehicleIconPx,           // was: 22
            ),
          ),
          const SizedBox(width: AppSpacing.md),          // was: SizedBox(width:12)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle No. $vehicleNo',
                  style: AppTextStyles.xmiVehicleNo,     // was: inline TextStyle(fontSize:15, w700, color:Color(0xFF111827), ls:-0.1)
                ),
                const SizedBox(height: 3),
                Text(
                  dateStr,
                  style: AppTextStyles.xmiReturnDate,    // was: inline TextStyle(fontSize:13, w500, color:Color(0xFF6B7280))
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: AppSpacing.xmiStatusBadgePadding,   // was: symmetric(horizontal:10, vertical:5)
            decoration: BoxDecoration(
              color: isReceived
                  ? AppColors.xmiReceivedBadgeBg         // was: Color(0xFFF0FDF4)
                  : AppColors.xmiPendingBadgeBg,         // was: Color(0xFFFFF7ED)
              borderRadius: AppRadius.xmiStatusBadge,    // was: BorderRadius.circular(20)
            ),
            child: Text(
              isReceived ? 'Received ✓' : 'Pending',
              style: AppTextStyles.xmiStatusBadge.copyWith(
                color: isReceived
                    ? AppColors.xmiReceivedBadgeFg       // was: Color(0xFF166534)
                    : AppColors.xmiPendingBadgeFg,       // was: Color(0xFF9A3412)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ITEM DETAIL LIST
// Table of items with quantities (expanded only)
// ─────────────────────────────────────────────
class _ItemDetailList extends StatelessWidget {
  const _ItemDetailList({
    required this.itemDetails,
    required this.stockList,
    required this.isReceived,
  });

  final List<ItemDetails> itemDetails;
  final List<GetCurrentStcOfGodownKeeperModel> stockList;
  final bool isReceived;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column header row
        Container(
          color: AppColors.xmiTableHeaderBg,             // was: Color(0xFFF8FAFC)
          padding: AppSpacing.xmiTableHeaderPadding,     // was: fromLTRB(16,8,16,8)
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'ITEM',
                  style: AppTextStyles.xmiTableColHeader, // was: inline TextStyle(fontSize:11, w700, color:Color(0xFF6B7280), ls:0.5)
                ),
              ),
              _colHeader('STOCK'),
              _colHeader(isReceived ? 'FILLED RX' : 'EMPTY QTY'),
              if (!isReceived) _colHeader('R-EMR'),
              if (!isReceived) _colHeader('INVOICE'),
            ],
          ),
        ),
        Divider(height: 1, color: AppColors.divider),    // was: Color(0xFFF1F5F9)

        // Item rows
        ...itemDetails.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == itemDetails.length - 1;

          final stockInfo = stockList.firstWhere(
                (s) => s.itemId == item.itemId,
            orElse: () => GetCurrentStcOfGodownKeeperModel(),
          );

          final stockVal = isReceived
              ? (stockInfo.currentStkEmpty?.toString() ?? '0')
              : (stockInfo.currentStkFilled?.toString() ?? '0');

          return _ItemRow(
            item: item,
            stockVal: stockVal,
            isReceived: isReceived,
            showDivider: !isLast,
          );
        }),
        Divider(height: 1, color: AppColors.divider),    // was: Color(0xFFF1F5F9)
      ],
    );
  }

  Widget _colHeader(String text) {
    return SizedBox(
      width: AppSizes.xmiQtyColWidth,                    // was: 62
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.xmiTableColHeader,          // was: inline TextStyle(fontSize:11, w700, color:Color(0xFF6B7280), ls:0.5)
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ITEM ROW
// Single item's quantities in the table
// ─────────────────────────────────────────────
class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.item,
    required this.stockVal,
    required this.isReceived,
    required this.showDivider,
  });

  final ItemDetails item;
  final String stockVal;
  final bool isReceived;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.xmiItemRowPadding,             // was: fromLTRB(16,10,16,10)
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
          bottom: BorderSide(color: AppColors.divider, width: 1), // was: Color(0xFFF1F5F9)
        )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.itemName ?? '—',
              style: AppTextStyles.xmiItemName,          // was: inline TextStyle(fontSize:13, w600, color:Color(0xFF374151))
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _valCell(stockVal, AppColors.primaryLight),    // was: Color(0xFF2D52C5)
          _valCell(
            item.emptyReturnQty?.toString() ?? '0',
            AppColors.textPrimary,                       // was: Color(0xFF111827)
          ),
          if (!isReceived)
            _valCell(item.emptyEMR?.toString() ?? '0', AppColors.textPrimary),
          if (!isReceived)
            _valCell(item.eXMIQty?.toString() ?? '0', AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _valCell(String text, Color color) {
    return SizedBox(
      width: AppSizes.xmiQtyColWidth,                    // was: 62
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.xmiQtyValue.copyWith(color: color), // was: inline TextStyle(fontSize:14, w700; color dynamic)
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ACTION BUTTON ROW
// "In" + "Edit" — ONLY shown when card is expanded
// and receipt is pending (not yet received)
// ─────────────────────────────────────────────
// class _ActionButtonRow extends StatelessWidget {
//   const _ActionButtonRow({
//     required this.saveFlag,
//     required this.onInPressed,
//     required this.onEditPressed,
//   });
//
//   final bool saveFlag;
//   final VoidCallback onInPressed;
//   final VoidCallback onEditPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: AppSpacing.xmiActionRowPadding,           // was: fromLTRB(16,10,16,4)
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           _ActionButton(
//             label: 'In',
//             color: saveFlag
//                 ? AppColors.xmiActionBtnDisabled         // was: Color(0xFF9CA3AF)
//                 : AppColors.xmiInBtnActive,              // was: Color(0xFF0F766E)
//             onPressed: () {
//               HapticFeedback.lightImpact();
//               onInPressed();
//             },
//           ),
//           const SizedBox(width: 10),
//           _ActionButton(
//             label: 'Edit',
//             color: saveFlag
//                 ? AppColors.xmiActionBtnDisabled         // was: Color(0xFF9CA3AF)
//                 : AppColors.primaryLight,                // was: Color(0xFF2D52C5)
//             onPressed: () {
//               HapticFeedback.lightImpact();
//               onEditPressed();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

class _ActionButtonRow extends StatelessWidget {
  const _ActionButtonRow({
    required this.saveFlag,
    required this.onInPressed,
    required this.onEditPressed,
  });

  final bool saveFlag;
  final VoidCallback onInPressed;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.xmiActionRowPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _ActionIconButton(
            icon: Icons.local_shipping_rounded,
            tooltip: 'In',
            color: saveFlag
                ? AppColors.xmiActionBtnDisabled
                : AppColors.xmiInBtnActive,
            onPressed: () {
              HapticFeedback.lightImpact();
              onInPressed();
            },
          ),
          const SizedBox(width: 8),
          _ActionIconButton(
            icon: Icons.edit_rounded,
            tooltip: 'Edit',
            color: saveFlag
                ? AppColors.xmiActionBtnDisabled
                : AppColors.primaryLight,
            onPressed: () {
              HapticFeedback.lightImpact();
              onEditPressed();
            },
          ),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          splashColor: color.withOpacity(0.15),
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// EXPAND TOGGLE
// "View More / View Less" at the bottom of the card
// ─────────────────────────────────────────────
class _ExpandToggle extends StatelessWidget {
  const _ExpandToggle({
    required this.isExpanded,
    required this.onToggle,
  });

  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onToggle();
      },
      borderRadius: AppRadius.xmiToggleBottom,           // was: BorderRadius.vertical(bottom:Radius.circular(18))
      child: Padding(
        padding: AppSpacing.xmiTogglePadding,            // was: fromLTRB(16,10,16,12)
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryLight,             // was: Color(0xFF2D52C5)
              size: AppSizes.xmiToggleIconSize,          // was: 20
            ),
            const SizedBox(width: AppSpacing.xs),       // was: SizedBox(width:4)
            Text(
              isExpanded ? 'View Less' : 'View More',
              style: AppTextStyles.xmiExpandToggle,      // was: inline TextStyle(fontSize:13, w600, color:Color(0xFF2D52C5))
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ACTION BUTTON
// Compact pill-shaped button
// ─────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.xmiActionBtnHeight,               // was: 36
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.surface,            // was: Colors.white
          elevation: 0,
          padding: AppSpacing.xmiActionBtnPadding,       // was: symmetric(horizontal:24)
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.xmiActionBtn,        // was: BorderRadius.circular(50)
          ),
          textStyle: AppTextStyles.xmiActionBtnLabel,    // was: inline TextStyle(fontSize:14, w700)
        ),
        child: Text(label),
      ),
    );
  }
}