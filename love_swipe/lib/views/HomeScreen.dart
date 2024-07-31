import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:love_swipe/views/tab_screens/Chats.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';
import 'tab_screens/ProfileTab.dart';
import 'tab_screens/ShuffleTab.dart';
import 'tab_screens/StoriesTab.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const HomeScreen({super.key, required this.toggleTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final VoidCallback toggleTheme;
  late final List<Widget> _tabs;

  @override
  void initState() {
    toggleTheme = widget.toggleTheme;
    _tabs = [
      const StoriesTab(),
      const Chats(),
      const ShuffleTab(),
      ProfileTab(
        toggleTheme: toggleTheme,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedIconTheme: const IconThemeData(color: AppColors.pinkColor),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme:  IconThemeData(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
        selectedItemColor: AppColors.pinkColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off_sharp),
            label: 'Hikayeler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Mesajlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on_sharp),
            label: 'Shuffle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
