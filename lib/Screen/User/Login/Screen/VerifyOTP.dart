import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/shared_preference.dart';
class VerifyOtp extends StatefulWidget {
  static const screenName = '/verifyOtp';
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final _otpController = TextEditingController();
  String? storeOTP;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child:
          Container(
            margin: EdgeInsets.only(left: 40,right: 40),
            child: Column(
              children: [
                Image.asset(
                  'assets/redlockuser.png',  // Path to your image
                  height: 200, // Adjust the height as needed
                  width: 200,  // Adjust the width as needed
                ),
                // Large LOGIN Text
                Text(
                  'Verify OTP',
                  style: TextStyle(
                    fontSize: 32, // Large font size for LOGIN
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
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
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text('OTP Verified..!')),
                       );
                       Navigator.pushReplacementNamed(context, '/godownDashboard');
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
    );
  }
}
