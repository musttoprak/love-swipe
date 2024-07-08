import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:love_swipe/constants/app_colors.dart';
import 'package:love_swipe/services/LocalNotifications.dart';
import 'package:love_swipe/views/HomeScreen.dart';
import 'package:love_swipe/views/auth/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

final navigatorKey = GlobalKey<NavigatorState>();
const String taskName = "sendNotification";
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == taskName) {
      await LocalNotifications.showPeriodicNotifications();
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool runingNotification = prefs.getBool('runingNotification') ?? false;
  if(!runingNotification){
    await LocalNotifications.init();
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      DateTime.now().second.toString(),
      taskName,
      frequency: const Duration(minutes: 1),
    );
  }
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Love Swipe',
      theme: ThemeData(
        primaryColor: AppColors.greenColor,
        primarySwatch: Colors.green,
        canvasColor: AppColors.primaryWhiteColor,
      ),
      home: widget.isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
