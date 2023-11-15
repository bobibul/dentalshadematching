import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../util/doctors.dart';
import '../util/helpers/doctors.dart';
import '../util/helpers/text_helper.dart';
import '../util/text.dart';
import 'appointment.dart';
import 'camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Patient> patientList = [
    Patient(name: "김경자", shadeguide: '5m3', sex: "여", imagepath: "assets/분석1.jpg",age:36),
    Patient(name: "한영숙", shadeguide: '2m2', sex: "여", imagepath: "assets/분석2.jpg",age:75),
    Patient(name: "채영훈", shadeguide: '2r1', sex: "남", imagepath: "assets/분석3.jpg",age:62),
    Patient(name: "곽도현", shadeguide: '3l1.5', sex: "남", imagepath: "assets/분석4.jpg",age:62),
    Patient(name: "양채경", shadeguide: '3l2.5', sex: "여", imagepath: "assets/dr-5.jpg",age:61),
    Patient(name: "김동민", shadeguide: '1m2', sex: "남", imagepath: "assets/dc-1.jpg",age:53),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.purple[800],
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20,bottom: 10),
                child: Row(
                  children: [
                    CText(
                      decorations:
                      TextDecorations(fontSize: 20, weight: FontWeight.bold,color: Colors.white),
                      text: "반가워요, 유진혁 님! 👋",
                    ),
                    const SizedBox(width: 70,),
                    const CircleAvatar(
                      minRadius: 20,
                      maxRadius: 20,
                      backgroundImage: AssetImage("assets/셀카.jpg"),
                    ),
                    const SizedBox(width:10),
                    const Icon(Icons.notifications,size: 40,color: Colors.white),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),

            Row(
              children: [
                InkWell(
                  onTap: ()async{Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CameraApp(
                          )));
                    },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container( width: 260,height: 300,decoration: BoxDecoration(color:Colors.purple[700],borderRadius: BorderRadius.circular(30) ),child: Column(
                      children: [
                        Image.asset('assets/돋보기치아2.png',color: Colors.white,height: 200,width: 200),
                        const Text('치아색 분석',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),)
                      ],
                    )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(width: 110,height: 300,decoration: BoxDecoration(color:Colors.purple[300],borderRadius: BorderRadius.circular(30) ),child: const Column(
                    children: [
                      SizedBox(height: 60,),
                      Icon(Icons.send,color: Colors.white,size: 70),
                      SizedBox(height: 40,),
                      Text('분석',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                      SizedBox(height: 5,),
                      Text('결과',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                      SizedBox(height: 5,),
                      Text('전송',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
                      ],
                  ),),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 45,
                left: 10,
              ),
              child: Center(
                child: CText(
                    text: "지난 분석결과",
                    decorations: TextDecorations(
                      fontSize: 25,
                      weight: FontWeight.bold

                      // weight: FontWeight.bold
                    )),
              ),
            ),

            SizedBox(height: 30,),
            GridView.builder(
                primary: false,
                itemCount: patientList.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 240,
                    mainAxisSpacing: 17
                ),
                itemBuilder: (_, index) {
                  var patient = patientList[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 10,
                        right: 6
                    ),
                    child: OpenContainer(
                      openElevation: 3,
                      openShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      transitionType: ContainerTransitionType.fade,

                      transitionDuration: Duration(seconds: 1),
                      closedBuilder: (content,openCallBack)=>InkWell(
                        onTap: openCallBack,
                        child: PatientsCard(
                          patient: patient,
                        ),
                      ),
                      openBuilder: (context,_)=> Appointment(dr_name: patient.name, special: patient.shadeguide,
                          image : patient.imagepath),

                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
