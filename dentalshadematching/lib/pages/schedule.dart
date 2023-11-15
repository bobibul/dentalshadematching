import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/util/helpers/schedule.dart';
import 'package:medical_app/util/helpers/text_helper.dart';
import 'package:medical_app/util/navigation_bottom.dart';
import 'package:medical_app/util/schedule_timers.dart';
import 'package:medical_app/util/text.dart';

import '../constants.dart';
import '../util/schedule.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<Schedules> scheduleTyes = [
    Schedules(type: "Upcoming"),
    Schedules(type: "Completed"),
    Schedules(type: "Canceled"),
  ];

  int currentIndex = 0;
  int pageIndex=2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10),
              child: CText(
                text: "Schedule",
                decorations:
                    TextDecorations(fontSize: 35, family: "Roboto Bold"),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 30, left: 10, right: 5),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Color(0xfff4f5f9),
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(6)),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (_, index) {
                                var schedule = scheduleTyes[index];
                                return ScheduleMethod(
                                  onClicked: () {
                                    setState(() {
                                      currentIndex = index;
                                    });
                                  },
                                  color: currentIndex == index
                                      ? colors['primary'] as Color
                                      : Color(0xfff4f5f9),
                                  foreColor: currentIndex == index
                                      ? colors['white-color'] as Color
                                      : Colors.blueGrey,
                                  schedules: schedule,
                                );
                              },
                              separatorBuilder: (_, i) => SizedBox(
                                    width: 8,
                                  ),
                              itemCount: scheduleTyes.length),
                        ),
                      )
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 10),
              child: CText(
                text: "Nearest Visit",
                decorations: TextDecorations(fontSize: 20),
              ),
            ),
            const DoctorVisitorCard(
              drName: "Dr's Nasra",
              imagePath: "assets/dr-4.jpg",
              specia: "Neurologist",

            ),

            Padding(
              padding: const EdgeInsets.only(top: 15, left: 10),
              child: CText(
                text: "Future Visit",
                decorations: TextDecorations(fontSize: 20),
              ),
            ),
            DoctorVisitorCard(
              drName: "Dr Khalid KC",
              imagePath: "assets/dr-2.jpg",
              specia: "Therapost",
            ),

          ],
        ),
      ),
    );
  }
}

class DoctorVisitorCard extends StatelessWidget {
  final String drName;
  final String imagePath;
  final String specia;
  const DoctorVisitorCard({
    required this.imagePath,
    required this.drName,
    required this.specia,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 20),
      child: Container(
        padding: EdgeInsets.all(23),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(13)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CText(
                      text: drName,
                      decorations: TextDecorations(fontSize: 18),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    CText(text: specia)
                  ],
                ),
                CircleAvatar(
                  backgroundImage: AssetImage(imagePath),
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Divider(
              color: Colors.grey.shade300,
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              children: [
                ScheduleTimer(
                  text: "27/8/2023",
                  icon: Icons.calendar_month,
                ),
                SizedBox(
                  width: 9,
                ),
                ScheduleTimer(
                  text: "12:12 AM",
                  icon: Icons.timer,
                ),
                SizedBox(
                  width: 9,
                ),
                ScheduleTimer(
                  text: "Confirmed",
                  icon: Icons.circle,
                  size: 15,
                  color: Colors.green,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: Color(0xfff4f5f9),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: CText(
                    text: "Cancel",
                    decorations: TextDecorations(
                        fontSize: 18, weight: FontWeight.bold),
                  )),
                )),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: colors['primary'],
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: CText(
                    text: "Reschedule",
                    decorations: TextDecorations(
                      color: Colors.white,
                        fontSize: 18, weight: FontWeight.bold),
                  )),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
