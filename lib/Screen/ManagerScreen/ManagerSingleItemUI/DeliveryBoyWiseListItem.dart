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
import '../../Utils/constants.dart';
import '../BootomNavigatinBarManager.dart';
import '../DeliveryBoyWiseListShow.dart';
import '../ManagerModelClass/DailySaleSaummaryListModel.dart';
import '../ManagerModelClass/GetLastUploadedFrileDifferenceModel.dart';
import '../ManagerUpdateSaleScreen.dart';

class DeliveryBoyWiseListItem extends StatefulWidget {
  DailySaleSaummaryListModel filteredSales;
  final bool enableNetworkCalls;

  DeliveryBoyWiseListItem(
    this.filteredSales, {
    Key? key,
    this.enableNetworkCalls = true,
  }) : super(key: key);

  @override
  State<DeliveryBoyWiseListItem> createState() =>
      _DeliveryBoyWiseListItemState();
}

class _DeliveryBoyWiseListItemState extends State<DeliveryBoyWiseListItem> {
  bool isListViewVisible = false;
  bool _isExpanded = false;
  List<GetLastUploadedFrileDifferenceModel> getLastUploadedFile = [];
  bool saveFlag = false;

  @override
  void initState() {
    super.initState();
    if (widget.enableNetworkCalls) {
      checkAndSaveDayEndData();
      getLastUploadedFileDifference();
    }
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: staff name + status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    sale.staffName ?? '',
                    style: AppTypography.cardTitle.copyWith(color: AppColors.blue),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Text('Status: ',
                        style: AppTypography.dataRowLabel.copyWith(color: AppColors.blue)),
                    Text('${sale.statusStr ?? 0}',
                        style: AppTypography.dataRowLabel),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Column labels
            Row(
              children: [
                _labelCell('SV'),
                _labelCell('TV'),
                _labelCell('Sale'),
                _labelCell('Def.'),
                _labelCell('Act. Sale'),
              ],
            ),
            const SizedBox(height: 4),
            // Column values
            Row(
              children: [
                _valueCell('${sale.totalSVQty ?? 0}'),
                _valueCell('${sale.totalTVQty ?? 0}'),
                _valueCell('${sale.totalFilledQty ?? 0}'),
                _valueCell('${sale.totalDefQty ?? 0}'),
                _valueCell('${sale.totalActualSaleQty ?? 0}'),
              ],
            ),
            const SizedBox(height: 8),
            // Total and received amounts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Text('Total Amt.: ',
                          style: AppTypography.dataRowLabel
                              .copyWith(color: AppColors.textMuted)),
                      Flexible(
                        child: Text(
                          formatCurrency((sale.totalAmt ?? 0).toDouble()),
                          style: AppTypography.dataRowLabel,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Row(
                    children: [
                      Text('Rcvd. Amt.: ',
                          style: AppTypography.dataRowLabel
                              .copyWith(color: AppColors.textMuted)),
                      Flexible(
                        child: Text(
                          formatCurrency((sale.totRecievedcAmt ?? 0).toDouble()),
                          style: AppTypography.dataRowLabel,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
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
                    _paymentRow('Cash', sale.cashAmt),
                    const SizedBox(height: 6),
                    _paymentRow('Online/Prepaid', sale.prepaidAmt),
                    const SizedBox(height: 6),
                    _paymentRow('Merchant QR', sale.postPaidAmt),
                    const SizedBox(height: 6),
                    _paymentRow('Credit', sale.retiCrAmt),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            // Footer: expand toggle + action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Row(
                    children: [
                      Text(
                        _isExpanded ? 'View Less' : 'View More',
                        style: AppTypography.dataRowLabel
                            .copyWith(color: AppColors.blue),
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (saveFlag) {
                          showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          Navigator.pushNamed(
                              context, ManagerUpdateSaleScreen.screenName,
                              arguments: {
                                "delBoyName": sale.staffName,
                                "receiptNo": "",
                                "receiptDate": sale.delDate,
                                "delBoyId": sale.dMId,
                                "saledgkID": sale.saleGKId,
                                "vehicleNo": sale.vehicleNo,
                                "vehicleID": sale.vehicleId,
                              });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          (sale.dailySaleStatus == 1 ||
                                  sale.dailySaleStatus == 4)
                              ? 'Accept'
                              : ((sale.dailySaleStatus == 2) ||
                                      (sale.dailySaleStatus != 3 &&
                                          sale.dailySaleStatus != 1 &&
                                          sale.dailySaleStatus != 4 &&
                                          sale.dailySaleStatus != 7))
                                  ? 'Update'
                                  : '',
                          style: AppTypography.dataRowLabel.copyWith(
                            color: AppColors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        if ((sale.dailySaleStatus != 3 &&
                            sale.dailySaleStatus != 5 &&
                            sale.dailySaleStatus != 6 &&
                            sale.dailySaleStatus != 7 &&
                            sale.dailySaleStatus != 8)) {
                          int? saleGk = sale.saleGKId?.toInt();
                          statusChangeApi(
                              saleGk!, 0, 3, Constants.correctionRequestMethod);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          (sale.dailySaleStatus != 3 &&
                                  sale.dailySaleStatus != 5 &&
                                  sale.dailySaleStatus != 6 &&
                                  sale.dailySaleStatus != 7 &&
                                  sale.dailySaleStatus != 8)
                              ? 'Correction'
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
          ],
        ),
      ),
    );
  }

  Widget _labelCell(String label) => Expanded(
        child: Text(label,
            style: AppTypography.dataRowLabel.copyWith(color: AppColors.textMuted)),
      );

  Widget _valueCell(String value) => Expanded(
        child: Text(value, style: AppTypography.dataRowLabel),
      );

  Widget _paymentRow(String label, dynamic amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTypography.dataRowLabel.copyWith(color: AppColors.textMuted)),
        Row(
          children: [
            Icon(Icons.currency_rupee, size: 12, color: AppColors.text),
            Text(
              formatCurrency((amount ?? 0).toDouble()),
              style: AppTypography.dataRowLabel,
            ),
          ],
        ),
      ],
    );
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
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint(
            "Response body DailySaleByGK_StatusUpdate: ${response.body}");
        debugPrint(
            "request body DailySaleByGK_StatusUpdate: ${response.request}");

        if (response.statusCode == 200) {
          EasyLoading.showToast(messageShow,
              duration: const Duration(milliseconds: 3000));
          Navigator.pushNamed(
            context,
            BottomNavBarExample.screenName,
            arguments: 2,
          );
          setState(() {});
        } else {
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        debugPrint("Error: $error");
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

  Future<void> getLastUploadedFileDifference() async {
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
          Uri.parse('${AppUrl.GetLastUploadedTimeDiff}/$distributorId'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        );

        debugPrint("Response body GetLastUploadedTimeDiff: ${response.body}");
        debugPrint("request body GetLastUploadedTimeDiff: ${response.request}");

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getLastUploadedFile = data
                .map((jsonItem) =>
                    GetLastUploadedFrileDifferenceModel.fromJson(jsonItem))
                .toList();
          });
        } else {
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        debugPrint("Error: $error");
      }
    }
  }

  void showCustomAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    String cancelText = 'OK',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline_rounded, size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              Text(title,
                  style: AppTypography.cardTitle.copyWith(color: AppColors.blue),
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(content,
                  style: AppTypography.cardSubtitle,
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
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
        );
      },
    );
  }

  Future<void> checkAndSaveDayEndData() async {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..loadingStyle = EasyLoadingStyle.light
      ..dismissOnTap = false
      ..userInteractions = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    if (distributorId == null || bearerToken == null) return;
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
        } else {
          saveFlag = true;
        }
      } else {
        debugPrint("Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
    }
  }
}
