import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:color/color.dart';

import '../yellow_outputs.dart';



double calculateHSVdiffrence(List<double> list1, List<double> list2){

  double diffrence = 0.0;

  diffrence += (list1[0] - list2[0]).abs();
  diffrence += (list1[1] - list2[1]).abs();
  diffrence += (list1[2] - list2[2]).abs();

  return diffrence;
}

List<double> CalculateAverageHSV(img.Image image){

  // 모든 픽셀의 HSV 누적값 초기화
  double totalR = 0.0;
  double totalG = 0.0;
  double totalB = 0.0;


  RgbColor rgbColor = RgbColor(0, 0, 0);

  final decodedBytes = image.getBytes();



  // RGB to HSV 변환 및 누적값 계산
  for (int y = 0; y < 150; y++) {
    for (int x = 0; x < 150; x++) {
      rgbColor = RgbColor(decodedBytes[3*x+450*y], decodedBytes[3*x+1+450*y], decodedBytes[3*x+2+450*y]);
      totalR += rgbColor.r;
      totalG += rgbColor.g;
      totalB += rgbColor.b;

    }
  }

  // 평균값 계산
  double averageR = totalR / (150*150);
  double averageG = totalG / (150*150);
  double averageB = totalB / (150*150);

  rgbColor = RgbColor(averageR, averageG, averageB);
  HsvColor hsvColor = rgbColor.toHsvColor();


  return [hsvColor.h.toDouble(),hsvColor.s.toDouble(),hsvColor.v.toDouble()];
}


Future<String> DefineResult(XFile xfile1, XFile xfile2) async {

  List<double> guideHSV;
  List<double> teethHSV;


  Uint8List bytes1 = await File(xfile1.path).readAsBytes();
  img.Image? guide = img.decodeImage(bytes1);

  guideHSV = CalculateAverageHSV(guide!);



  Uint8List bytes2 = await File(xfile2.path).readAsBytes();
  img.Image? teeth = img.decodeImage(bytes2);

  teethHSV = CalculateAverageHSV(teeth!);

  int minoutput = 1;
  double minoutputValue = 1000.0;
  String keyname = "yellowClassic1";

  for(int i = 1; i<=4;i++){
    keyname = "yellowClassic$i";

    if(minoutputValue > calculateHSVdiffrence(yellowOutputs[keyname]!,guideHSV)){
      minoutputValue = calculateHSVdiffrence(yellowOutputs[keyname]!,guideHSV);
      minoutput = i;
    }
  }

  print(minoutput);

  Map<String, List<double>> yellowAnswer = yellows[minoutput];

  String result = "a1";

  List<String> classic = ["a1","a2","a3","a3_5","a4","b1","b2","b3","b4","c1","c2","c3","c4","d2","d3","d4"];

  minoutputValue = 1000.0;
  String valueName = "a1";

  for(int i = 1; i<=16;i++){

    if(minoutputValue > calculateHSVdiffrence(yellowAnswer[classic[i]]!,teethHSV)){
      minoutputValue = calculateHSVdiffrence(yellowAnswer[classic[i]]!,teethHSV);
    }
    result = classic[i];
  }

  return result;

}
