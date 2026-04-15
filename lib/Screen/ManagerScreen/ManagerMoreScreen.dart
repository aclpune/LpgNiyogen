import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/BlinkingText.dart';
import '../Utils/app_url.dart';
import '../Utils/constants.dart';
import '../Utils/shared_preference.dart';
import 'ARBReturnScreen/ArbReturnScreen.dart';
import 'ARBSaleScreen/ArbSaleScreen.dart';
import 'ARBScreen/ArbScreen.dart';
import 'CashDepositToBankScreen.dart';
import 'CashHandoverScreen.dart';
import 'ConfigurationScreen.dart';
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
  String? roleId, isUserActive,userActivet;

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

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
                      Visibility(
                        visible: roleId == Constants.roleIdOwner,
                        child:
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 10.0),
                        //   child: Text("Admin Settings",style:Styling.itemGreyTextBigMore,),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child:  Row(
                            children: [
                              Text("Admin Settings - ",style:Styling.itemGreyTextBigMore,),
                              const SizedBox(width: 5),
                              BlinkingText(
                                text: "New",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: roleId == Constants.roleIdOwner,
                        child:
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacementNamed(context, Configurationscreen.screenName);
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
                                            Icon(Icons.settings_applications),
                                            SizedBox(width: 10,),
                                            Text("Configuration",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),

                              ],
                            ),
                          ),
                          // Padding(
                          //     padding: const EdgeInsets.all(10.0),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //
                          //         Row(
                          //           children: [
                          //             Icon(Icons.settings_applications),
                          //             SizedBox(width: 10,),
                          //             Text("Cofiguration",style: Styling.itemBlackTestMore,),
                          //           ],
                          //         ),
                          //
                          //         Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                          //       ],
                          //     )
                          // ),
                        ),
                      ),
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
  //
  //     sendPostRequest(0);
  //
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

      // await getDeactiveUserForNotiMob("N");
      await getDeactiveUserForNotiMobD("N");

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


  Future<void> getDeactiveUserForNotiMob(String flag) async {
    try {
      EasyLoading.show();

      final prefs = await SharedPreferences.getInstance();
      final String? distributorId = prefs.getString('DistributorId');
      final String? userId = prefs.getString('UserId');
      final String? bearerToken = prefs.getString('token');
      final deviceId = await getDeviceId();
      debugPrint("dhghkggeedsd $deviceId");

      // // Safety checks
      // if (distributorId == null || userId == null || bearerToken == null) {
      //   debugPrint('Logout API skipped: missing user data');
      //   return;
      // }

      final uri = Uri.parse(
        '${AppUrl.DeactiveUserForNotiMob}/$distributorId/$userId/$flag/$deviceId',
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

  Future<void> getDeactiveUserForNotiMobD(String flag) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? userId = prefs.getString("UserId");
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final deviceId = await getDeviceId();
    debugPrint("dhghkggeedsd $deviceId");

    final Map<String, dynamic> requestBody =
    {
      "MobDeviceId":deviceId,
      "DistributorId":distributorId,
      "UserId":userId,
      "ActiveStatus":flag,


    };
    print("DeactiveUserForNotiMob: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });
    // try {
    final response = await http.post(
      Uri.parse('${AppUrl.DeactiveUserForNotiMob}'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
      body: json.encode(requestBody),
    );
    print(
        "requestBody DeactiveUserForNotiMob: ${response.statusCode} - ${response.request}${requestBody}");

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body == '0') {
        // Show a user-friendly error if the response body is 0
        EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
        print("Error: Response returned 0");
      } else {

        print("Response DeactiveUserForNotiMob: ${response.body}");

        EasyLoading.dismiss();
      }
    } else {
      print("Error DeactiveUserForNotiMob: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

  // Function to show logout confirmation dialog
  // void _showLogoutDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Confirm Logout"),
  //         content: Text("Are you sure you want to logout?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               // Logic for confirming logout
  //               Navigator.of(context).pop(); // Close the dialog
  //               logoutUser(context); // Call logout function here
  //             },
  //             child: Text("Yes"),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: Text("No"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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

  Future<void> getUserDetail() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? fetchedRoleId = preferences.getString('roleId');
      String? fetchedUserActive = preferences.getString('userActive');
      debugPrint("roleId $fetchedRoleId");
      debugPrint(fetchedUserActive);

      setState(() {
        roleId = fetchedRoleId;
        userActivet = fetchedUserActive;
      });
    } catch (error) {
      rethrow;
    }
  }

  static Future<String?> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      }
    } catch (e) {
      debugPrint("Device ID error: $e");
    }

    return null;
  }
}
