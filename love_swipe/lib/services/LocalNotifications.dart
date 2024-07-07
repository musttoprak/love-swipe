import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

// on tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

// initialize the local notifications
  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }


  // to show periodic notification at regular interval
  static Future showPeriodicNotifications() async {
    print("SHOW NOTİFİCATİON");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int notificationCount = prefs.getInt('notificationCount') ?? 0;
    print("SHOW NOTİFİCATİON COUNT : $notificationCount");
    if (notificationCount < 7) {
      List<String> images = prefs.getStringList('images') ?? [];
      List<String> messages = prefs.getStringList('messages') ?? [];
      List<String> users = prefs.getStringList('users') ?? [];
      print(
          "SHOW NOTİFİCATİON isEmpty : ${images.isEmpty || messages.isEmpty || users.isEmpty}");
      if (images.isEmpty || messages.isEmpty || users.isEmpty) {

        List<String> images = await loadAsset('assets/bot_image.txt');
        List<String> messages = await loadAsset('assets/bot_message.txt');
        List<String> users = await loadAsset('assets/bot_user.txt');

        await prefs.setStringList('images', images);
        await prefs.setStringList('messages', messages);
        await prefs.setStringList('users', users);
        await prefs.setInt('notificationCount', 0);
        print("images ${images.length}");
        print("message ${messages.length}");
        print("users ${users.length}");
        await showPeriodicNotifications();
        return;
      }
      print(notificationCount);
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'com.android.application', 'com.example.love_swipe',
          importance: Importance.max, priority: Priority.high);
      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('channel 2', 'your channel name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      //await _flutterLocalNotificationsPlugin.periodicallyShow(
      //  notificationCount,
      //  users[notificationCount],
      //  messages[notificationCount],
      //  RepeatInterval.everyMinute,
      //  notificationDetails,
      //  androidAllowWhileIdle: true
      //);

      print("SHOW NOTİFİCATİON show : true");

      notificationCount++;
      await prefs.setInt('notificationCount', notificationCount);
    }else {
      await cancelAll();
    }
  }

  static Future<List<String>> loadAsset(String path) async {
    String content = await rootBundle.loadString(path);
    List<String> allItems = content.split('\n');
    allItems.shuffle();
    return allItems.take(7).toList();
  }


  // close a specific channel notification
  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // close all the notifications available
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
