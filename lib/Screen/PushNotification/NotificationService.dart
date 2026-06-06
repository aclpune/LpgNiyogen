
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ManagerScreen/BootomNavigatinBarManager.dart';
import '../ManagerScreen/CashHandoverScreen.dart';
import '../ManagerScreen/DashboardItemClickUI/CreditSaleCountDetailListUI.dart';
import '../ManagerScreen/DashboardItemClickUI/UnsettledSaleDetailList.dart';

class NotificationService {


  // Single instance of FlutterLocalNotificationsPlugin
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  /// Pass your app's navigatorKey here
  //static late GlobalKey<NavigatorState> navigatorKey;
  static GlobalKey<NavigatorState>? navigatorKey;

  static Map<String, dynamic>? _pendingArguments;


  /// Route pending navigation
  static String? _pendingRoute;
  static bool _navigationInProgress = false;

  // Initialize notifications for Android and iOS
  static Future<void> init() async {
    // Android settings
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    final DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    // Combined settings
    final InitializationSettings settings =
    InitializationSettings(android: androidSettings, iOS: iosSettings);



    // Initialize plugin
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: onSelectNotification,
    );
  }


  // Show notification (call this from foreground or background)
  static Future<void> showNotification(String title, String body,String identifier) async {
    // Android notification details
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'file_import_channel', // Channel ID
      'File Import Status',  // Channel name
      channelDescription: 'Notification for file import status',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    // iOS notification details
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Combined platform details
    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    int notificationId = getNotificationIdByTitle(identifier);

    // Show the notification
    await _localNotifications.show(
      notificationId,      // Notification ID
      title,  // Notification title
      body,   // Notification body
      platformDetails,
      payload: identifier
    );
  }
  /// Map titles to IDs (for Android notifications)
  static int getNotificationIdByTitle(String title) {
    switch (title) {
      case 'Total Outstanding Pending':
        return 1;
      case 'Prepaid cashmemo punching status':
        return 2;
      case 'Total Credit Amt':
        return 3;
      case 'Total Unsettled sale':
        return 4;
      case 'Refill Booking source status':
        return 5;
      case 'Cashmemo punching type status':
        return 6;
      case 'Cash in hand status':
        return 7;
      default:
        return 0;
    }
  }

  // iOS callback for older devices (< iOS 10)
  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    debugPrint('iOS Local Notification Received: $title, $body');
  }

  // Called when notification is tapped
  // static void onSelectNotification(NotificationResponse response) {
  //   debugPrint('Notification tapped: ${response.payload}');
  //   // You can navigate to a screen here if needed
  // }

  /// Called when user taps notification
  static void onSelectNotification(NotificationResponse response) {
    String? title = response.payload;
    debugPrint('--- Notification tapped ---');
    debugPrint('Title received: $title');

    if (title == null) return;


    // Determine route based on title
    String routeName;
    // String routeName = ManagerDashboardScreen.screenName;

    switch (title) {
      case 'Cash in hand status':
        routeName = CashHandoverScreen.screenName;
        break;
    // case 'Cashmemo punching type status':
    //   // routeName = ManagerDashboardScreen.screenName;
    //   routeName = BottomNavBarExample.screenName;
    //   break;
      case 'Cashmemo punching type status':
        _pendingRoute = BottomNavBarExample.screenName;
        _pendingArguments = {
          "tabIndex": 0,
          "openCashmemoSheet": true,
        };
        _tryNavigate();
        return;
      case 'Refill Booking source status':
        _pendingRoute = BottomNavBarExample.screenName;
        _pendingArguments = {
          "tabIndex": 0,
          "refillBooking": true,
        };
        _tryNavigate();
        return;
      case 'Total Unsettled sale':
        routeName = UnsettledSaleDetailList.screenName;
        break;
      case 'Total Credit Amt':
        routeName = CreditSaleCountDetailListUI.screenName;
        break;
      case 'Prepaid cashmemo punching status':
        _pendingRoute = BottomNavBarExample.screenName;
        _pendingArguments = {
          "tabIndex": 0,
          "openPrepaidSheet": true,
        };
        _tryNavigate();
        return;
      default:
        routeName = BottomNavBarExample.screenName;
    }
    _pendingRoute = routeName;
    _tryNavigate();
  }


  /// Try to navigate safely
  // static void _tryNavigate() async {
  //   if (_pendingRoute == null || _navigationInProgress) return;
  //
  //   _navigationInProgress = true;
  //   int attempts = 0;
  //   const maxAttempts = 20;
  //   const delay = Duration(milliseconds: 250);
  //
  //   while (navigatorKey?.currentState == null && attempts < maxAttempts) {
  //     debugPrint('Navigator not ready, delaying...');
  //     await Future.delayed(delay);
  //     attempts++;
  //   }
  //
  //   if (navigatorKey?.currentState != null) {
  //     navigatorKey?.currentState!.pushReplacementNamed(
  //       _pendingRoute!,
  //       arguments: _pendingArguments,
  //     );
  //     _pendingRoute = null;
  //     _pendingArguments = null;
  //   }
  //   _navigationInProgress = false;
  // }



  static void _tryNavigate() async {
    if (_pendingRoute == null || _navigationInProgress) return;

    _navigationInProgress = true;

    bool loggedIn = await _isLoggedIn();

    if (!loggedIn) {
      navigatorKey?.currentState!
          .pushNamedAndRemoveUntil("/login", (route) => false);

      _pendingRoute = null;
      _pendingArguments = null;
      _navigationInProgress = false;
      return;
    }

    // If logged in → continue navigation
    int attempts = 0;
    const maxAttempts = 20;
    const delay = Duration(milliseconds: 250);

    while (navigatorKey?.currentState == null && attempts < maxAttempts) {
      await Future.delayed(delay);
      attempts++;
    }

    if (navigatorKey?.currentState != null) {
      navigatorKey?.currentState!.pushReplacementNamed(
        _pendingRoute!,
        arguments: _pendingArguments,
      );
    }

    _pendingRoute = null;
    _pendingArguments = null;
    _navigationInProgress = false;
  }

  static Future<bool> _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }


}


// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   /// =========================
//   /// Initialization
//   /// =========================
//   static Future<void> init() async {
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     final DarwinInitializationSettings iosSettings =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
//     );
//
//     final InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await _notificationsPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//     );
//   }
//
//   /// =========================
//   /// Show Notification
//   /// =========================
//   static Future<void> showNotification(
//       String title,
//       String body, {
//         required bool playSound,
//       }) async {
//     final AndroidNotificationDetails androidDetails =
//     AndroidNotificationDetails(
//       'file_import_channel',
//       'File Import Status',
//       channelDescription: 'Notification for file import status',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: playSound,
//       sound: playSound
//           ? const RawResourceAndroidNotificationSound('notification')
//           : null,
//     );
//
//     final DarwinNotificationDetails iosDetails =
//     DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: playSound,
//     );
//
//     final NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await _notificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       details,
//     );
//   }
//
//   /// =========================
//   /// Sound Control Helpers
//   /// =========================
//   static Future<bool> canPlaySound() async {
//     final prefs = await SharedPreferences.getInstance();
//     return !(prefs.getBool('soundPlayed') ?? false);
//   }
//
//   static Future<void> markSoundPlayed() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('soundPlayed', true);
//   }
//
//   static Future<void> resetSoundFlag() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('soundPlayed', false);
//   }
//
//   /// =========================
//   /// Notification Callbacks
//   /// =========================
//   static void _onNotificationTap(NotificationResponse response) async {
//     debugPrint('Notification tapped');
//     await resetSoundFlag(); // 🔑 allow next notification sound
//   }
//
//   static void _onDidReceiveLocalNotification(
//       int id,
//       String? title,
//       String? body,
//       String? payload,
//       ) {
//     debugPrint('iOS < 10 notification: $title - $body');
//   }
// }




