import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lpgsalesandinventory/Screen/Utils/app_url.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationApiHelper {
  // Replace with your backend API URL
  /// Send FCM token, user ID, platform, and bearer token to backend
  static Future<void> sendTokenToBackend() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Get FCM token for this device
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      String? bearerToken = prefs.getString('token');
      String? addedBy = prefs.getString('StaffId');
      String? userName = prefs.getString('StaffName');
      String? userId = prefs.getString('UserId');
      String? mobileNo = prefs.getString('MobileNo');
      String? roleId = prefs.getString('roleId');
      String? distId = prefs.getString('DistributorId');
      String currentVersion = '';
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      currentVersion = packageInfo.version;

      debugPrint("fcm token send $fcmToken");
      if (fcmToken == null) {
        print('FCM token not available');
        return;
      }

      // Detect platform
      String platform = Platform.isAndroid ? 'Android' : 'iOS';
      final deviceId = await getDeviceId();
      debugPrint("dhghkgge $deviceId");

      // Build payload
      Map<String, dynamic> payload = {
        'pkActiveUserId':0,
        'DistributorId':distId,
        'UserId':userId,
        'Username':userName,
        'MobileNo':mobileNo,
        'RoleId':roleId,
        'VersionNo':currentVersion,
        'ApplActiveFrom':'',
        'LastSeen':'',
        'DeviceId':fcmToken,
        'ActiveStatus':'Y',
        'UninstallStatus':null,
        'UninstalledDate':null,
        'Platform':platform,
        'MobDeviceId':deviceId,
      };


      print('Sending device token to backend: $payload');

      // Send POST request to backend
      final response = await http.post(
        Uri.parse('${AppUrl.SaveDistribuotrDeviceId}'),
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

  static Future<String?> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      }
    } catch (e) {
      debugPrint("Device ID error: $e");
    }

    return null;
  }
}
