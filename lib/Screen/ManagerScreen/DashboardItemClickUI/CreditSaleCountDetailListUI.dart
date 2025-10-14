import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/Styling.dart';
import '../../Utils/Widget.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../BootomNavigatinBarManager.dart';
import '../ClickModelClass/GetCreditSaleLedgerDtlsListModel.dart';
import '../ClickModelClass/GetTopFiveCreditorsModel.dart';
import '../PaymentReceiptScreen/GetCustomerListModel.dart';


class CreditSaleCountDetailListUI extends StatefulWidget {
  static const screenName = '/creditSaleCountDetailListUI';
  @override
  State<StatefulWidget> createState() {
    return _CreditSaleCountDetailListUI();
  }
}

class _CreditSaleCountDetailListUI extends State<CreditSaleCountDetailListUI>{
  String? formattedDate;
  bool isLoading = true;
  List<GetCreditSaleLedgerDtlsListModel> _items = [];
  List<GetTopFiveCreditorsModel> _topFiveItems = [];
  List<GetCreditSaleLedgerDtlsListModel> displayList = [];
  List<GetTopFiveCreditorsModel> topFivedisplayList = [];
  List<GetCustomerListModel> customerModel = [];
  GetCustomerListModel? _selectedItemModel;
  final GetCustomerListModel allItem = GetCustomerListModel(customerId: -1, customerName: "ALL");
  final top5Item = GetCustomerListModel(customerId: -2, customerName: 'Top 5');
  final oldestItem = GetCustomerListModel(customerId: -3, customerName: 'Oldest');
  String? _selectedItem;
  int? selectedItemId;
  double? totalOutstandingAmount;
  double? totalOutstandingAmountForFive;
  bool isChecked = false;
  bool isTextEntered = false;
  String? errorMessage;
  late List<String> selectedConsumerNos;
  bool isCheckboxEnabled = true; // Default to true, enabling checkboxes
  List<TextEditingController> _consumerNoControllers = [];
  List<bool> isCheckedList = [];
  List<bool> isTextEnteredList = [];
  //String label = '';
  @override
  void dispose() {
    // Dispose of each controller when the widget is disposed
    for (var controller in _consumerNoControllers) {
      controller.dispose();
    }
    super.dispose();  // Don't forget to call the superclass's dispose method
  }
  void addItem() {
    setState(() {

      _consumerNoControllers.add(TextEditingController());

      isCheckedList.add(false);  // Default state for checkbox
      isTextEnteredList.add(false);  // Default state for text entered
    });
  }


  @override
  void initState() {
    super.initState();
    _selectedItemModel = allItem;
    getCreditSaleLedgerDtls(0);
    getTopFiveCreditors(0);
    getCustomerList();
    DateTime now = DateTime.now().toUtc();
    formattedDate = now.toIso8601String();
    addItem();
  }
  String nullToDash(String? value) {
    if (value == null || value.toLowerCase() == "null") {
      return "-";  // If value is null or the string "null", replace with '-'
    }
    return value;  // If not null or "null", return the original value
  }

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;

    String formattedAmount = formatCurrency(totalOutstandingAmount ?? 0.0);
    String formattedAmountForFiveDist = formatCurrency(totalOutstandingAmountForFive ?? 0.0);

    String label = _selectedItem == "Top 5 outstanding"
        ? 'Total Outstanding Amount: $formattedAmountForFiveDist'
        : 'Total Outstanding Amount: $formattedAmount';

    print(label);
    print('Total Outstanding Amount Data: $label');

