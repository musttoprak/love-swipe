import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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
  if (!runingNotification) {
    await LocalNotifications.init();
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      DateTime.now().second.toString(),
      taskName,
      frequency: const Duration(minutes: 5),
    );
  }
  final theme = prefs.getString('themeMode') ?? 'system';
  runApp(MyApp(isLoggedIn: isLoggedIn, theme: theme));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final String theme;

  const MyApp({super.key, required this.isLoggedIn, required this.theme});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    print(widget.theme);
    setState(() {
      switch (widget.theme) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
    });
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = mode;
    });
    await prefs.setString('themeMode', mode.toString().split('.').last);
  }

  Future<void> _toggleTheme() async {
    final newThemeMode =
        (_themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    await _saveThemeMode(newThemeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Love Swipe',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF69B4),
        primarySwatch: Colors.pink,
        canvasColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFF69B4),
          onPrimary: Colors.white,
          secondary: Color(0xFFFF69B4),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xFFFF69B4),
        primarySwatch: Colors.pink,
        canvasColor: const Color(0xFF313131),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF69B4),
          onPrimary: Colors.white,
          secondary: Color(0xFFFF69B4),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Color(0xFF313131),
          onSurface: Colors.white,
        ),
      ),
      themeMode: _themeMode,
      home: widget.isLoggedIn
          ? HomeScreen(
              toggleTheme: _toggleTheme,
            )
          : LoginScreen(
              toggleTheme: _toggleTheme,
            ),
    );
  }
}
