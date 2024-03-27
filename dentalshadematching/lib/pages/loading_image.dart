
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'dart:collection';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'analyse_image.dart';
import 'package:medical_app/util/evaluate_function.dart';
import 'package:medical_app/util/values.dart';
import 'package:delta_e/delta_e.dart';

int pixel = 150;


class AnalyseImage extends StatefulWidget {

  final XFile xfile1;
  final XFile xfile2;
  const AnalyseImage({super.key, required this.xfile1, required this.xfile2});

  @override
  State<AnalyseImage> createState() => _AnalyseImageState();
}

class _AnalyseImageState extends State<AnalyseImage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100,),
            Image.file(File(widget.xfile1.path)),
            const Text("샘플",style: TextStyle(color: Colors.black,
                fontFamily: '진혁폰트',
                letterSpacing: 2.0,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),),
            const SizedBox(height: 30,),
            Image.file(File(widget.xfile2.path)),
            const Text("치아",style: TextStyle(color: Colors.black,
                fontFamily: '진혁폰트',
                letterSpacing: 2.0,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),),
            const SizedBox(height: 30,),
            FloatingActionButton(onPressed: ()async {

              Uint8List bytes1 = await File(widget.xfile1.path).readAsBytes();
              img.Image? guideimage = img.decodeImage(bytes1);

              Uint8List bytes2 = await File(widget.xfile2.path).readAsBytes();
              img.Image? teethimage = img.decodeImage(bytes2);

              LabColor guideLab = await calculateAverageLab(guideimage!);

              print(guideLab);
              LabColor teethLab = await calculateAverageLab(teethimage!);
              double minCIEDE2000 = 50;
              double calculatedCIEDE2000 = 50;

              int keyNum = 0;
              List<String> valueType = ['a1','a2','a3','a3_5','a4','b1','b2','b3','b4','c1','c2','c3','c4','d2','d3','d4'];

              for(int i=0;i<12;i++){
                LabColor realLab = LabColor(values[i]['a4'][0],values[i]['a4'][1],values[i]['a4'][2]);
                calculatedCIEDE2000 = deltaE(guideLab,realLab);

                print("calculated = ${calculatedCIEDE2000}, i = $i");

                if(calculatedCIEDE2000 < minCIEDE2000){
                  minCIEDE2000 = calculatedCIEDE2000;
                  keyNum = i;
                }
              }

              //List<double> residual = [values[keyNum]['a4'][0] - guideLab.l,values[keyNum]['a4'][1] - guideLab.a,values[keyNum]['a4'][2] - guideLab.b];
              //teethLab = LabColor(teethLab.l + residual[0]/2,teethLab.a + residual[1]/2,teethLab.b + residual[2]/2);


              print("keynum = $keyNum");

              minCIEDE2000 = 50;
              calculatedCIEDE2000 = 50;
              String answer = "";


              for(int i =0;i<16;i++){

                LabColor realLab = LabColor(values[keyNum][valueType[i]][0],values[keyNum][valueType[i]][1],values[keyNum][valueType[i]][2]);
                calculatedCIEDE2000 = deltaE(teethLab,realLab);
                print("$i , $calculatedCIEDE2000");

                if(calculatedCIEDE2000 < minCIEDE2000){
                  minCIEDE2000 = calculatedCIEDE2000;
                  answer = valueType[i];
                }

              }
              if(!mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowResult(string: answer, xfile2: widget.xfile2,)));

            },child: Icon(Icons.check),)
          ],
        ),
      ),
    );
  }
}