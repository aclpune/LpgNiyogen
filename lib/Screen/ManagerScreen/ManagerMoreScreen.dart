import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/app_url.dart';
import '../Utils/shared_preference.dart';
import 'ARBReturnScreen/ArbReturnScreen.dart';
import 'ARBSaleScreen/ArbSaleScreen.dart';
import 'ARBScreen/ArbScreen.dart';
import 'CashDepositToBankScreen.dart';
import 'CashHandoverScreen.dart';
import 'PaymentReceiptScreen/PaymentReceiptScreen.dart';
import 'ReceiptRegulatorScreen/ReceiptRegulatorScreen.dart';
import 'SVSaleReportScreen.dart';
import 'SalaryPaymentScreen/SalaryPaymentScreen.dart';
import 'TVSaleScreen/TVSalesScreen.dart';
import 'UpdatePaymentsScreen/UpdatePaymentScreen.dart';
class ManagerMoreScree extends StatefulWidget {
  static const screenName = '/managerMoreScree';
  const ManagerMoreScree({super.key});

  @override
  State<ManagerMoreScree> createState() => _ManagerMoreScreeState();
}

class _ManagerMoreScreeState extends State<ManagerMoreScree> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return  WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        } else {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body:
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // Ensures the content is scrollable
                child:
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, right:5.0, bottom: 5.0, top: 10.0),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text("Daily Transaction",style:Styling.itemGreyTextBigMore,),
                      ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child:
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, SVSaleReportScreen.screenName
                                  );
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.sell_outlined),
                                            SizedBox(width: 10,),
                                            Text("SV Sale",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, TVSalesScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          children: [
                                            Icon(Icons.receipt_outlined),
                                            SizedBox(width: 10,),
                                            Text("TV Receipt",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),

                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, PaymentReceiptScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                
                                        Row(
                                          children: [
                                            Icon(Icons.payment_outlined),
                                            SizedBox(width: 10,),
                                            Text("Payments Receipt",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),
                                
                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, UpdatePaymentScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                
                                        Row(
                                          children: [
                                            Icon(Icons.update),
                                            SizedBox(width: 10,),
                                            Text("Update Payments",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),
                                
                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, SalaryPaymentScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                
                                        Row(
                                          children: [
                                            Icon(Icons.payments_outlined),
                                            SizedBox(width: 10,),
                                            Text("Salary Payments",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),
                                
                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, CashHandoverScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                
                                        Row(
                                          children: [
                                            Icon(Icons.comment_bank_outlined),
                                            SizedBox(width: 10,),
                                            Text("Cash Handover-Bank Deposit",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),
                                
                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, ReceiptRegulatorScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          children: [
                                            Icon(Icons.broken_image_outlined),
                                            SizedBox(width: 10,),
                                            Text("Receipt Defective Regulator",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),

                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text("ARB",style:Styling.itemGreyTextBigMore,),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 1,
                        color: Colors.white,
                        child:
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, ArbScreen.screenName
                                );
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.payments_outlined),
                                          SizedBox(width: 10,),
                                          Text("ARB Purchase",style: Styling.itemBlackTestMore,),
                                        ],
                                      ),
                                      Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                    ],
                                  )
                              ),
                            ),
                            Container(height: 1,color: Colors.grey[300],),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushReplacementNamed(context, ArbReturnScreen.screenName);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(
                                        children: [
                                          Icon(Icons.assignment_return_outlined),
                                          SizedBox(width: 10,),
                                          Text("ARB Purchase Return",style: Styling.itemBlackTestMore,),
                                        ],
                                      ),

                                      Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                    ],
                                  )
                              ),
                            ),
                            Container(height: 1,color: Colors.grey[300],),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushReplacementNamed(context, ArbSaleScreen.screenName);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(
                                        children: [
                                          Icon(Icons.sell_outlined),
                                          SizedBox(width: 10,),
                                          Text("ARB Sale",style: Styling.itemBlackTestMore,),
                                        ],
                                      ),

                                      Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text("LOGOUT",style:Styling.itemGreyTextBigMore,),
                      ),
                      GestureDetector(
                        onTap: (){
                          _showLogoutDialog(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(
                                        children: [
                                          Icon(Icons.logout_outlined),
                                          SizedBox(width: 10,),
                                          Text("Logout",style: Styling.itemBlackTestMore,),
                                        ],
                                      ),

                                      Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                    ],
                                  )
                              ),

                            ],
                          ),
                        ),
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

  // Future<void> logoutUser(BuildContext context) async {
  //   ///Save data before logout logic
  //   EasyLoading.show(status: 'Loading...');
  //
  //   try {
  //     SharedPref().removeUser();
  //
  //     // try {
  //     //   if (Platform.isAndroid) {
  //     //     await FirebaseMessaging.instance
  //     //         .deleteToken()
  //     //         .whenComplete(() => debugPrint("Android FCM Token Deleted"));
  //     //   } else if (Platform.isIOS) {
  //     //     await FirebaseMessaging.instance
  //     //         .deleteToken()
  //     //         .whenComplete(() => debugPrint("iOS FCM Token Deleted"));
  //     //   }
  //     // } on PlatformException {
  //     //   debugPrint('###PlatformExc');
  //     // }
  //
  //     EasyLoading.dismiss();
  //
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, SplashScreen.screenName, (r) => false);
  //
  //     debugPrint("Logout Successful");
  //   } catch (error) {
  //     EasyLoading.dismiss();
  //     debugPrint("LogoutPrefEcx: $error");
  //   }
  // }

  Future<void> logoutUser(BuildContext context) async {

    ///Save data before logout logic
    EasyLoading.show(status: 'Loading...');

    try {

      await getDeactiveUserForNotiMob("N");

      await sendPostRequest(0);

       SharedPref().removeUser();

      // try {
      //   if (Platform.isAndroid) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("Android FCM Token Deleted"));
      //   } else if (Platform.isIOS) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("iOS FCM Token Deleted"));
      //   }
      // } on PlatformException {
      //   debugPrint('###PlatformExc');
      // }

      EasyLoading.dismiss();

      Navigator.pushNamedAndRemoveUntil(
          context, SplashScreen.screenName, (r) => false);

      debugPrint("Logout Successful");
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint("LogoutPrefEcx: $error");
    }
  }

  Future<void> sendPostRequest(int flag) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    String? roleId = prefs.getString('roleId');
    String? mobileNoStr = prefs.getString('MobileNo');
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);


    // Fetch app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionNo = packageInfo.version; // Get app version number


    // Debug output
    debugPrint('versionNo: $versionNo');
    debugPrint('distributorId: $distributorId');
    debugPrint('staffId: $staffId');
    debugPrint('activatedOn: $formattedDate');
    debugPrint('mobileNo: $mobileNoStr');

    int distributorIdd = int.tryParse(distributorId ?? '') ?? 0;
    int staffIdd = int.tryParse(staffId ?? '') ?? 0;
    int mobileNo = int.tryParse(mobileNoStr ?? '') ?? 0;



    final Map<String, dynamic> requestBody =
    {
      "VersionNo":versionNo,
      "DistributorId":distributorIdd,
      "StaffId":staffIdd,
      "ActivatedOn":formattedDate,
      "IsActive":flag,
      "RoleId":roleId,
      "MobileNo":mobileNo

    };
    print("MobileStaffwiseVersionAdd: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.MobileStaffwiseVersionAdd}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody MobileStaffwiseVersionAdd: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {

        print("Response MobileStaffwiseVersionAdd: ${response.body}");

        EasyLoading.dismiss();
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

  // Future<void> getDeactiveUserForNotiMob(String flag) async {
  //   EasyLoading.show();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? distributorId = prefs.getString('DistributorId');
  //   String? userId = prefs.getString("UserId");
  //   String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
  //
  //   if (bearerToken == null) {
  //     throw Exception('Bearer token is missing');
  //   }
  //
  //   Map<String, dynamic> requestBody = {
  //     "DistributorId": distributorId,
  //     "UserId": userId
  //   };
  //
  //   final response = await http.get(
  //     Uri.parse('${AppUrl.DeactiveUserForNotiMob}/$distributorId/$userId/$flag'),
  //     headers: {
  //       'Authorization': 'Bearer $bearerToken', // Add Bearer token here
  //     },
  //   );
  //   debugPrint("GetDashPunchSummaryCnt : " +
  //       '${AppUrl.DeactiveUserForNotiMob}/$distributorId/$userId/$flag');
  //   debugPrint("GetDashPunchSummaryCnt : " + '${response.body}');
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     // setState(() {
  //     //   getDashPunchSummaryCntModel = data.map((json) {
  //     //     return GetDashPunchSummaryCntModel.fromJson(json);
  //     //   }).toList();
  //     //
  //     //   // totalExpenseForProfit = expenseReportModel.fold(0.0, (sum, item) {
  //     //   //   return sum! + (item.totExpAmt ?? 0.0);
  //     //   // });
  //     //   // incomeProfit = totalGrossProfit! - totalExpenseForProfit!;
  //     //   // debugPrint("totalGrossProfit $totalGrossProfit");
  //     //   // debugPrint("totalExpenseForProfit $totalExpenseForProfit");
  //     //   // debugPrint("incomeProfit $incomeProfit");
  //     //   // debugPrint("Total Expense: $totalExpenseForProfit");
  //     //   EasyLoading.dismiss();
  //     // });
  //   } else {
  //     EasyLoading.dismiss();
  //     throw Exception('Failed to load items');
  //   }
  // }

  Future<void> getDeactiveUserForNotiMob(String flag) async {
    try {
      EasyLoading.show();

      final prefs = await SharedPreferences.getInstance();
      final String? distributorId = prefs.getString('DistributorId');
      final String? userId = prefs.getString('UserId');
      final String? bearerToken = prefs.getString('token');

      // // Safety checks
      // if (distributorId == null || userId == null || bearerToken == null) {
      //   debugPrint('Logout API skipped: missing user data');
      //   return;
      // }

      final uri = Uri.parse(
        '${AppUrl.DeactiveUserForNotiMob}/$distributorId/$userId/$flag',
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Deactivate API URL: $uri');
      debugPrint('Deactivate API Response: ${response.body}');

      if (response.statusCode != 204) {
        debugPrint('Deactivate API failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Deactivate API error: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Function to show logout confirmation dialog
  void _showLogoutDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogcontext) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () async {
                // Logic for confirming logout
                Navigator.of(dialogcontext).pop(); // Close the dialog
                await logoutUser(parentContext); // Call logout function here
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogcontext).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }
}
