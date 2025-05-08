import 'dart:convert';
//***********GetexpensepopupListModel
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstantScreen/widgets.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';

import '../ClickModelClass/GetexpensepopupListModel.dart';
import 'ManagerExpenseTabScreenUI.dart';

class ManagerExpenseTabScreenDetails extends StatefulWidget{
static const screenName = '/managerExpenseTabScreenDetails';
  @override
  State<StatefulWidget> createState() {
   return _ManagerExpenseTabScreenDetailsState();
  }
}

class _ManagerExpenseTabScreenDetailsState extends State<ManagerExpenseTabScreenDetails> {
  late List<GetexpensepopupListModel> getExpenseModel = [];
  bool isLoading = true;
  var argValue;
  String? flag; //
  DateTime? date;
  int? expenseHeadId;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute
            .of(context)
            ?.settings
            .arguments as Map;
        flag = argValue["FlagCheck"] ?? '';
        date = argValue["Date"] ?? '';
        expenseHeadId = argValue["expenseHeadId"] ?? '';

        debugPrint("flag :- ${flag.toString()}");
        debugPrint("date :- ${date.toString()}");
        debugPrint("expenseHeadId :- ${expenseHeadId.toString()}");

        fetchExpenseData(flag!, expenseHeadId!);
      });
    });
  }

  Future<void> fetchExpenseData(String flag, int expenseHeadId) async {
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


        //DateTime now = DateTime.now();
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
          "ExpHeadId": expenseHeadId,
          "Flag":flag,
        };

        final response = await http.post(
          Uri.parse('${AppUrl.GetexpensepopupListOnAccount_Mob}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body GetexpensepopupListOnAccount_Mob: ${response.body}");
        debugPrint("Request body GetexpensepopupListOnAccount_Mob: ${response
            .request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            getExpenseModel = data.map((jsonItem) =>
                GetexpensepopupListModel.fromJson(jsonItem)).toList();
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

    var sale = getExpenseModel;
    String? titleText = sale.isNotEmpty ? sale[0].expensehead : 'No Items';
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Against : $titleText',
          style: TextStyle(fontSize: 16
          ),
        ),

      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      ) // Show loading indicator while fetching data
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'Sr.No.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Staff Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Cash Amt',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: flag != 'On Account',
                        child: Expanded(
                          flex: 2,
                          child: Text(
                            flag == 'On Account' ? '' : 'Bank Amount',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
            getExpenseModel.isNotEmpty
                ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: getExpenseModel.length,
              itemBuilder: (context, index) {
                debugPrint("Rendering Expense Item: ${getExpenseModel[index]}");
                return ManagerExpenseTabScreenUI(
                    getExpenseModel[index],
                  index + 1,
                  flag!,

                );
              },
            )
                : Container(
              child: Text('No Records Found'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Aligns everything to the end (right side)
                children: [
                  // Total Amount for Cash
                  Align(
                    alignment: Alignment.center, // Ensures the content inside is aligned right
                    child: Text(
                      'Total Cash: ${getCashTotal().toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(width: 8),
                  if (flag != 'On Account')
                  Align(
                    alignment: Alignment.centerRight, // Ensures the content inside is aligned right
                    child: Text(
                      'Total Bank: ${getBankTotal().toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  getCashTotal() {
    double totalCashAmount = 0.0;

    for (var item in getExpenseModel) {
      num? amount = item
          .cash; // Assuming the amount is a property of the model
      if (amount! > 0) {
        totalCashAmount += amount; // Add if the amount is positive
      } else {
        totalCashAmount +=
            amount; // Subtract (negative value) if the amount is negative
      }
    }

    return totalCashAmount;
  }


  getBankTotal() {
    double totalCashAmount = 0.0;

    for (var item in getExpenseModel) {
      num? amount = item
          .bank; // Assuming the amount is a property of the model
      if (amount! > 0) {
        totalCashAmount += amount; // Add if the amount is positive
      } else {
        totalCashAmount +=
            amount; // Subtract (negative value) if the amount is negative
      }
    }

    return totalCashAmount;
  }

}

