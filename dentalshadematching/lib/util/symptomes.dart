import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/util/helpers/symtomes.dart';
import 'package:medical_app/util/text.dart';

import 'helpers/text_helper.dart';

class Symptoms extends StatelessWidget {
  final SymptomsFigures symptomsFigures;
  final Function() onTap;
  final Color color;
  final Color? forGround;
  const Symptoms({super.key,
  required this.symptomsFigures, required this.onTap, required this.color,this.forGround});

  @override
  Widget build(BuildContext context) {
    return    InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 18,horizontal: 20
        ),
        // width: MediaQuery.sizeOf(context).width*0.5,
        decoration: BoxDecoration(
          // color: Color(0xfff4f5f9),
            color: color,
            // color: Colors.red,
            borderRadius: BorderRadius.circular(10)

        ),
        child: Row(
            children: [
              CText(text: symptomsFigures.type),
              SizedBox(width: 10,),
              CText(text: symptomsFigures.title,
                decorations: TextDecorations(
              color: forGround??Colors.black
                ),)
            ]
        ),
      ),
    );
  }
}
