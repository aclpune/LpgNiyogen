import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/CustomAppBar.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../BottomNavigationForGodownKeeper.dart';
import '../DeliveryBoyModel/GetDefectiveStockListModel.dart';
import '../ItemReceipt/CylItemList/CylItemListModel.dart';
import 'package:http/http.dart' as http;

import 'MarkDefectiveItemUI.dart';

class MarkDefectiveItemScreen extends StatefulWidget {
  static const screenName = '/markDefectiveItemScreen';

  const MarkDefectiveItemScreen({super.key});

  @override
  State<MarkDefectiveItemScreen> createState() =>
      _MarkDefectiveItemScreenState();
}

class _MarkDefectiveItemScreenState extends State<MarkDefectiveItemScreen> {
  String? formattedDate;
  CylItemListModel? _selectedItemModel;
  List<CylItemListModel> _items = [];
  String? _selectedItem;
  int? selectedItemId;
  final TextEditingController _defectiveController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  List<GetDefectiveStockListModel> _defectiveStockList = [];
  bool saveFlag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    _dateController.text = formattedDate!;
    fetchItems();
    _fetchDefectiveData();
    checkAndSaveDayEndData();
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;

    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        if (argLRAdd == "fromDrawer") {
          // Navigator.pushReplacementNamed(context, '/godownDashboard');
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName);
          return false;
        } else {
          // Navigator.pushReplacementNamed(context, '/godownDashboard');
          Navigator.pushReplacementNamed(
              context, BottomNavigationForGodownKeeper.screenName);
          return false;
        } // In case `null` is returned, return `false`
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Mark Defective', // Title or hint text for the text field
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Date
                    // itemSubLine("Date",formattedDate!),
                    Row(
                      children: [
                        Expanded(child: textWidgetBlueColorWithoutStar("Date")),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _dateController,
                            decoration:
                                buildInputBorderUpdateStatus(" ", context),
                            style: Styling.textFormText,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(250),
                              // Allow only digits
                            ],
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    // Divider(),
                    Row(
                      children: [
                        Expanded(
                            child: textWidgetBlueColorWithStar(
                                "Select Item", "*")),
                        Flexible(
                          flex: 1,
                          child: DropdownButtonFormField<CylItemListModel>(
                            decoration: buildInputBorderUpdateStatus(
                                "Select Item", context),
                            value: _selectedItemModel,
                            // Bind the value to the selected item model
                            items: _items.map((CylItemListModel item) {
                              return DropdownMenuItem<CylItemListModel>(
                                value: item,
                                child: Text(
                                  item.itemName ?? 'Unknown',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal),
                                ),
                              );
                            }).toList(),
                            onChanged: (CylItemListModel? selectedItem) {
                              if (selectedItem != null) {
                                setState(() {
                                  _selectedItem = selectedItem.itemName;
                                  selectedItemId = selectedItem.itemId!.toInt();

                                  // Update the selectedItemModel when the selection changes
                                  _selectedItemModel = selectedItem;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: textWidgetBlueColorWithStar(
                                "Defective Count", "*")),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _defectiveController,
                            decoration: buildInputBorderUpdateStatus(
                                "Enter Defective Count", context),
                            style: Styling.textFormText,
                            keyboardType: TextInputType.number,
                            // Set keyboard type to numeric
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                              // Allow only digits
                            ],
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: textWidgetBlueColorWithoutStar("Remark")),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _remarkController,
                            decoration: buildInputBorderUpdateStatus(
                                "Enter Remark", context),
                            style: Styling.textFormText,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(250),
                              // Allow only digits
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        // Add 10px margin on left and right
                        child: ElevatedButton(
                          onPressed: () {
                            if (saveFlag) {
                              print('saveFlag $saveFlag');
                              showFlushBar(context, Constants.dayEndCompleted);
                            } else {
                              if (_defectiveController.text.isNotEmpty) {
                                int defctiveQty =
                                int.parse(_defectiveController.text);
                                if (_defectiveController.text.isNotEmpty) {
                                  if (_selectedItem != null) {
                                    if (defctiveQty > 0) {
                                      submitDefectiveToApi();
                                    } else {
                                      showFlushBar(
                                          context, Constants.validCountEnter);
                                    }
                                  } else {
                                    showFlushBar(context,
                                        Constants.selectValidItemReceipt);
                                  }
                                } else {
                                  showFlushBar(
                                      context, Constants.validCountEnter);
                                }
                              } else {
                                showFlushBar(context, Constants.validCountEnter);
                              }
                            }

                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25, top: 12, bottom: 12),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ), // Set text color directly if needed
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              // Optional: Set rounded corners
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Defective List",
                          style: Styling.bodyTitleBig,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text("Date",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff1280b3),
                                          fontFamily: 'OpenSans',
                                        )),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text("Item",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff1280b3),
                                            fontFamily: 'OpenSans')),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: Text("Defective",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff1280b3),
                                              fontFamily: 'OpenSans')))),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text("Action",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff1280b3),
                                              fontFamily: 'OpenSans')))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Color(0xff1280b3)),
                    Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: _defectiveStockList.length,
                            itemBuilder: (context, index) {
                              return MarkdefectiveItemUI(
                                  _defectiveStockList[index]);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Fetch data from API Item
  Future<void> fetchItems() async {
    EasyLoading.show();
    Constants.isNetworkAvailable =
        await InternetConnectionChecker().hasConnection;
    if (Constants.isNetworkAvailable) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken =
          prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetItemMasterList}/$distributorId/1/C'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );
      debugPrint("GetItemMasterList" +
          '${AppUrl.GetItemMasterList}/$distributorId/1/C');
      debugPrint("GetItemMasterList" + response.body);
      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _items = data.map((json) => CylItemListModel.fromJson(json)).toList();
          _items = _items
              .where(
                  (item) => !item.itemName!.toLowerCase().contains('regulator'))
              .toList();

          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        throw Exception('Failed To Load Items');
      }
    } else {
      EasyLoading.dismiss();
      showFlushBar(context, Constants.connectionMessage);
    }
  }

  Future<void> submitDefectiveToApi() async {
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
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);

    // Add checks for empty or invalid inputs
    int defectiveC = 0;

    try {
      defectiveC = int.tryParse(_defectiveController.text) ?? 0;
    } catch (e) {
      // Handle any error parsing the quantities
      print("Error parsing quantities: $e");
      EasyLoading.showToast("Invalid input for quantities");
      return; // Early exit to prevent the API call with invalid values
    }

    String remarks = _remarkController.text;

    Map<String, dynamic> requestBody = {
      "DefId": 0,
      "DistributorId": dId,
      "DefDate": formattedDate,
      "GodownId": gId,
      "ItemId": selectedItemId,
      "DefQty": defectiveC,
      "Remark": remarks,
      "Action": "ADD",
      "AddedBy": addedBy
    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.DefectiveMasterAdd_Mob}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody), // Encode the request body as JSON
      );

      // Print the raw response for debugging
      print(
          "API Response Status Code DefectiveMasterAdd_Mob: ${response.statusCode}");
      print("API Response Body DefectiveMasterAdd_Mob: ${response.body}");
      print(
          "API Response request DefectiveMasterAdd_Mob: ${response.request} ${requestBody}");

      if (response.statusCode == 200) {
        // Handle success
        print("DefectiveMasterAdd_Mob quantity added successfully!");
        EasyLoading.showToast(Constants.dataUpdated,
            duration: const Duration(milliseconds: 3000));
        _defectiveController.clear();
        _remarkController.clear();
        _selectedItem = null;
        selectedItemId = null;
        _selectedItem = null;
        _selectedItemModel = null;
        _fetchDefectiveData();
      } else {
        // Handle error response
        print("Failed to add imbalance quantity: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred: $e");
    }
  }

  Future<void> _fetchDefectiveData() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? godownId = prefs.getString('godownId');
    String? addedBy = prefs.getString('StaffId');
    String? godownKeeperId = prefs.getString('godownKeeperId');
    String? token = prefs.getString('token');
    int dId = int.parse(distributorId!);
    int gId = int.parse(godownId!); // This is your bearer token
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(now); // Format selectedDate
    // String formattedDate = "2025-03-20"; // Format selectedDate

    try {
      final response = await http.post(
        Uri.parse(AppUrl.GetDefectiveList_Mob),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Adding token to the Authorization header
        },
        body: jsonEncode({
          "DistributorId": dId,
          "DefDate": formattedDate,
          "GodownId": gId,
        }),
      );

      debugPrint(
          'jsonRequestBodyGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.request}');
      debugPrint(
          'responseGetDsrIncomeReportListForMobGetDefectiveList_Mob: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _defectiveStockList = data
              .map((json) => GetDefectiveStockListModel.fromJson(json))
              .toList();
          EasyLoading.dismiss();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
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
