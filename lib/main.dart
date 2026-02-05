import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'Screen/GodownKeeper/BottomNavigationForGodownKeeper.dart';
import 'Screen/GodownKeeper/DashboardScreen.dart';
import 'Screen/GodownKeeper/DelBoyStockReturn/DeliveryMenListShowScreen.dart';
import 'Screen/GodownKeeper/DelBoyStockReturn/StockReturnFromDelBoy.dart';
import 'Screen/GodownKeeper/DelBoyStockReturn/StockTransferToGodownScreen.dart';
import 'Screen/GodownKeeper/DelBoyStockSubmitToManager/StockSubmitToManager.dart';
import 'Screen/GodownKeeper/DeliveryBoyModel/StockSubmitToManagerListModel.dart';
import 'Screen/GodownKeeper/ItemReceipt/AddItem/ItemReceiptScreen.dart';
import 'Screen/GodownKeeper/ItemReceipt/ItemReturn/ItenRetun.dart';
import 'Screen/GodownKeeper/ItemReceipt/ItemReturnXMI/screen/AddReturnItemXMIScreen.dart';
import 'Screen/GodownKeeper/ItemReceipt/ItemReturnXMI/screen/ItemReturnXMIListScreen.dart';
import 'Screen/GodownKeeper/MoreOptionScreenGodownKeeper.dart';
import 'Screen/ManagerScreen/ARBReturnScreen/ArbReturnScreen.dart';
import 'Screen/ManagerScreen/ARBSaleScreen/ArbSaleScreen.dart';
import 'Screen/ManagerScreen/ARBScreen/AddPaymentPopupScreen.dart';
import 'Screen/ManagerScreen/ARBScreen/ArbScreen.dart';
import 'Screen/ManagerScreen/BootomNavigatinBarManager.dart';
import 'Screen/GodownKeeper/MarkDefective/MarkDefectiveItemScreen.dart';
import 'Screen/ManagerScreen/CashDepositToBankScreen.dart';
import 'Screen/ManagerScreen/CashHandoverScreen.dart';
import 'Screen/ManagerScreen/DSRItemClickUI/ManagerCashInHandScreenDetails.dart';
import 'Screen/ManagerScreen/DSRItemClickUI/ManagerDSRReportScreenDetails.dart';
import 'Screen/ManagerScreen/DSRItemClickUI/ManagerExpenseTabScreenDetails.dart';
import 'Screen/ManagerScreen/DSRItemClickUI/ManagerIncomeUnsettledScreenDetails.dart';
import 'Screen/ManagerScreen/DSRItemClickUI/ManagerCashInHandScreenDetails.dart';
import 'Screen/ManagerScreen/DSRItemClickUI/ManagerDSRReportScreenDetails.dart';
import 'Screen/ManagerScreen/DSRItemClickUI/ManagerExpenseTabScreenDetails.dart';
import 'Screen/ManagerScreen/DSRItemClickUI/ManagerIncomeUnsettledScreenDetails.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/ARBProfitDetailScreenUi.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/CreditSaleCountDetailListUI.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/DashboardPostPaidVerifPendDetails.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/DashboardPrepaidDetails.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/DashboardSVDetails.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/DashboardTVDetails.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/ImbalanceCountClickUI.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/OnAccountPopupScreen.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/PrepaidBookingAndSettlementGraphScreen.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/RefillProfitDetailScreenUi.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/SVProfitdetailScreenUi.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/TodaysCashSummaryOnAccountList.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/UnsettledSaleDetailList.dart';
import 'Screen/ManagerScreen/DashboardItemClickUI/VendorPaymentDetailListUI.dart';
import 'Screen/ManagerScreen/DeliveryBoyWiseListShow.dart';
import 'Screen/ManagerScreen/ExpensesScreen/ExpensesScreenUI.dart';
import 'Screen/ManagerScreen/ExpensesScreen/SalesComparisonScreen.dart';
import 'Screen/ManagerScreen/ManagerDSRReportScreen.dart';
import 'Screen/ManagerScreen/ManagerDashboard.dart';
import 'Screen/ManagerScreen/ManagerMoreScreen.dart';
import 'Screen/ManagerScreen/ManagerUpdateSaleCashUpdation.dart';
import 'Screen/ManagerScreen/ManagerUpdateSaleScreen.dart';
import 'Screen/ManagerScreen/PaymentReceiptScreen/PaymentReceiptScreen.dart';
import 'Screen/ManagerScreen/ReceiptRegulatorScreen/ReceiptRegulatorScreen.dart';
import 'Screen/ManagerScreen/RegulatorItemReceiptScreen.dart';
import 'Screen/ManagerScreen/SVSaleReportScreen.dart';
import 'Screen/ManagerScreen/SalaryPaymentScreen/SalaryPaymentScreen.dart';
import 'Screen/ManagerScreen/TVSaleScreen/TVSalesScreen.dart';
import 'Screen/ManagerScreen/UpdatePaymentsScreen/UpdatePaymentScreen.dart';
import 'Screen/PushNotification/NotificationService.dart';
import 'Screen/UndocumentedSVDash/DashboardUndocumentedDetails.dart';
import 'Screen/User/Login/Screen/MyLogin.dart';
import 'Screen/User/Login/Screen/VerifyOTP.dart';
import 'Screen/User/Login/provider/LoginProvider.dart';
import 'Screen/User/splashscreen/page/splash_screen.dart';
import 'Screen/Utils/size_config.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    //todo check proper solution for ssl certificate for production mode
  }
}
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(
//     RemoteMessage message) async {
//   await Firebase.initializeApp();
//   if (message.notification != null) {
//     await NotificationService.showNotification(
//       message.notification!.title ?? 'Notification',
//       message.notification!.body ?? '',
//     );
//   }
//   print('Background message received: ${message.messageId}');
// }

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase (required in background isolate)
  await Firebase.initializeApp();

  // Only show notification for data-only messages
  // if (message.data.isNotEmpty) {
  //   await NotificationService.showNotification(
  //     message.data['title'] ?? 'Notification',
  //     message.data['body'] ?? '',
  //   );
  // }

  print('Background message received: ${message.messageId}');
}
//
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(
//     RemoteMessage message,
//     ) async {
//   // Initialize Flutter bindings and Firebase for background isolate
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   // Show notification if it exists
//   if (message.notification != null) {
//     await NotificationService.showNotification(
//       message.notification!.title ?? 'Notification',
//       message.notification!.body ?? '',
//     );
//   }
//
//   debugPrint('Background message received: ${message.messageId}');
// }

void main() async{
  /// Http ssl certificate...
  HttpOverrides.global = MyHttpOverrides();
  try{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler);
    // if(Platform.isAndroid){
    //   await Firebase.initializeApp();
    //
    //   debugPrint("Firebase initialize");
    // }else{
    //   debugPrint("Firebase not initialize");
    // }
  }catch(e){
    debugPrint("Firebase not initialize${e.toString()}");
  }
  runApp(
      const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
    return OrientationBuilder(builder: (context, orientation) {
      SizeConfig().init(constraints, orientation);
    return
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginProvider()),
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


            ///GK
            DashboardScreen.screenName: (context) => DashboardScreen(),
            ItemReceiptScreen.screenName: (context) => ItemReceiptScreen(),
            DailyRefillSalePage.screenName: (context) => DailyRefillSalePage(sale:null,saleGKId: null,dMId: null,flagAdd: null),
            ItemReturnScreen.screenName: (context) => ItemReturnScreen(),
            VerifyOtp.screenName: (context) => VerifyOtp(),
            StockSubmitToManager.screenName: (context) => StockSubmitToManager(),
            DeliveryMenListShowScreen.screenName: (context) => DeliveryMenListShowScreen(),
            StockTransferTOGodownScreen.screenName: (context) => StockTransferTOGodownScreen(),
            AddReturnItemXMIScreen.screenName: (context) => AddReturnItemXMIScreen(),
            ItemReturnXMIListScreen.screenName: (context) => ItemReturnXMIListScreen(),
            MarkDefectiveItemScreen.screenName: (context) => MarkDefectiveItemScreen(),
            BottomNavigationForGodownKeeper.screenName: (context) => BottomNavigationForGodownKeeper(),
            MoreOptionScreenGodownKeeper.screenName: (context) => MoreOptionScreenGodownKeeper(),

            ///Manager
            CashHandoverScreen.screenName: (context) => CashHandoverScreen(),
            CashDepositToBankScreen.screenName: (context) => CashDepositToBankScreen(),
            ManagerUpdateSaleScreen.screenName: (context) => ManagerUpdateSaleScreen(),
            ManagerUpdateSaleCashUpdation.screenName: (context) => ManagerUpdateSaleCashUpdation(),
            DeliveryBoyWiseListShow.screenName: (context) => DeliveryBoyWiseListShow(),
            ManagerDashboardScreen.screenName: (context) => ManagerDashboardScreen(),
            ManagerDSRReportScreen.screenName: (context) => ManagerDSRReportScreen(),
            BottomNavBarExample.screenName: (context) => BottomNavBarExample(),
            ManagerMoreScree.screenName: (context) => ManagerMoreScree(),
            ManagerDSRReportScreenDetails.screenName: (context) => ManagerDSRReportScreenDetails(),
            ManagerIncomeUnsettledScreenDetails.screenName: (context) => ManagerIncomeUnsettledScreenDetails(),
            ManagerCashInHandScreenDeails.screenName: (context) => ManagerCashInHandScreenDeails(),
            ManagerExpenseTabScreenDetails.screenName: (context) => ManagerExpenseTabScreenDetails(),
            //ManagerCashInHandScreenDetails.screenName: (context) => ManagerCashInHandScreenDetails(),


            RegulatorItemReceiptScreen.screenName: (context) => RegulatorItemReceiptScreen(),
            ManagerDSRReportScreenDetails.screenName: (context) => ManagerDSRReportScreenDetails(),
            ManagerIncomeUnsettledScreenDetails.screenName: (context) => ManagerIncomeUnsettledScreenDetails(),
            ManagerCashInHandScreenDeails.screenName: (context) => ManagerCashInHandScreenDeails(),
            ManagerExpenseTabScreenDetails.screenName: (context) => ManagerExpenseTabScreenDetails(),
            DashboardPrepaidDetails.screenName: (context) => DashboardPrepaidDetails(),
            DashboardPostPaidVerifPendDetails.screenName: (context) => DashboardPostPaidVerifPendDetails(),
            DashboardSVDetails.screenName: (context) => DashboardSVDetails(),
            DashboardTVDetails.screenName: (context) => DashboardTVDetails(),
            SVSaleReportScreen.screenName: (context) => SVSaleReportScreen(),
            PaymentReceiptScreen.screenName: (context) => PaymentReceiptScreen(),
            UpdatePaymentScreen.screenName: (context) => UpdatePaymentScreen(),
            TodaysCashSummaryOnAccountList.screenName: (context) => TodaysCashSummaryOnAccountList(),
            UnsettledSaleDetailList.screenName: (context) => UnsettledSaleDetailList(),
            ImbalanceCountClickUI.screenName: (context) => ImbalanceCountClickUI(),
            TVSalesScreen.screenName: (context) => TVSalesScreen(),
            SalaryPaymentScreen.screenName: (context) => SalaryPaymentScreen(),
            ArbReturnScreen.screenName: (context) => ArbReturnScreen(),
            ArbSaleScreen.screenName: (context) => ArbSaleScreen(),
            ArbScreen.screenName: (context) => ArbScreen(),
            AddPaymentPopupScreen.screenName: (context) => AddPaymentPopupScreen(),
            OnAccountPopupScreen.screenName: (context) => OnAccountPopupScreen(),
            DashboardUndocumentedDetails.screenName: (context) => DashboardUndocumentedDetails(),
            CreditSaleCountDetailListUI.screenName: (context) => CreditSaleCountDetailListUI(),
            ReceiptRegulatorScreen.screenName: (context) => ReceiptRegulatorScreen(),
            SVProfitDetailScreenUI.screenName: (context) => SVProfitDetailScreenUI(),
            ARBProfitDetailScreenUi.screenName: (context) => ARBProfitDetailScreenUi(),
            RefillProfitDetailScreenUi.screenName: (context) => RefillProfitDetailScreenUi(),
            PrepaidBookingAndSettlementGraphScreen.screenName: (context) => PrepaidBookingAndSettlementGraphScreen(),
            SalesComparisonScreen.screenName: (context) => SalesComparisonScreen(),
            ExpensesScreenUI.screenName: (context) => ExpensesScreenUI(),
            VendorPaymentDetailListUI.screenName: (context) => VendorPaymentDetailListUI(),

            //ManagerCashInHandScreenDetails.screenName: (context) => ManagerCashInHandScreenDetails(),



          },
        ),
      );
    });
    });
  }
}

