import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../GodownKeeper/BottomNavigationForGodownKeeper.dart';
import '../../../GodownKeeper/DashboardScreen.dart';
import '../../../ManagerScreen/BootomNavigatinBarManager.dart';
import '../../../ManagerScreen/ManagerDashboard.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/shared_preference.dart';
import '../../Login/Screen/MyLogin.dart';
import 'dart:io' as io;

class SplashScreen extends StatefulWidget {
  static const screenName = '/splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = '';

  String? roleId, isUserActive,userActivet;

  @override
  void initState() {
    super.initState();

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
              Image.asset(
                'assets/logonew.png',  // Path to your image
                height: 250, // Adjust the height as needed
                width: 250,  // Adjust the width as needed
              ),
              SizedBox(height: 10),
              Text(
                "Version: " + "2.0.3",
                style: Styling.itemBlackTestSmall,
              )
            ],
          )
              //child: Text('Logo'),
              ),
        ),
      ),
    );
  }

  Future<void> navigateToDashboard() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      roleId = preferences.getString('roleId');
      userActivet = preferences.getString('userActive');
      debugPrint("roleId $roleId");
      debugPrint(userActivet);

        if (userActivet == "Y") {
        if (roleId != null) {
          if(roleId == Constants.roleIdGodown){
            Navigator.pushReplacementNamed(context, BottomNavigationForGodownKeeper.screenName,
                arguments: "checkVersion");
          }else if(roleId == Constants.roleIdManager){
            Navigator.pushReplacementNamed(context, BottomNavBarExample.screenName,
                arguments: "checkVersion");
          }else if(roleId == Constants.roleIdOwner){
            Navigator.pushReplacementNamed(context, BottomNavBarExample.screenName,
                arguments: "checkVersion");
          }
          else{
            Navigator.pushReplacementNamed(context, MyLogin.screenName);
          }

        } else if (roleId == Constants.roleIdOwner) {
          if (mounted) {
          }
        }else{
          Navigator.pushReplacementNamed(context, MyLogin.screenName);
        }
      } else {
        debugPrint("Deactivated User");
        Navigator.pushReplacementNamed(context, MyLogin.screenName);
      }
    } catch (error) {
      rethrow;
    }
  }


}
