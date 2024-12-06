import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../../Utils/app_url.dart';
import '../../../Utils/constants.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  Future<Map<String, dynamic>> forgotPassword(String distributorCode, String userName) async {
    var result;

    final Map<String, dynamic> forgetPassData = {
      "DistCode": distributorCode,
      "Username" : userName,
    };

    notifyListeners();

    try {
      Response response = await post(
        Uri.parse(AppUrl.forgotPassword),
        body: json.encode(forgetPassData),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      debugPrint('ForgetPassResCode: ' + response.statusCode.toString());

      if (response.statusCode == Constants.success) {
        //final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint('ForgetPassParam: ' + forgetPassData.toString());
        debugPrint('ForgetPassResponse: ' + json.decode((response.body)));
        String value = json.decode((response.body));

        notifyListeners();

        result = {'status': true, 'message': 'Successful', 'value': value};
      } else {
        notifyListeners();
        result = {
          'status': false,
          'message': json.decode(response.body)['error']
        };
      }
    } catch (error) {
      debugPrint('ForgotPassExc: ' + error.toString());
    }

    return result;
  }
}



// class ForgotPasswordProvider extends ChangeNotifier {
//   Future<Map<String, dynamic>> forgotPassword(String email) async {
//     var result = <String, dynamic>{};
//
//     final Map<String, dynamic> forgetPassData = {
//       "Email": email.trim(),
//     };
//
//     try {
//       final response = await post(
//         Uri.parse(AppUrl.forgotPassword),
//         body: json.encode(forgetPassData),
//         headers: {'Content-Type': 'application/json; charset=UTF-8'},
//       );
//
//       if (response.statusCode == 200) {
//         final String responseData = response.body;
//
//         // Assuming the response is just a string ("Success")
//         if (responseData == "Success") {
//           result = {
//             'status': true,
//             'message': 'Password reset request successful',
//             'value': responseData,
//           };
//         } else {
//           result = {
//             'status': false,
//             'message': responseData ?? 'Unknown error occurred',
//           };
//         }
//       } else {
//         result = {
//           'status': false,
//           'message': 'Failed to reset password',
//         };
//       }
//     } catch (error) {
//       result = {
//         'status': false,
//         'message': error.toString(),
//       };
//     }
//
//     return result;
//   }
// }

