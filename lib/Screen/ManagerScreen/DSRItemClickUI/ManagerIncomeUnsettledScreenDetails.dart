// import 'dart:convert';
//
// import 'package:encrypt/encrypt.dart';
// import 'package:flutter/cupertino.dart' hide Key;
// import 'package:flutter/material.dart' hide Key;
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Utils/app_url.dart';
// import '../ClickModelClass/GetUnsettledAmountListModel.dart';
//
//
// class ManagerIncomeUnsettledScreenDetails extends StatefulWidget {
//   final List<GetUnsettledAmountListModel> unsettledModelList;
//
//   ManagerIncomeUnsettledScreenDetails({super.key, required this.unsettledModelList});
//
//   @override
//   _ManagerIncomeUnsettledScreenDetails createState() =>
//       _ManagerIncomeUnsettledScreenDetails();
// }
//
// class _ManagerIncomeUnsettledScreenDetails extends State<ManagerIncomeUnsettledScreenDetails> {
//   late List<GetUnsettledAmountListModel> unsettledModelList = []; // Initialize as empty list
//
//   bool isLoading = true;
//
//   var argValue;
//   String? screenMode; //settled/Unsettled
//   DateTime? date;
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.delayed(Duration.zero, () {
//       setState(() {
//         argValue = ModalRoute
//             .of(context)
//             ?.settings
//             .arguments as Map;
//         screenMode = argValue["Flag"];
//         date = argValue["Date"];
//
//         debugPrint("customerHoldingData :- ${screenMode.toString()}");
//         debugPrint("customerHoldingData :- ${date.toString()}");
//       });
//     });
//     fetchUnsettledData(screenMode!);
//   }
//
//   // Method to fetch data from the API
//   Future<void> fetchUnsettledData(String flag) async {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? distributorId = prefs.getString('DistributorId');
//     String? bearerToken = prefs.getString('token');
//     String? ItemId = prefs.getString('ItemId');
//
//     // DateTime now = DateTime.now();
//     String formattedDate = DateFormat('yyyy-MM-dd').format(date!);
//     debugPrint("formattedDate :- ${formattedDate.toString()}");
//     if (bearerToken == null) {
//       isLoading = false;
//       throw Exception('Bearer token is missing');
//     }
//
//     // Construct the request body for the POST request
//     Map<String, dynamic> requestBody = {
//       "DistributorId": distributorId,
//       "Date": formattedDate,
//       "ItemId": ItemId,
//       "Flag": flag,
//       // Example: you can replace this with `distributorId` if needed
//
//     };
//
//     try {
//       final response = await http.get(
//         Uri.parse('${AppUrl.GetUnsettledAmountList_Mob}/$distributorId/1/2'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $bearerToken", // Pass bearer token in headers
//         },
//       );
//       debugPrint("CheckDayEndConfirmation"+response.body);
//       debugPrint("CheckDayEndConfirmation ${response.request}");
//       if (response.statusCode == 200) {
//         // If the server returns a 200 OK response, parse the data
//         final List<dynamic> data = json.decode(response.body);
//         setState(() {
//           unsettledModelList = data
//               .map((jsonItem) => GetUnsettledAmountListModel.fromJson(jsonItem))
//               .toList();
//           isLoading = false; // Data is loaded, set isLoading to false
//         });
//       } else {
//         // Handle failed request
//         throw Exception('Failed to load delivery men');
//       }
//     } catch (error) {
//       // Handle any errors
//       debugPrint('Error: $error');
//       setState(() {
//         isLoading = false; // Stop loading on error
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settled/Unsettled'),
//       ),
//       body: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(),
//       ) // Show loading indicator while fetching data
//           : SingleChildScrollView(
//         child: Column(
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       // Sr No Column Name
//                       Expanded(
//                         flex: 1,
//                         child: Text(
//                           'Sr.No.',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           'Staff Name',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Text(
//                           'Qty.',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           'Total Amount',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Divider(), // Horizontal divider after the heading row
//                 ],
//               ),
//             ),
//             unsettledModelList.isNotEmpty
//                 ? ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: unsettledModelList.length,
//               itemBuilder: (context, index) {
//                 debugPrint("Rendering Expense Item: ${unsettledModelList[index]}");
//                 return ManagerIncomeUnsettledScreenDetails(
//                   unsettledModelList: [],
//                 );
//               },
//             )
//                 : Container(
//               child: Text('No Records Found'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
import 'dart:convert';

import 'package:flutter/cupertino.dart' hide Key;
import 'package:flutter/material.dart' hide Key;
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstantScreen/widgets.dart';
import '../../Utils/app_url.dart';
import '../../Utils/constants.dart';
import '../ClickModelClass/GetUnsettledAmountListModel.dart';
import 'ManagerIncomeUnsettledScreenDetailUI.dart';


class ManagerIncomeUnsettledScreenDetails extends StatefulWidget {
  static const screenName = '/managerIncomeUnsettledScreenDetails';

  ManagerIncomeUnsettledScreenDetails({super.key});

  @override
  _ManagerIncomeUnsettledScreenDetails createState() => _ManagerIncomeUnsettledScreenDetails();
}

class _ManagerIncomeUnsettledScreenDetails extends State<ManagerIncomeUnsettledScreenDetails> {
  late List<GetUnsettledAmountListModel> unsettledModelList = []; // Initialize as empty list
  bool isLoading = true;
  var argValue;
  int? flag; //settled/Unsettled
  DateTime? date;
  int? itemIds;
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
          itemIds = argValue["itemId"] ?? '';

          debugPrint("flag :- ${flag.toString()}");
          debugPrint("date :- ${date.toString()}");
          debugPrint("itemIds :- ${itemIds.toString()}");

          fetchUnsettledData(flag!,itemIds!);
        });
      });
  }

  Future<void> fetchUnsettledData(int flag,int itemId) async {
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
          "ItemId": itemId,
          "Flag":flag,
        };

        final response = await http.post(
          Uri.parse('${AppUrl.GetUnsettledAmountList_Mob}'),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // Ensure the request body is JSON
          },
          body: json.encode(requestBody), // Encode the request body as JSON
        );

        debugPrint("Response body GetUnsettledAmountList_Mob: ${response.body}");
        debugPrint("Request body GetUnsettledAmountList_Mob: ${response
            .request}${requestBody}");

        if (response.statusCode == 200) {
          // Parse the JSON response
          final List<dynamic> data = json.decode(response.body);
          setState(() {
            unsettledModelList = data.map((jsonItem) =>
                GetUnsettledAmountListModel.fromJson(jsonItem)).toList();
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
    var sale = unsettledModelList;

    String? titleText = sale.isNotEmpty ? sale[0].itemName : 'No Items';
     return Scaffold(
       appBar: AppBar(
          // title: Text(flag.toString() == '1' ? 'UnSettled' : 'Settled'),
         title: Text('Sale Against: $titleText' ),
       ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      ) // Show loading indicator while fetching data
          : SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
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
                        flex: 1,
                        child: Text(
                          'Qty.',
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
                  Divider(),
                ],
              ),
            ),
            unsettledModelList.isNotEmpty
                ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: unsettledModelList.length,
              itemBuilder: (context, index) {
                debugPrint("Rendering Expense Item: ${unsettledModelList[index]}");
                return ManagerIncomeUnsettledScreenDetailUI(
                  unsettledModelList[index], // Pass each item to the UI widget
                  index + 1
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
    ),
 );
}
  double getTotalCash() {
    double totalAmount = 0.0;

    for (var item in unsettledModelList) {
      num? amount = item
          .amount; // Assuming the amount is a property of the model
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
