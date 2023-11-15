import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/util/helpers/schedule.dart';
import 'package:medical_app/util/text.dart';

import '../constants.dart';
import 'helpers/text_helper.dart';

class ScheduleMethod extends StatelessWidget {
  final Schedules schedules;
  final Color color;
  final Color foreColor;
  final  void Function() onClicked;
  const ScheduleMethod({
    super.key,
    required this.schedules,
    required this.color,
    required this.foreColor,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClicked,
      child: Container(
        width: 110,
        padding: EdgeInsets.all(15),
        decoration:
        BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,

        ),
        child: Center(child: CText(text: schedules.type,
          decorations: TextDecorations(color: foreColor),)),
      ),
    );
  }
}