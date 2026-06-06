
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
import 'package:http/http.dart' as http;

import '../../../ConstantScreen/widgets.dart'; // ← AppDashCard, AppSectionLabel,
//   AppStyledField, AppItemDropdown,
//   AppItemBadge, AppRemoveButton,
//   AppAddItemButton, AppSectionHeader,
//   AppGradientSubmitButton  all live here
import '../../../User/Login/provider/LoginProvider.dart';
import '../../../User/splashscreen/page/splash_screen.dart';
import '../../../Utils/CustomAppBar.dart';
import '../../../Utils/CustomeAlertDialog.dart';
import '../../../Utils/Widget.dart';
import '../../../Utils/app_url.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/styles/app_colors.dart';
import '../../BottomNavigationForGodownKeeper.dart';
import '../../DeliveryBoyModel/GetStockTransferListModel.dart';
import '../../MoreOptionScreenGodownKeeper.dart';
import '../CylItemList/CylItemListModel.dart';
import '../EditItem/Model/GetItemReceiptListModel.dart';

class ItemReceiptScreen extends StatefulWidget {
  static const screenName = '/itemWiseReceipt';

  @override
  _ItemReceiptScreenState createState() => _ItemReceiptScreenState();
}

class _ItemReceiptScreenState extends State<ItemReceiptScreen> {
  // ── controllers ─────────────────────────────────────────────────────────────
  final TextEditingController receiptDateController =
  TextEditingController();
  final TextEditingController vehicleNoController =
  TextEditingController();

  // ── state ───────────────────────────────────────────────────────────────────
  List<Map<String, TextEditingController>> items = [];
  String? _selectedItem;
  List<CylItemListModel> _items = [];
  Map<int, String?> _selectedItems = {};
  String? mobileNo;
  bool isValid = true;
  var argValue;
  List<ItemDetails> itemsToShow = [];
  String? modes;
  int? receiptIds;
  bool saveFlag = false;
  bool stockTransferFlag = false;
  List<GetStockTransferListModel> _stockTransferList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    receiptDateController.text = formattedDate;

