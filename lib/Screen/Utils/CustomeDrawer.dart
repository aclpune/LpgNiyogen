import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lpgsalesandinventory/Screen/Utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../User/splashscreen/page/splash_screen.dart';

class CustomeDrawer extends StatelessWidget {
  Future<String> getGodownName() async {
    // Fetch Godown name from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String godownName = prefs.getString('StaffName') ?? 'Cylinder Godown';
    return godownName;
  }

  Future<String> getGodownNId() async {
    // Fetch Godown name from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String godownId = prefs.getString('StaffId') ?? ' ';
    return godownId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getGodownName(), // Get the Godown name from SharedPreferences
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Drawer(
            child: Center(child: CircularProgressIndicator()), // Show loading spinner while waiting
          );
        }

        if (snapshot.hasError) {
          return Drawer(
            child: Center(child: Text('Error loading data')),
          );
        }

        // Use the fetched godown name
        String godownName = snapshot.data ?? 'Cylinder Godown';
        String id = snapshot.data ?? 'Cylinder Godown';
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer Header with Godown Name from SharedPreferences
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Column(
                  children: [
                    Text(
                      '$godownName', // Display the Godown name here
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Drawer items (navigate to different screens)
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // Navigate to home screen if required
                },
              ),
              ListTile(
                leading: Icon(Icons.receipt),
                title: Text('Item Receipt'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/itemWiseReceipt');
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment_return_outlined),
                title: Text('Item Return'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/itemReturnScreen');
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment_return_outlined),
                title: Text('Return EXMI/Rev-EMR'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/addReturnItemXMIScreen');
                },
              ),
              ListTile(
                leading: Icon(Icons.receipt),
                title: Text('Receipt EXMI'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/itemReturnXMIListScreen');
                },
              ),
              /*ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Item'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/editItemReceiptPage');
                },
              ),*/
              // ListTile(
              //   leading: Icon(Icons.update_outlined),
              //   title: Text('Update Sale'),
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, '/stockReturnFromDelBoy');
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.update_outlined),
              //   title: Text('Del Update Sale'),
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, '/stockSubmitToManager');
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  logoutUser(context);
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.logout),
              //   title: Text('cashHandoverScreen'),
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, '/cashHandoverScreen');
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.logout),
              //   title: Text('cashDepositToBankScreen'),
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, '/cashDepositToBankScreen');
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.logout),
              //   title: Text('managerUpdateSaleScreen'),
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, '/managerUpdateSaleCashUpdation');
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.logout),
              //   title: Text('deliveryBoyWiseListShow'),
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, '/deliveryBoyWiseListShow');
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.logout),
              //   title: Text('Dashboard'),
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, '/managerDashboardScreen');
              //   },
              // ),
              // ListTile(
              //   leading: Icon(Icons.logout),
              //   title: Text('DSRReport'),
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, '/managerDSRReportScreen');
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    ///Save data before logout logic
    EasyLoading.show(status: 'Loading...');

    try {
      SharedPref().removeUser();

      // try {
      //   if (Platform.isAndroid) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("Android FCM Token Deleted"));
      //   } else if (Platform.isIOS) {
      //     await FirebaseMessaging.instance
      //         .deleteToken()
      //         .whenComplete(() => debugPrint("iOS FCM Token Deleted"));
      //   }
      // } on PlatformException {
      //   debugPrint('###PlatformExc');
      // }

      EasyLoading.dismiss();

      Navigator.pushNamedAndRemoveUntil(
          context, SplashScreen.screenName, (r) => false);

      debugPrint("Logout Successful");
    } catch (error) {
      EasyLoading.dismiss();
      debugPrint("LogoutPrefEcx: $error");
    }
  }

}
