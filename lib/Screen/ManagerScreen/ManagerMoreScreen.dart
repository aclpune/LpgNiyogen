import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';

import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/shared_preference.dart';
class ManagerMoreScree extends StatefulWidget {
  static const screenName = '/managerMoreScree';
  const ManagerMoreScree({super.key});

  @override
  State<ManagerMoreScree> createState() => _ManagerMoreScreeState();
}

class _ManagerMoreScreeState extends State<ManagerMoreScree> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: _scaffoldKey,
      body:
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // Ensures the content is scrollable
                child:
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, right:5.0, bottom: 5.0, top: 10.0),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text("CASH",style:Styling.itemGreyTextBigMore,),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title for Cylinder Categories Table
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.business_center_outlined),
                                        SizedBox(width: 10,),
                                        Text("Cash Handover",style: Styling.itemBlackTestMore,),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                  ],
                                )
                              ),
                              Container(
                                height: 1,
                                color: Colors.grey[200],
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.add_business_outlined),
                                          SizedBox(width: 10,),
                                          Text("Cash Deposit To Bank",style: Styling.itemBlackTestMore,),
                                        ],
                                      ),
                                      Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text("LOGOUT",style:Styling.itemGreyTextBigMore,),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 1,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title for Cylinder Categories Table
                            Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        _showLogoutDialog(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.logout_outlined),
                                          SizedBox(width: 10,),
                                          Text("Logout",style: Styling.itemBlackTestMore,),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                  ],
                                )
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

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

  // Function to show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                // Logic for confirming logout
                Navigator.of(context).pop(); // Close the dialog
                logoutUser(context); // Call logout function here
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }
}
