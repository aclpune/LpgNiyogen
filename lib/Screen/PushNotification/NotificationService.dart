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
//   // static Future<void> showNotification(
//   //     String title,
//   //     String body, {
//   //       required bool playSound,
//   //     }) async {
//   //   final AndroidNotificationDetails androidDetails =
//   //   AndroidNotificationDetails(
//   //     'file_import_channel',
//   //     'File Import Status',
//   //     channelDescription: 'Notification for file import status',
//   //     importance: Importance.max,
//   //     priority: Priority.high,
//   //     playSound: playSound,
//   //     sound: playSound
//   //         ? const RawResourceAndroidNotificationSound('notification')
//   //         : null,
//   //   );
//   //
//   //   final DarwinNotificationDetails iosDetails =
//   //   DarwinNotificationDetails(
//   //     presentAlert: true,
//   //     presentBadge: true,
//   //     presentSound: playSound,
//   //   );
//   //
//   //   final NotificationDetails details = NotificationDetails(
//   //     android: androidDetails,
//   //     iOS: iosDetails,
//   //   );
//   //
//   //   await _notificationsPlugin.show(
//   //     DateTime.now().millisecondsSinceEpoch ~/ 1000,
//   //     title,
//   //     body,
//   //     details,
//   //   );
//   // }
//
//   static Future<void> showNotification(
//       String title,
//       String body,
//       ) async {
//     final bool playSound = await canPlaySound();
//
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
//
//     /// 🔑 Mark sound as played AFTER first notification
//     if (playSound) {
//       await markSoundPlayed();
//     }
//   }
//
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


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';

class NotificationService {
  // Single instance of FlutterLocalNotificationsPlugin
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

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
  static Future<void> showNotification(String title, String body) async {
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

    // Show the notification
    await _localNotifications.show(
      0,      // Notification ID
      title,  // Notification title
      body,   // Notification body
      platformDetails,
    );
  }

  // iOS callback for older devices (< iOS 10)
  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    debugPrint('iOS Local Notification Received: $title, $body');
  }

  // Called when notification is tapped
  static void onSelectNotification(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // You can navigate to a screen here if needed
  }
}