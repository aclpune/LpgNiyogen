import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../GodownKeeper/DashboardScreen.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/shared_preference.dart';
import '../../Login/Screen/MyLogin.dart';


class SplashScreen extends StatefulWidget {
  static const screenName = '/splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = '';

  String? roleId, isUserActive;

  @override
  void initState() {
    super.initState();

    // SharedPref().setDashboardApiCallStatus("Pending");
    // SharedPref().setDashboardCountApiCallStatusForNA("Pending");
    // SharedPref().setDashboardCountApiCallStatusForTP("Pending");

    // getVersionName().whenComplete(() {
    //   setState(() {});
    // });

    Future.delayed(const Duration(milliseconds: 3000), () async {
      navigateToDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset('assets/login.png'),
              Text(
                "LPG Niyogen",
              ),
              Text(
                "Version: " + version.toString(),
              )
            ],
          )
              //child: Text('Logo'),
              ),
        ),
      ),
    );
  }

  // Future<String> getVersionName() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   version = packageInfo.version;
  //
  //   debugPrint('Version::: ' + version.toString());
  //   return version;
  // }

  Future<void> navigateToDashboard() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userId = preferences.getString('userId');
      roleId = preferences.getString('roleId');
      isUserActive = preferences.getString('IsActive').toString();
      debugPrint(userId);
      debugPrint(roleId);

      //if (isUserActive == "Y") {
      if (userId != null) {
        //if (isUserActive == "Y") {
        if (roleId == Constants.roleIdGodown) {
          Navigator.pushReplacementNamed(context, DashboardScreen.screenName,
              arguments: "checkVersion");
        } else if (roleId == Constants.roleIdOwner) {
          if (mounted) {

          }
        }
      } else {
        debugPrint("UserId- null");
        Navigator.pushReplacementNamed(context, MyLogin.screenName);
      }
      /*} else {
        debugPrint("Deactivated User");
        Navigator.pushReplacementNamed(context, Login.screenName);
      }*/
    } catch (error) {
      rethrow;
    }
  }
}
