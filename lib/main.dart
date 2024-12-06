import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'Screen/GodownKeeper/DashboardScreen.dart';
import 'Screen/GodownKeeper/DelBoyStockReturn/StockReturnFromDelBoy.dart';
import 'Screen/GodownKeeper/ItemReceipt/AddItem/ItemReceiptScreen.dart';
import 'Screen/GodownKeeper/ItemReceipt/EditItem/ItemEditScreen.dart';
import 'Screen/GodownKeeper/ItemReceipt/ItemReturn/ItenRetun.dart';
import 'Screen/User/ForgetPassword/Screen/ForgetPassword.dart';
import 'Screen/User/ForgetPassword/provider/forget_password_provider.dart';
import 'Screen/User/Login/Screen/MyLogin.dart';
import 'Screen/User/Login/provider/LoginProvider.dart';
import 'Screen/User/splashscreen/page/splash_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    //todo check proper solution for ssl certificate for production mode
  }
}

void main() {
  /// Http ssl certificate...
  HttpOverrides.global = MyHttpOverrides();
  runApp(
      const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ],
        child:
        MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Login Registration',
          builder: EasyLoading.init(),
          theme: ThemeData(
            primaryColor: const Color(0xff1280b3),
            fontFamily: 'OpenSans',
            textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              headlineMedium: const TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              headlineSmall: const TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              headlineLarge: const TextStyle(
                fontFamily: 'OpenSans',
                color: Color(0xff1280b3),
                fontWeight: FontWeight.normal,
                fontSize: 18,
              ),
              displaySmall: const TextStyle(
                fontFamily: 'OpenSans',
                color: Color(0xff666666),
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              labelLarge: const TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff1280b3),
              titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          home: SplashScreen(),
          routes: {
            SplashScreen.screenName: (context) => SplashScreen(),
            MyLogin.screenName: (context) => MyLogin(),
            ForgetPassword.screenName: (context) => ForgetPassword(),
            DashboardScreen.screenName: (context) => DashboardScreen(),
            ItemReceiptScreen.screenName: (context) => ItemReceiptScreen(),
            DailyRefillSalePage.screenName: (context) => DailyRefillSalePage(),
            EditItemReceiptPage.screenName: (context) => EditItemReceiptPage(),
            ItemReturnScreen.screenName: (context) => ItemReturnScreen(),
          },
        ),
      );
  }
}

