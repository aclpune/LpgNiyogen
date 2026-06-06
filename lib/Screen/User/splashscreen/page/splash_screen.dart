import 'package:flutter/material.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../newTheam/core/theme/app_colors.dart';
import '../../../GodownKeeper/BottomNavigationForGodownKeeper.dart';
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

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: Scaffold(
  //       backgroundColor: Colors.white,
  //       body: Container(
  //         padding: const EdgeInsets.all(16),
  //         child: Center(
  //             child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             // Image.asset('assets/login.png'),
  //             Image.asset(
  //               'assets/logonew.png',  // Path to your image
  //               height: 250, // Adjust the height as needed
  //               width: 250,  // Adjust the width as needed
  //             ),
  //             SizedBox(height: 10),
  //
  //             Text(
  //               "Version: " + "3.0.6",
  //               style: Styling.itemBlackTestSmall,
  //             )
  //           ],
  //         )
  //             //child: Text('Logo'),
  //             ),
  //       ),
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration:  BoxDecoration(
            gradient: AppColors.gradHero,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo with glow container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.5),
                  ),
                  child: Image.asset(
                    'assets/playstore.png',
                    height: 120,
                    width: 120,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Niyojan',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'LPG Sales & Inventory',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 48),
                // Loading indicator
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Version 3.0.6',
                  style: TextStyle(fontSize: 12, color: Colors.white54, letterSpacing: 0.3),
                ),
              ],
            ),
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

