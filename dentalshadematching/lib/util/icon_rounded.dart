import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconRounded extends StatelessWidget {
  final double? padding;
  final IconData icon;
  final Color? iconColor;
  final Color? bgColor;
  const IconRounded({
    super.key,
    this.bgColor,
    this.padding,
    required this.icon,
    this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(padding??10),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor??Color(0xff9f97e3)
        ),
        child: Icon(icon, color: iconColor??Colors.black45,));
  }
}