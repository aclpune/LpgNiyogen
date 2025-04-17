import 'dart:convert';
import 'package:flutter/cupertino.dart' hide Key;
import 'package:flutter/material.dart' hide Key;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/DsrReportCashInHandModel.dart';
import 'ManagerCashInHandScreenDetailsUI.dart';

class ManagerCashInHandScreenDeails extends StatefulWidget {
  static const screenName = '/managerCashInHandScreenDeails';

  ManagerCashInHandScreenDeails({super.key});

  @override
  _ManagerCashInHandScreenDeails createState() =>
      _ManagerCashInHandScreenDeails();
}

class _ManagerCashInHandScreenDeails extends State<ManagerCashInHandScreenDeails> {
  late List<DsrReportCashInHandModel> cashInHandModel = []; // Initialize as empty list

  bool isLoading = true;
  var argValue;
  DateTime? date;
  int? staffId;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        argValue = ModalRoute
            .of(context)
            ?.settings
            .arguments as Map;
        date = argValue["Date"];
        staffId = argValue["staffId"];

        debugPrint("date :- ${date.toString()}");
        debugPrint("staffId :- ${staffId.toString()}");
        fetchCashInHand(staffId!);
      });
    });
  }

  // Method to fetch data from the API
  Future<void> fetchCashInHand(int staffId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    //String? ItemId = prefs.getString('ItemId');

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
      "StaffId": staffId,

    };

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.GetCashInHandpopupList_Mob}'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
          // Ensure the request body is JSON
        },
        body: json.encode(requestBody), // Encode the request body as JSON
      );

      debugPrint("CheckDayEndConfirmation" + response.body);
      debugPrint("CheckDayEndConfirmation ${response.request}");
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the data
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          cashInHandModel = data
              .map((jsonItem) => DsrReportCashInHandModel.fromJson(jsonItem))
              .toList();
          isLoading = false; // Data is loaded, set isLoading to false
        });
      } else {
        // Handle failed request
        throw Exception('Failed to load delivery men');
      }
    } catch (error) {
      // Handle any errors
      debugPrint('Error: $error');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // var sale = cashInHandModel;
    // String? titleText = sale.isNotEmpty ? sale[0].itemName : 'No Items';
    return Scaffold(
        appBar: AppBar(title: Text('Cash Hand'),),
        body: isLoading
            ? const Center(
            child: CircularProgressIndicator()) // Show loading indicator while fetching data
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0), // Adjust padding as needed
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Sr.No.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Staff Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Total Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(), // Horizontal divider after the heading row
                  ],
                ),
              ),
              cashInHandModel.isNotEmpty
                  ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: cashInHandModel.length,
                itemBuilder: (context, index) {
                  debugPrint(
                      "Rendering Expense Item: ${cashInHandModel[index]}");
                  return ManagerCashInHandScreenDetailsUI(
                    cashInHandModel[index],
                    //screenMode!,
                    index + 1,
                  );
                },
              )
                  : Container(child: Text('No Records Found')),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Aligns everything to the end (right side)
                  children: [
                    // Total Amount for Cash
                  Align(
                  alignment: Alignment.centerRight, // Ensures the content inside is aligned right
                  child: Text(
                        'Total: ${getTotalCash().toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                  ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  double getTotalCash() {
    double totalAmount = 0.0;

    for (var item in cashInHandModel) {
      num? amount = item
          .totalAmount; // Assuming the amount is a property of the model
      if (amount! > 0) {
        totalAmount += amount; // Add if the amount is positive
      } else {
        totalAmount +=
            amount; // Subtract (negative value) if the amount is negative
         }
     }

    return totalAmount;
  }
}