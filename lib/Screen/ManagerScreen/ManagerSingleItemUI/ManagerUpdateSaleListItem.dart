import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';
import '../../ConstantScreen/widgets.dart';
import '../../GodownKeeper/DeliveryBoyModel/GetSVTVConsumerListModel.dart';
import '../../Utils/constants.dart';
import '../BootomNavigatinBarManager.dart';
import '../ManagerModelClass/DailySaleSaummaryListModel.dart';
import '../ManagerModelClass/DilySaleSummaryDeliveryBoyWiseListModel.dart';
import '../ManagerModelClass/RSPAmountOFItemListModel.dart';
import '../ManagerUpdateSaleCashUpdation.dart' show ManagerUpdateSaleCashUpdation;
import '../SVSaleModel/GetSVConsumerListForCashCollectionMode.dart';

class ManagerUpdateSaleListItem extends StatefulWidget {
  DilySaleSummaryDeliveryBoyWiseListModel filteredSales;
  int? vehicleIDs;
  String? vehicleNumber;
  String? receiptNoText;

  ManagerUpdateSaleListItem(this.filteredSales, this.vehicleIDs,
      this.vehicleNumber, this.receiptNoText,
      {Key? key})
      : super(key: key);

  @override
  State<ManagerUpdateSaleListItem> createState() =>
      _ManagerUpdateSaleListItemState();
}

class _ManagerUpdateSaleListItemState extends State<ManagerUpdateSaleListItem> {
  bool isListViewVisible = false;
  bool _isExpanded = false;
  List<RspAmountOfItemListModel> rspAmountOfItemList = [];
  bool isLoading = true;
  List<GetSvConsumerListForCashCollectionMode> getSvtvConsumerList = [];

