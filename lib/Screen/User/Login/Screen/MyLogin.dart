import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpgsalesandinventory/Screen/User/Login/provider/LoginProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ConstantScreen/widgets.dart';
import '../../ForgetPassword/Screen/ForgetPassword.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class MyLogin extends StatefulWidget {
  static const screenName = '/login';
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final _distributorCodeController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
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
    _loadStoredUserData();
  }

  Future<void> _loadStoredUserData() async {
    Map<String, String?> storedUserData = await getStoredUserData();
    String? storedUsername = storedUserData['username'];
    String? storedDistributorCode = storedUserData['loginId'];

    // If stored username or login ID exists, pre-fill the fields
    if (storedUsername != null) {
      setState(() {
        _usernameController.text = storedUsername;
      });
    }
    if (storedDistributorCode != null) {
      setState(() {
        _distributorCodeController.text = storedDistributorCode;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 40,right: 40),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/cylinderred.png',  // Path to your image
                      height: 200, // Adjust the height as needed
                      width: 200,  // Adjust the width as needed
                    ),
                    // Large LOGIN Text
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 32, // Large font size for LOGIN
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: _distributorCodeController,
                      keyboardType: TextInputType.number, // Set keyboard type to numeric
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),// Allow only digits
                      ],
                      decoration: InputDecoration(
                        labelText: 'Distributor Code',
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
                    SizedBox(height: 20.0),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'User Name',
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
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isHidden,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 12),
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock),
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                          icon: _isHidden
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        ),
                        filled: true,
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
                                final encryptedPassword = encryptPassword(_passwordController.text,context);
                                loginProvider.login(
                                  _distributorCodeController.text,
                                  _usernameController.text,
                                  encryptedPassword,
                                  _passwordController.text,
                                  context,
                                );
                        },
                        child: Center( // Align the text in the center
                          child: Text('LOG IN', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16)),
                        ),
                      ),
                    ),


                    SizedBox(height: 5.0),
                    // Forgot password link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgotPassword');
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.blueAccent,fontSize: 14,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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

  // String encryptPassword(String? password) {
  //   if (password!.isEmpty) {
  //     throw ArgumentError('Password cannot be empty');
  //   } else{
  //     final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  //   final encryptedData = encrypter.encrypt(password!, iv: iv);
  //   _password = encryptedData.base64.toString();
  //   debugPrint('encryptPass: $_password');
  //   return encryptedData.base64;
  // }
  // }
  String encryptPassword(String? password, BuildContext context) {
    if (password == null || password.isEmpty) {
      // Show an error message if password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password cannot be empty')),
      );
      return ''; // Return an empty string or handle as needed
    } else {
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final encryptedData = encrypter.encrypt(password, iv: iv);
      _password = encryptedData.base64.toString();
      debugPrint('encryptPass: $_password');
      return encryptedData.base64;
    }
  }

}



