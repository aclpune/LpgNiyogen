import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
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

  // Check for update and show dialog if an update is available
  static void checkForUpdate(BuildContext context) async {
    String currentVersion = '';
    String latestVersion = await fetchLatestAppVersion();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    currentVersion = packageInfo.version;
    debugPrint("Current Version: $currentVersion");
    debugPrint("Fetched Version: $latestVersion");

    if (currentVersion != latestVersion) {
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
                    // Replace with your app's Play Store link
                    await launch('https://play.google.com/store/apps/details?id=lpg.niyojan.lpgsalesandinventory');
                  } else if (Platform.isIOS) {
                    // Replace with your app's App Store link
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
}