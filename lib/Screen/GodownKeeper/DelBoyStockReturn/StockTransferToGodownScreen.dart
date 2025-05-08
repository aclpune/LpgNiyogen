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
import '../DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import '../DeliveryBoyModel/GetGodownListModel.dart';
import '../DeliveryBoyModel/GetStockTransferListModel.dart';
import '../ItemReceipt/CylItemList/CylItemListModel.dart';
import 'StockTransferTOGodownScreenItemUI.dart';
import 'package:http/http.dart' as http;
class StockTransferTOGodownScreen extends StatefulWidget {
  static const screenName = '/stockTransferTOGodownScreen';
  const StockTransferTOGodownScreen({super.key});

  @override
  State<StockTransferTOGodownScreen> createState() => _StockTransferTOGodownScreenState();
}

class _StockTransferTOGodownScreenState extends State<StockTransferTOGodownScreen> {
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
  int? itemIds,filledCount, emptyCount, defectiveCount;
  String? mobileNo;
  bool stockTransferFlag = false;

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
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return
      WillPopScope(
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
          appBar: CustomAppBar(
            title: 'Stock Transfer',
          ),
          body: SingleChildScrollView(  // Wrap the entire body with SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: itemSubLineLeftBig("Item", itemNames!)),
                      Flexible(child: itemSubLineLeftBig("Filled", filledCount.toString())),
                    ],
                  ),
                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: itemSubLineLeftBig("Empty", emptyCount.toString())),
                      Flexible(child: itemSubLineLeftBig("Defective", defectiveCount.toString())),
                    ],
                  ),
                  SizedBox(height: 5),

                  Divider(),

                  Row(
                    children: [
                      Expanded(child: textWidgetBlueColorWithoutStar("Filled Qty")),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _filledQtyController,
                          decoration: buildInputBorderUpdateStatus("Enter Filled Qty", context),
                          style: Styling.textFormText,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          onChanged: (value) {
                            setState(() {
                              int filledQty = int.tryParse(value) ?? 0;
                              if (filledQty > (filledCount ?? 0)) {
                                showFlushBar(context, Constants.stockTransferValidation);
                                _filledQtyController.clear();
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: textWidgetBlueColorWithoutStar("Empty Qty")),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _emptyQtyController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: buildInputBorderUpdateStatus("Enter Empty Qty", context),
                          style: Styling.textFormText,
                          onChanged: (value) {
                            setState(() {
                              int emptyQtys = int.tryParse(value) ?? 0;
                              if (emptyQtys > (emptyCount ?? 0)) {
                                showFlushBar(context, Constants.stockTransferValidation);
                                _emptyQtyController.clear();
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: textWidgetBlueColorWithoutStar("Defective Qty")),
                      Flexible(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _defectiveQtyController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                decoration: buildInputBorderUpdateStatus("Enter Defective Qty", context),
                                style: Styling.textFormText,
                                onChanged: (value) {
                                  setState(() {
                                    int defectiveQtys = int.tryParse(value) ?? 0;
                                    if (defectiveQtys > (defectiveCount ?? 0)) {
                                      showFlushBar(context, Constants.stockTransferValidation);
                                      _defectiveQtyController.clear();
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: textWidgetBlueColorWithStar("Select Godown", "*")),
                      Flexible(
                        flex: 1,
                        child:
                        DropdownButtonFormField<GetGodownListModel>(
                          decoration: buildInputBorderUpdateStatus("Select Godown", context),
                          value: _selectedGodownModel,
                          style: Styling.textFormText,
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
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text("Remark", style: Styling.blueClrText)),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _remarkController,
                          maxLength: 250,
                          decoration: buildInputBorderUpdateStatus("Enter Remark", context),
                          style: Styling.textFormText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () {
    if(stockTransferFlag){
      submitStockToApi();
    }else{
      CustomAlertDialog.showCustomAlert(context, Constants.stockNotAccepted);

    }

                        },
                        child: Text("Submit", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: stockTransferFlag?Colors.blue:Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Stock Transfer History", style: Styling.bodyTitleWithBlue),
                  ),
                  SizedBox(height: 10),

                  // Use ListView.builder here
                  SizedBox(
                    height: 200, // Set a fixed height for the ListView
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _stockTransferList.length,
                      itemBuilder: (context, index) {
                        return StockTransferTOGodownScreenItemUI(_stockTransferList[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  // Fetch data from API Item
  Future<void> fetchGodownInfo() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      int gId = int.parse(godownId!);
      String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetGodownMasterList}/$distributorId/1'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );
      debugPrint("GetGodownMasterList" +
          '${AppUrl.GetGodownMasterList}/$distributorId/1');
      debugPrint("GetGodownMasterList" + response.body);
      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _godownItems = data.map((json) => GetGodownListModel.fromJson(json)).toList();
          // Exclude the godownId from the list if it exists in the list
          _godownItems = _godownItems
              .where((item) => item.godownId != gId) // Exclude the godownId
              .toList();
        });
      } else {
        refreshTokens();
        throw Exception('Failed To Load Items');
      }
    } else {
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

  Future<void> submitStockToApi() async {
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

    // Add checks for empty or invalid inputs
    int fillC = 0;
    int emptyC = 0;
    int defC = 0;

    try {
      fillC = int.tryParse(_filledQtyController.text) ?? 0;
      emptyC = int.tryParse(_emptyQtyController.text) ?? 0;
      defC = int.tryParse(_defectiveQtyController.text) ?? 0;
    } catch (e) {
      // Handle any error parsing the quantities
      print("Error parsing quantities: $e");
      EasyLoading.showToast("Invalid input for quantities");
      return; // Early exit to prevent the API call with invalid values
    }

    String remarks = _remarkController.text;

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
        print("SaveGodownStockTransferDtls quantity added successfully!");
        EasyLoading.showToast("Data Sent Successfully..", duration: const Duration(milliseconds: 3000));
        fetchTransactionList();
        _filledQtyController.clear();
        _emptyQtyController.clear();
        _defectiveQtyController.clear();
        _remarkController.clear();
        _selectedGodownName = null;
        _selectedGodownModel = null;
        selectedGodownId = null;
      } else {
        // Handle error response
        print("Failed to add imbalance quantity: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred: $e");
    }
  }

  // Future<void> fetchTransactionList() async {
  //   EasyLoading.show();
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if (Constants.isNetworkAvailable) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? godownId = prefs.getString('godownId');
  //     String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
  //     int dId = int.parse(distributorId!);
  //     int gId = int.parse(godownId!);
  //     if (bearerToken == null) {
  //       throw Exception('Bearer token is missing');
  //     }
  //
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.GetStockTransferDtls}/$dId/$gId'),
  //       headers: {
  //         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
  //       },
  //     );
  //     debugPrint(
  //         "GetStockTransferDtls" + '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
  //     debugPrint("GetStockTransferDtls" + response.body);
  //     if (response.statusCode == 200) {
  //       // Parse the response
  //       List<dynamic> data = json.decode(response.body);
  //       setState(() {
  //         _stockTransferList =
  //             data.map((json) => GetStockTransferListModel.fromJson(json)).toList();
  //
  //       });
  //       EasyLoading.dismiss();
  //       isLoading = false;
  //     } else {
  //       refreshTokens();
  //       isLoading = false;
  //       EasyLoading.dismiss();
  //
  //       throw Exception(Constants.listGettingFail);
  //     }
  //   } else {
  //     isLoading = false;
  //     EasyLoading.dismiss();
  //     showFlushBar(
  //         context, Constants.connectionMessage);
  //   }
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

  Future<void> fetchTransactionList() async {
    EasyLoading.show();
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
          _stockTransferList = data.map((json) => GetStockTransferListModel.fromJson(json)).toList();
          bool hasZeroStkTrans = false;
          for (int i = 0; i < _stockTransferList.length; i++) {
            if (_stockTransferList[i].isStkTrans == 0) {
              hasZeroStkTrans = true;
              debugPrint("Found item with isStkTrans = 0");
              break; // No need to continue checking once we find an item with isStkTrans = 0
            }
          }
          if (hasZeroStkTrans) {
            stockTransferFlag = false; // Disable the button
            // showFlushBar(
            //     context, "Action Restricted", "Cannot perform the action as one or more items have isStkTrans = 0");
          } else {
            stockTransferFlag = true; // Enable the button
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
      showFlushBar(
          context, Constants.connectionMessage);
    }
  }

}
