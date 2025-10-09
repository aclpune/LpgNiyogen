import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Styling.dart';

import '../User/splashscreen/page/splash_screen.dart';
import '../Utils/shared_preference.dart';
import 'ARBReturnScreen/ArbReturnScreen.dart';
import 'ARBSaleScreen/ArbSaleScreen.dart';
import 'ARBScreen/ArbScreen.dart';
import 'CashDepositToBankScreen.dart';
import 'CashHandoverScreen.dart';
import 'PaymentReceiptScreen/PaymentReceiptScreen.dart';
import 'ReceiptRegulatorScreen/ReceiptRegulatorScreen.dart';
import 'SVSaleReportScreen.dart';
import 'SalaryPaymentScreen/SalaryPaymentScreen.dart';
import 'TVSaleScreen/TVSalesScreen.dart';
import 'UpdatePaymentsScreen/UpdatePaymentScreen.dart';
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
    var argLRAdd = ModalRoute.of(context)?.settings.arguments;
    return  WillPopScope(
      onWillPop: () async {
        if (argLRAdd == "fromDrawer") {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        } else {
          Navigator.pushReplacementNamed(context, '/bottomNavBarExample');
          return false;
        }
      },
      child: Scaffold(
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
                        child: Text("Daily Transaction",style:Styling.itemGreyTextBigMore,),
                      ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child:
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, SVSaleReportScreen.screenName
                                  );
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.sell_outlined),
                                            SizedBox(width: 10,),
                                            Text("SV Sale",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, TVSalesScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          children: [
                                            Icon(Icons.receipt_outlined),
                                            SizedBox(width: 10,),
                                            Text("TV Receipt",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),

                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, PaymentReceiptScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                
                                        Row(
                                          children: [
                                            Icon(Icons.payment_outlined),
                                            SizedBox(width: 10,),
                                            Text("Payments Receipt",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),
                                
                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, UpdatePaymentScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                
                                        Row(
                                          children: [
                                            Icon(Icons.update),
                                            SizedBox(width: 10,),
                                            Text("Update Payments",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),
                                
                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, SalaryPaymentScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                
                                        Row(
                                          children: [
                                            Icon(Icons.payments_outlined),
                                            SizedBox(width: 10,),
                                            Text("Salary Payments",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),
                                
                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, CashHandoverScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                
                                        Row(
                                          children: [
                                            Icon(Icons.comment_bank_outlined),
                                            SizedBox(width: 10,),
                                            Text("Cash Handover-Bank Deposit",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),
                                
                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                              Container(height: 1,color: Colors.grey[300],),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, ReceiptRegulatorScreen.screenName);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Row(
                                          children: [
                                            Icon(Icons.broken_image_outlined),
                                            SizedBox(width: 10,),
                                            Text("Receipt Defective Regulator",style: Styling.itemBlackTestMore,),
                                          ],
                                        ),

                                        Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                      ],
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text("ARB",style:Styling.itemGreyTextBigMore,),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 1,
                        color: Colors.white,
                        child:
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, ArbScreen.screenName
                                );
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.payments_outlined),
                                          SizedBox(width: 10,),
                                          Text("ARB Purchase",style: Styling.itemBlackTestMore,),
                                        ],
                                      ),
                                      Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                    ],
                                  )
                              ),
                            ),
                            Container(height: 1,color: Colors.grey[300],),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushReplacementNamed(context, ArbReturnScreen.screenName);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(
                                        children: [
                                          Icon(Icons.assignment_return_outlined),
                                          SizedBox(width: 10,),
                                          Text("ARB Purchase Return",style: Styling.itemBlackTestMore,),
                                        ],
                                      ),

                                      Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                    ],
                                  )
                              ),
                            ),
                            Container(height: 1,color: Colors.grey[300],),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushReplacementNamed(context, ArbSaleScreen.screenName);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Row(
                                        children: [
                                          Icon(Icons.sell_outlined),
                                          SizedBox(width: 10,),
                                          Text("ARB Sale",style: Styling.itemBlackTestMore,),
                                        ],
                                      ),

                                      Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text("LOGOUT",style:Styling.itemGreyTextBigMore,),
                      ),
                      GestureDetector(
                        onTap: (){
                          _showLogoutDialog(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 1,
                          color: Colors.white,
                          child:
                          Column(
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
                                          Icon(Icons.logout_outlined),
                                          SizedBox(width: 10,),
                                          Text("Logout",style: Styling.itemBlackTestMore,),
                                        ],
                                      ),

                                      Icon(Icons.arrow_forward_ios_sharp,color: Colors.grey,size: 20,),
                                    ],
                                  )
                              ),

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