  @override
  Widget build(BuildContext context) {
    var sale = widget.filteredSales;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: item name + user name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${sale.itemName ?? ''}',
                    style: AppTypography.cardTitle.copyWith(color: AppColors.blue),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '${sale.userName ?? ''}',
                    style: AppTypography.cardTitle.copyWith(color: AppColors.blue),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Data grid: 3 columns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Column 1: Sale + TV
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dataRow('Sale', '${sale.gDFilledSale ?? 0}'),
                    const SizedBox(height: 4),
                    _dataRow('TV', '${sale.tVQty ?? 0}'),
                  ],
                ),
                // Column 2: Act.Sale + Def
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dataRow('Act.Sale', '${sale.actualSaleQty ?? 0}'),
                    const SizedBox(height: 4),
                    _dataRow('Def.', '${sale.deffQty ?? 0}'),
                  ],
                ),
                // Column 3: SV (tappable) + Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _fetchSVConsumerData("sv", sale.saleGKItemId!.toInt());
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 65,
                            child: Text('SV:',
                                style: AppTypography.dataRowLabel
                                    .copyWith(color: AppColors.textMuted)),
                          ),
                          Text(
                            '${sale.sVQty ?? 0}',
                            style: AppTypography.dataRowLabel.copyWith(
                              color: AppColors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SizedBox(
                          width: 65,
                          child: Text('Amount:',
                              style: AppTypography.dataRowLabel
                                  .copyWith(color: AppColors.textMuted)),
                        ),
                        Text(
                          formatCurrency((sale.amount ?? 0).toDouble()),
                          style: AppTypography.dataRowLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Expandable payment breakdown
            if (_isExpanded) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.blueXL,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _paymentRow(
                        'Cash', sale.cashQty, sale.cashAmt),
                    const SizedBox(height: 6),
                    _paymentRow(
                        'Online/Prepaid', sale.prepaidQty, sale.prepaidAmt),
                    const SizedBox(height: 6),
                    _paymentRow(
                        'Merchant QR', sale.postQty, sale.postAmt),
                    const SizedBox(height: 6),
                    _paymentRow(
                        'Credit', sale.creditQty, sale.creditAmt),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 8),
            // Footer row: received amount + expand toggle + action button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Received Amt
                Flexible(
                  child: Row(
                    children: [
                      Text('Received Amt.:',
                          style: AppTypography.dataRowLabel
                              .copyWith(color: AppColors.textMuted)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          formatCurrency((sale.denoCashRcvd ?? 0).toDouble()),
                          style: AppTypography.dataRowLabel,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Expand toggle
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Row(
                    children: [
                      Text(
                        _isExpanded ? 'View Less' : 'View More',
                        style: AppTypography.dataRowLabel
                            .copyWith(color: AppColors.blue, fontSize: 12),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: AppColors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                // Action button
                GestureDetector(
                  onTap: () async {
                    int itemId = sale.itemId?.toInt() ?? 0;
                    double? itemRate = await fetchItemRate(itemId);
                    debugPrint("$itemRate");

                    if ((sale.cashQty == 0 &&
                        sale.prepaidQty == 0 &&
                        sale.postQty == 0 &&
                        sale.creditQty == 0 &&
                        sale.cashAmt == 0 &&
                        sale.postAmt == 0 &&
                        sale.actualSaleQty != 0)) {
                      Navigator.pushNamed(
                          context, ManagerUpdateSaleCashUpdation.screenName,
                          arguments: {
                            "delBoyName": sale.staffName,
                            "itemName": sale.itemName,
                            "saleQty": sale.actualSaleQty,
                            "svQty": sale.sVQty,
                            "tvQty": sale.tVQty,
                            "amountTotal": sale.amount,
                            "expAmount": "",
                            "dmBal": "",
                            "itemRate": itemRate,
                            "delBoyID": sale.staffId,
                            "itemID": sale.itemId,
                            "salesGkId": sale.saleGKId,
                            "sakesGKItemID": sale.saleGKItemId,
                            "vehicleID": widget.vehicleIDs,
                            "dSCollMgrId": sale.dSCollMgrId,
                            "vehicleNumber": widget.vehicleNumber,
                            "receiptNoText": widget.receiptNoText,
                            "actionModeApi": '',
                            "prepaidQtyApi": sale.prepaidQty,
                            "prepaidAmountApi": sale.prepaidAmt,
                            "postpaidQtyApi": sale.postQty,
                            "postpaidAmountApi": sale.postAmt,
                            "creditQtyApi": sale.creditQty,
                            "creditAmountApi": sale.creditAmt,
                            "cashQtyApi": sale.cashQty,
                            "cashAmountApi": sale.cashAmt,
                            "cashTotalExpectedAmount": sale.denoCashExptd,
                            "cashTotalReceiveAmount": sale.denoCashRcvd,
                            "cashBalanceAmount": sale.cashBalance,
                            "itemSubtype": sale.itemSubType,
                          });
                    } else if ((sale.cashQty != 0 ||
                        sale.prepaidQty != 0 ||
                        sale.postQty != 0 ||
                        sale.creditQty != 0 ||
                        sale.cashAmt != 0 ||
                        sale.postAmt != 0 && sale.actualSaleQty != 0)) {
                      Navigator.pushNamed(
                          context, ManagerUpdateSaleCashUpdation.screenName,
                          arguments: {
                            "delBoyName": sale.staffName,
                            "itemName": sale.itemName,
                            "saleQty": sale.actualSaleQty,
                            "svQty": sale.sVQty,
                            "tvQty": sale.tVQty,
                            "amountTotal": sale.amount,
                            "expAmount": "",
                            "dmBal": "",
                            "itemRate": itemRate,
                            "delBoyID": sale.staffId,
                            "itemID": sale.itemId,
                            "salesGkId": sale.saleGKId,
                            "sakesGKItemID": sale.saleGKItemId,
                            "vehicleID": widget.vehicleIDs,
                            "dSCollMgrId": sale.dSCollMgrId,
                            "vehicleNumber": widget.vehicleNumber,
                            "receiptNoText": widget.receiptNoText,
                            "actionModeApi": 'EDIT',
                            "prepaidQtyApi": sale.prepaidQty,
                            "prepaidAmountApi": sale.prepaidAmt,
                            "postpaidQtyApi": sale.postQty,
                            "postpaidAmountApi": sale.postAmt,
                            "creditQtyApi": sale.creditQty,
                            "creditAmountApi": sale.creditAmt,
                            "cashQtyApi": sale.cashQty,
                            "cashAmountApi": sale.cashAmt,
                            "cashTotalExpectedAmount": sale.denoCashExptd,
                            "cashTotalReceiveAmount": sale.denoCashRcvd,
                            "cashBalanceAmount": sale.cashBalance,
                            "itemSubtype": sale.itemSubType,
                          });
                    } else if ((sale.actualSaleQty == 0 ||
                        sale.dailySaleStatus != 13)) {
                      int? saleGk = sale.saleGKId?.toInt();
                      int? saleGkItemId = sale.saleGKItemId?.toInt();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            contentPadding: const EdgeInsets.fromLTRB(
                                24.0, 20.0, 24.0, 24.0),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.info_outline_rounded,
                                    size: 48, color: Colors.orange),
                                const SizedBox(height: 16),
                                Text(
                                  'No cash against only SV sale',
                                  style: AppTypography.cardTitle,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'You want to settle sale',
                                  style: AppTypography.cardSubtitle,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        statusChangeApi(saleGk!, saleGkItemId!,
                                            13, Constants.acceptSale);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Yes, settle',
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Cancel',
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      (sale.cashQty == 0 &&
                              sale.prepaidQty == 0 &&
                              sale.postQty == 0 &&
                              sale.creditQty == 0 &&
                              sale.cashAmt == 0 &&
                              sale.postAmt == 0 &&
                              sale.actualSaleQty != 0)
                          ? 'Update'
                          : (sale.cashQty != 0 ||
                                  sale.prepaidQty != 0 ||
                                  sale.postQty != 0 ||
                                  sale.creditQty != 0 ||
                                  sale.cashAmt != 0 ||
                                  sale.postAmt != 0 &&
                                      sale.actualSaleQty != 0)
                              ? 'Edit'
                              : (sale.actualSaleQty == 0 ||
                                      sale.dailySaleStatus != 13)
                                  ? 'No Cash'
                                  : '',
                      style: AppTypography.dataRowLabel.copyWith(
                        color: AppColors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 65,
          child: Text(label,
              style: AppTypography.dataRowLabel
                  .copyWith(color: AppColors.textMuted)),
        ),
        Text(value, style: AppTypography.dataRowLabel),
      ],
    );
  }

  Widget _paymentRow(String label, dynamic qty, dynamic amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label,
              style: AppTypography.dataRowLabel
                  .copyWith(color: AppColors.textMuted, fontSize: 12)),
        ),
        Row(
          children: [
            Text('${qty ?? 0}',
                style: AppTypography.dataRowLabel.copyWith(fontSize: 12)),
            const SizedBox(width: 4),
            Icon(Icons.currency_rupee, size: 11, color: AppColors.text),
            Text(
              formatCurrency((amount ?? 0).toDouble()),
              style: AppTypography.dataRowLabel.copyWith(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Future<double?> fetchItemRate(int itemID) async {
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
      return null;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse('${AppUrl.GetRSPDetailsList}/$distributorId/Today'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );

        debugPrint("Response body GetRSPDetailsList: ${response.body}");

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          var item = data.firstWhere(
              (jsonItem) => jsonItem['ItemId'] == itemID,
              orElse: () => null);
          if (item != null) {
            return item['RSP_Price']?.toDouble();
          } else {
            debugPrint('Item not found');
            return null;
          }
        } else {
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        debugPrint("Error: $error");
        return null;
      }
    }
  }

  String formatCurrency(double amount) {
    if (amount == 0) return '0.00';
    final format = NumberFormat('#,##,###.00', 'en_IN');
    String formattedAmount = format.format(amount);
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0' + formattedAmount;
    }
    return formattedAmount;
  }

  Future<void> statusChangeApi(int salesGKId, int salesGKItemId, int flagUpdate,
      String messageShow) async {
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      showFlushBar(context, Constants.connectionMessage);
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');

        if (bearerToken == null) {
          throw Exception('Bearer token is missing');
        }

        final response = await http.get(
          Uri.parse(
              '${AppUrl.DailySaleByGK_StatusUpdate}/$distributorId/$salesGKId/$salesGKItemId/$flagUpdate'),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );

        debugPrint(
            "Response body DailySaleByGK_StatusUpdate: ${response.body}");
        debugPrint(
            "request body DailySaleByGK_StatusUpdate: ${response.request}");

        if (response.statusCode == 200) {
          EasyLoading.showToast(messageShow,
              duration: const Duration(milliseconds: 3000));
          Navigator.pushNamed(context, BottomNavBarExample.screenName,
              arguments: 2);
          setState(() {});
        } else {
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        debugPrint("Error: $error");
      }
    }
  }

  void showYesCancelDialog(
    BuildContext context, {
    required String title,
    required String content,
    String yesText = 'Yes',
    String cancelText = 'Cancel',
    required VoidCallback onYesPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              Text(title,
                  style: AppTypography.cardTitle,
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(content,
                  style: AppTypography.cardSubtitle,
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onYesPressed();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(yesText,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(cancelText,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fetchSVConsumerData(String flag, int saleGkItemId) async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? token = prefs.getString('token');
      int dId = int.parse(distributorId!);

      try {
        final response = await http.get(
          Uri.parse(
              '${AppUrl.GetDailySaleSVTVConsumerDtls}/$dId/$flag/$saleGkItemId'),
          headers: {'Authorization': 'Bearer $token'},
        );
        debugPrint(
            "GetDailySaleSVTVConsumerDtls_Mob response ${response.body}");
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getSvtvConsumerList = data
                .map((json) =>
                    GetSvConsumerListForCashCollectionMode.fromJson(json))
                .toList();
            showDetailsDialog(context, getSvtvConsumerList);
            EasyLoading.dismiss();
          });
        } else {
          setState(() {
            EasyLoading.dismiss();
            isLoading = false;
            showFlushBar(context, Constants.listGettingFail);
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            EasyLoading.dismiss();
            isLoading = false;
            showFlushBar(context, Constants.listGettingFail);
          });
        }
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  void showDetailsDialog(
    BuildContext context,
    List<GetSvConsumerListForCashCollectionMode> itemss,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.blueXL,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SV Consumer Details',
                          style: AppTypography.cardTitle
                              .copyWith(color: AppColors.blue)),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child:
                            const Icon(Icons.close, color: Colors.red, size: 20),
                      ),
                    ],
                  ),
                ),
                // Table Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text('DC/Challan',
                              style: AppTypography.dataRowLabel
                                  .copyWith(color: AppColors.blue))),
                      Expanded(
                          flex: 2,
                          child: Text('Cons. No.',
                              style: AppTypography.dataRowLabel
                                  .copyWith(color: AppColors.blue))),
                      Expanded(
                          flex: 3,
                          child: Text('Consumer Name',
                              style: AppTypography.dataRowLabel
                                  .copyWith(color: AppColors.blue))),
                      Expanded(
                          flex: 2,
                          child: Text('Cyl.Qty.',
                              style: AppTypography.dataRowLabel
                                  .copyWith(color: AppColors.blue),
                              textAlign: TextAlign.center)),
                      Expanded(
                          flex: 2,
                          child: Text('Date',
                              style: AppTypography.dataRowLabel
                                  .copyWith(color: AppColors.blue),
                              textAlign: TextAlign.center)),
                    ],
                  ),
                ),
                Divider(color: AppColors.border, height: 1),
                // Table Content
                Expanded(
                  child: itemss.isNotEmpty
                      ? ListView.builder(
                          itemCount: itemss.length,
                          itemBuilder: (context, index) {
                            final items = itemss[index];
                            final Color rowBg = (index % 2 == 0)
                                ? AppColors.blueXL
                                : AppColors.white;
                            return Container(
                              color: rowBg,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          items.dCChallanNo.toString(),
                                          style: AppTypography.dataRowLabel)),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          items.consumerNo.toString(),
                                          style: AppTypography.dataRowLabel)),
                                  Expanded(
                                      flex: 3,
                                      child: Text(
                                          items.consumerName.toString(),
                                          style: AppTypography.dataRowLabel)),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                          items.cylQty.toString(),
                                          style: AppTypography.dataRowLabel,
                                          textAlign: TextAlign.center)),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                              items.sVTVDate ?? '')),
                                      style: AppTypography.dataRowLabel,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text('No Data Available',
                              style: AppTypography.cardSubtitle)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
