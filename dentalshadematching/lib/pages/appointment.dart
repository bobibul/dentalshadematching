import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/util/helpers/review_helper.dart';
import 'package:medical_app/util/helpers/text_helper.dart';
import 'package:medical_app/util/text.dart';

import '../constants.dart';
import '../util/icon_rounded.dart';
import '../util/reviewre.dart';

class Appointment extends StatelessWidget {
  final String dr_name;
  final String image;
  final String special;
  const Appointment({super.key,required this.dr_name, required  this.special,required this.image});
  static  List<ReviewDetailsData> data=[
    ReviewDetailsData(rate: 5.0, assetPath: "assets/dc-1.jpg", name: "ENG-CJ", time: "1day ago", reviewText: "Masha Allah Dr-kaan Waa Dr Fiican Allah Ha u Ziyaadiyo Cilmiga, Anigoo Mar Hergab Iga Daweyay😄"),
    ReviewDetailsData(rate: 4.3, assetPath: "assets/dc-1.jpg", name: "Abdullahi Qani", time: "3days ago", reviewText: "Dr Aqoon U Leh waxa uusoo bartay dadkana si fiican ugu adeego baa tahay😊"),
    ReviewDetailsData(rate: 3.5, assetPath: "assets/dc-1.jpg", name: "ENG Ibraahim", time: "29 apr", reviewText: "The best doctor in the Beledweyn Hospital"),
    ReviewDetailsData(rate: 5.0, assetPath: "assets/dc-1.jpg", name: "Halima Mohamed", time: "5days ago", reviewText: "In publishing and graphic design"),

  ];

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      backgroundColor: colors['primary'],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: ()=> Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  Icon(Icons.more_vert_outlined, color: Colors.white),
                ],
              ),
            ),
            Column(
              children: [
                CircleAvatar(
                  minRadius: 10,
                  maxRadius: 30,
                  backgroundImage: AssetImage(image),
                ),
                SizedBox(
                  height: 10,
                ),
                CText(
                  text: dr_name,
                  decorations:
                      TextDecorations(fontSize: 25, color: Colors.white),
                ),
                SizedBox(
                  height: 4,
                ),
                CText(
                  text: special,
                  decorations: TextDecorations(
                      fontSize: 16, color: Colors.white.withOpacity(0.9)),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconRounded(
                      iconColor: Colors.white,
                      icon: Icons.call,
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    IconRounded(
                      icon: Icons.message,
                      iconColor: Colors.white,
                    ),
                    // Icon(Icons.message),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 29, right: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CText(
                          text: "About Doctor",
                          decorations: TextDecorations(
                              fontSize: 19, weight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CText(
                          text:
                              "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate",
                          decorations: TextDecorations(
                              fontSize: 15, family: "Roboto Light", height: 1.5),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CText(
                                  text: "Reviews",
                                  decorations: TextDecorations(fontSize: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Color(0xffffad1b),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                CText(text: "4.8"),
                                SizedBox(
                                  width: 3,
                                ),
                                CText(text: "(114)")
                              ],
                            ),
                            CText(
                              text: "See All",
                              decorations: TextDecorations(
                                  fontSize: 17,
                                  color: colors['primary'] as Color),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height *0.2,
                          child: ListView.separated(
                            separatorBuilder: (_,i)=> SizedBox(width: 3,),
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            shrinkWrap: true,

                            itemBuilder: (_,index) {
                              var reviewData= data[index];
                              return  Reviewers(
                                reviewsData: reviewData
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CText(
                          text: "Location",
                          decorations: TextDecorations(
                              fontSize: 19, weight: FontWeight.bold),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            IconRounded(
                              icon: Icons.location_on_rounded,
                              iconColor: colors['primary'],
                              bgColor: Color(0xfff0eefa),),
                            SizedBox(width: 15,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CText(text: "Beledweyn Medical Center",
                                decorations: TextDecorations(
                                  fontSize: 16
                                ),),
                                CText(text: "Road 252 Glob89 Street",
                                decorations: TextDecorations(
                                  color: Colors.grey.withOpacity(0.8)
                                ),)
                              ],
                            )
                          ],
                        ),
                       


                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [

                    BoxShadow(
                      color: Color(0xFFefeefb).withOpacity(1),
                      offset: Offset(-6, -11),
                      blurRadius: 9,
                      spreadRadius: -5,
                    ),

                  ] ,
                  color: Colors.white,
                ),

                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CText(text: "Consultation Price"),
                          CText(text: "\$100"),
                        ],
                      ),
          SizedBox(height: 10,),
                      Expanded(
                        child: Container(
                          height: 70,
                          padding: EdgeInsets.all(15),
                         decoration: BoxDecoration(
                           color: colors['primary'],
                           borderRadius: BorderRadius.circular(16)
                         ),
                          width: double.infinity,
                          child: Center(child: CText(text:"Book Appointment",
                          decorations: TextDecorations(
                            fontSize: 25,
                            color: Colors.white,
                            family: "Roboto Bold"
                          ),)),
                        ),
                      )
                    ],
                  ),
                ),

              ),
            )
          ],
        ),
      ),
    );




  }
}
