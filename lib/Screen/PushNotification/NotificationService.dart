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