    _addNewItem();
    fetchItems();
    checkAndSaveDayEndData();
    fetchTransactionList();
    vehicleNoController.addListener(_updateButtonState);

    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute.of(context)?.settings.arguments as Map?; // ← nullable cast
        vehicleNoController.text = argValue?["vehicleNo"] ?? '';
        modes = argValue?["modeChange"] ?? '';
        receiptIds = argValue?["receiptID"] ?? 0;  // ← also guard this with ?.
        if (argValue != null) {
          final itemsToShow = argValue["itemsToShow"] ?? [];
          if (itemsToShow.isNotEmpty) {
            _initializeItems(itemsToShow);
          } else {
            _initializeItems([]);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    receiptDateController.dispose();
    vehicleNoController.removeListener(_updateButtonState);
    vehicleNoController.dispose();
    for (var item in items) {
      item.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  // ── item management ──────────────────────────────────────────────────────────
  // All logic below is IDENTICAL to the original — only formatting cleaned up.

  void _addNewItem() {
    setState(() {
      int newIndex = items.length;
      items.add({
        'selectItem': TextEditingController(),
        'receivedQty': TextEditingController(),
        'emr': TextEditingController(),
        'invoice': TextEditingController(),
      });
      _selectedItems[newIndex] = '';
    });
  }

  void _initializeItems(List<ItemDetails> itemsToShow) {
    setState(() {
      items.clear();
      _selectedItems.clear();
      for (var i = 0; i < itemsToShow.length; i++) {
        var item = itemsToShow[i];
        items.add({
          'selectItem':
          TextEditingController(text: item.itemName ?? ''),
          'receivedQty': TextEditingController(
              text: item.filledQty?.toString() ?? ''),
          'emr': TextEditingController(
              text: item.eMRQty?.toString() ?? ''),
          'invoice': TextEditingController(
              text: item.invoiceQty?.toString() ?? ''),
        });
        _selectedItems[items.length - 1] = item.itemName ?? '';
      }
      print('Items Count: ${items.length}');
      print('Selected Items: $_selectedItems');
    });
  }

  void _removeItem(int index) {
    setState(() {
      print('Removing item at index: $index');
      print('Selected Items Before: $_selectedItems');
      items[index]['receivedQty']?.dispose();
      items[index]['emr']?.dispose();
      items[index]['invoice']?.dispose();
      items.removeAt(index);
      _selectedItems.remove(index);
      _selectedItems = Map.fromEntries(
        _selectedItems.entries.map((entry) {
          return entry.key > index
              ? MapEntry(entry.key - 1, entry.value)
              : entry;
        }),
      );
      print('Selected Items After: $_selectedItems');
    });
  }

  void _updateButtonState() => setState(() {});

  bool get _isAddNewItemEnabled {
    return _items
        .any((item) => !_selectedItems.values.contains(item.itemName));
  }

  void _updateSum(int index) {
    double receivedQty =
        double.tryParse(items[index]['receivedQty']?.text ?? '') ?? 0;
    double emr =
        double.tryParse(items[index]['emr']?.text ?? '') ?? 0;
    if (receivedQty != 0) {
      if (emr != 0) {
        double totalSum = receivedQty + emr;
        items[index]['invoice']?.text = totalSum.toInt().toString();
      } else {
        items[index]['invoice']?.text = receivedQty.toInt().toString();
      }
    } else {
      if (emr != 0) {
        items[index]['invoice']?.text = emr.toInt().toString();
      } else {
        showFlushBar(context, Constants.atLeastOneQtyRequired);
      }
    }
  }

  // ── API calls (zero changes) ─────────────────────────────────────────────────

  Future<void> _submitData() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? godownId = prefs.getString('godownId');
      String? addedBy = prefs.getString('StaffId');
      String? godownKeeperId = prefs.getString('godownKeeperId');
      String? token = prefs.getString('token');

      if (vehicleNoController.text.isNotEmpty) {
        for (var i = 0; i < items.length; i++) {
          String? invoiceQty = items[i]['invoice']?.text ?? '';
          String? filledQty = items[i]['receivedQty']?.text ?? '';
          String? emrQty = items[i]['emr']?.text ?? '';
          String? selectedItemName = _selectedItems[i];

          if (selectedItemName == null || selectedItemName.isEmpty) {
            showFlushBar(context, Constants.selectValidItemReceipt);
            return;
          }
          if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
            showFlushBar(context, Constants.atLeastOneQtyRequired);
            return;
          }
          if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
              (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
            showFlushBar(context, Constants.atLeastOneQtyRequired);
            return;
          }
        }

        String action;
        int? rId;
        if (modes == "Edit") {
          action = "EDIT";
          rId = receiptIds;
        } else {
          action = "ADD";
          rId = 0;
        }

        Set<int> itemIds = {};
        for (var i = 0; i < items.length; i++) {
          String? selectedItemName = _selectedItems[i];
          CylItemListModel? selectedItem = _items.firstWhere(
                (model) => model.itemName == selectedItemName,
            orElse: () => CylItemListModel(itemId: 0, itemName: ''),
          );
          if (selectedItem.itemId != null && selectedItem.itemId != 0) {
            int itemId = selectedItem.itemId!.toInt();
            if (itemIds.contains(itemId)) {
              showFlushBar(context, Constants.recordExist);
              return;
            }
            itemIds.add(itemId);
          }
        }

        List<Map<String, dynamic>> itemDetails = items.map((item) {
          String? selectedItemName =
          _selectedItems[items.indexOf(item)];
          CylItemListModel? selectedItem = _items.firstWhere(
                (model) => model.itemName == selectedItemName,
            orElse: () => CylItemListModel(itemId: 0, itemName: ''),
          );
          return {
            'ItemId': selectedItem.itemId ?? '',
            'FilledQty': item['receivedQty']?.text ?? '',
            'EMRQty': item['emr']?.text ?? '',
            'InvoiceQty': item['invoice']?.text ?? '',
          };
        }).toList();

        Map<String, dynamic> requestBody = {
          'ReceiptId': rId,
          'DistributorId': distributorId,
          'GodownId': godownId,
          'ReceiptDate': receiptDateController.text,
          'VehicleNo': vehicleNoController.text,
          'GodownKeeperId': godownKeeperId,
          'AddedBy': addedBy,
          'Action': action,
          'ItemDetails': itemDetails,
        };

        String jsonRequestBody = jsonEncode(requestBody);
        debugPrint(jsonRequestBody);

        try {
          final response = await http.post(
            Uri.parse(AppUrl.ItemReceiptAddEdit),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonRequestBody,
          );
          debugPrint('jsonRequestBody: $jsonRequestBody');
          if (response.statusCode == 200) {
            debugPrint('Response: ${response.body}');
            int responseValue =
                int.tryParse(response.body) ?? 0;
            if (responseValue > 0) {
              EasyLoading.showToast(Constants.itemAddedSuccessfully,
                  duration: const Duration(milliseconds: 3000));

              await Future.delayed(const Duration(milliseconds: 1500));

              Navigator.pushReplacementNamed(
                  context,
                  BottomNavigationForGodownKeeper.screenName);
              setState(() {
                vehicleNoController.clear();
                items.forEach((item) {
                  item['receivedQty']?.clear();
                  item['emr']?.clear();
                  item['invoice']?.clear();
                });
                _selectedItems.clear();
              });
            } else if (responseValue == -1) {
              showFlushBar(context, Constants.vehicleNotReturn);
            } else if (responseValue == -2) {
              showFlushBar(
                  context, Constants.itemreceiptDataNotInserted);
            } else {
              showFlushBar(context, Constants.failToInserRecord);
            }
          } else {
            refreshTokens();
            showFlushBar(context, Constants.recordExist);
            throw Exception(Constants.listGettingFail);
          }
        } catch (e) {
          debugPrint('Error: $e');
          showFlushBar(context, Constants.recordExist);
        }
      } else {
        showFlushBar(context, Constants.vehicleValidation);
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  // Future<void> _submitData() async {
  //   // Fetch shared preference values
  //   Constants.isNetworkAvailable =
  //   await InternetConnectionChecker().hasConnection;
  //   if (Constants.isNetworkAvailable) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? distributorId = prefs.getString('DistributorId');
  //     String? godownId = prefs.getString('godownId');
  //     String? addedBy = prefs.getString('StaffId');
  //     String? godownKeeperId = prefs.getString('godownKeeperId');
  //     String? token = prefs.getString('token');
  //
  //     if (vehicleNoController.text.isNotEmpty) {
  //       // if (isValid) {
  //       //   print('Valid vehicle number');
  //
  //       for (var i = 0; i < items.length; i++) {
  //         String? invoiceQty = items[i]['invoice']?.text ?? '';
  //         String? filledQty = items[i]['receivedQty']?.text ?? '';
  //         String? emrQty = items[i]['emr']?.text ?? '';
  //         String? selectedItemName = _selectedItems[i];
  //
  //         // Check if the selected item is valid (not empty)
  //         if (selectedItemName == null || selectedItemName.isEmpty) {
  //           showFlushBar(context, Constants.selectValidItemReceipt);
  //           return; // Stop the submission process
  //         }
  //
  //         // Check if InvoiceQty is empty or zero
  //         if (invoiceQty.isEmpty || double.tryParse(invoiceQty) == 0) {
  //           showFlushBar(context,Constants.atLeastOneQtyRequired);
  //           return; // Stop the submission process
  //         }
  //         if ((filledQty.isEmpty || double.tryParse(filledQty) == 0) &&
  //             (emrQty.isEmpty || double.tryParse(emrQty) == 0)) {
  //           showFlushBar(context, Constants.atLeastOneQtyRequired);
  //           return;
  //         }
  //       }
  //       String action;
  //       int? rId;
  //       if (modes == "Edit") {
  //         action = "EDIT";
  //         rId = receiptIds;
  //       } else {
  //         action = "ADD";
  //         rId = 0;
  //       }
  //       // Check for duplicate items in the list
  //       Set<int> itemIds = {};
  //       for (var i = 0; i < items.length; i++) {
  //         String? selectedItemName = _selectedItems[i];
  //         CylItemListModel? selectedItem = _items.firstWhere(
  //               (model) => model.itemName == selectedItemName,
  //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
  //         );
  //
  //         // Check if the item ID is valid (not null or zero)
  //         if (selectedItem.itemId != null && selectedItem.itemId != 0) {
  //           int itemId = selectedItem.itemId!.toInt(); // Convert num to int
  //           if (itemIds.contains(itemId)) {
  //             showFlushBar(
  //                 context,Constants.recordExist);
  //             return; // Stop the submission process
  //           }
  //           itemIds.add(itemId);
  //         }
  //       }
  //
  //       List<Map<String, dynamic>> itemDetails = items.map((item) {
  //         String? selectedItemName = _selectedItems[items.indexOf(item)];
  //
  //         CylItemListModel? selectedItem = _items.firstWhere(
  //               (model) => model.itemName == selectedItemName,
  //           orElse: () => CylItemListModel(itemId: 0, itemName: ''),
  //         );
  //
  //         return {
  //           'ItemId': selectedItem.itemId ?? '',
  //           'FilledQty': item['receivedQty']?.text ?? '',
  //           'EMRQty': item['emr']?.text ?? '',
  //           'InvoiceQty': item['invoice']?.text ?? '',
  //         };
  //       }).toList();
  //
  //       // Build the full JSON object
  //       Map<String, dynamic> requestBody = {
  //         'ReceiptId': rId,
  //         'DistributorId': distributorId,
  //         'GodownId': godownId,
  //         'ReceiptDate': receiptDateController.text,
  //         'VehicleNo': vehicleNoController.text,
  //         'GodownKeeperId': godownKeeperId,
  //         'AddedBy': addedBy,
  //         'Action': action,
  //         'ItemDetails': itemDetails,
  //       };
  //
  //       String jsonRequestBody = jsonEncode(requestBody);
  //       debugPrint(jsonRequestBody);
  //
  //       try {
  //         final response = await http.post(
  //           Uri.parse(AppUrl.ItemReceiptAddEdit),
  //           headers: {
  //             'Content-Type': 'application/json',
  //             'Authorization': 'Bearer $token',
  //           },
  //           body: jsonRequestBody,
  //         );
  //         debugPrint('jsonRequestBody: ${jsonRequestBody}');
  //         if (response.statusCode == 200) {
  //           debugPrint('Response: ${response.body}');
  //           int responseValue = int.tryParse(response.body) ?? 0;
  //           if (responseValue > 0) {
  //             EasyLoading.showToast(Constants.itemAddedSuccessfully,
  //                 duration: const Duration(milliseconds: 3000));
  //             // Navigator.pushReplacementNamed(context, '/godownDashboard');
  //             Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName);
  //             setState(() {
  //               vehicleNoController.clear();
  //               items.forEach((item) {
  //                 item['receivedQty']?.clear();
  //                 item['emr']?.clear();
  //                 item['invoice']?.clear();
  //               });
  //               _selectedItems.clear();
  //             });
  //           } else if(responseValue == -1) {
  //             showFlushBar(
  //                 context,Constants.vehicleNotReturn);
  //           }else if(responseValue == -2){
  //             showFlushBar(
  //                 context,Constants.itemreceiptDataNotInserted);
  //           }else{
  //             showFlushBar(
  //                 context,Constants.failToInserRecord);
  //           }
  //         } else {
  //           refreshTokens();
  //           showFlushBar(context, Constants.recordExist);
  //           throw Exception(
  //               Constants.listGettingFail);
  //         }
  //       } catch (e) {
  //         debugPrint('Error: $e');
  //         showFlushBar(context, Constants.recordExist);
  //       }
  //       // } else {
  //       //   showFlushBar(context, "Invalid Vehicle Number",
  //       //       'Please Enter a Valid Vehicle Number!');
  //       // }
  //     } else {
  //       showFlushBar(context, Constants.vehicleValidation);
  //     }
  //   } else {
  //     showFlushBar(
  //         context, Constants.connectionMessage);
  //   }
  // }

  Future<void> fetchItems() async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token');
      if (bearerToken == null) {
        throw Exception('Bearer Token Is Missing');
      }
      final response = await http.get(
        Uri.parse(
            '${AppUrl.GetItemMasterList}/$distributorId/1/C'),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      debugPrint(
          "item${AppUrl.GetItemMasterList}/$distributorId/1/C");
      debugPrint("item${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _items = data
              .map((json) => CylItemListModel.fromJson(json))
              .toList();
        });
      } else {
        refreshTokens();
        throw Exception(
            'Unable To Load Data At This Time. Please Try Again');
      }
    } else {
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> refreshTokens() async {
    LoginProvider auth =
    Provider.of<LoginProvider>(context, listen: false);
    try {
      SharedPreferences preferences =
      await SharedPreferences.getInstance();
      mobileNo = preferences.getString('MobileNo').toString();
      final Future<Map<String, dynamic>> respose =
      auth.refreshToken(mobileNo!, context);
      try {
        respose.then((response) {
          EasyLoading.dismiss();
          if (response['status']) {
            debugPrint('RefreshTokenStatus - True');
            fetchItems();
          } else if (response['message'] == "UnSuccessful") {
            debugPrint('RefreshTokenExc401 - true');
            checkAndSaveDayEndData();
            fetchTransactionList();
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
        String message =
            "Your Session Is Expire. Click Ok To Login Again.";
        String btnLabel = "Ok";
        return Platform.isIOS
            ? WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text(btnLabel),
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

  Future<void> checkAndSaveDayEndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    int? distributorIds = int.parse(distributorId!);
    try {
      final response = await http.get(
        Uri.parse(
            '${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
      );
      debugPrint(
          "Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint(
          "requesr bodyCheckDayEndConfirmation: ${response.request}");
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
        refreshTokens();
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      refreshTokens();
      print("Exception: $e");
    }
  }

  Future<void> fetchTransactionList() async {
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
      debugPrint("GetStockTransferDtls" +
          '${AppUrl.GetStockTransferDtls}/$distributorId/1/2');
      debugPrint("GetStockTransferDtls" + response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _stockTransferList = data
              .map((json) =>
              GetStockTransferListModel.fromJson(json))
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
      } else {
        refreshTokens();
        isLoading = false;
        throw Exception('Failed To Load Items');
      }
    } else {
      refreshTokens();
      isLoading = false;
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  // ── BUILD ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(
          context,
          BottomNavigationForGodownKeeper.screenName,
          arguments: "onBack",
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.bg2,
        // appBar: CustomAppBar(title: 'Item Receipt'),
        // appBar: CustomGKAppBar(title: 'Item Receipt',
        // backScreen: BottomNavigationForGodownKeeper(),),
        appBar: CustomGKAppBar(
          title: 'Item Receipt',
        ),
        body: Column(
          children: [
            // ── Gradient header (from widgets.dart) ─────────────
            // AppGradientHeader(
            //   title: 'Item Receipt',
            //   subtitle: 'Record incoming stock from vehicle',
            //   icon: Icons.receipt_long_rounded,
            //   onBack: () => Navigator.pushReplacementNamed(
            //     context,
            //     BottomNavigationForGodownKeeper.screenName,
            //     arguments: "onBack",
            //   ),
            // ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                children: [
                  // ── Receipt Details ──────────────────────────────
                  // AppSectionLabel lives in widgets.dart
                  const AppSectionLabel(label: 'Receipt Details'),
                  const SizedBox(height: 8),
                  _ReceiptDetailsCard(
                    receiptDateController: receiptDateController,
                    vehicleNoController: vehicleNoController,
                  ),
                  const SizedBox(height: 20),

                  // ── Items section header ─────────────────────────
                  // AppSectionHeader + AppAddItemButton live in widgets.dart

                  AppSectionHeader(
                    label: 'Items',
                    dotColor: AppColors.teal,
                    trailingButton: AppAddItemButton(
                      isEnabled: _isAddNewItemEnabled,
                      onTap: _addNewItem,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Dynamic item cards ───────────────────────────
                  ...List.generate(items.length, (index) {
                    return _ItemEntryCard(
                      index: index,
                      items: items,
                      selectedItems: _selectedItems,
                      availableItems: _items,
                      onRemove: () => _removeItem(index),
                      onItemSelected: (value) {
                        setState(() {
                          _selectedItems[index] = value ?? '';
                        });
                      },
                      onQtyChanged: (_) => _updateSum(index),
                    );
                  }),

                  const SizedBox(height: 8),

                  // ── Submit button ────────────────────────────────
                  // AppGradientSubmitButton lives in widgets.dart
                  AppGradientSubmitButton(
                    label: 'Submit Receipt',
                    isActive: !saveFlag &&
                        stockTransferFlag &&
                        vehicleNoController.text.isNotEmpty,
                    onPressed:

                    //     () {
                    //   if (saveFlag) {
                    //     showFlushBar(
                    //         context, Constants.dayEndCompleted);
                    //   } else {
                    //     if (stockTransferFlag) {
                    //       if (vehicleNoController.text.isNotEmpty) {
                    //         setState(() {
                    //           _submitData();
                    //         });
                    //       } else {
                    //         print('Invalid vehicle number');
                    //       }
                    //     } else {
                    //       CustomAlertDialog.showCustomAlert(
                    //           context, Constants.stockNotAccepted);
                    //     }
                    //   }
                    // },

                        () {
                      if(saveFlag){
                        print('saveFlag $saveFlag');
                        showFlushBar(context,
                            Constants.dayEndCompleted);
                      }else{
                        if(stockTransferFlag){
                          if (vehicleNoController.text.isNotEmpty) {
                            setState(() {
                              _submitData();
                            });
                          } else {
                            print('Invalid vehicle number');
                          }
                        }else{
                          CustomAlertDialog.showCustomAlert(context,Constants.stockNotAccepted);
                        }
                      }

                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// FILE-LOCAL COMPOSITE WIDGETS
//
// These two widgets are specific enough to ItemReceiptScreen that they stay
// here.  They compose the shared primitives from widgets.dart instead of
// duplicating any decoration code.
// =============================================================================

/// White card holding the Receipt Date (read-only) and Vehicle No. fields.
class _ReceiptDetailsCard extends StatelessWidget {
  const _ReceiptDetailsCard({
    required this.receiptDateController,
    required this.vehicleNoController,
  });

  final TextEditingController receiptDateController;
  final TextEditingController vehicleNoController;

  @override
  Widget build(BuildContext context) {
    // AppDashCard and AppStyledField both come from widgets.dart
    return AppDashCard(
      child: Row(
        children: [
          Expanded(
            child: AppStyledField(
              label: 'Receipt Date',
              controller: receiptDateController,
              enabled: false,
              keyboardType: TextInputType.datetime,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppStyledField(
              label: 'Vehicle No. *',
              controller: vehicleNoController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [LengthLimitingTextInputFormatter(11),
                // Allow only A-Z, a-z, 0-9, space and hyphen
                FilteringTextInputFormatter.allow(
                  RegExp(r'[A-Za-z0-9\s-]'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card for one item row: badge + remove button + dropdown + qty fields.
class _ItemEntryCard extends StatelessWidget {
  const _ItemEntryCard({
    required this.index,
    required this.items,
    required this.selectedItems,
    required this.availableItems,
    required this.onRemove,
    required this.onItemSelected,
    required this.onQtyChanged,
  });

  final int index;
  final List<Map<String, TextEditingController>> items;
  final Map<int, String?> selectedItems;
  final List<CylItemListModel> availableItems;
  final VoidCallback onRemove;
  final ValueChanged<String?> onItemSelected;
  final ValueChanged<String> onQtyChanged;

  /// Returns names not yet picked by another row (or the current row's own pick).
  List<String> _filteredNames() {
    return availableItems
        .where((item) =>
    !selectedItems.values.contains(item.itemName) ||
        selectedItems[index] == item.itemName)
        .toSet()
        .map((item) => item.itemName ?? 'Unknown')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // AppDashCard, AppItemBadge, AppRemoveButton, AppItemDropdown,
    // AppStyledField — all from widgets.dart
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppDashCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Badge + remove ───────────────────────────────────
            Row(
              children: [
                AppItemBadge(label: 'Item ${index + 1}'),
                const Spacer(),
                if (items.length > 1)
                  AppRemoveButton(onTap: onRemove),
              ],
            ),
            const SizedBox(height: 12),

            // ── Item dropdown ────────────────────────────────────
            AppItemDropdown(
              label: 'Select Item',
              items: _filteredNames(),
              value: selectedItems[index],
              onChanged: onItemSelected,
              isRequired: true,
              prefixIcon: Icons.inventory_2_rounded,
            ),
            const SizedBox(height: 12),

            // ── Qty fields ───────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: AppStyledField(
                    label: 'Filled',
                    controller: items[index]['receivedQty']!,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    onChanged: onQtyChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppStyledField(
                    label: 'EMR',
                    controller: items[index]['emr']!,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    onChanged: onQtyChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppStyledField(
                    label: 'Invoice *',
                    controller: items[index]['invoice']!,
                    keyboardType: TextInputType.number,
                    enabled: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class _ItemReceiptHeader extends StatelessWidget {
  const _ItemReceiptHeader({required this.onBack, this.mode});
  final VoidCallback onBack;
  final String? mode;

  @override
  Widget build(BuildContext context) {
    final bool isEdit = mode == 'Edit';
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradHero),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 20, 18),
          child: Row(
            children: [
              // Back chevron
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                tooltip: 'Back',
              ),
              // Icon badge
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.25), width: 1),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEdit ? 'Edit Item Receipt' : 'Item Receipt',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isEdit
                          ? 'Update existing receipt details'
                          : 'Record incoming stock from vehicle',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

