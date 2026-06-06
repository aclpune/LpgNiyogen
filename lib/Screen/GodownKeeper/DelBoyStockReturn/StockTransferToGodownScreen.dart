

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../User/Login/provider/LoginProvider.dart';
import '../../User/splashscreen/page/splash_screen.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/CustomeAlertDialog.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../../Utils/shared_preference.dart';
import '../BottomNavigationForGodownKeeper.dart';
import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import '../DeliveryBoyModel/GetGodownListModel.dart';
import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import '../ItemReceipt/CylItemList/CylItemListModel.dart';
import 'StockTransferTOGodownScreenItemUI.dart';
import 'package:http/http.dart' as http;

// Design system imports
import '../../Utils/styles/app_colors.dart';
import '../../Utils/styles/app_spacing.dart';
import '../../Utils/styles/app_text_styles.dart';

class StockTransferTOGodownScreen extends StatefulWidget {
  static const screenName = '/stockTransferTOGodownScreen';

  const StockTransferTOGodownScreen({super.key});

  @override
  State<StockTransferTOGodownScreen> createState() =>
      _StockTransferTOGodownScreenState();
}

class _StockTransferTOGodownScreenState
    extends State<StockTransferTOGodownScreen> {
  final TextEditingController _filledQtyController = TextEditingController();
  final TextEditingController _emptyQtyController = TextEditingController();
  final TextEditingController _defectiveQtyController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  GetGodownListModel? _selectedGodownModel;
  List<GetGodownListModel> _godownItems = [];
  List<GetStockTransferListModel> _stockTransferList = [];
  bool isLoading = true;
  String? _selectedGodownName;
  int? selectedGodownId;
  var argValue;
  String? itemNames;
  int? itemIds, filledCount, emptyCount, defectiveCount;
  String? mobileNo;
  bool stockTransferFlag = false;
  bool saveFlag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map;
        itemNames = argValue["itemName"] ?? '';
        itemIds = argValue["itemID"] ?? 0;
        filledCount = argValue["filledStock"] ?? 0;
        emptyCount = argValue["emptyStock"] ?? 0;
        defectiveCount = argValue["defectiveStock"] ?? 0;
      });
    });
    fetchGodownInfo();
    fetchTransactionList();
    checkAndSaveDayEndData();
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pop(context);
          return false;
        } else {
          Navigator.pop(context);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background2,                    // was: Color(0xFFF1F5FE)
        appBar: CustomAppBar(
          title: 'Stock Transfer',
        ),
        body:
        SingleChildScrollView(
          padding: AppSpacing.formBodyPadding,                      // was: EdgeInsets.all(16)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Stock Summary Card ──
              _StockSummaryCard(
                itemName: itemNames ?? '',
                filledCount: filledCount ?? 0,
                emptyCount: emptyCount ?? 0,
                defectiveCount: defectiveCount ?? 0,
              ),
              const SizedBox(height: AppSpacing.lg),               // was: SizedBox(height: 16)

              // ── Transfer Form Card ──
              _SectionLabel(title: 'Transfer Details'),
              const SizedBox(height: AppSpacing.sm),               // was: SizedBox(height: 8)
              _FormCard(
                children: [
                  _QtyField(
                    label: 'Filled Qty',
                    hint: 'Enter Filled Qty',
                    controller: _filledQtyController,
                    onChanged: (value) {
                      setState(() {
                        int filledQty = int.tryParse(value) ?? 0;
                        if (filledQty > (filledCount ?? 0)) {
                          showFlushBar(
                              context, Constants.stockTransferValidation);
                          _filledQtyController.clear();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),           // was: SizedBox(height: 12)
                  _QtyField(
                    label: 'Empty Qty',
                    hint: 'Enter Empty Qty',
                    controller: _emptyQtyController,
                    onChanged: (value) {
                      setState(() {
                        int emptyQtys = int.tryParse(value) ?? 0;
                        if (emptyQtys > (emptyCount ?? 0)) {
                          showFlushBar(
                              context, Constants.stockTransferValidation);
                          _emptyQtyController.clear();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),           // was: SizedBox(height: 12)
                  _QtyField(
                    label: 'Defective Qty',
                    hint: 'Enter Defective Qty',
                    controller: _defectiveQtyController,
                    onChanged: (value) {
                      setState(() {
                        int defectiveQtys = int.tryParse(value) ?? 0;
                        if (defectiveQtys > (defectiveCount ?? 0)) {
                          showFlushBar(context,
                              Constants.stockTransferValidation);
                          _defectiveQtyController.clear();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),           // was: SizedBox(height: 12)

                  // ── Godown Dropdown ──
                  _FieldLabel(label: 'Select Godown', required: true),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<GetGodownListModel>(
                    decoration: InputDecoration(
                      hintText: 'Select Godown',
                      hintStyle: AppTextStyles.dropdownHint,        // was: TextStyle(fontSize:14, color: Color(0xFF6B7280))
                      filled: true,
                      fillColor: AppColors.surfaceMuted,            // was: Color(0xFFF8FAFC)
                      contentPadding: AppSpacing.dropdownContentPadding, // was: EdgeInsets.symmetric(horizontal:14,vertical:14)
                      border: AppDecorations.formBorderEnabled,     // was: OutlineInputBorder(radius:12, color:0xFFE2E8F0)
                      enabledBorder: AppDecorations.formBorderEnabled,
                      focusedBorder: AppDecorations.formBorderFocused, // was: color:0xFF2D52C5 width:1.5
                    ),
                    value: _selectedGodownModel,
                    style: AppTextStyles.formFieldInput,             // was: TextStyle(fontSize:14, color:0xFF111827, w500)
                    items: _godownItems.map((GetGodownListModel item) {
                      return DropdownMenuItem<GetGodownListModel>(
                        value: item,
                        child: Text(
                          item.godownNo ?? 'Unknown',
                          style: Styling.textFormText,
                        ),
                      );
                    }).toList(),
                    onChanged: (GetGodownListModel? selectedItem) {
                      if (selectedItem != null) {
                        setState(() {
                          _selectedGodownName = selectedItem.godownNo;
                          selectedGodownId = selectedItem.godownId!.toInt();
                          _selectedGodownModel = selectedItem;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),           // was: SizedBox(height: 12)

                  // ── Remark ──
                  _FieldLabel(label: 'Remark'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _remarkController,
                    maxLength: 250,
                    maxLines: 2,
                    style: AppTextStyles.formFieldInput,             // was: TextStyle(fontSize:14, color:0xFF111827)
                    decoration: InputDecoration(
                      hintText: 'Enter Remark',
                      hintStyle: AppTextStyles.dropdownHint,        // was: TextStyle(fontSize:14, color:0xFF6B7280)
                      filled: true,
                      fillColor: AppColors.surfaceMuted,            // was: Color(0xFFF8FAFC)
                      contentPadding: AppSpacing.dropdownContentPadding,
                      border: AppDecorations.formBorderEnabled,
                      enabledBorder: AppDecorations.formBorderEnabled,
                      focusedBorder: AppDecorations.formBorderFocused,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),           // was: SizedBox(height: 8)

                  // ── Submit Button ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (saveFlag) {
                          print('saveFlag $saveFlag');
                          showFlushBar(context, Constants.dayEndCompleted);
                        } else {
                          if (_selectedGodownName != null) {
                            if (_filledQtyController.text.isNotEmpty ||
                                _emptyQtyController.text.isNotEmpty ||
                                _defectiveQtyController.text.isNotEmpty) {
                              if (stockTransferFlag) {
                                submitStockToApi();
                              } else {
                                CustomAlertDialog.showCustomAlert(
                                    context, Constants.stockNotAccepted);
                              }
                            } else {
                              showFlushBar(context, Constants.validCountEnter);
                            }
                          } else {
                            showFlushBar(context, "Select godown.");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: stockTransferFlag
                            ? AppColors.primary                      // was: Color(0xFF1E3A8A)
                            : AppColors.textDisabled,                // was: Color(0xFF9CA3AF)
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: Size.fromHeight(AppSizes.submitBtnHeight), // was: Size.fromHeight(52)
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.formButton,        // was: BorderRadius.circular(14)
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),               // was: SizedBox(height: 20)

              // ── Transfer History ──
              _SectionLabel(title: 'Stock Transfer History'),
              const SizedBox(height: AppSpacing.sm),               // was: SizedBox(height: 8)
              SizedBox(
                height: AppSizes.historyListHeight,                // was: 200
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _stockTransferList.length,
                  itemBuilder: (context, index) {
                    return StockTransferTOGodownScreenItemUI(
                        _stockTransferList[index]);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),               // was: SizedBox(height: 16)
            ],
          ),
        ),
      ),

      // child: Scaffold(
      //   backgroundColor: AppColors.background2,
      //   body: Column(
      //     children: [
      //       // ── App Gradient Header ──
      //       AppGradientHeader(
      //         title: 'Stock Transfer',
      //         subtitle: 'Move stock between godowns',
      //         icon: Icons.swap_horiz_rounded,
      //         onBack: () => Navigator.pushReplacementNamed(
      //           context,
      //           BottomNavigationForGodownKeeper.screenName,
      //           arguments: "onBack",
      //         ),
      //       ),
      //
      //       // ── Scrollable Body ──
      //       Expanded(
      //         child: SingleChildScrollView(
      //           padding: AppSpacing.formBodyPadding,
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               // ── Stock Summary Card ──
      //               _StockSummaryCard(
      //                 itemName: itemNames ?? '',
      //                 filledCount: filledCount ?? 0,
      //                 emptyCount: emptyCount ?? 0,
      //                 defectiveCount: defectiveCount ?? 0,
      //               ),
      //               const SizedBox(height: AppSpacing.lg),
      //
      //               // ── Transfer Form Card ──
      //               _SectionLabel(title: 'Transfer Details'),
      //               const SizedBox(height: AppSpacing.sm),
      //               _FormCard(
      //                 children: [
      //                   _QtyField(
      //                     label: 'Filled Qty',
      //                     hint: 'Enter Filled Qty',
      //                     controller: _filledQtyController,
      //                     onChanged: (value) {
      //                       setState(() {
      //                         int filledQty = int.tryParse(value) ?? 0;
      //                         if (filledQty > (filledCount ?? 0)) {
      //                           showFlushBar(context, Constants.stockTransferValidation);
      //                           _filledQtyController.clear();
      //                         }
      //                       });
      //                     },
      //                   ),
      //                   const SizedBox(height: AppSpacing.md),
      //                   _QtyField(
      //                     label: 'Empty Qty',
      //                     hint: 'Enter Empty Qty',
      //                     controller: _emptyQtyController,
      //                     onChanged: (value) {
      //                       setState(() {
      //                         int emptyQtys = int.tryParse(value) ?? 0;
      //                         if (emptyQtys > (emptyCount ?? 0)) {
      //                           showFlushBar(context, Constants.stockTransferValidation);
      //                           _emptyQtyController.clear();
      //                         }
      //                       });
      //                     },
      //                   ),
      //                   const SizedBox(height: AppSpacing.md),
      //                   _QtyField(
      //                     label: 'Defective Qty',
      //                     hint: 'Enter Defective Qty',
      //                     controller: _defectiveQtyController,
      //                     onChanged: (value) {
      //                       setState(() {
      //                         int defectiveQtys = int.tryParse(value) ?? 0;
      //                         if (defectiveQtys > (defectiveCount ?? 0)) {
      //                           showFlushBar(context, Constants.stockTransferValidation);
      //                           _defectiveQtyController.clear();
      //                         }
      //                       });
      //                     },
      //                   ),
      //                   const SizedBox(height: AppSpacing.md),
      //
      //                   // ── Godown Dropdown ──
      //                   _FieldLabel(label: 'Select Godown', required: true),
      //                   const SizedBox(height: 6),
      //                   DropdownButtonFormField<GetGodownListModel>(
      //                     decoration: InputDecoration(
      //                       hintText: 'Select Godown',
      //                       hintStyle: AppTextStyles.dropdownHint,
      //                       filled: true,
      //                       fillColor: AppColors.surfaceMuted,
      //                       contentPadding: AppSpacing.dropdownContentPadding,
      //                       border: AppDecorations.formBorderEnabled,
      //                       enabledBorder: AppDecorations.formBorderEnabled,
      //                       focusedBorder: AppDecorations.formBorderFocused,
      //                     ),
      //                     value: _selectedGodownModel,
      //                     style: AppTextStyles.formFieldInput,
      //                     items: _godownItems.map((GetGodownListModel item) {
      //                       return DropdownMenuItem<GetGodownListModel>(
      //                         value: item,
      //                         child: Text(
      //                           item.godownNo ?? 'Unknown',
      //                           style: Styling.textFormText,
      //                         ),
      //                       );
      //                     }).toList(),
      //                     onChanged: (GetGodownListModel? selectedItem) {
      //                       if (selectedItem != null) {
      //                         setState(() {
      //                           _selectedGodownName = selectedItem.godownNo;
      //                           selectedGodownId = selectedItem.godownId!.toInt();
      //                           _selectedGodownModel = selectedItem;
      //                         });
      //                       }
      //                     },
      //                   ),
      //                   const SizedBox(height: AppSpacing.md),
      //
      //                   // ── Remark ──
      //                   _FieldLabel(label: 'Remark'),
      //                   const SizedBox(height: 6),
      //                   TextField(
      //                     controller: _remarkController,
      //                     maxLength: 250,
      //                     maxLines: 2,
      //                     style: AppTextStyles.formFieldInput,
      //                     decoration: InputDecoration(
      //                       hintText: 'Enter Remark',
      //                       hintStyle: AppTextStyles.dropdownHint,
      //                       filled: true,
      //                       fillColor: AppColors.surfaceMuted,
      //                       contentPadding: AppSpacing.dropdownContentPadding,
      //                       border: AppDecorations.formBorderEnabled,
      //                       enabledBorder: AppDecorations.formBorderEnabled,
      //                       focusedBorder: AppDecorations.formBorderFocused,
      //                     ),
      //                   ),
      //                   const SizedBox(height: AppSpacing.sm),
      //
      //                   // ── Submit Button ──
      //                   SizedBox(
      //                     width: double.infinity,
      //                     child: ElevatedButton(
      //                       onPressed: () {
      //                         if (saveFlag) {
      //                           print('saveFlag $saveFlag');
      //                           showFlushBar(context, Constants.dayEndCompleted);
      //                         } else {
      //                           if (_selectedGodownName != null) {
      //                             if (_filledQtyController.text.isNotEmpty ||
      //                                 _emptyQtyController.text.isNotEmpty ||
      //                                 _defectiveQtyController.text.isNotEmpty) {
      //                               if (stockTransferFlag) {
      //                                 submitStockToApi();
      //                               } else {
      //                                 CustomAlertDialog.showCustomAlert(
      //                                     context, Constants.stockNotAccepted);
      //                               }
      //                             } else {
      //                               showFlushBar(context, Constants.validCountEnter);
      //                             }
      //                           } else {
      //                             showFlushBar(context, "Select godown.");
      //                           }
      //                         }
      //                       },
      //                       style: ElevatedButton.styleFrom(
      //                         backgroundColor: stockTransferFlag
      //                             ? AppColors.primary
      //                             : AppColors.textDisabled,
      //                         foregroundColor: Colors.white,
      //                         elevation: 0,
      //                         minimumSize: Size.fromHeight(AppSizes.submitBtnHeight),
      //                         shape: RoundedRectangleBorder(
      //                           borderRadius: AppRadius.formButton,
      //                         ),
      //                         textStyle: const TextStyle(
      //                           fontSize: 15,
      //                           fontWeight: FontWeight.w700,
      //                           letterSpacing: 0.1,
      //                         ),
      //                       ),
      //                       child: const Text('Submit'),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               const SizedBox(height: AppSpacing.xl),
      //
      //               // ── Transfer History ──
      //               _SectionLabel(title: 'Stock Transfer History'),
      //               const SizedBox(height: AppSpacing.sm),
      //               SizedBox(
      //                 height: AppSizes.historyListHeight,
      //                 child: ListView.builder(
      //                   shrinkWrap: true,
      //                   physics: const AlwaysScrollableScrollPhysics(),
      //                   itemCount: _stockTransferList.length,
      //                   itemBuilder: (context, index) {
      //                     return StockTransferTOGodownScreenItemUI(
      //                         _stockTransferList[index]);
      //                   },
      //                 ),
      //               ),
      //               const SizedBox(height: AppSpacing.lg),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // ── All business logic / API methods below are UNCHANGED ─────────────────────

  Future<void> fetchGodownInfo() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      int gId = int.parse(godownId!);
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetGodownMasterList}/$distributorId/1'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      debugPrint("GetGodownMasterList" +
          '${AppUrl.GetGodownMasterList}/$distributorId/1');
      debugPrint("GetGodownMasterList" + response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _godownItems =
              data.map((json) => GetGodownListModel.fromJson(json)).toList();
          _godownItems = _godownItems
              .where((item) => item.godownId != gId)
              .toList();
        });
      } else {
        refreshTokens();
        throw Exception('Failed To Load Items');
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> submitStockToApi() async {
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

    int fillC = 0;
    int emptyC = 0;
    int defC = 0;

    try {
      fillC = int.tryParse(_filledQtyController.text) ?? 0;
      emptyC = int.tryParse(_emptyQtyController.text) ?? 0;
      defC = int.tryParse(_defectiveQtyController.text) ?? 0;
    } catch (e) {
      print("Error parsing quantities: $e");
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": dId,
      "FromGodownId": gId,
      "StkTransDate": formattedDate,
      "ToGodownId": selectedGodownId ?? 0,
      "ItemId": itemIds,
      "FilledStk": fillC,
      "EmptyStk": emptyC,
      "DefectiveStk": defC,
      "IsStkTrans": 0,
      "Remark": _remarkController.text,
      "AddedBy": addedBy,
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

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        Navigator.pop(context);
        print("Stock transfer submitted successfully!");
        EasyLoading.showToast("Data Sent Successfully..",
            duration: const Duration(milliseconds: 3000));
        fetchTransactionList();
      } else {
        print("Failed to submit stock transfer: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
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
            fetchGodownInfo();
            fetchTransactionList();
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
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );
      debugPrint("GetStockTransferDtls" +
          '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
      debugPrint("GetStockTransferDtls" + response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if (!mounted) return;
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
          if (hasZeroStkTrans) {
            stockTransferFlag = false;
          } else {
            stockTransferFlag = true;
          }
          EasyLoading.dismiss();
        });

        isLoading = false;
      } else {
        EasyLoading.dismiss();
        refreshTokens();
        isLoading = false;
        throw Exception(Constants.listGettingFail);
      }
    } else {
      EasyLoading.dismiss();
      refreshTokens();
      isLoading = false;
      showFlushBar(context, Constants.connectionMessage);
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

/// Stock summary card shown at the top of the screen
class _StockSummaryCard extends StatelessWidget {
  const _StockSummaryCard({
    required this.itemName,
    required this.filledCount,
    required this.emptyCount,
    required this.defectiveCount,
  });

  final String itemName;
  final int filledCount;
  final int emptyCount;
  final int defectiveCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.formCardPadding,                          // was: EdgeInsets.all(18)
      decoration: AppDecorations.formCard,                          // was: inline BoxDecoration(white, r18, shadow)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemName,
            style: AppTextStyles.cardTitle,                         // was: inline TextStyle(fontSize:16, w700, textPrimary)
          ),
          const SizedBox(height: AppSpacing.md),                   // was: SizedBox(height: 12)
          Row(
            children: [
              Expanded(
                child: _StockChip(
                  label: 'Filled',
                  count: filledCount,
                  color: AppColors.green,                           // was: Color(0xFF16A34A)
                  bgColor: AppColors.greenXLight,                   // was: Color(0xFFF0FDF4)
                ),
              ),
              const SizedBox(width: AppSpacing.sm + AppSpacing.xxs), // was: SizedBox(width: 10)
              Expanded(
                child: _StockChip(
                  label: 'Empty',
                  count: emptyCount,
                  color: AppColors.orange2,                         // was: Color(0xFFF97316)
                  bgColor: AppColors.orange2XLight,                 // was: Color(0xFFFFF7ED)
                ),
              ),
              const SizedBox(width: AppSpacing.sm + AppSpacing.xxs),
              Expanded(
                child: _StockChip(
                  label: 'Defective',
                  count: defectiveCount,
                  color: AppColors.red,                             // was: Color(0xFFEF4444)
                  bgColor: AppColors.redXLight,                     // was: Color(0xFFFEF2F2)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StockChip extends StatelessWidget {
  const _StockChip({
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
      padding: AppSpacing.stockChipInner,                           // was: EdgeInsets.symmetric(horizontal:12, vertical:10)
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.stockChip,                          // was: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),                   // was: SizedBox(height: 4)
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section label matching dashboard design
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSizes.sectionDotSize,                           // was: 8
          height: AppSizes.sectionDotSize,                          // was: 8
          decoration: BoxDecoration(
            color: AppColors.primaryLight,                          // was: Color(0xFF2D52C5)
            borderRadius: BorderRadius.circular(AppRadius.xs),      // was: BorderRadius.circular(2)
          ),
        ),
        const SizedBox(width: AppSpacing.sm),                      // was: SizedBox(width: 8)
        Text(
          title.toUpperCase(),
          style: AppTextStyles.sectionHeader,                       // was: TextStyle(fontSize:12, w700, 0xFF374151, ls:0.8)
        ),
      ],
    );
  }
}

/// White rounded card wrapper for form fields
class _FormCard extends StatelessWidget {
  const _FormCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.formCardPadding,                          // was: EdgeInsets.all(18)
      decoration: AppDecorations.formCard,                          // was: inline BoxDecoration(white, r18, shadow)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// Field label text
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, this.required = false});
  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: AppTextStyles.formFieldLabel,                        // was: TextStyle(fontSize:13, w600, 0xFF374151)
        children: required
            ? [
          TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.error),             // was: Color(0xFFEF4444)
          ),
        ]
            : [],
      ),
    );
  }
}

/// Quantity input row: label on left, text field on right
class _QtyField extends StatelessWidget {
  const _QtyField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FieldLabel(label: label),
        ),
        const SizedBox(width: AppSpacing.md),                      // was: SizedBox(width: 12)
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            style: AppTextStyles.formFieldInput,                    // was: TextStyle(fontSize:14, 0xFF111827, w600)
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.formHint,                    // was: TextStyle(fontSize:13, 0xFF9CA3AF)
              filled: true,
              fillColor: AppColors.surfaceMuted,                    // was: Color(0xFFF8FAFC)
              contentPadding: AppSpacing.dropdownContentPadding,    // was: EdgeInsets.symmetric(horizontal:14, vertical:12)
              border: AppDecorations.formBorderEnabled,             // was: OutlineInputBorder(r:12, 0xFFE2E8F0)
              enabledBorder: AppDecorations.formBorderEnabled,
              focusedBorder: AppDecorations.formBorderFocused,      // was: color:0xFF2D52C5, width:1.5
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
