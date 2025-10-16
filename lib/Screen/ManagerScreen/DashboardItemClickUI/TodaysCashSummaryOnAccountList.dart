import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DashboardItemClickUI/OnAccountPopupScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../BootomNavigatinBarManager.dart';
import '../ClickModelClass/GetDashboardPostpaidVarifiPendCntLstForMobListModel.dart';
import '../ClickModelClass/TodaysCashSummaryOnAccountListModel.dart';
import 'package:http/http.dart' as http;

import '../ManagerDashboard.dart';
import '../ManagerModelClass/GetStaffLedgerReportModelList.dart';
import '../SVSaleModel/GetStaffDetailsListModel.dart';
enum BalanceType { totalBalance, advance, onAccount }

class TodaysCashSummaryOnAccountList extends StatefulWidget {
  static const screenName = '/todaysCashSummaryOnAccountList';
  const TodaysCashSummaryOnAccountList({super.key});

  @override
  State<TodaysCashSummaryOnAccountList> createState() => _TodaysCashSummaryOnAccountListState();
}

class _TodaysCashSummaryOnAccountListState extends State<TodaysCashSummaryOnAccountList> {
  late List<TodaysCashSummaryOnAccountListModel> onAccountList = [];
  bool isLoading = true;
  List<GetStaffDetailsListModel> staffdetailsmodel = [];
  List<GetStaffLedgerReportModelList> lederReportModel = [];
  GetStaffDetailsListModel? selectedStaff;
  int? selectedReferredID;
  String? selectedReferredName;
  bool isPaymentButtonEnabled = false;
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  var argValue;
  double? onAccountAmount;
  bool saveFlag = false;
  bool isChecked = false;
  List<bool> isCheckedList = [];
  double onAccountAsOfDate =0.00;
  double totalAmt = 0.0;
  double totalBalance = 0.0;
  int cashsummary = 0;
  BalanceType? _selectedBalanceType = BalanceType.onAccount;
  String? modes;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndSaveDayEndData();
    //fetchOnAccountList();
    getStaffDetailsList();
    getStaffLedgerReportList(0);
    _updateTotalBalance();
    isCheckedList =
    List<bool>.filled(lederReportModel.length, false, growable: true);

