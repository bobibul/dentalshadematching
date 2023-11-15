import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/util/text.dart';

import '../constants.dart';
import 'helpers/text_helper.dart';

class BannerCard extends StatelessWidget {
  final Color? bgColor;
  final String assetPath;
  final String? title, subtitle;
  final List<BoxShadow>? shadows;
  final TextDecorations? textDecoration;
  const BannerCard({
    super.key,
    this.bgColor,
    this.title,
    this.subtitle,
    this.shadows,
    this.textDecoration,
    required this.assetPath
  });


  @override
  Widget build(BuildContext context) {
    return Container(


      decoration: BoxDecoration(
          color: bgColor??colors['primary'],
          borderRadius: BorderRadius.circular(12),
          boxShadow: shadows?? [

            BoxShadow(
              color: Color(0xFFa39ebf).withOpacity(1),
              offset: Offset(0, 24),
              blurRadius: 40,
              spreadRadius: -10,
            ),

          ]
      ),
      child: SizedBox(width: MediaQuery.of(context).size.width*0.5,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 60,height: 60,child: Image.asset(assetPath)),
              SizedBox(height: 10,),
              CText(text: title??"",decorations: textDecoration,),
              SizedBox(height: 6,),
              CText(text: subtitle??"",decorations: textDecoration,)

            ],
          ),
        ),),
    );
  }
}