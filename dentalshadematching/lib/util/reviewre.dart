import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/util/helpers/review_helper.dart';
import 'package:medical_app/util/rate_banner.dart';
import 'package:medical_app/util/review_details_header.dart';
import 'package:medical_app/util/text.dart';

import 'helpers/text_helper.dart';

class Reviewers extends StatelessWidget {
  final ReviewDetailsData reviewsData;
  const Reviewers({
    super.key,
    required this.reviewsData
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:Colors.transparent,
          boxShadow: [


            BoxShadow(
              color: Color(0xFFefeefb).withOpacity(1),
              offset: Offset(-6, 8),
              blurRadius: 9,
              spreadRadius: -5,
            ),

          ]),
      width: MediaQuery.sizeOf(context).width * 0.8,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 16, left: 10, right: 8, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReviewerDetails(
                    userDetail: reviewsData,
                  ),
                  RateBanner(
                    rate: reviewsData.rate,
                  )
                ],
              ),
              SizedBox(height: 14,),

              CText(text: reviewsData.reviewText,
                decorations: TextDecorations(
                    height: 1.6
                ),)
            ],
          ),
        ),
      ),
    );
  }
}