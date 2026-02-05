import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/Styling.dart';
import '../Utils/app_url.dart';
import '../Utils/shared_preference.dart';
import 'ItemReceipt/AddItem/ItemReceiptScreen.dart';
import 'ItemReceipt/ItemReturn/ItenRetun.dart';
import 'ItemReceipt/ItemReturnXMI/screen/AddReturnItemXMIScreen.dart';
import 'ItemReceipt/ItemReturnXMI/screen/ItemReturnXMIListScreen.dart';
import 'MarkDefective/MarkDefectiveItemScreen.dart';

class MoreOptionScreenGodownKeeper extends StatefulWidget {
  static const screenName = '/moreOptionScreenGodownKeeper';

  const MoreOptionScreenGodownKeeper({super.key});

  @override
  State<MoreOptionScreenGodownKeeper> createState() =>
      _MoreOptionScreenGodownKeeperState();
}

class _MoreOptionScreenGodownKeeperState
    extends State<MoreOptionScreenGodownKeeper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
              context, '/bottomNavigationForGodownKeeper');
          return false;
        } else {
          Navigator.pushReplacementNamed(
              context, '/bottomNavigationForGodownKeeper');
          return false;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // Ensures the content is scrollable
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, right: 5.0, bottom: 5.0, top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Item Receipt/Return",
                          style: Styling.itemGreyTextBigMore,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, ItemReceiptScreen.screenName);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                              Icons.receipt),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Item Receipt",
                                            style: Styling.itemBlackTestMore,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, ItemReturnScreen.screenName);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                              Icons.assignment_return_outlined),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Item Return",
                                            style: Styling.itemBlackTestMore,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "EXMI/Rev-EMR",
                          style: Styling.itemGreyTextBigMore,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, AddReturnItemXMIScreen.screenName);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                              Icons.assignment_return_outlined),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Return EXMI/Rev-EMR",
                                            style: Styling.itemBlackTestMore,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, ItemReturnXMIListScreen.screenName);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.receipt),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Receipt EXMI",
                                            style: Styling.itemBlackTestMore,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Mark Defective",
                          style: Styling.itemGreyTextBigMore,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, MarkDefectiveItemScreen.screenName);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Mark Defective",
                                            style: Styling.itemBlackTestMore,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "LOGOUT",
                          style: Styling.itemGreyTextBigMore,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.logout_outlined),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Logout",
                                            style: Styling.itemBlackTestMore,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  )),
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

      sendPostRequest(0);

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

  // Function to show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                // Logic for confirming logout
                Navigator.of(context).pop(); // Close the dialog
                logoutUser(context); // Call logout function here
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }
}