    final currentList = (_selectedItem == "Top 5 outstanding")
        ? topFivedisplayList
        : displayList;
    return
      WillPopScope(
        onWillPop: () async {
          if (argLRAdd == "fromDrawer") {
            Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
            return false;
          } else {
            Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
            return false;
          }
        },
        child:
        Scaffold(
          appBar:
          PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child:
            AppBar(
              automaticallyImplyLeading: false,
              surfaceTintColor: Color(0xFFECEFFF),
              backgroundColor: Color(0xFFECEFFF),
              flexibleSpace: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                         // Navigator.pushNamed(context, BottomNavBarExample.screenName);
                          Navigator.pop(context);

                        },
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Credit Sale Ledger',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              textScaler: TextScaler.noScaling,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${label}',
                                    style: TextStyle(fontSize: 12, color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                    textScaler: TextScaler.noScaling,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body:
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child:
                Row(
                  children: [
                    Text("Select Customer:",style: Styling.blueClrText,textScaler: TextScaler.noScaling,),
                    // Expanded(
                    //   child: DropdownButtonFormField<GetCustomerListModel>(
                    //     isExpanded: true,
                    //     decoration: buildInputBorderUpdateStatus("ALL", context),
                    //     value: _selectedItemModel,
                    //     items: [
                    //       DropdownMenuItem<GetCustomerListModel>(
                    //         value: allItem,
                    //         child: Text(
                    //           "ALL",
                    //           style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                    //           textScaler:
                    //           TextScaler.noScaling,
                    //         ),
                    //       ),
                    //       ...customerModel.map((GetCustomerListModel item) {
                    //         return DropdownMenuItem<GetCustomerListModel>(
                    //           value: item,
                    //           child: Text(
                    //             item.customerName ?? '',
                    //             style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                    //             textScaler:
                    //             TextScaler.noScaling,
                    //           ),
                    //         );
                    //       }).toList(),
                    //     ],
                    //     onChanged: (GetCustomerListModel? selectedItem) {
                    //       if (selectedItem != null) {
                    //         setState(() {
                    //           _selectedItemModel = selectedItem;
                    //
                    //           if (selectedItem.customerId == -1) {
                    //             _selectedItem = "ALL";
                    //             selectedItemId = -1;
                    //             showTop5ByOutstanding();
                    //             // getCreditSaleLedgerDtls(0);
                    //           } else {
                    //             _selectedItem = selectedItem.customerName!;
                    //             selectedItemId = selectedItem.customerId?.toInt();
                    //             getCreditSaleLedgerDtls(selectedItemId!);
                    //           }
                    //         });
                    //       }
                    //     },
                    //     hint: Text('ALL',
                    //       textScaler:
                    //       TextScaler.noScaling,),
                    //   ),
                    // ),

                    ///top 5
                    Expanded(
                      child:
                      DropdownButtonFormField<GetCustomerListModel>(
                        isExpanded: true,
                        decoration: buildInputBorderUpdateStatus("ALL", context),
                        value: _selectedItemModel,
                        items: [
                          DropdownMenuItem<GetCustomerListModel>(
                            value: allItem,
                            child: Text(
                              "ALL",
                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                              textScaler: TextScaler.noScaling,
                            ),
                          ),
                          DropdownMenuItem<GetCustomerListModel>(
                            value: top5Item,
                            child: Text(
                              "Top 5",
                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                              textScaler: TextScaler.noScaling,
                            ),
                          ),
                          DropdownMenuItem<GetCustomerListModel>(
                            value: oldestItem,
                            child: Text(
                              "Oldest",
                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                              textScaler: TextScaler.noScaling,
                            ),
                          ),
                          ...customerModel.map((GetCustomerListModel item) {
                            return DropdownMenuItem<GetCustomerListModel>(
                              value: item,
                              child: Text(
                                item.customerName ?? '',
                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                                textScaler: TextScaler.noScaling,
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (GetCustomerListModel? selectedItem) {
                          if (selectedItem != null) {
                            setState(() {
                              _selectedItemModel = selectedItem;

                              if (selectedItem.customerId == -1) {
                                _selectedItem = "ALL";
                                selectedItemId = -1;
                                getCreditSaleLedgerDtls(0);
                                // Fetch all data
                              } else if (selectedItem.customerId == -2) {
                                _selectedItem = "Top 5 outstanding";
                                selectedItemId = -2;
                                getTopFiveCreditors(0);  // Your function to get top 5
                              } else if (selectedItem.customerId == -3) {
                                _selectedItem = "Oldest by day's";
                                selectedItemId = -3;
                                showOldestRecords();       // Function to get oldest 5 by date
                              } else {
                                _selectedItem = selectedItem.customerName!;
                                selectedItemId = selectedItem.customerId?.toInt();
                                getCreditSaleLedgerDtls(selectedItemId!);  // Fetch for selected customer
                              }
                            });
                          }
                        },
                        hint: Text(
                          'ALL',
                          textScaler: TextScaler.noScaling,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentList.isNotEmpty
          ? ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: currentList.length,
        itemBuilder: (context, index) {
          final isTopFive = _selectedItem == "Top 5 outstanding";

          final collRcptDate = isTopFive
              ? (currentList[index] as GetTopFiveCreditorsModel?)?.collRcptDate
              : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)?.collRcptDate;

          final customerName = isTopFive
              ? (currentList[index] as GetTopFiveCreditorsModel?)?.customerName
              : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)?.customerName;

          final totalOutstanding = isTopFive
              ? (currentList[index] as GetTopFiveCreditorsModel?)?.totalOutstanding
              : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)?.totalOutstanding;

          final pendingSinceDays = isTopFive
              ? (currentList[index] as GetTopFiveCreditorsModel?)?.pendingSinceDays
              : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)?.pendingSinceDays;

          final customerType = isTopFive
              ? (currentList[index] as GetTopFiveCreditorsModel?)?.customerType
              : (currentList[index] as GetCreditSaleLedgerDtlsListModel?)?.customerType;

          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 0,
                        child: countTextWidgetTextWithoutHeading(
                          context,
                          DateFormat('dd-MM-yyyy').format(
                            DateTime.tryParse(collRcptDate ?? '') ?? DateTime.now(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: countTextWidgetTextWithoutHeading(
                          context,
                          nullToDash(customerName),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(children: [
                    Text(
                      "Total Outstanding Bal.",
                      style: Styling.itemGreyText,
                      maxLines: 2,
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Text(
                    //   ": ${nullToDash(
                    //     totalOutstanding == null
                    //         ? null
                    //         : totalOutstanding! % 1 == 0
                    //         ? totalOutstanding.toStringAsFixed(0)
                    //         : totalOutstanding.toString(),
                    //   )}",
                    //   style: Styling.itemBlackTest,
                    //   textScaler: TextScaler.noScaling,
                    // ),
                    Text(
                      ": ${nullToDash(
                        totalOutstanding == null
                            ? null
                            : formatCurrency(totalOutstanding.toDouble()),
                      )}",
                      style: Styling.itemBlackTest,
                      textScaler: TextScaler.noScaling,
                    ),
                  ]),
                  const SizedBox(height: 2),
                  Row(children: [
                    Text(
                      "Pending Since No. of Days",
                      style: Styling.itemGreyText,
                      maxLines: 2,
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "  : ${nullToDash(pendingSinceDays?.toStringAsFixed(0))}",
                        style: Styling.itemBlackTest,
                        textScaler: TextScaler.noScaling,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 2),
                  Row(children: [
                    Text(
                      "Customer Type",
                      style: Styling.itemGreyText,
                      maxLines: 2,
                      textScaler: TextScaler.noScaling,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "  : ${nullToDash(customerType)}",
                        style: Styling.itemBlackTest,
                        textScaler: TextScaler.noScaling,
                      ),
                    ),
                  ]),
                  if(_selectedItem != "Top 5 outstanding")...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 0,
                        child: countTextWidgetTextWithoutHeadingGrey(
                          context,
                          "Pay Now",
                        ),
                      ),
                    ],
                  ),
                 ],
                ],
              ),
            ),
          );
        },
      )
          : const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'No Records Found',
                style: TextStyle(color: Colors.grey),
                textScaler: TextScaler.noScaling,
              ),
            ],
          ),
        ),
      ),
    ),
   ],
   ),
  ),
  );
  }

  Future<void> getCreditSaleLedgerDtls(int consumorId) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

      if (!Constants.isNetworkAvailable) {
        showFlushBar(context, Constants.connectionMessage);
        setState(() {
          isLoading = false; // Hide loading indicator
        });
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer Token is missing. Please log in again.');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetCreditSaleLedgerDtls}/$distributorId/$consumorId'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );

      debugPrint("GetCreditSaleLedgerDtls: ${AppUrl.GetCreditSaleLedgerDtls}/$distributorId/$consumorId");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _items = data.map((json) => GetCreditSaleLedgerDtlsListModel.fromJson(json)).toList();
          displayList = _items;
          isLoading = false; // Hide loading indicator after data is fetched
        });

        _calculateTotalAmount();
      } else {
        throw Exception('Unable to load data at this time. Please try again later.');
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() {
        isLoading = false; // Hide loading indicator if there's an error
      });
      showFlushBar(context, 'An error occurred. Please try again.');
    }
  }

  Future<void> getTopFiveCreditors(int customerId) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;

      if (!Constants.isNetworkAvailable) {
        showFlushBar(context, Constants.connectionMessage);
        setState(() {
          isLoading = false; // Hide loading indicator
        });
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? distributorId = prefs.getString('DistributorId');
      String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer Token is missing. Please log in again.');
      }

      final response = await http.get(
        Uri.parse('${AppUrl.GetTopFiveCreditors}/$distributorId/$customerId'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );

      debugPrint("GetTopFiveCreditors: ${AppUrl.GetTopFiveCreditors}/$distributorId/$customerId");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _topFiveItems = data.map((json) => GetTopFiveCreditorsModel.fromJson(json)).toList();
          topFivedisplayList = _topFiveItems;
          isLoading = false; // Hide loading indicator after data is fetched
        });


        _calculateTotalAmount();
      } else {
        throw Exception('Unable to load data at this time. Please try again later.');
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() {
        isLoading = false; // Hide loading indicator if there's an error
      });
      showFlushBar(context, 'An error occurred. Please try again.');
    }
  }

  Future<void> getCustomerList() async {
    EasyLoading.show();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken =
    prefs.getString('token'); // Assuming the token is stored here

    if (bearerToken == null) {
      throw Exception('Bearer token is missing');
    }
    Map<String, dynamic> requestBody = {
      "DistributorId": distributorId,
    };

    final response = await http.get(
      Uri.parse('${AppUrl.GetCustomerList}/$distributorId/1'),
      headers: {
        'Authorization': 'Bearer $bearerToken', // Add Bearer token here
      },
    );
    debugPrint("GetCustomerListModel : " +
        '${AppUrl.GetCustomerList}/$distributorId/1');
    debugPrint("GetCustomerList : " + '${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        customerModel = data.map((json) {
          return GetCustomerListModel.fromJson(json);
        }).toList();
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
      throw Exception('Failed to load items');
    }
  }

  String formatCurrency(double amount) {
    if (amount == 0) {
      return '0.00';
    }
    final format = NumberFormat('#,##,###.00', 'en_IN');

    String formattedAmount = format.format(amount);

    if (amount < 1 && formattedAmount.startsWith('.')) {
      formattedAmount = '0' + formattedAmount;
    }
    return formattedAmount;
  }

  void _calculateTotalAmount() {
    print("Items: $displayList");
    totalOutstandingAmount = displayList.fold(
      0.0,
          (sum, report) {
            double pendingDays = (report.totalOutstanding ?? 0.0).toDouble();
        return sum! + pendingDays;
      },
    );
    totalOutstandingAmountForFive = topFivedisplayList.fold(
      0.0,
          (sum, report) {
        double pendingDays = (report.totalOutstanding ?? 0.0).toDouble();
        return sum! + pendingDays;
      },
    );
    print("Total Amount: $totalOutstandingAmount");
    print("totalOutstandingAmountForFive: $totalOutstandingAmountForFive");

  }
  // void showTop5ByOutstanding() {
  //   // Step 1: Sort descending by totalOutstanding
  //   List<GetCreditSaleLedgerDtlsListModel> sortedList = List.from(_items);
  //   sortedList.sort((a, b) => (b.totalOutstanding ?? 0).compareTo(a.totalOutstanding ?? 0));
  //
  //   // Step 2: Take top 5 (or fewer if list is small)
  //   List<GetCreditSaleLedgerDtlsListModel> top5 = sortedList.take(5).toList();
  //
  //   // Step 3: Use these top 5 items (for example, print or update UI)
  //   for (var item in top5) {
  //     print('Customer: ${item.customerName}, Outstanding: ${item.totalOutstanding}');
  //   }
  //
  //   // You can also update state here to show the list in UI
  //   setState(() {
  //     _items = top5;
  //   });
  // }
  void showTop5ByOutstanding() {
    List<GetCreditSaleLedgerDtlsListModel> sorted = List.from(_items);
    sorted.sort((a, b) => (b.totalOutstanding ?? 0).compareTo(a.totalOutstanding ?? 0));
    setState(() {
      displayList = sorted.take(5).toList();
      _calculateTotalAmount();
    });
  }

  void showOldestRecords() {
    List<GetCreditSaleLedgerDtlsListModel> sorted = List.from(_items);
    sorted.sort((a, b) {
      // Parse date strings or handle nulls
      DateTime dateA = a.collRcptDate != null
          ? DateTime.tryParse(a.collRcptDate!) ?? DateTime(1970)
          : DateTime(1970);
      DateTime dateB = b.collRcptDate != null
          ? DateTime.tryParse(b.collRcptDate!) ?? DateTime(1970)
          : DateTime(1970);
      return dateA.compareTo(dateB);
    });
    setState(() {
      displayList = sorted;
      _calculateTotalAmount();
    });
  }
}