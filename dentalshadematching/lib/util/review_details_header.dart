import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/util/helpers/review_helper.dart';
import 'package:medical_app/util/text.dart';

import 'helpers/text_helper.dart';

class ReviewerDetails extends StatelessWidget {
  final ReviewDetailsData userDetail;
  const ReviewerDetails({
    super.key,
    required this.userDetail
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage:
          AssetImage(userDetail.assetPath),
        ),
        SizedBox(width:15,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CText(text: userDetail.name,
              decorations: TextDecorations(
                  fontSize: 16
              ),),
            CText(text: userDetail.time,
              decorations: TextDecorations(
                  color: Colors.blueGrey.withOpacity(0.5)
              ),)
          ],
        ),
      ],
    );
  }
}