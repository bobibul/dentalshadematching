import 'dart:ui';

import 'package:flutter/material.dart';

class TextDecorations {
  double fontSize;
  double height;
  String family;
  FontWeight weight;
  Color color;

  TextDecorations({this.color=Colors.black,this.height=0, this.family="Roboto Regular", this.fontSize=14, this.weight=FontWeight.normal});
}
