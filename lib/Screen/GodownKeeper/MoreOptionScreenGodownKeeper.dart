import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/Styling.dart';
import '../Utils/shared_preference.dart';
import 'ItemReceipt/ItemReturn/ItenRetun.dart';
import 'ItemReceipt/ItemReturnXMI/screen/AddReturnItemXMIScreen.dart';
import 'ItemReceipt/ItemReturnXMI/screen/ItemReturnXMIListScreen.dart';
import 'MarkDefective/MarkDefectiveItemScreen.dart';

class MoreOptionScreenGodownKeeper extends StatefulWidget {
  static const screenName = '/moreOptionScreenGodownKeeper';

  const MoreOptionScreenGodownKeeper({super.key});

  @override
  State<MoreOptionScreenGodownKeeper> createState() =>
      _MoreOptionScreenGodownKeeperState();
}

class _MoreOptionScreenGodownKeeperState
    extends State<MoreOptionScreenGodownKeeper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(
              context, '/bottomNavigationForGodownKeeper');
          return false;
        } else {
          Navigator.pushReplacementNamed(
              context, '/bottomNavigationForGodownKeeper');
          return false;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // Ensures the content is scrollable
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, right: 5.0, bottom: 5.0, top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Item Return",
                          style: Styling.itemGreyTextBigMore,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, ItemReturnScreen.screenName);
                        },
                        child: Card(
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
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                              Icons.assignment_return_outlined),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Item Return",
                                            style: Styling.itemBlackTestMore,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "EXMI/Rev-EMR",
                          style: Styling.itemGreyTextBigMore,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, AddReturnItemXMIScreen.screenName);
                        },
                        child: Card(
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
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                              Icons.assignment_return_outlined),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Return EXMI/Rev-EMR",
                                            style: Styling.itemBlackTestMore,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, ItemReturnXMIListScreen.screenName);
                        },
                        child: Card(
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
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.receipt),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Receipt EXMI",
                                            style: Styling.itemBlackTestMore,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Mark Defective",
                          style: Styling.itemGreyTextBigMore,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, MarkDefectiveItemScreen.screenName);
                        },
                        child: Card(
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
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Mark Defective",
                                            style: Styling.itemBlackTestMore,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "LOGOUT",
                          style: Styling.itemGreyTextBigMore,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                        child: Card(
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
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.logout_outlined),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Logout",
                                            style: Styling.itemBlackTestMore,
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
