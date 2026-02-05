import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ConstantScreen/widgets.dart';
import '../../../GodownKeeper/BottomNavigationForGodownKeeper.dart';
import '../../../GodownKeeper/DashboardScreen.dart';
import '../../../ManagerScreen/BootomNavigatinBarManager.dart';
import '../../../ManagerScreen/ManagerDashboard.dart';
import '../../../Utils/app_url.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/shared_preference.dart';
import 'MyLogin.dart';
class VerifyOtp extends StatefulWidget {
  static const screenName = '/verifyOtp';
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final _otpController = TextEditingController();
  String? storeOTP;
  String? roleId,userActivet;

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () async {
            Navigator.pushReplacementNamed(
                context, MyLogin.screenName);
            return false;
          // In case `null` is returned, return `false`
        },
        child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child:
            Container(
              margin: EdgeInsets.only(left: 40,right: 40,top: 60),
              child:
              Column(
                children: [
                  Image.asset(
                    'assets/icononlytransparentnobuffer.png',  // Path to your image
                    height: 150, // Adjust the height as needed
                    width: 150,  // Adjust the width as needed
                  ),

                  SizedBox(height: 40),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number, // Set keyboard type to numeric
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),// Allow only digits
                    ],
                    decoration: InputDecoration(
                      labelText: 'OTP',
                      labelStyle: TextStyle(fontSize: 12),
                      prefixIcon: Icon(Icons.account_circle_sharp),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      border: OutlineInputBorder(
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14.0, // Adjust the text size here
                    ),
                  ),
                  SizedBox(height: 30.0),
                  // Login button
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),// This ensures the button takes up full width
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40), // The button takes up full width
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () async {
                        String currentOtp = _otpController.text;
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        storeOTP = prefs.getString('OTP');
                       if(storeOTP == currentOtp){
                         final sharedPref = SharedPref();
                         await sharedPref.setUserName("Y");
                         // ScaffoldMessenger.of(context).showSnackBar(
                         //   SnackBar(content: Text('OTP Verified..!')),
                         // );
                         await getUserData();

                         sendPostRequest(1);

                         // Navigator.pushReplacementNamed(context, '/godownDashboard');
                       }else{
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('OTP not match..!')),
                         );
                       }
                      },
                      child: Center( // Align the text in the center
                        child: Text('Verify', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16)),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        "OTP Guide",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                        SizedBox(height: 7,),
                        countTextWidgetOptSteps(context," Login to the ","Niyojan Portal"),
                        SizedBox(height: 4,),
                        countTextWidgetOptSteps(context,"	Go to ","Masters"),
                        SizedBox(height: 4,),
                        countTextWidgetOptSteps(context," Select ","Staff"),
                        SizedBox(height: 4,),
                        countTextWidgetOptSteps(context," Search with your ","mobile number"),
                        SizedBox(height: 4,),
                        countTextWidgetOptSteps(context," View  ","OTP column"),
                    ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
            ),
      );
  }
  Future<void> getUserData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    roleId = preferences.getString('roleId');
    userActivet = preferences.getString('userActive');
    debugPrint(roleId);
    debugPrint(userActivet);

    if (userActivet == "Y") {
      if (roleId != null) {
        if(roleId == Constants.roleIdGodown){
          Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName,
              arguments: "checkVersion");

        }else if(roleId == Constants.roleIdManager){
          Navigator.pushReplacementNamed(context, BottomNavBarExample.screenName,
              arguments: "checkVersion");
        }else if(roleId == Constants.roleIdOwner){
          Navigator.pushReplacementNamed(context, BottomNavBarExample.screenName,
              arguments: "checkVersion");
        }
        else{
          Navigator.pushReplacementNamed(context, MyLogin.screenName);
        }

      } else if (roleId == Constants.roleIdOwner) {
        if (mounted) {
        }
      }else{
        Navigator.pushReplacementNamed(context, MyLogin.screenName);
      }
    } else {
      debugPrint("Deactivated User");
      Navigator.pushReplacementNamed(context, MyLogin.screenName);
    }
  }

  Future<void> sendPostRequest(int flag) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    String? activatedOn = prefs.getString('activatedOn');
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

        // setState(() {
        // });
        EasyLoading.dismiss();
      }
    } else {
      print("Error PaymentDetailAddEdit: ${response.statusCode} - ${response.body}");
      EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }
}
