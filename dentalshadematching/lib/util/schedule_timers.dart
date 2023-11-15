import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/util/text.dart';

class ScheduleTimer extends StatelessWidget {
  final IconData icon;
  final String text;
  final double? size;
  final Color? color;
  const ScheduleTimer({super.key,

this.size,
this.color,
  required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color??Color(0xffa8afbd), size: size,),
        SizedBox(width: 5,),
        CText(text: text)
      ],
    );
  }
}
