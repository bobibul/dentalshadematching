import 'package:flutter/material.dart';

import '../constants.dart';

class AppBottomNavigation extends StatefulWidget {
  final Function(int) onBindingPage;
  final int currentIndex;
  const AppBottomNavigation({super.key,required this.onBindingPage,
  required this.currentIndex});

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
        onTap: widget.onBindingPage,
        currentIndex: widget.currentIndex,
        backgroundColor: colors['white-color'],
        elevation: 100,
        selectedItemColor:Colors.purple[800],
        selectedFontSize: 17,
        iconSize: 29,
        unselectedItemColor: Colors.grey[400],
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
            fontSize: 17
        ),

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Schedule"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),

          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      );

  }
}
