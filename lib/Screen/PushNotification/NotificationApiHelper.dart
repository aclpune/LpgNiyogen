import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationApiHelper {
  // Replace with your backend API URL
  static const String backendUrl = 'https://your-backend.com/api/registerDevice';

  /// Send FCM token, user ID, platform, and bearer token to backend
  static Future<void> sendTokenToBackend() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Get FCM token for this device
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      String? bearerToken = prefs.getString('token');
      String? addedBy = prefs.getString('StaffId');
      if (fcmToken == null) {
        print('FCM token not available');
        return;
      }

      // Detect platform
      String platform = Platform.isAndroid ? 'android' : 'ios';

      // Build payload
      Map<String, dynamic> payload = {
        'userId': addedBy,
        'fcmToken': fcmToken,
        'platform': platform,
      };

      print('Sending device token to backend: $payload');

      // Send POST request to backend
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Device token registered successfully');
      } else {
        print(
            'Failed to register device token. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending token to backend: $e');
    }
  }
}