    Future.delayed(Duration.zero, () async {
      final argValue = ModalRoute.of(context)?.settings.arguments as Map?;

      // Extract the updated staff details
      final String staffId = argValue?["staffId"] ?? '';
      final String staffNameEdit = argValue?["staffName"] ?? '';

      // Log the staff data for debugging
      debugPrint("Updated staffId: $staffId, updated staffName: $staffNameEdit");

      if (staffId.isNotEmpty && staffNameEdit.isNotEmpty) {
        // Fetch the staff details based on the updated data
        await getStaffDetailsList(); // Only call once
        await getStaffDetailsList();

        setState(() {
          // Find the updated staff details in the staff list
          selectedStaff = staffdetailsmodel.firstWhere(
                (item) => item.staffName == staffNameEdit,
            orElse: () => GetStaffDetailsListModel(staffName: ''), // Default if not found
          );

          // Update the UI with the latest staff data
          selectedReferredID = int.tryParse(staffId) ?? 0;
          selectedReferredName = staffNameEdit;
          getStaffLedgerReportList(selectedReferredID!);

        });
        _updateTotalBalance();
        //debugPrint("staff count: $cashsummary");
        debugPrint("selected staff: $selectedReferredID");
        debugPrint("Updated referredByNameEdit: $staffId, selectedReferredName: $staffNameEdit");
      }
    });
  }

  void _updateTotalBalance() {
    // Get the filtered list of reports based on selected staff
    var filteredReports = selectedStaff == null
        ? lederReportModel
        : lederReportModel.where((report) => report.staffId == selectedStaff?.staffId).toList();

    // Calculate the total balance for the filtered reports
    totalBalance = filteredReports.fold(0.0, (sum, report) => sum + (report.balance ?? 0.0));

    // You can print the totalBalance for debugging
    print("Total Balance: $totalBalance");
  }

  String nullToDash(String? value) {
    if (value == null || value.toLowerCase() == "null") {
      return "-";
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {

   // cashsummary = lederReportModel.length;
    if (lederReportModel != null && lederReportModel.isNotEmpty) {
      cashsummary = selectedReferredID == null
          ? lederReportModel.length  // Total count if staffId is null
          : lederReportModel.where((report) => report.staffId == selectedReferredID).length;
    } else {
      cashsummary = 0; // No reports
    }
    var filteredReports = selectedStaff == null
        ? lederReportModel
        : lederReportModel.where((report) => report.staffId == selectedStaff?.staffId).toList();
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return
      WillPopScope(
        onWillPop: () async {
      // Show a confirmation dialog
      if (argLRAdd == "fromDrawer") {
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        return false;
      } else {
        Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
        return false;
      } // In case `null` is returned, return `false`
    },
    child:
    Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Color(0xFFECEFFF),
        backgroundColor: Color(0xFFECEFFF),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pushNamed(context, BottomNavBarExample.screenName);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Staff Ledger',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                              Text(
                                'Count: $cashsummary',
                                style: TextStyle(fontSize: 12, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  countTextWidgetTextStarWithBlue(
                      context, 'Staff Name', showAsterisk: true),
                  const SizedBox(width: 10),
                  Expanded(
                    child:
                    DropdownButtonFormField<
                                GetStaffDetailsListModel>(
                              key: formKey1,
                              //value: selectedStaff,
                              value: staffdetailsmodel.contains(selectedStaff)
                                  ? selectedStaff
                                  : null,
                              items: [
                                DropdownMenuItem<GetStaffDetailsListModel>(
                                  value: null, // null indicates "All"
                                  child: Text('All'),
                                ),
                                ...staffdetailsmodel.map((staff) {
                                  return DropdownMenuItem<
                                      GetStaffDetailsListModel>(
                                    value: staff,
                                    child: Text(staff.staffName ?? ''),
                                  );
                                }).toList(),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedStaff = value;
                                  if (value == null) {
                                    getStaffLedgerReportList(0);
                                    selectedReferredID = null;
                                    selectedReferredName = null;
                                  } else {
                                    selectedReferredID =
                                        value?.staffId?.toInt();
                                    selectedReferredName = value?.staffName;
                                    getStaffLedgerReportList(selectedReferredID!);
                                  }

                                  // Reset the checkbox list when a new staff is selected
                                  isCheckedList
                                      .clear(); // Clear previous selections

                                  // If the new staff is selected, reinitialize the checkbox states
                                  var filteredReports = selectedStaff == null
                                      ? lederReportModel
                                      : lederReportModel
                                          .where((report) =>
                                              report.staffId ==
                                              selectedStaff?.staffId)
                                          .toList();

                                  // Reinitialize the isCheckedList with the correct size based on the filtered reports
                                  //where i reflect i want to refresh the data of that screen without initalize the data
                                  isCheckedList = List<bool>.generate(
                                      filteredReports.length, (index) => false);

                                  // Dynamically calculate the sum when a staff is selected
                                  _updateTotalBalance();

                                });
                              },
                              isExpanded: true,
                              hint: const Text('All'),
                            ),
                          ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Radio<BalanceType>(
                      value: BalanceType.totalBalance,
                      groupValue: _selectedBalanceType,
                      onChanged: null, // Disabled
                    ),
                    Column(
                      children: [
                        Text('Total Balance',
                          style: TextStyle(fontSize: 12),),
                        Text(
                          '0.00',
                          style: Styling.itemBlackTestVerySmallBoldOne,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<BalanceType>(
                      value: BalanceType.advance,
                      groupValue: _selectedBalanceType,
                      onChanged: null, // Disabled
                    ),
                    Column(
                      children: [
                        Text('Advance',
                          style: TextStyle(fontSize: 12),),
                        Text(
                          '0.00',
                          style: Styling.itemBlackTestVerySmallBoldOne,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio<BalanceType>(
                      value: BalanceType.onAccount,
                      groupValue: _selectedBalanceType,
                      onChanged: (BalanceType? value) {
                        setState(() {
                          _selectedBalanceType = value;
                        });
                      },
                    ),
                    Column(
                      children: [
                        Text('On Account',
                            style: TextStyle(fontSize: 12),),
                        Text(
                          '${formatCurrency(totalBalance)}',
                          style: Styling.itemBlackTestVerySmallBoldOne,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
             // Ledger Report List with Checkboxes
              Card(
                child: isLoading
                    ? Center(child: CircularProgressIndicator()) // Show loader when isLoading is true
                    : (selectedStaff == null
                    ? lederReportModel.isEmpty
                    : lederReportModel.where((report) => report.staffId == selectedStaff?.staffId).isEmpty)
                    ? Center(child: Text('No Records Found'))
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: (selectedStaff == null)
                      ? lederReportModel.length
                      : lederReportModel.where((report) => report.staffId == selectedStaff?.staffId).length,
                  itemBuilder: (context, index) {
                    var filteredReports = selectedStaff == null
                        ? lederReportModel
                        : lederReportModel.where((report) => report.staffId == selectedStaff?.staffId).toList();

                    GetStaffLedgerReportModelList? payList = filteredReports[index];

                    bool isStaffSelected = selectedStaff?.staffId == payList.staffId;

                    // Ensure `isCheckedList` length matches the filtered list
                    if (isCheckedList.length <= index) {
                      isCheckedList.add(false);
                    }

                    return
                      Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(child: Text(payList.description ?? '', style: TextStyle(color: Colors.blue))),
                            Expanded(child: Text(payList.staffName ?? '', style: TextStyle(color: Colors.blue))),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(flex: 1, child: countTextWidgetTextOnAccount(
                                context,
                                "Date",
                                payList.transDate != null
                                    ? DateFormat('dd-MM-yyyy').format(DateTime.parse(payList.transDate!))
                                    : ''
                            )),
                            Expanded(
                              flex: 1,
                              child: CheckboxListTile(
                                value: isCheckedList[index],
                                onChanged: (bool? value) {
                                  if (selectedReferredID == null) {
                                    EasyLoading.showToast(
                                      Constants.OnAccErr,
                                      duration: const Duration(milliseconds: 3000),
                                    );
                                    return;
                                  }
                                  setState(() {
                                    isCheckedList[index] = value ?? false;
                                    isPaymentButtonEnabled = isCheckedList.contains(true);
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  return states.contains(MaterialState.selected)
                                      ? Colors.pink
                                      : Colors.white;
                                }),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(flex: 1, child: countTextWidgetTextOnAccount(context, "Debit", formatCurrency(payList.debitAmt?.toDouble() ?? 0.0),)),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(flex: 1, child: countTextWidgetTextOnAccount(context, "Credit", formatCurrency(payList.creditAmt?.toDouble() ?? 0.0),)),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(flex: 1, child: countTextWidgetTextOnAccount(context, "Balance", formatCurrency(payList.balance?.toDouble() ?? 0.0),)),
                          ],
                        ),
                        Divider(color: Colors.white70, thickness: 3),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                //  Payment Button
                  //here when i select more than one staff i want to share list of ledger id of that respective selected staffs
                  ElevatedButton(
                    onPressed: isPaymentButtonEnabled
                        ? () {
                      // List to store selected ledgerIds
                      var selectedLedgerIds = [];
                      totalAmt = 0.0;  // Variable to store the sum of balances

                      // Loop through filteredReports to collect selected reports and their respective ledgerIds
                      for (int i = 0; i < filteredReports.length; i++) {
                        if (isCheckedList[i]) {
                          selectedLedgerIds.add(filteredReports[i].ledgerId.toString());  // Collect ledgerId
                          totalAmt += filteredReports[i].balance ?? 0.0;  // Add balance to total
                        }
                      }

                      print('Total Selected Amount: $totalAmt');
                      print('Selected Ledger IDs: $selectedLedgerIds'); // Print the selected ledger IDs

                      setState(() {
                        // Create other necessary details for the first selected report or a summary one
                        var firstSelectedReport = filteredReports.firstWhere((report) => isCheckedList[filteredReports.indexOf(report)]);

                        var ledgerId = firstSelectedReport.ledgerId.toString(); // You can select the first one for display purpose
                        var receiptDate = firstSelectedReport.transDate.toString();
                        var category = firstSelectedReport.description.toString();
                        var staffId = firstSelectedReport.staffId.toString();
                        var staffName = firstSelectedReport.staffName.toString();
                        var balance = firstSelectedReport.balance.toString();

                        // Navigate and pass the selected ledgerIds list and other necessary arguments
                        Navigator.pushNamed(
                          context,
                          OnAccountPopupScreen.screenName,
                          arguments: {
                            'ledgerIds': selectedLedgerIds,  // Pass the list of selected ledgerIds
                            'receiptDate': receiptDate,
                            'category': category,
                            'staffId': staffId,
                            'staffName': staffName,
                            'balance': balance,
                            'totalBalance': totalAmt.toString(),
                          },
                        );
                        print('Add Payment Clicked $selectedLedgerIds');
                      });
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPaymentButtonEnabled ? Colors.blue : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      'Payment',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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

  Future<void> getStaffDetailsList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? staffStatus = prefs.getString('StaffStatus');
    String? designation = prefs.getString('Designation');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    //String formattedDate = DateFormat('yyyy-MM-dd').format(date! as DateTime);
    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }

    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
      "StaffStatus": staffStatus,
      "Designation": designation,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetStaffDetailsList}/$distributorId/1/0'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetStaffDetailsList : " +
        '${AppUrl.GetStaffDetailsList}/$distributorId/1/0');
    debugPrint("GetStaffDetailsList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        staffdetailsmodel = data.map((json) {
          return GetStaffDetailsListModel.fromJson(json);
        }).toList();

        // 🔤 Sort alphabetically by a string field like "staffName"
        staffdetailsmodel.sort((a, b) {
          final nameA = a.staffName ?? '';
          final nameB = b.staffName ?? '';
          return nameA.toLowerCase().compareTo(nameB.toLowerCase());
        });

        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  Future<void> getStaffLedgerReportList(int staffId) async {
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

    if (!Constants.isNetworkAvailable) {
      // Return an empty list if there is no network connection
      showFlushBar(context, Constants.connectionMessage);
      isLoading = false;
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? distributorId = prefs.getString('DistributorId');
        String? bearerToken = prefs.getString('token');
        String? userId = prefs.getString("UserId");
        String? addedBy = prefs.getString('StaffId');


        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        Map<String, dynamic> requestBody = {
          "DistributorId": distributorId,
          "StaffId": staffId,
          "Flag":"OnAccount"
        };

        final response = await http.post(
          Uri.parse('${AppUrl.GetStaffLedgerReportMob_V1}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body GetCashHandOverDtls: ${response.body}");
        debugPrint("Request body GetCashHandOverDtls: ${response.request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
             lederReportModel = data.map((jsonItem) =>
             GetStaffLedgerReportModelList.fromJson(jsonItem)).toList();
             _updateTotalBalance();
            isLoading = false;
          });
        } else {
          isLoading = false;
          throw Exception('Failed to load sales data');
        }
      } catch (error) {
        isLoading = false;
        debugPrint("Error: $error");
        // Return an empty list in case of an error
      }
    }
  }

  Future<void> checkAndSaveDayEndData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? StaffId = prefs.getString('StaffId');
    int? staffIds = int.parse(StaffId!);
    int? distributorIds = int.parse(distributorId!);
    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse('${AppUrl.CheckDayEndConfirmation}/$distributorIds'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken", // Pass bearer token in headers
        },
      );
      debugPrint("Response bodyCheckDayEndConfirmation: ${response.body}");
      debugPrint("requesr bodyCheckDayEndConfirmation: ${response.request}");
      if (response.statusCode == 200) {
        // Parse the API response
        List<dynamic> apiResponse = json.decode(response.body);

        // Check if the response list is empty
        if (apiResponse.isEmpty) {
          // If the list is empty, do not save
          saveFlag = false;
          print("The list is empty, no data to save.");
        } else {
          // If there is data in the response, process it and save
          var dayEndData = apiResponse[0]; // Access the first item in the list (assuming it's an object)

          // You can validate the fields in the response as needed
          int DSRSaved = dayEndData['DSRSaved'] ?? 0;
          int CDCMSStkSaved = dayEndData['CDCMSStkSaved'] ?? 0;
          int OpClSaved = dayEndData['OpClSaved'] ?? 0;

          // Check if all required fields are saved
          if (DSRSaved == 1 && CDCMSStkSaved == 1 && OpClSaved == 1) {
            saveFlag = true;
            // If the conditions are met, set the flag and save the data
            print("Data is valid, proceeding to save.");
          } else {
            // If any condition is not met, print a message
            print("Data is incomplete. Cannot proceed to save.");
          }
        }
      } else {
        // Handle API error
        print("Error: ${response.statusCode}");
      }
    }
    catch (e) {
      // Exception handling
      print("Exception: $e");
    }
  }

  String formatCurrency(double amount) {
    if (amount == 0) {
      return '0.00'; // Return "0.00" if the amount is zero
    }
    final format = NumberFormat('#,##,###.00', 'en_IN'); // Indian locale with comma separator

    // Ensure the result always shows a leading zero before the decimal point
    String formattedAmount = format.format(amount);

    // If there's no integer part, it ensures that a leading zero is added before decimal
    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0' + formattedAmount;
    }
    return formattedAmount;
  }
}
