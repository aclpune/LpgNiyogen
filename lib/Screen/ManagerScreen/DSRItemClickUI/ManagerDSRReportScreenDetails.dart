import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DSRItemClickUI/ManagerDSRExpenseUI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../GodownKeeper/DelBoyStockReturn/DeliveryMenListShowScreenItemUI.dart';
import '../../GodownKeeper/DeliveryBoyModel/DeliveryMenSaleListModel.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../ClickModelClass/DSRReportExpenseModel.dart';
import '../ClickModelClass/DSRReportScreenDetailModel.dart';
import 'ManagerDSRReportScreenItemUI.dart'; // Your app URL constants

class ManagerDSRReportScreenDetails extends StatefulWidget {
  static const screenName = '/managerDSRReportScreenDetails';

  // Constructor to receive the deliveryMenList
  ManagerDSRReportScreenDetails({super.key});

  @override
  _ManagerDSRReportScreenDetailsState createState() =>
      _ManagerDSRReportScreenDetailsState();
}

class _ManagerDSRReportScreenDetailsState extends State<ManagerDSRReportScreenDetails> {
  List<DsrReportScreenDetailModel> getDSRReportScreenDetailmodel = [];
  List<DsrReportExpenseModel> getDSRReportExpensemodel = [
  ]; // Initialize as empty list

  bool isLoading = true; // Variable to track loading state
  var argValue;
  String? screenMode;
  DateTime? date;


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute
            .of(context)
            ?.settings
            .arguments as Map;
        screenMode = argValue["ScreenMode"];
        date = argValue["Date"];

