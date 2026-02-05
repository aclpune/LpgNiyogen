import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'app_url.dart';
class UpdateService {
  // Fetch the latest app version from Firebase Remote Config
  static Future<String> fetchLatestAppVersion() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    // Set cache expiration to 0 for testing
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 10),
        minimumFetchInterval: Duration.zero, // Disable caching for testing
      ),
    );

    await remoteConfig.setDefaults(<String, dynamic>{
      'latest_app_version': '1.0.0',
    });

    try {
      // Fetch remote config values
      await remoteConfig.fetchAndActivate();
      String latestVersion = remoteConfig.getString('latest_app_version');
      return latestVersion;
    } catch (e) {
      print('Error fetching remote config: $e');
      return '1.0.0'; // Default version in case of error
    }
  }

  // // Check for update and show dialog if an update is available
  // static void checkForUpdate(BuildContext context) async {
  //   String currentVersion = '';
  //   String latestVersion = await fetchLatestAppVersion();
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   currentVersion = packageInfo.version;
  //   debugPrint("Current Version: $currentVersion");
  //   debugPrint("Fetched Version: $latestVersion");
  //
  //   if (currentVersion != latestVersion) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Update Available'),
  //           content: Text(
  //               'A new version of the app is available. Please update to version $latestVersion.'),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text('Update Now'),
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 if (Platform.isAndroid) {
  //                   // Replace with your app's Play Store link
  //                   await launch('https://play.google.com/store/apps/details?id=lpg.niyojan.lpgsalesandinventory');
  //                 } else if (Platform.isIOS) {
  //                   // Replace with your app's App Store link
  //                   await launch('https://apps.apple.com/app/idXXXXXXXXX');
  //                 }
  //               },
  //             ),
  //             TextButton(
  //               child: Text('Later'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  static Future<void> checkForUpdate(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    String latestVersion = await fetchLatestAppVersion();
    debugPrint("Current Version: $currentVersion");
    debugPrint("Fetched Version: $latestVersion");

    Version currentVer = Version.parse(currentVersion);
    Version latestVer = Version.parse(latestVersion);


    //Version greaterVersion = currentVer.compareTo(latestVer) >= 0 ? currentVer : latestVer;
    //
    // // --- Check if app was just updated ---
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? lastVersion = prefs.getString('lastAppVersion');

    // if (lastVersion != currentVersion) {
    //   debugPrint("App just updated: $lastVersion -> $currentVersion");
    //
    //   // Call your API with the greater version
    //   try {
    //     await sendPostRequest(greaterVersion.toString(), 1);
    //   } catch (e) {
    //     debugPrint("Error sending POST request: $e");
    //   }
    //
    //   // Update stored version
    //   prefs.setString('lastAppVersion', currentVersion);
    // }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Only send API if user is logged in
    // if (token != null && token.isNotEmpty) {
    //   String? lastVersion = prefs.getString('lastAppVersion');
    //
    //   if (lastVersion != currentVersion) {
    //     debugPrint("App just updated: $lastVersion -> $currentVersion");
    //
    //     try {
    //       // Send the installed version (or greater version if needed)
    //       await sendPostRequest(currentVersion, 1);
    //     } catch (e) {
    //       debugPrint("Error sending POST request: $e");
    //     }
    //
    //     prefs.setString('lastAppVersion', currentVersion);

    //   }
    // } else {
    //   debugPrint("User not logged in. Skipping version update API.");
    // }
    if (token != null && token.isNotEmpty) {
      if (currentVersion == latestVersion) {
        String? lastVersion = prefs.getString('lastAppVersion');

        if (lastVersion != currentVersion) {
          debugPrint("User installed the latest version: $currentVersion");

          try {
            await sendPostRequest(currentVersion, 1); // Send installed version
          } catch (e) {
            debugPrint("Error sending POST request: $e");
          }

          prefs.setString('lastAppVersion', currentVersion);
        }
      }
    } else {
      debugPrint("User not logged in. Skipping version update API.");
    }


    // --- Show update dialog if outdated ---
    if (currentVer < latestVer) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Available'),
            content: Text(
                'A new version of the app is available. Please update to version $latestVersion.'),
            actions: <Widget>[
              TextButton(
                child: Text('Update Now'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (Platform.isAndroid) {
                    await launch(
                        'https://play.google.com/store/apps/details?id=lpg.niyojan.lpgsalesandinventory');
                  } else if (Platform.isIOS) {
                    await launch('https://apps.apple.com/app/idXXXXXXXXX');
                  }
                },
              ),
              TextButton(
                child: Text('Later'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
}

