import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../ConstantScreen/widgets.dart';
import '../Utils/constants.dart';

class ChangePassword extends StatefulWidget {
  static const screenName = '/changePasswordScreen';

  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isHidden = true;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _passwordError = '';
  // Function to validate password
  bool isPasswordValid(String password) {
    // Regular expression for password validation
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  // Function to compare new and confirm password
  bool arePasswordsMatching() {
    return _newPasswordController.text == _confirmPasswordController.text;
  }
  // Function to validate the password and show real-time feedback
  void _validatePassword() {
    setState(() {
      if (_newPasswordController.text.isEmpty) {
        _passwordError = 'Password is required';
      } else if (!isPasswordValid(_newPasswordController.text)) {
        _passwordError = 'Password must contain uppercase, lowercase, number, and special character';
      } else {
        _passwordError = '';
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/redlockuser.png', // Path to your image
                          height: 200, // Adjust the height as needed
                          width: 300, // Adjust the width as needed
                        ),
                        Text(
                          'Want to change your password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Enter your old pasword and new password.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    left: 35,
                    right: 35,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _oldPasswordController,
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 12),
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.lock),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
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
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(
                            fontSize: 14.0, // Adjust the text size here
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 12),
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.lock),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
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
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(
                            fontSize: 14.0, // Adjust the text size here
                          ),
                          onChanged: (value) => _validatePassword(), // Real-time validation
                        ),
                        if (_passwordError.isNotEmpty)
                          Text(_passwordError, style: TextStyle(color: Colors.red, fontSize: 12)),
                        SizedBox(height: 10.0),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _isHidden,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 12),
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.lock),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
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
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(
                            fontSize: 14.0, // Adjust the text size here
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          // This ensures the button takes up full width
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 40),
                              // The button takes up full width
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () async {
                              // Check internet connectivity
                              bool isNetworkAvailable =
                                  await InternetConnectionChecker()
                                      .hasConnection;

                              if (isNetworkAvailable) {
                                // Validate passwords
                                if (_newPasswordController.text.isEmpty ||
                                    _confirmPasswordController.text.isEmpty ||
                                    _oldPasswordController.text.isEmpty) {
                                  showFlushBar(context,Constants.failed,'Please fill all fields');
                                } else if (!isPasswordValid(
                                    _newPasswordController.text)) {
                                  showFlushBar(context,Constants.failed,'Password must contain upper/lowercase letters, digits, and special characters.');
                                } else if (!arePasswordsMatching()) {
                                  showFlushBar(context,Constants.failed,'New password and confirm password do not match.');
                                } else {
                                  showFlushBar(context,Constants.failed,' match.');

                                  // Call the API to submit the password change
                                  // submitChangePassword();
                                }
                              } else {
                                showFlushBar(context,Constants.failed,'No internet connection');
                              }
                            },
                            child: Center(
                              // Align the text in the center
                              child: Text('Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
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
      ),
    );
  }
}