        debugPrint("customerHoldingData :- ${screenMode.toString()}");
        debugPrint("customerHoldingData :- ${date.toString()}");
        fetchDSRData(screenMode!);
        fetchExpenseData(screenMode!);
      });
    });
  }

  // Method to calculate total cash
  getTotalCash() {
    double totalCash = 0.0;
    for (var item in getDSRReportScreenDetailmodel) {
      if (item.cashAmt != null) {
        totalCash += item.cashAmt!;
      }
    }
    return totalCash;
  }

  // Method to calculate total bank amount
  getTotalBank() {
    double totalBank = 0.0;
    for (var item in getDSRReportScreenDetailmodel) {
      if (item.bankAmt != null) {
        totalBank += item.bankAmt!;
      }
    }
    return totalBank;
  }

  // Method to calculate total credit amount
  getTotalCredit() {
    double totalCredit = 0.0;
    for (var item in getDSRReportScreenDetailmodel) {
      if (item.creditAmt != null) {
        totalCredit += item.creditAmt!;
      }
    }
    return totalCredit;
  }

  getExpenseCashAmount() {
    double totalCredit = 0.0;
    for (var item in getDSRReportExpensemodel) {
      if (item.cash != null) {
        totalCredit += item.cash!;
      }
    }
    return totalCredit;
  }
  getExpenseBankAmount() {
    double totalCredit = 0.0;
    for (var item in getDSRReportExpensemodel) {
      if (item.bank != null) {
        totalCredit += item.bank!;
      }
    }
    return totalCredit;
  }
  Future<void> fetchExpenseData(String flag) async {
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

        // DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(date!);
        debugPrint("formattedDate :- ${formattedDate.toString()}");
        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        // Construct the request body for the POST request
        Map<String, dynamic> requestBody = {
          "DistributorId": distributorId,
          "Date": formattedDate,
          "Flag": flag
          // Example: you can replace this with `distributorId` if needed

        };
        final response = await http.post(
          Uri.parse('${AppUrl.GetexpensepopupList_Mob}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body GetexpensepopupList_Mob: ${response.body}");
        debugPrint("Request body GetexpensepopupList_Mob: ${response
            .request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getDSRReportExpensemodel = data.map((jsonItem) =>
                DsrReportExpenseModel.fromJson(jsonItem)).toList();
            // filteredSales = dailySales;
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

  // Method to fetch data from the API
  Future<void> fetchDSRData(String flag) async {
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

        // DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(date!);
        debugPrint("formattedDate :- ${formattedDate.toString()}");
        if (bearerToken == null) {
          isLoading = false;
          throw Exception('Bearer token is missing');
        }

        // Construct the request body for the POST request
        Map<String, dynamic> requestBody = {
          "DistributorId": distributorId,
          "Date": formattedDate,
          "Flag": flag
          // Example: you can replace this with `distributorId` if needed

        };
        final response = await http.post(
          Uri.parse('${AppUrl.GetCashflowpopupList_Mob}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body GetCashflowpopupList_Mob: ${response.body}");
        debugPrint("Request body GetCashflowpopupList_Mob: ${response
            .request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getDSRReportScreenDetailmodel = data.map((jsonItem) =>
                DsrReportScreenDetailModel.fromJson(jsonItem)).toList();
            // filteredSales = dailySales;
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
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text('${screenMode} Details'),
      ),
      body: isLoading
          ? const Center(
          child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left:5.0,right: 5,top: 2,bottom: 2), // Adjust padding as needed
              child: Column(
                children: [
                  Row(
                    children: [
                      // Sr No Column Name
                       Expanded(
                        flex: 1,
                        child: Text(
                          screenMode == "Credit" || screenMode == "Expenses" ?
                          'Sr.\nNo.':"Sr.No.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          screenMode == 'Expenses' ? 'Expense Head' : 'Item Name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: screenMode == 'Credit',
                        child: const Expanded(
                          flex: 2,
                          child: Text(
                            'Qty.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: screenMode == 'Credit' || screenMode == 'Expenses',
                        child: Expanded(
                          flex: screenMode == 'Credit' ? 4: 2,
                          child: Text(
                            screenMode == 'Expenses' ? 'Cash\nAmount' : 'Customer Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8,),
                      // Total Amount Column Name
                      Expanded(
                        flex: screenMode == 'Credit' ? 3: 2,
                        child: Text(
                          screenMode == 'Expenses' ? 'Bank\nAmount' : 'Total Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(), // Horizontal divider after the heading row
                ],
              ),
            ),

            screenMode == "Expenses"
                ? getDSRReportExpensemodel.isNotEmpty
                ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: getDSRReportExpensemodel.length,
              itemBuilder: (context, index) {
                debugPrint("Rendering Expense Item: ${getDSRReportExpensemodel[index]}");
                return ManagerDSRExpenseUI(
                  getDSRReportExpensemodel[index],
                  screenMode!,
                  index + 1,
                );
              },
            )
                : Container(child: Text('No Records Found'))
                : getDSRReportScreenDetailmodel.isNotEmpty?
            getDSRReportScreenDetailmodel.any((item) => screenMode == "Credit"? item.creditAmt! > 0:screenMode == "Cash"?item.cashAmt! > 0:item.bankAmt! > 0)
                ?

            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: screenMode == "Cash"
                  ? getDSRReportScreenDetailmodel
                  .where((item) => item.cashAmt! > 0)
                  .length
                  : screenMode == "Bank"
                  ? getDSRReportScreenDetailmodel
                  .where((item) => item.bankAmt != null && item.bankAmt! > 0)
                  .length
                  : screenMode == "Credit"
                  ? getDSRReportScreenDetailmodel
                  .where((item) => item.creditAmt! > 0)
                  .length
                  : getDSRReportScreenDetailmodel.length,
              itemBuilder: (context, index) {
                final filteredList = screenMode == "Cash"
                    ? getDSRReportScreenDetailmodel.where((item) => item.cashAmt != null && item.cashAmt! > 0).toList()
                    : screenMode == "Bank"
                    ? getDSRReportScreenDetailmodel.where((item) => item.bankAmt != null && item.bankAmt! > 0).toList()
                    : screenMode == "Credit"
                    ? getDSRReportScreenDetailmodel.where((item) => item.creditAmt != null && item.creditAmt! > 0).toList()
                    : getDSRReportScreenDetailmodel;
                return ManagerDSRReportScreenItemUI(
                  filteredList[index],
                  screenMode!,
                  index + 1,
                );
              },
            )
                : Container(child: Text('No records found')
            ): Container(child: Text('No records found')
            ),

              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Total Amount for Cash
                    Align(
                      alignment: Alignment.centerRight, // Ensures the content inside is aligned right
                      child: Text(
                        screenMode == 'Cash'
                            ? 'Total: ${formatCurrency(getTotalCash())}' // Display total cash
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    // Total Amount for Bank
                    Align(
                      alignment: Alignment.centerRight, // Align text to the right
                      child: Text(
                        screenMode == 'Bank'
                            ? 'Total: ${formatCurrency(getTotalBank())}' // Display total bank
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    // Total Amount for Credit
                    Align(
                      alignment: Alignment.centerRight, // Align text to the right
                      child: Text(
                        screenMode == 'Credit'
                            ? 'Total: ${formatCurrency(getTotalCredit())}' // Display total credit
                            : '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    // Additional Padding and Total Amount for Expenses
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Total Amount for Cash (Expenses)
                          if (screenMode == 'Expenses')
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Total Cash Amt.- ${formatCurrency(getExpenseCashAmount())}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          SizedBox(width: 8), // Add a gap between cash and bank amounts
                          // Total Amount for Bank (Expenses)
                          if (screenMode == 'Expenses')
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Total Bank Amt.- ${formatCurrency(getExpenseBankAmount())}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),// Empty container when no data is available
     );
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

