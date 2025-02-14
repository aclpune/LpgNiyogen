import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

import '../../../Utils/app_url.dart';
import '../model/LoginResponseModel.dart';

class AuthService {

  // Create an insecure HTTP client to bypass certificate validation
  http.Client get _httpClient {
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Ignore cert validation
    return IOClient(ioClient);
  }

  Future<LoginResponseModel> login(String mobileNo) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "MobileNo": mobileNo, // Replace with dynamic values if needed
      "GrantType": "password",
    });

    try {
      final client = _httpClient; // Use the custom HTTP client
      final response = await client.post(
        Uri.parse(AppUrl.login),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        debugPrint(response.body);
        debugPrint('success');
        return LoginResponseModel.fromJson(jsonDecode(response.body));

      } else {
        throw Exception("Invalid User..!");
        // throw Exception("Failed to login: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Invalid User..!");
    }
  }
}
