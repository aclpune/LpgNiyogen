import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'Utils/app_url.dart';


class IosVersionUpdateCheck {
  final String appStoreUrl = 'https://apps.apple.com/us/app/lpg-niyojan/id6748051208'; // Replace with your App Store URL

  Future<void> checkForUpdate(BuildContext context) async {
    try {
      // Get current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
        debugPrint("Current app ersion ios $currentVersion");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? bearerToken = prefs.getString('token'); // Assuming the token is stored here

      if (bearerToken == null) {
        throw Exception('Bearer token is missing');
      }
      final response = await http.get(
        Uri.parse('${AppUrl.GetLatestVersionDetails}'),
        headers: {
          'Authorization': 'Bearer $bearerToken', // Add Bearer token here
        },
      );
      debugPrint("request body ${AppUrl.GetLatestVersionDetails}");
      debugPrint("response body ${response.body}");
      if (response.statusCode == 200) {
        String latestVersion = jsonDecode(response.body);
        debugPrint("response bodyv ${latestVersion}");
        if (currentVersion != latestVersion) {
          _showUpdateDialog(context,latestVersion);
        }
      }
    } catch (e) {
      print('Version check failed: $e');
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
          TextButton(
            child: Text('Later'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}