import 'package:flutter/cupertino.dart';
import 'package:medical_app/util/helpers/text_helper.dart';

class CText extends StatelessWidget {
  final TextDecorations? decorations;
  final String text;
  const CText({
    super.key,
    required this.text,
    this.decorations
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
    style: TextStyle(
      fontFamily: decorations?.family,
      color: decorations?.color,
      fontSize: decorations?.fontSize,
      fontWeight: decorations?.weight,
      height: decorations?.height,

    )

    );
  }
}