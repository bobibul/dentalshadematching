import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/constants.dart';
import 'package:medical_app/pages/appointment.dart';
import 'package:medical_app/pages/home_page.dart';
import 'package:medical_app/pages/schedule.dart';
import 'package:medical_app/util/banner.dart';
import 'package:medical_app/util/helpers/symtomes.dart';
import 'package:medical_app/util/helpers/text_helper.dart';
import 'package:medical_app/util/navigation_bottom.dart';
import 'package:medical_app/util/symptomes.dart';

import '../util/doctors.dart';
import '../util/helpers/doctors.dart';
import '../util/text.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List pages = [HomePage(), Schedule()];

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: AppBottomNavigation(
          currentIndex: pageIndex,
          onBindingPage: (index) {
            if (index > 1) {
              return;
            }
            setState(() {
              pageIndex = index;
            });
          },
        ),
        backgroundColor: Colors.grey[100],
        body: pages[pageIndex]);
  }
}
