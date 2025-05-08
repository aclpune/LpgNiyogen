import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../GodownKeeper/BottomNavigationForGodownKeeper.dart';
import '../../../GodownKeeper/DashboardScreen.dart';
import '../../../ManagerScreen/BootomNavigatinBarManager.dart';
import '../../../ManagerScreen/ManagerDashboard.dart';
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
              child: Column(
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
}
