import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'Utils/app_url.dart';


class IosVersionUpdateCheck {
  final String appStoreUrl = 'https://apps.apple.com/us/app/lpg-niyojan/id6748051208'; // Replace with your App Store URL

  // Future<void> checkForUpdate(BuildContext context) async {
  //   try {
  //     // Get current app version
  //     PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //     String currentVersion = packageInfo.version;
  //       debugPrint("Current app ersion ios $currentVersion");
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? bearerToken = prefs.getString('token'); // Assuming the token is stored here
  //
  //     if (bearerToken == null) {
  //       throw Exception('Bearer token is missing');
  //     }
  //     final response = await http.get(
  //       Uri.parse('${AppUrl.GetLatestVersionDetails}'),
  //       headers: {
  //         'Authorization': 'Bearer $bearerToken', // Add Bearer token here
  //       },
  //     );
  //     debugPrint("request body ${AppUrl.GetLatestVersionDetails}");
  //     debugPrint("response body ${response.body}");
  //     if (response.statusCode == 200) {
  //       String latestVersion = jsonDecode(response.body);
  //       debugPrint("response bodyv ${latestVersion}");
  //       if (currentVersion != latestVersion) {
  //         _showUpdateDialog(context,latestVersion);
  //       }
  //     }
  //   } catch (e) {
  //     print('Version check failed: $e');
  //   }
  // }

  Future<void> checkForUpdate(BuildContext context) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      debugPrint("Current app version iOS: $currentVersion");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token');

      if (bearerToken == null || bearerToken.isEmpty) {
        debugPrint("User not logged in. Skipping version API.");
        return;
      }

      final response = await http.get(
        Uri.parse(AppUrl.GetLatestVersionDetails),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (response.statusCode == 200) {
        String latestVersion = jsonDecode(response.body);
        debugPrint("Latest version from API: $latestVersion");

        Version currentVer = Version.parse(currentVersion);
        Version latestVer = Version.parse(latestVersion);

        ///  CALL sendPostRequest ONLY IF USER INSTALLED LATEST VERSION
        if (currentVer == latestVer) {
          String? lastVersion = prefs.getString('lastAppVersion');

          if (lastVersion != currentVersion) {
            debugPrint("User installed latest iOS version: $currentVersion");

            await sendPostRequest(currentVersion, 1);

            prefs.setString('lastAppVersion', currentVersion);
          }
        }

        ///  SHOW UPDATE DIALOG IF OUTDATED
        if (currentVer < latestVer) {
          _showUpdateDialog(context, latestVersion);
        }
      }
    } catch (e) {
      debugPrint('iOS Version check failed: $e');
    }
  }

  static Future<void> sendPostRequest(String latestVersion, int flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? distributorId = prefs.getString('DistributorId');
    String? bearerToken = prefs.getString('token');
    String? staffId = prefs.getString('StaffId');
    String? userId = prefs.getString("UserId");
    String? roleId = prefs.getString('roleId');
    String? mobileNoStr = prefs.getString('MobileNo');
    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    // Fetch app version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionNo = packageInfo.version; // Get app version number

    // Debug output
    debugPrint('versionNo: $versionNo');
    debugPrint('distributorId: $distributorId');
    debugPrint('staffId: $staffId');
    debugPrint('activatedOn: $formattedDate');
    debugPrint('mobileNo: $mobileNoStr');
    debugPrint('latestVersion: $latestVersion');  // Log latest version

    int distributorIdd = int.tryParse(distributorId ?? '') ?? 0;
    int staffIdd = int.tryParse(staffId ?? '') ?? 0;
    int mobileNo = int.tryParse(mobileNoStr ?? '') ?? 0;

    final Map<String, dynamic> requestBody = {
      "VersionNo": latestVersion,  // Use the latest version passed here
      "DistributorId": distributorIdd,
      "StaffId": staffIdd,
      "ActivatedOn": formattedDate,
      "IsActive": flag,
      "RoleId": roleId,
      "MobileNo": mobileNo
    };

    print("MobileStaffwiseVersionAdd: ${requestBody}");
    requestBody.forEach((key, value) {
      print('$key: $value');
    });

    try {
      final response = await http.post(
        Uri.parse('${AppUrl.MobileStaffwiseVersionAdd}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $bearerToken",
        },
        body: json.encode(requestBody),
      );
      print("requestBody MobileStaffwiseVersionAdd: ${response.statusCode} - ${response.request}${requestBody}");

      if (response.statusCode == 200) {
        if (response.body == '0') {
          EasyLoading.showToast("Something went wrong. Please try again.", duration: const Duration(milliseconds: 3000));
          print("Error: Response returned 0");
        } else {
          print("Response MobileStaffwiseVersionAdd: ${response.body}");
          EasyLoading.dismiss();
        }
      } else {
        print("Error MobileStaffwiseVersionAdd: ${response.statusCode} - ${response.body}");
        EasyLoading.showToast("Request failed. Please try again.", duration: const Duration(milliseconds: 3000));
      }
    } catch (e) {
      print("Error: $e");
      EasyLoading.showToast("An error occurred. Please try again.", duration: const Duration(milliseconds: 3000));
    }
  }

  void _showUpdateDialog(BuildContext context, String appVersion) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing without updating
      builder: (context) => AlertDialog(
        title: Text('Update Available'),
        content: Text('A new version of the app is available. Please update to version.$appVersion'),
        actions: [
          TextButton(
            child: Text('Update Now'),
            onPressed: () async {
              final url = Uri.parse(appStoreUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
          // TextButton(
          //   child: Text('Later'),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      ),
    );
  }
}