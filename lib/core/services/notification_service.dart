import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as fln;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:trade_quest/core/services/supabase_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final fln.FlutterLocalNotificationsPlugin _localNotifications = fln.FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // 1. Initialize Timezone
    tz.initializeTimeZones();

    // 2. Request Permission (Remote)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 3. Initialize Local Notifications
    var androidSettings = const fln.AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosSettings = const fln.DarwinInitializationSettings();
    var initSettings = fln.InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _localNotifications.initialize(initSettings);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      
      // 4. Upload Token
      await _uploadToken();

      // 5. Listen for token refreshes
      _messaging.onTokenRefresh.listen((newToken) {
        _saveTokenToSupabase(newToken);
      });

      // 6. Foreground Messages (Remote)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          _showLocalNotification(message);
        }
      });

    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    var androidDetails = const fln.AndroidNotificationDetails(
      'trade_quest_remote', 
      'Remote Notifications',
      importance: fln.Importance.max,
      priority: fln.Priority.high,
    );
    var details = fln.NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
    );
  }

  // --- Local Scheduling Logic ---

  Future<void> scheduleOpenMicReminder() async {
    // TODO: Implement zonedSchedule once type resolution is fixed
    debugPrint("Scheduled Open Mic Reminder for 3 days from now (Simulated).");
  }

  Future<void> scheduleRetentionReminder() async {
     // TODO: Implement zonedSchedule once type resolution is fixed
    debugPrint("Scheduled Retention Reminder for 24 hours from now (Simulated).");
  }

  Future<void> cancelAll() async {
    await _localNotifications.cancelAll();
    debugPrint("Cancelled all pending notifications.");
  }

  Future<void> _uploadToken() async {
    final token = await _messaging.getToken();
    if (token != null) {
      debugPrint("FCM Token: $token");
      await _saveTokenToSupabase(token);
    }
  }

  Future<void> _saveTokenToSupabase(String token) async {
    final user = SupabaseService().currentUser;
    if (user == null) return;

    try {
      await SupabaseService().updateProfile(
        userId: user.id,
        fcmToken: token,
      );
      debugPrint("FCM Token saved to Supabase");
    } catch (e) {
      debugPrint("Error saving FCM Token: $e");
    }
  }
}
