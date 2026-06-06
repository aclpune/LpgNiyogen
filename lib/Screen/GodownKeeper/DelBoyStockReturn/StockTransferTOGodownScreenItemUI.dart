

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../User/Login/provider/LoginProvider.dart';
import '../../User/splashscreen/page/splash_screen.dart';
import '../../Utils/CustomeAlertDialog.dart';
import '../../Utils/Widget.dart';
import 'package:http/http.dart' as http;

import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/shared_preference.dart';
import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import '../ItemReceipt/CylItemList/GetCurrentStcOfGodownKeeperModel.dart';
import 'StockReturnFromDelBoy.dart';

// Design system imports
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import '../../Utils/styles/app_text_styles.dart';

class StockTransferTOGodownScreenItemUI extends StatefulWidget {
  GetStockTransferListModel _listModel;

  StockTransferTOGodownScreenItemUI(this._listModel, {Key? key})
      : super(key: key);

  @override
  State<StockTransferTOGodownScreenItemUI> createState() =>
      _StockTransferTOGodownScreenItemUIState();
}

class _StockTransferTOGodownScreenItemUIState
    extends State<StockTransferTOGodownScreenItemUI> {
  bool isListViewVisible = false;
  bool isLoading = true;
  List<GetStockTransferListModel> _stockTransferList = [];
  String? mobileNo;
  List<GetCurrentStcOfGodownKeeperModel> getCurrentStcOfGodownKeeper = [];
  bool saveFlag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndSaveDayEndData();
  }

  @override
  Widget build(BuildContext context) {
    var value = widget._listModel;
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),   // was: EdgeInsets.symmetric(vertical: 12)
            child: Center(
              child: SizedBox(
                width: AppSizes.miniSpinnerSize,                              // was: 24
                height: AppSizes.miniSpinnerSize,                             // was: 24
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.miniSpinnerStroke,                    // was: 2
                  color: AppColors.primary,                                   // was: Color(0xFF1E3A8A)
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        String? godownId = snapshot.data?.getString('godownId');

        bool hideAcceptButton = (value.fromGodownId ==
            int.parse(godownId ?? '0')) ||
            value.isStkTrans == 1;

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm + AppSpacing.xxs), // was: EdgeInsets.only(bottom: 10)
          decoration: AppDecorations.stockListItem,                             // was: inline BoxDecoration(white, r16, listItem shadow)
          child: Padding(
            padding: AppSpacing.stockItemPadding,                               // was: EdgeInsets.symmetric(horizontal:16, vertical:14)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header row: item name + date ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        value.itemName ?? '',
                        style: AppTextStyles.cardTitle,                         // was: TextStyle(fontSize:15, w700, 0xFF111827, ls:-0.1)
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),                      // was: SizedBox(width: 8)
                    Container(
                      padding: AppSpacing.dateBadgePadding,                    // was: EdgeInsets.symmetric(horizontal:9, vertical:4)
                      decoration: AppDecorations.dateBadge,                    // was: BoxDecoration(color:0xFFEFF6FF, r:20)
                      child: Text(
                        DateFormat('dd-MM-yyyy').format(
                          DateTime.parse(value.stkTransDate ?? ''),
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryLight,                        // was: Color(0xFF2D52C5)
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),                         // was: SizedBox(height: 12)
                const Divider(height: 1, color: AppColors.divider),             // was: Color(0xFFF1F5F9)
                const SizedBox(height: AppSpacing.md),                         // was: SizedBox(height: 12)

                // ── Stock count row ──
                Row(
                  children: [
                    _StockBadge(
                      label: 'Fill',
                      count: (value.filledStk ?? 0).toInt(),
                      color: AppColors.green,                                   // was: Color(0xFF16A34A)
                      bgColor: AppColors.greenXLight,                           // was: Color(0xFFF0FDF4)
                    ),
                    const SizedBox(width: AppSpacing.sm),                      // was: SizedBox(width: 8)
                    _StockBadge(
                      label: 'Empty',
                      count: (value.emptyStk ?? 0).toInt(),
                      color: AppColors.orange2,                                 // was: Color(0xFFF97316)
                      bgColor: AppColors.orange2XLight,                        // was: Color(0xFFFFF7ED)
                    ),
                    const SizedBox(width: AppSpacing.sm),                      // was: SizedBox(width: 8)
                    _StockBadge(
                      label: 'Defective',
                      count: (value.defectiveStk ?? 0).toInt(),
                      color: AppColors.red,                                     // was: Color(0xFFEF4444)
                      bgColor: AppColors.redXLight,                             // was: Color(0xFFFEF2F2)
                    ),
                  ],
                ),

                // ── Accept button ──
                if (!hideAcceptButton) ...[
                  const SizedBox(height: AppSpacing.md),                       // was: SizedBox(height: 12)
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                    GestureDetector(
                      onTap: () async {
                        int tGID = (value.toGodownId ?? 0).toInt();
                        int fGID = (value.fromGodownId ?? 0).toInt();
                        int fillQ = (value.filledStk ?? 0).toInt();
                        int emptyQ = (value.emptyStk ?? 0).toInt();
                        int defQ = (value.defectiveStk ?? 0).toInt();
                        int itemIDs = (value.itemId ?? 0).toInt();
                        String remark = value.remark ?? '';

                        bool isStockValid = await fetchCurrentStock(
                            fGID, fillQ, emptyQ, defQ, itemIDs);
                        if (saveFlag) {
                          print('saveFlag $saveFlag');
                          showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          if (isStockValid) {
                            submitStockToApi(tGID, fGID, itemIDs, fillQ,
                                emptyQ, defQ, remark);
                          } else {
                            CustomAlertDialog.showCustomAlert(context,
                                Constants.countShouldNotBeGreater);
                          }
                        }
                      },
                      child: Container(
                        padding: AppSpacing.acceptBtnPadding,                  // was: EdgeInsets.symmetric(horizontal:16, vertical:8)
                        decoration: AppDecorations.acceptBtn,                  // was: BoxDecoration(color:0xFF1E3A8A, r:20)
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ── All business logic / API methods below are UNCHANGED ─────────────────────

  Future<void> submitStockToApi(int toGodownId, int fromGodownId, int itemIds,
      int fillC, int emptyC, int defC, String remarks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token');

    int dId = int.parse(distributorId!);
    int gId = int.parse(godownId!);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    Map<String, dynamic> requestBody = {
      "DistributorId": dId,
      "FromGodownId": fromGodownId,
      "StkTransDate": formattedDate,
      "ToGodownId": toGodownId ?? 0,
      "ItemId": itemIds,
      "FilledStk": fillC,
      "EmptyStk": emptyC,
      "DefectiveStk": defC,
      "IsStkTrans": 1,
      "Remark": remarks ?? '',
      "AddedBy": addedBy
    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.SaveGodownStockTransferDtls}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print("API Response Status Code SaveGodownStockTransferDtls: ${response.statusCode}");
      print("API Response Body SaveGodownStockTransferDtls: ${response.body}");
      print("API Response request SaveGodownStockTransferDtls: ${response.request} ${requestBody}");

      if (response.statusCode == 200) {
        // Navigator.pushReplacementNamed(context, '/godownDashboard');
        Navigator.pushReplacementNamed(context, '/bottomNavigationForGodownKeeper');
        print("SaveGodownStockTransferDtls quantity added successfully!");
        EasyLoading.showToast("Data Sent Successfully..",
            duration: const Duration(milliseconds: 3000));
        fetchTransactionList();
      } else {
        print("Failed to add imbalance quantity: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  // Future<void> fetchTransactionList() async {
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if (Constants.isNetworkAvailable) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? godownId = prefs.getString('godownId');
  //     String? bearerToken = prefs.getString('token');
  //     int dId = int.parse(distributorId!);
  //     int gId = int.parse(godownId!);
  //     if (bearerToken == null) {
  //       throw Exception('Bearer token is missing');
  //     }
  //
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
  //       headers: {
  //         'Authorization': 'Bearer $bearerToken',
  //       },
  //     );
  //     debugPrint("GetStockTransferDtls" +
  //         '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
  //     debugPrint("GetStockTransferDtls" + response.body);
  //     if (response.statusCode == 200) {
  //       List<dynamic> data = json.decode(response.body);
  //       if (!mounted) return;
  //       setState(() {
  //         _stockTransferList = data
  //             .map((json) => GetStockTransferListModel.fromJson(json))
  //             .toList();
  //       });
  //       isLoading = false;
  //     } else {
  //       isLoading = false;
  //       throw Exception('Failed To Load Items');
  //     }
  //   } else {
  //     isLoading = false;
  //     showFlushBar(context, Constants.connectionMessage);
  //   }
  // }

  Future<void> fetchTransactionList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!mounted) return;

    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (!mounted) return;

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

      if (!mounted) return;

      debugPrint("GetStockTransferDtls"
          '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
      debugPrint("GetStockTransferDtls" + response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _stockTransferList = data
              .map((json) => GetStockTransferListModel.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        throw Exception('Failed To Load Items');
      }
    } else {
      setState(() => isLoading = false);
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> refreshTokens() async {
    LoginProvider auth = Provider.of<LoginProvider>(context, listen: false);
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      mobileNo = preferences.getString('MobileNo').toString();

      final Future<Map<String, dynamic>> respose =
      auth.refreshToken(mobileNo!, context);

      try {
        respose.then((response) {
          EasyLoading.dismiss();
          if (response['status']) {
            debugPrint('RefreshTokenStatus - True');
          } else if (response['message'] == "UnSuccessful") {
            debugPrint('RefreshTokenExc401 - true');

            showDialogToExpireSession(context);
          } else {
            debugPrint('RefreshTokenStatus - false');
          }
        }).catchError((error) {
          EasyLoading.dismiss();
          debugPrint('RefreshTokenError1: $error');
        });
      } on HttpException catch (error) {
        EasyLoading.dismiss();
        debugPrint('RefreshTokenHttpExc: $error');
      } catch (error) {
        EasyLoading.dismiss();
        debugPrint('RefreshTokenError2: $error');
      }
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint('RefreshTokenError3: $error');
    }
  }

  showDialogToExpireSession(BuildContext context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Expired";
        String message = "Your Session Is Expire. Click Ok To Login Again.";
        String btnLabel = "Ok";
        return Platform.isIOS
            ? WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: CupertinoAlertDialog(
            title: Text(title, style: Styling.bodyTitle),
            content: Text(message, style: Styling.bodyTitle),
            actions: <Widget>[
              TextButton(
                child: Text(btnLabel, style: Styling.blueClrText),
                onPressed: () => logoutUser(context),
              ),
            ],
          ),
        )
            : WillPopScope(
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(btnLabel),
                onPressed: () => logoutUser(context),
              ),
            ],
          ),
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
        );
      },
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    EasyLoading.show(status: 'Loading...');
    try {
      SharedPref().removeUser();
      EasyLoading.dismiss();
      Navigator.pushNamedAndRemoveUntil(
          context, SplashScreen.screenName, (r) => false);
      debugPrint("Logout Successful");
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint("LogoutPrefEcx: $error");
    }
  }

  Future<bool> fetchCurrentStock(int fromGodownId, int fillQ, int emptyQ,
      int defQ, int itemIDs) async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token');

      try {
        final response = await http.get(
          Uri.parse(
              '${AppUrl.ItemCurrentStkList}/$distributorId/$fromGodownId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        print("Request URL ItemCurrentStkList: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        print("API Response Status ItemCurrentStkList: ${response.statusCode}");
        print("API Response ItemCurrentStkList: ${response.body}");

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getCurrentStcOfGodownKeeper = data
                .map((json) =>
                GetCurrentStcOfGodownKeeperModel.fromJson(json))
                .toList();
            isLoading = false;
            EasyLoading.dismiss();
          });

          for (var stockItem in getCurrentStcOfGodownKeeper) {
            if (stockItem.itemId == itemIDs) {
              if (fillQ > (stockItem.currentStkFilled ?? 0)) {
                return false;
              }
              if (defQ > (stockItem.currentStkDefective ?? 0)) {
                return false;
              }
              if (emptyQ > (stockItem.currentStkEmpty ?? 0)) {
                return false;
              }
            }
          }
          return true;
        } else {
          setState(() {
            isLoading = false;
            EasyLoading.dismiss();
            refreshTokens();
          });
          showFlushBar(context, Constants.listGettingFail);
          return false;
        }
      } catch (e) {
        setState(() {
          EasyLoading.dismiss();
          isLoading = false;
          refreshTokens();
        });
        showFlushBar(context, Constants.listGettingFail);
        return false;
      }
    } else {
      EasyLoading.dismiss();
      refreshTokens();
      showFlushBar(context, Constants.connectionMessage);
      return false;
    }
  }

  Future<void> checkAndSaveDayEndData() async {
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
// LOCAL UI WIDGETS (stateless, UI-only)
// ─────────────────────────────────────────────

/// Compact stock count badge for history list items
class _StockBadge extends StatelessWidget {
  const _StockBadge({
    required this.label,
    required this.count,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final int count;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.stockBadgeInner,                          // was: EdgeInsets.symmetric(horizontal:10, vertical:5)
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.checkboxChip,                       // was: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
