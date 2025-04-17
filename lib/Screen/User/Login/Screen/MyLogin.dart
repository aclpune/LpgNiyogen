import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpgsalesandinventory/Screen/User/Login/provider/LoginProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ConstantScreen/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../Utils/UpdateService.dart';

class MyLogin extends StatefulWidget {
  static const screenName = '/login';
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final _mobileNoController = TextEditingController();
  bool _isHidden = true;
  String? _userName, _password;
  final key = encrypt.Key.fromUtf8('8080808080808080'); //16 chars
  final iv = encrypt.IV.fromUtf8('8080808080808080'); //16 chars

  Future<Map<String, String?>> getStoredUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('userName');  // Retrieve username
    String? storedDistributorCode = prefs.getString('distributorCode');    // Retrieve login ID
    return {'username': storedUsername, 'loginId': storedDistributorCode};
  }

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      UpdateService.checkForUpdate(context);
      debugPrint("Firebase initialize Dash${Platform}");
    }else{
      debugPrint("Firebase not initialize");
    }
    _loadStoredUserData();
  }

  Future<void> _loadStoredUserData() async {
    Map<String, String?> storedUserData = await getStoredUserData();
    String? storedUsername = storedUserData['username'];
    String? storedMobileNo = storedUserData['MobileNo'];

    if (storedMobileNo != null) {
      setState(() {
        _mobileNoController.text = storedMobileNo;
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body:
        SingleChildScrollView(
              child:
              Container(
                margin: EdgeInsets.only(left: 40,right: 40,top: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icononlytransparentnobuffer.png',  // Path to your image
                      height: 150, // Adjust the height as needed
                      width: 150,  // Adjust the width as needed
                    ),
                    SizedBox(height: 50),
                    TextField(
                      controller: _mobileNoController,
                      keyboardType: TextInputType.number, // Set keyboard type to numeric
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),// Allow only digits
                      ],
                      decoration: InputDecoration(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Mobile Number',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 4),
                            // Add some space between the text and the icon
                            Icon(
                              Icons.star, // Use a star or any other icon
                              color: Colors.red, // Set the icon color to red
                              size: 10, // Adjust the size of the icon
                            ),
                          ],
                        ),
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
                        onPressed: () {
                                final loginProvider = Provider.of<LoginProvider>(context, listen: false);
                                // final encryptedPassword = encryptPassword(_passwordController.text,context);
                                loginProvider.login(
                                  _mobileNoController.text,
                                  context,
                                );
                        },
                        child: Center( // Align the text in the center
                          child: Text('Login', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16)),
                        ),
                      ),
                    ),
                    // Loading Indicator
                    Consumer<LoginProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return CircularProgressIndicator();
                        }

                        if (provider.errorMessage != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              provider.errorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 16.0),
                            ),
                          );
                        }

                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

}



