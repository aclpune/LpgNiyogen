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
  List<GetCustomerListModel> customerModel = [];
  GetCustomerListModel? _selectedItemModel;
  final GetCustomerListModel allItem = GetCustomerListModel(customerId: -1, customerName: "ALL");
  String? _selectedItem;
  int? selectedItemId;
  double? totalOutstandingAmount;
  bool isChecked = false;
  bool isTextEntered = false;
  String? errorMessage;
  late List<String> selectedConsumerNos;
  bool isCheckboxEnabled = true; // Default to true, enabling checkboxes
  List<TextEditingController> _consumerNoControllers = [];
  List<bool> isCheckedList = [];
  List<bool> isTextEnteredList = [];

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
      // Add a new TextEditingController to the list
      _consumerNoControllers.add(TextEditingController());

      // Add corresponding states for Checkbox and TextField
      isCheckedList.add(false);  // Default state for checkbox
      isTextEnteredList.add(false);  // Default state for text entered
    });
  }


  @override
  void initState() {
    super.initState();
    _selectedItemModel = allItem;
    getCreditSaleLedgerDtls(0);
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
    print('Total Outstanding Amount: $formattedAmount');
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
          AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        // Navigator.pop(context);
                        Navigator.pushNamed(context, BottomNavBarExample.screenName);
                      },
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Credit Sale Ledger',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textScaler: TextScaler.noScaling,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Total Outstanding Amount: ${formattedAmount}',
                                  //'Total Outstanding Amount: 4,12,23,456.00',
                                  style: TextStyle(fontSize: 14, color: Colors.white),
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
          body:
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child:
                Row(
                  children: [
                    Text("Select Customer:",style: Styling.blueClrText,textScaler: TextScaler.noScaling,),
                    Expanded(
                      child: DropdownButtonFormField<GetCustomerListModel>(
                        isExpanded: true,
                        decoration: buildInputBorderUpdateStatus("ALL", context),
                        value: _selectedItemModel,
                        items: [
                          DropdownMenuItem<GetCustomerListModel>(
                            value: allItem,
                            child: Text(
                              "ALL",
                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                              textScaler:
                              TextScaler.noScaling,
                            ),
                          ),
                          ...customerModel.map((GetCustomerListModel item) {
                            return DropdownMenuItem<GetCustomerListModel>(
                              value: item,
                              child: Text(
                                item.customerName ?? '',
                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                                textScaler:
                                TextScaler.noScaling,
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
                              } else {
                                _selectedItem = selectedItem.customerName!;
                                selectedItemId = selectedItem.customerId?.toInt();
                                getCreditSaleLedgerDtls(selectedItemId!);
                              }
                            });
                          }
                        },
                        hint: Text('ALL',
                          textScaler:
                          TextScaler.noScaling,),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator()) // Show loader when isLoading is true
                    : _items.isNotEmpty
                    ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    debugPrint("Rendering Expense Item: ${_items[index]}");
                    GetCreditSaleLedgerDtlsListModel? sale = _items[index];
                    return Card(
                      elevation: 4.0,
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
                                            child:
                                            countTextWidgetTextWithoutHeading(
                                            context,
                                            DateFormat('dd-MM-yyyy')
                                            .format(DateTime.parse(
                                            sale.collRcptDate ??
                                          '')))),
                               Expanded(
                                  flex: 0,
                                  child: countTextWidgetTextWithoutHeading(
                                      context, nullToDash(sale.customerName)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       flex: 1,
                            //       child: countTextWidgetText(
                            //           context, "Total Outstanding Bal.",
                            //           nullToDash(sale.totalOutstanding! % 1 == 0
                            //               ? sale.totalOutstanding?.toStringAsFixed(0)
                            //               : sale.totalOutstanding.toString())
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                      child: Row(children: [
                                        Text(
                                            "Total Outstanding Bal.",
                                            style:
                                            Styling.itemGreyText,
                                            maxLines: 2,
                                            textScaler:
                                            TextScaler.noScaling,
                                            overflow:
                                            TextOverflow.ellipsis),
                                         Text(": ${nullToDash(sale.totalOutstanding! % 1 == 0
                                                ? sale.totalOutstanding?.toStringAsFixed(0)
                                                : sale.totalOutstanding.toString())}",
                                                style: Styling
                                                    .itemBlackTest,
                                                textScaler: TextScaler
                                                    .noScaling)
                                      ])))
                            ]),
                            const SizedBox(height: 2),
                                    Row(children: [
                                      Expanded(
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Row(children: [
                                                Text(
                                                    "Pending Since No. of Days",
                                                    style: Styling.itemGreyText,
                                                    maxLines: 2,
                                                    textScaler:
                                                        TextScaler.noScaling,
                                                    overflow:
                                                        TextOverflow.ellipsis
                                                ),
                                                SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                        "  : ${nullToDash(sale.pendingSinceDays?.toStringAsFixed(0))}",
                                                        style: Styling
                                                            .itemBlackTest,
                                                        textScaler: TextScaler
                                                            .noScaling)),
                                              ]))),
                            ]),
                            const SizedBox(height: 2),
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
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
                    : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('No Records Found', style: TextStyle(color: Colors.grey),textScaler: TextScaler.noScaling,),
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
    print("Items: $_items");
    totalOutstandingAmount = _items.fold(
      0.0,
          (sum, report) {
            double pendingDays = (report.totalOutstanding ?? 0.0).toDouble();
        return sum! + pendingDays;
      },
    );
    print("Total Amount: $totalOutstandingAmount");
  }

}