import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../ConstantScreen/widgets.dart';
import '../../../Utils/app_url.dart';
import '../../../Utils/constants.dart';
import '../model/LoginResponseModel.dart'; // Assuming this is the response model
import '../../../Utils/shared_preference.dart'; // Assuming sharedPref utility is already there
import '../ApiService/AuthService.dart'; // Assuming this contains the `login` and `refreshToken` functions
import 'package:flutter/foundation.dart';
import 'dart:convert';

enum Status {
  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut
}

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  LoginResponseModel? _loginResponse;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  LoginResponseModel? get loginResponse => _loginResponse;

  Status _loggedInStatus = Status.notLoggedIn;

  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
    notifyListeners();
  }

  // Method for login functionality
  Future<void> login(String mobileNo,
      BuildContext context) async {
    // Check if any required field is empty
    bool isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;

      if (mobileNo.isEmpty) {
        // Show error message if any field is empty
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all the fields')),
        );
        return; // Exit early
      }
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        if(isNetworkAvailable) {
        final authService = AuthService();
        final response = await authService.login(mobileNo);

        _loginResponse = response;
        _errorMessage = null;
        // Save the token and user info in SharedPreferences
        final sharedPref = SharedPref();
        // await sharedPref.setAuthToken(_loginResponse!.authToken!); // Save the auth token
        await sharedPref.saveUser(_loginResponse!.authToken!);
        await sharedPref.setUserName("N");
        Navigator.pushReplacementNamed(context, '/verifyOtp');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        debugPrint("dashbpa");
        debugPrint("dashbpa${response.authToken}");
        debugPrint("dashbpa${_loginResponse!.authToken!}");

      }else{
      showFlushBar(context,
          Constants.connectionMessage);
    }
      } catch (e) {
        _errorMessage = e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
        );
      } finally {
        _isLoading = false;
        notifyListeners();
      }

  }

  // Method to refresh the token
  Future<Map<String, dynamic>> refreshToken(
      String mobileNo,
      BuildContext context,) async {
    var result;

    // Prepare the request data for refreshing the token
    final Map<String, dynamic> refreshTokenData = {
    "MobileNo" :mobileNo,
    "GrantType": Constants.grantTypeRefreshToken,
    };

    loggedInStatus = Status.authenticating;
    notifyListeners();
    Constants.isNetworkAvailable =
    await InternetConnectionChecker().hasConnection;
    if(Constants.isNetworkAvailable){
      try {
        // Make the API call
        Response response = await post(
          Uri.parse(AppUrl.login), // You might want to replace this with your actual refresh token endpoint
          body: json.encode(refreshTokenData),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        );

        debugPrint('RefreshTokenResCode: ${response.statusCode}');
        debugPrint('RefreshTokenParams: $refreshTokenData');
        debugPrint('RefreshTokenParams body: ${response.request}');
        debugPrint('RefreshTokenParams response: ${response.body}');
        debugPrint('RefreshTokenParams response1: ${response.toString()}');

        // Handle successful response
        if (response.statusCode == Constants.success) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          debugPrint('RefreshTokenResponseData: $responseData');

          // var userInfoData = responseData['authToken']['UserInfo'];
          var authTokenData = responseData['authToken'];

          // Parse the user and token data
          AuthToken authToken = AuthToken.fromJson(authTokenData);

          // Save user and token to SharedPreferences
          SharedPref().saveUser(authToken);

          loggedInStatus = Status.loggedIn;
          notifyListeners();

          result = {'status': true, 'message': 'Successful', 'user': authToken};

        } else if (response.statusCode == Constants.tokenExpireAuth) {
          // Handle token expiration case
          loggedInStatus = Status.notLoggedIn;
          notifyListeners();
          result = {'status': false, 'message': 'Token Expired'};
        } else {
          // Handle failure case
          loggedInStatus = Status.notLoggedIn;
          notifyListeners();
          result = {
            'status': false,
            'message': json.decode(response.body)['error'],
          };
        }
      } catch (error) {
        debugPrint('RefreshTokenException: $error');
        loggedInStatus = Status.notLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': 'An error occurred: ${error.toString()}'};
      }
    }else{
      showFlushBar(context,
      Constants.connectionMessage);
    }


    return
    result;
  }

  static onError(error) {
    debugPrint('Error: ${error.detail}');
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}

