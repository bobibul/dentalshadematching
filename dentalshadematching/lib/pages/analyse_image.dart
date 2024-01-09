
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class ShowResult extends StatefulWidget {

  final String result; // a1,a2
  final String keyname; // classic_cropped_1...
  final img.Image adjustedGuideImage;
  final img.Image adjustedTeethImage;
  const ShowResult({super.key,  required this.result, required this.keyname,required this.adjustedGuideImage, required this.adjustedTeethImage});


  @override
  State<ShowResult> createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 70.0, 30.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.purple, width: 6)
                ),
                child: const Text(
                  '분석 결과',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold),
                ),
              ),


              const SizedBox(
                height: 20,
              ),

              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                          backgroundImage:
                          AssetImage('assets/classic_sample/${widget.keyname}.jpg'),
                          radius: 50.0,
                          backgroundColor: Colors.white),
                      Text("내장된 가이드"),
                      const SizedBox(height: 30,),
                      CircleAvatar(
                          backgroundImage:
                          AssetImage('assets/${widget.keyname}/${widget.result}.jpg'),
                          radius: 50.0,
                          backgroundColor: Colors.white),
                      Text("내장된 치아 가이드"),
                    ],
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.black, width: 6)
                    ),
                    child: Center(
                      child: Text(
                        widget.result,
                        textAlign: TextAlign.center,

                        style: TextStyle(color: Colors.amber[200],
                            letterSpacing: 2.0,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    children: [
                      CircleAvatar(
                          backgroundImage: MemoryImage(Uint8List.fromList(img.encodePng(widget.adjustedGuideImage))),
                          radius: 50.0,
                          backgroundColor: Colors.white),

                      Text("수정된 가이드"),
                      const SizedBox(height: 30,),
                      CircleAvatar(
                          backgroundImage: MemoryImage(Uint8List.fromList(img.encodePng(widget.adjustedTeethImage))), // img.Image를 Uint8List로 변환하여 사용,
                          radius: 50.0,
                          backgroundColor: Colors.white
                      ),
                      Text("수정된 이빨"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Container(width: 150,height: 300,decoration: BoxDecoration(color: Colors.purple[300],borderRadius: BorderRadius.circular(20)),
                  child:const Column(
                      children: [
                        SizedBox(height: 70,),
                      Icon(Icons.navigate_before_sharp,color: Colors.white,size: 100),
                  Text('다시 분석하기',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
                ],
              ),),
                  const SizedBox(width: 10,),
                  Container(width: 190,height: 300,decoration: BoxDecoration(color: Colors.purple[600],borderRadius: BorderRadius.circular(20)),
                      child:const Column(
                        children: [
                          SizedBox(height: 50,),
                          Icon(Icons.share,color: Colors.white,size: 100),
                          SizedBox(height: 20,),
                          Text('분석 결과 공유',style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold)),
                        ],
                      )),
                ],
              )
            ],
          )),
    );

  }
}