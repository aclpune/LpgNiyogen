import 'dart:convert';
import 'package:flutter/cupertino.dart' hide Key;
import 'package:flutter/material.dart' hide Key;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/app_url.dart';
import '../ClickModelClass/DsrReportCashInHandModel.dart';
import 'ManagerCashInHandScreenDetailsUI.dart';
import '../../../newTheam/core/theme/app_colors.dart';
import '../../../newTheam/core/theme/app_typography.dart';

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
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Cash In Hand', style: AppTypography.heroTitle),
        centerTitle: false,
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppColors.gradHero)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.blue))
          : Column(
        children: [
          // Header row
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.blueXL,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.blueXXL),
            ),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text('Sr.', style: AppTypography.labelMD.copyWith(color: AppColors.blue))),
                Expanded(flex: 3, child: Text('Staff Name', style: AppTypography.labelMD.copyWith(color: AppColors.blue))),
                Expanded(flex: 2, child: Text('Amount', style: AppTypography.labelMD.copyWith(color: AppColors.blue), textAlign: TextAlign.right)),
              ],
            ),
          ),
          // List
          Expanded(
            child: cashInHandModel.isNotEmpty
                ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 14),
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
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded, size: 48, color: AppColors.border2),
                  const SizedBox(height: 8),
                  Text('No Records Found', style: AppTypography.cardSubtitle),
                ],
              ),
            ),
          ),
          // Total footer
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: AppColors.gradPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Cash In Hand', style: AppTypography.labelMD.copyWith(color: Colors.white70)),
                Text('₹ ${formatCurrency(getTotalCash())}', style: AppTypography.cardTitle.copyWith(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
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