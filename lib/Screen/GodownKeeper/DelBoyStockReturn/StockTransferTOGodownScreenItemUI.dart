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

class StockTransferTOGodownScreenItemUI extends StatefulWidget {
  GetStockTransferListModel _listModel;

  StockTransferTOGodownScreenItemUI(this._listModel,{Key? key}) : super(key: key);

  @override
  State<StockTransferTOGodownScreenItemUI> createState() => _StockTransferTOGodownScreenItemUIState();
}

class _StockTransferTOGodownScreenItemUIState extends State<StockTransferTOGodownScreenItemUI> {
  bool isListViewVisible = false; // Tracks if ListView is visible
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
    return
      FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for SharedPreferences
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Get the stored godownId from SharedPreferences
          String? godownId = snapshot.data?.getString('godownId');

          // Check the conditions to hide the "Accept" button
          bool hideAcceptButton = (value.fromGodownId == int.parse(godownId ?? '0')) || value.isStkTrans == 1;

          return Card(
            elevation: 5,
            margin: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 12),
              child: Column(
                children: [
                  // Date and Weight Row with icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('${value.itemName ?? ''}', style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1280b3),
                              fontFamily: 'OpenSans')),
                        ],
                      ),
                      Row(
                        children: [
                          Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(value.stkTransDate ?? '')),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1280b3),
                                  fontFamily: 'OpenSans')),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // Data values Row with icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('Fill: ', style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                          Text('${value.filledStk ?? 0}',
                              style: TextStyle(fontSize: 14, fontFamily: 'OpenSans')),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Empty: ', style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                          Text('${value.emptyStk ?? 0}',
                              style: TextStyle(fontSize: 14, fontFamily: 'OpenSans')),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Defective: ', style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.grey[700])),
                          Text('${value.defectiveStk ?? 0}',
                              style: TextStyle(fontSize: 14, fontFamily: 'OpenSans')),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  // Hide the "Accept" button based on conditions
                  if (!hideAcceptButton)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // Add your action here
                            int tGID = (value.toGodownId ?? 0).toInt();
                            int fGID = (value.fromGodownId ?? 0).toInt();
                            int fillQ = (value.filledStk ?? 0).toInt();
                            int emptyQ = (value.emptyStk ?? 0).toInt();
                            int defQ = (value.defectiveStk ?? 0).toInt();
                            int itemIDs = (value.itemId ?? 0).toInt();
                            String remark = value.remark ?? '';

                            bool isStockValid = await fetchCurrentStock(fGID, fillQ, emptyQ, defQ, itemIDs);
                            if (saveFlag) {
                              print('saveFlag $saveFlag');
                              showFlushBar(context, Constants.dayEndCompleted);
                            } else {
                              if (isStockValid) {
                                submitStockToApi(tGID,fGID,itemIDs,fillQ,emptyQ,defQ,remark);
                              } else {
                                CustomAlertDialog.showCustomAlert(context, Constants.countShouldNotBeGreater);
                              }
                            }
                          },
                          child: Text(
                            "Accept",
                            style: Styling.blueClrTextWithUnderline,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      );
  }

  Future<void> submitStockToApi(int toGodownId,int fromGodownId,int itemIds,int fillC,int emptyC,int defC,String remarks) async {
    // Construct the request payload
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token'); // This is your bearer token

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
        body: json.encode(requestBody), // Encode the request body as JSON
      );

      // Print the raw response for debugging
      print("API Response Status Code SaveGodownStockTransferDtls: ${response.statusCode}");
      print("API Response Body SaveGodownStockTransferDtls: ${response.body}");
      print("API Response request SaveGodownStockTransferDtls: ${response.request} ${requestBody}");

      if (response.statusCode == 200) {
        // Handle success
        Navigator.pushReplacementNamed(context, '/godownDashboard');
        print("SaveGodownStockTransferDtls quantity added successfully!");
        EasyLoading.showToast("Data Sent Successfully..", duration: const Duration(milliseconds: 3000));
        fetchTransactionList();
      } else {
        // Handle error response
        print("Failed to add imbalance quantity: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred: $e");
    }
  }

  Future<void> fetchTransactionList() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
      int dId = int.parse(distributorId!);
      int gId = int.parse(godownId!);
      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );
      debugPrint(
          "GetStockTransferDtls" + '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
      debugPrint("GetStockTransferDtls" + response.body);
      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _stockTransferList =
              data.map((json) => GetStockTransferListModel.fromJson(json)).toList();

        });
        isLoading = false;
      } else {

        isLoading = false;
        throw Exception('Failed To Load Items');
      }
    } else {
      isLoading = false;
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

  // Future<void> fetchCurrentStock(int fromgodownId) async {
  //   EasyLoading.show();
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if(Constants.isNetworkAvailable){
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? godownId = prefs.getString('godownId');
  //     String? addedBy = prefs.getString('StaffId');
  //     String? godownKeeperId = prefs.getString('godownKeeperId');
  //     String? token = prefs.getString('token'); // This is your bearer token
  //
  //     try {
  //       final response = await http.get(
  //         Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$fromgodownId'),
  //         headers: {
  //           'Authorization': 'Bearer $token',  // Add the Bearer token here
  //           // Any other headers you need can go here
  //         },
  //       );
  //       // Print the URL and the headers (including the Bearer token)
  //       print("Request URL ItemCurrentStkList: ${response.request}");
  //       print("Request Headers: {'Authorization': 'Bearer $token'}");
  //       // Print the raw response for debugging
  //       print("API Response Status ItemCurrentStkList: ${response.statusCode}");
  //       print("API Response ItemCurrentStkList: ${response.body}");
  //       if (response.statusCode == 200) {
  //         final List<dynamic> data = json.decode(response.body);
  //         setState(() {
  //           getCurrentStcOfGodownKeeper = data.map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json)).toList();
  //           isLoading = false;
  //           EasyLoading.dismiss();
  //
  //         });
  //       } else {
  //         // Handle non-200 responses
  //
  //         setState(() {
  //           isLoading = false;
  //           EasyLoading.dismiss();
  //           refreshTokens();
  //         });
  //         showFlushBar(context, "Fail",
  //             'Unable To Load Data At This Time. Please Try Again');
  //       }
  //     } catch (e) {
  //       setState(() {
  //         EasyLoading.dismiss();
  //         isLoading = false;
  //         refreshTokens();
  //       });
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(content: Text('Error: $e')),
  //       // );
  //
  //       showFlushBar(context, "Fail",
  //           'Unable To Load Data At This Time. Please Try Again');
  //     }
  //   }else{
  //     EasyLoading.dismiss();
  //     refreshTokens();
  //     showFlushBar(context,Constants.connectionTitle,
  //         Constants.connectionMessage);
  //   }
  //
  // }

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
        String message = "Your session is expire. Click ok to login again.";
        String btnLabel = "Ok";
        return Platform.isIOS
            ? WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: CupertinoAlertDialog(
            title: Text(
              title,
              style: Styling.bodyTitle,
            ),
            content: Text(
              message,
              style: Styling.bodyTitle,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  btnLabel,
                  style: Styling.blueClrText,
                ),
                onPressed: () {},
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
    ///Save data before logout logic
    EasyLoading.show(status: 'Loading...');

    try {
      SharedPref().removeUser();

      // try {
      //   if (Platform.isAndroid) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("Android FCM Token Deleted"));
      //   } else if (Platform.isIOS) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("iOS FCM Token Deleted"));
      //   }
      // } on PlatformException {
      //   debugPrint('###PlatformExc');
      // }

      EasyLoading.dismiss();

      Navigator.pushNamedAndRemoveUntil(
          context, SplashScreen.screenName, (r) => false);

      debugPrint("Logout Successful");
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint("LogoutPrefEcx: $error");
    }
  }

  Future<bool> fetchCurrentStock(int fromGodownId, int fillQ, int emptyQ, int defQ, int itemIDs) async {
    EasyLoading.show();
    Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token'); // This is your bearer token

      try {
        final response = await http.get(
          Uri.parse('${AppUrl.ItemCurrentStkList}/$distributorId/$fromGodownId'),
          headers: {
            'Authorization': 'Bearer $token',  // Add the Bearer token here
          },
        );

        print("Request URL ItemCurrentStkList: ${response.request}");
        print("Request Headers: {'Authorization': 'Bearer $token'}");
        print("API Response Status ItemCurrentStkList: ${response.statusCode}");
        print("API Response ItemCurrentStkList: ${response.body}");

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getCurrentStcOfGodownKeeper = data.map((json) => GetCurrentStcOfGodownKeeperModel.fromJson(json)).toList();
            isLoading = false;
            EasyLoading.dismiss();
          });

          // Now check if the item quantities exceed the current stock
          for (var stockItem in getCurrentStcOfGodownKeeper) {
            if (stockItem.itemId == itemIDs) {  // Match the item ID
              // Compare the filled stock with current stock
              if (fillQ > (stockItem.currentStkFilled ?? 0)) {
                // If filled quantity exceeds available stock
                return false; // Invalid stock condition
              }

              // Compare the defective stock with current stock
              if (defQ > (stockItem.currentStkDefective ?? 0)) {
                // If defective quantity exceeds available stock
                return false; // Invalid stock condition
              }

              // Compare the empty stock with current stock
              if (emptyQ > (stockItem.currentStkEmpty ?? 0)) {
                // If empty quantity exceeds available stock
                return false; // Invalid stock condition
              }
            }
          }
          // If no issues found, return true (valid stock)
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
          // if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
          //   saveFlag = true;
          //   print("Data is valid, proceeding to save.");
          // } else {
          //   print("Data is incomplete. Cannot proceed to save.");
          // }
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
