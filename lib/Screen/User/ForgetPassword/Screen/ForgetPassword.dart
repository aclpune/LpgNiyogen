import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../../../ConstantScreen/widgets.dart';
import '../../../Utils/constants.dart';
import '../../Login/Screen/MyLogin.dart';
import '../provider/forget_password_provider.dart';
class ForgetPassword extends StatefulWidget {
  static const screenName = '/forgotPassword';


  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String? _email;
  String? _distributorCode,_userName;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
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
                            'assets/redlockuser.png',  // Path to your image
                            height: 200, // Adjust the height as needed
                            width: 300,  // Adjust the width as needed
                          ),
                          Text(
                            'Forget Your Password?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Enter your Distributor Code & User Name.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,fontWeight: FontWeight.normal
                            ),
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
                    child:
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            // obscureText: true,
                            autofocus: false,
                            keyboardType: TextInputType.number, // Set keyboard type to numeric
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),// Allow only digits
                            ],
                            onSaved: (value) => _distributorCode = value,
                            decoration: InputDecoration(
                              labelText: 'Distributor Code',
                              labelStyle: TextStyle(fontSize: 12),
                              prefixIcon: Icon(Icons.account_circle_sharp),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                              // hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14.0, // Adjust the text size here
                            ),
                          ),
                          SizedBox(height: 15.0),
                          TextFormField(
                            // obscureText: true,
                            autofocus: false,
                            //validator: validateEmail,
                            onSaved: (value) => _userName = value,
                            decoration: InputDecoration(
                              labelText: 'User Name',
                              labelStyle: TextStyle(fontSize: 12),
                              prefixIcon: Icon(Icons.account_circle_sharp),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                              // hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14.0, // Adjust the text size here
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "You'll receive the updated password on your email, or your distributor's if not provided.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,fontWeight: FontWeight.normal
                            ),
                          ),
                          SizedBox(height: 30.0),
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
                                Constants.isNetworkAvailable =
                                    await InternetConnectionChecker().hasConnection;
                                if (Constants.isNetworkAvailable) {
                                  submitForgetPass();
                                } else {
                                  showFlushBar(context, Constants.connectionTitle,
                                      Constants.connectionMessage);
                                }
                              },
                              child: Center( // Align the text in the center
                                child: Text('Submit', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16)),
                              ),
                            ),
                          ),
                          SizedBox(height:5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, MyLogin.screenName);
                                },
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(color: Colors.blueAccent,fontSize: 14,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
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

  void submitForgetPass() async {
    ForgotPasswordProvider provider =
    Provider.of<ForgotPasswordProvider>(context, listen: false);
    final form = _formKey.currentState;
    // Check if distributorCode or userName is null
    if (_distributorCode == null || _distributorCode!.isEmpty && _userName == null || _userName!.isEmpty) {
      showFlushBar(context, Constants.failed, "All filled is required.");
      debugPrint("_distributorCode $_distributorCode _userName $_userName");
    }else {
      if (form!.validate()) {
        form.save();

        final Future<Map<String, dynamic>> respose =
        provider.forgotPassword(_distributorCode!, _userName!);
        EasyLoading.show(status: 'Loading...');

        try {
          if (respose != "" || respose != "null") {
            respose.then((response) {
              EasyLoading.showSuccess('Successful..');
              if (response['status']) {
                String value = response['value'].toString();

                if (value == 'Success') {
                  debugPrint('ForgetPassRes: Success');
                  showDialogBox(context, () {
                    Navigator.pushNamed(context, MyLogin.screenName);
                  }, Constants.titleSuccess, Constants.titleContent);
                  //navigateToLogin();
                } else {
                  debugPrint('ForgetPassRes: Failed');
                  showFlushBar(
                      context, Constants.failed,
                      "Invalid Distributor Code or Username.");
                }
              } else {
                showFlushBar(
                    context, Constants.failed,
                    Constants.forgetPassFailedMessage);

                debugPrint('ForgetPassStatus - false');
              }
            }).catchError((error) {
              debugPrint('ForgetPassError: ' + error.toString());
              showFlushBar(
                  context, Constants.failed, Constants.forgetPassFailedMessage);
            });
          } else {
            showFlushBar(
                context, Constants.failed, "Enable to send email..!");
          }
        } on HttpException catch (error) {
          showFlushBar(
              context, Constants.failed, Constants.forgetPassFailedMessage);
          debugPrint('LoginHttpExc: ' + error.toString());
        } catch (error) {
          debugPrint('ForgetPassError: ' + error.toString());
        }
      } else {
        showFlushBar(context, 'Invalid email', 'Please enter valid email id');
      }
    }
  }
  // void submitForgetPass() async {
  //   ForgotPasswordProvider provider =
  //   Provider.of<ForgotPasswordProvider>(context, listen: false);
  //   final form = _formKey.currentState;
  //
  //   if (form!.validate()) {
  //     form.save();
  //
  //     Constants.isNetworkAvailable = await InternetConnectionChecker().hasConnection;
  //
  //     if (Constants.isNetworkAvailable) {
  //       EasyLoading.show(status: 'Loading...');
  //
  //       try {
  //         final response = await provider.forgotPassword(_email!);
  //
  //         // if (response['status']) {
  //           EasyLoading.showSuccess('Success');
  //           String value = response['value'].toString();
  //
  //           if (value == 'Success') {
  //             debugPrint('ForgetPassRes: Success');
  //             showDialogBox(context, () {
  //               Navigator.pushNamed(context, MyLogin.screenName);
  //             }, Constants.titleSuccess, Constants.titleContent);
  //           } else {
  //             debugPrint('ForgetPassRes: Failed');
  //             showFlushBar(context, Constants.failed, Constants.emailFailedMessage);
  //           }
  //         // } else {
  //         //   showFlushBar(context, Constants.failed, Constants.forgetPassFailedMessage);
  //         //   debugPrint('ForgetPassStatus - false');
  //         // }
  //       } catch (error) {
  //         showFlushBar(context, Constants.failed, Constants.forgetPassFailedMessage);
  //         debugPrint('ForgetPassError: $error');
  //       } finally {
  //         EasyLoading.dismiss();
  //       }
  //     } else {
  //       showFlushBar(context, Constants.connectionTitle, Constants.connectionMessage);
  //     }
  //   } else {
  //     showFlushBar(context, 'Invalid email', 'Please enter a valid email ID');
  //   }
  // }


  void navigateToLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('New password is sent to your email id.'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, MyLogin.screenName);
              },
              child: const Text('Okay'))
        ],
      ),
    );
  }
}
