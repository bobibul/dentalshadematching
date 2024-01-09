
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:color/color.dart';
import 'dart:collection';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'analyse_image.dart';

int pixel = 150;

Future<Map<String, List<double>>> readAndProcessFile(String filePath) async {
  File file = File(filePath);

  try {
    // 파일 읽기
    List<String> lines = await file.readAsLines();

    // 결과 데이터 초기화
    Map<String, List<double>> processedData = {};

    // 각 라인 처리
    for (String line in lines) {
      // 쉼표로 구분된 값 분리
      List<String> values = line.split(',');

      // key는 리스트의 첫 번째 값
      String key = values[0];

      // 나머지 3개의 값을 double로 변환하여 리스트에 추가
      List<double> valueList = values.sublist(1).map((String value) => double.parse(value)).toList();

      // 결과 데이터에 추가
      processedData[key] = valueList;
    }

    return processedData;
  } catch (e) {
    // 파일 읽기 또는 처리 중 에러 발생 시 예외 처리
    throw 'Error reading or processing file: $e';
  }
}

Map<String, List<double>> yellowOutputs= {
  "outputs_1": [29.597,199.523,184.812],
  "outputs_2": [26.009,236.767,181.126],
};


double calculatePSNR(img.Image image1, img.Image image2) {

  final decodedBytes1 = image1.getBytes();
  final decodedBytes2 = image2.getBytes();
  double mseH = 0.0, mseS = 0.0, mseV = 0.0;
  RgbColor rgbColor1 = RgbColor(0, 0, 0);
  HsvColor hsvColor1 = rgbColor1.toHsvColor();
  RgbColor rgbColor2 = RgbColor(0, 0, 0);
  HsvColor hsvColor2 = rgbColor2.toHsvColor();


  for (int y = 0; y < pixel; y++) {
    for (int x = 0; x < pixel; x++) {

      // Convert RGB to HSV
      rgbColor1 = RgbColor(decodedBytes1[x+pixel*y], decodedBytes1[x+1+pixel*y], decodedBytes1[x+2+pixel*y]);
      rgbColor2 = RgbColor(decodedBytes2[x+pixel*y], decodedBytes2[x+1+pixel*y], decodedBytes2[x+2+pixel*y]);

      hsvColor1 = rgbColor1.toHsvColor();
      hsvColor2 = rgbColor2.toHsvColor();


      mseH += pow((hsvColor1.h - hsvColor2.h).toDouble(), 2);
      mseS += pow((hsvColor1.s - hsvColor2.s).toDouble(), 2);
      mseV += pow((hsvColor1.v - hsvColor2.v).toDouble(), 2);
    }


  }

  mseH /= pixel*pixel;
  mseS /= pixel*pixel;
  mseV /= pixel*pixel;



  double mse = (mseH + mseS + mseV) / 3;
  double maxPixelValue = 255.0; // HSV values are in the range [0, 1]
  double psnr = 20.0 * log(maxPixelValue / sqrt(mse));




  return psnr;
}


class AnalyseImage extends StatefulWidget {

  final XFile xfile1;
  final XFile xfile2;
  const AnalyseImage({super.key, required this.xfile1, required this.xfile2});

  @override
  State<AnalyseImage> createState() => _AnalyseImageState();
}

class _AnalyseImageState extends State<AnalyseImage> {

  String findMaxValueKey(Map<String, double> map) {
    double maxValue = map.values.reduce((value, element) => value > element ? value : element);

    for (var entry in map.entries) {
      if (entry.value == maxValue) {
        return entry.key;
      }
    }

    return ''; // Empty string if no maximum value found
  }

  Future<List<String>> getAssetImagesInSample5m3Folder(String string) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter out image files based on the "sample5m3" folder path
    List<String> imageNames = manifestMap.keys
        .where((String key) => key.startsWith(string))
        .toList();

    // Extract file names from the image paths
    List<String> imageFileNames = imageNames
        .map((String imagePath) => imagePath.split('/').last)
        .toList();

    return imageFileNames;
  }

  Future<img.Image?> decodeAssetImage(String assetPath) async{
    ByteData data = await rootBundle.load(assetPath);
    List<int> bytes = data.buffer.asUint8List();
    img.Image? decodedImage = img.decodeImage(Uint8List.fromList(bytes));
    return decodedImage;
  }

  List<double> CalculateAverageHSV(img.Image img){

    // 모든 픽셀의 HSV 누적값 초기화
    double totalH = 0.0;
    double totalS = 0.0;
    double totalV = 0.0;
    final decodedBytes = img.getBytes();


    RgbColor rgbColor = RgbColor(0, 0, 0);
    HsvColor hsvColor = rgbColor.toHsvColor();


    // RGB to HSV 변환 및 누적값 계산
    for (int y = 0; y < 150; y++) {
      for (int x = 0; x < 150; x++) {

        rgbColor = RgbColor(decodedBytes[x+pixel*y], decodedBytes[x+1+pixel*y], decodedBytes[x+2+pixel*y]);
        hsvColor = rgbColor.toHsvColor();

        totalH += hsvColor.h;
        totalS += hsvColor.s;
        totalV += hsvColor.v;

      }
    }

    // 평균값 계산
    double averageH = totalH / (150*150);
    double averageS = totalS / (150*150);
    double averageV = totalV / (150*150);

    return [averageH,averageS,averageV];
  }

  double calculateHSVvalue(img.Image originalImage, img.Image currentImage){

    double diffrence = 0.0;

    diffrence += (CalculateAverageHSV(originalImage)[0] - CalculateAverageHSV(currentImage)[0]).abs();
    diffrence += (CalculateAverageHSV(originalImage)[1] - CalculateAverageHSV(currentImage)[1]).abs();
    diffrence += (CalculateAverageHSV(originalImage)[2] - CalculateAverageHSV(currentImage)[2]).abs();

    return diffrence;
  }

  List<double> calculateGradient(img.Image originalImage, img.Image currentImage,double a,double b) {
    // 현재 이미지와 원본 이미지의 차이를 이용하여 채도에 대한 그래디언트 계산
    img.Image copiedImage = currentImage.clone();

    double adjustedDiffrence1;
    double adjustedDiffrence2;
    double epsilon = 0.1;
    double diffrence = calculateHSVvalue(originalImage,currentImage);

    // 약간 채도를 변화시킨 후의 PSNR을 계산하여 그래디언트 근사
    double perturbedSaturation = a + epsilon*2;
    img.adjustColor(copiedImage, saturation: perturbedSaturation);
    adjustedDiffrence1 = calculateHSVvalue(originalImage,copiedImage);

    copiedImage = currentImage.clone();

    perturbedSaturation = b + epsilon;
    img.adjustColor(copiedImage,brightness: perturbedSaturation);
    adjustedDiffrence2 = calculateHSVvalue(originalImage,copiedImage);


    // 그래디언트 반환
    return [(diffrence - adjustedDiffrence1) / epsilon,(diffrence - adjustedDiffrence2) / epsilon];
  }


  List<double> adjustImages(img.Image originalImage, img.Image adjusted) {

    double learningRate = 0.0001;
    int epochs = 100;

    double HSVdiffrence = 200.0;
    double newHSVdiffrence = 0.0;

    double valueS = 1.0;
    double valueV = 1.0;

    double newValueS = 1.0;
    double newValueV = 1.0;

    double deltaS = 0.0;
    double deltaV = 0.0;

    List<double> values = [1.0,1.0];

    img.Image copiedimage = adjusted.clone();



    for (int epoch = 0; epoch < epochs; epoch++) {
      print("epoch ${epoch+1}, HSVdiffrence = $newHSVdiffrence");

      values = calculateGradient(originalImage, copiedimage, valueS, valueV);

      newValueS += values[0] * learningRate;
      newValueV += values[1] * learningRate;

      print('s = $newValueS, v = $newValueV');



      // 경사 하강법을 이용한 조절
      img.adjustColor(copiedimage, saturation: newValueS, brightness: newValueS);

      newHSVdiffrence = calculateHSVvalue(originalImage, copiedimage);


      if(newHSVdiffrence >= HSVdiffrence){
        return [newValueS,newValueV];
      }

      valueS = newValueS;
      valueV = newValueV;

      HSVdiffrence = newHSVdiffrence;
    }


    return [newValueS,newValueV];

  }





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

              Map<String,double> psnrMap = {};
              Map<String,double> psnrMap2 = {};

              img.Image? guideimage; // 찍은 guide 이미지 돌린거 저장하는곳
              img.Image? specialGuideimage; // 찍은 guide 이미지
              img.Image? specialTeethimage; // 찍은 teeth 이미지
              img.Image? normalGuideimage; // 폴더에 저장 된 guide 이미지
              img.Image? adjustedSpecialGuideimage; // 채도조절된 guide 이미지
              img.Image? adjustedSpecialTeethimage; // 채도조절된 teeth 이미지
              List<String> guidelineImage;

              double psnrValue;
              List<int> correctAngleList = [];
              int correctAngle = 0;


              Uint8List bytes1 = await File(widget.xfile1.path).readAsBytes();
              specialGuideimage = img.decodeImage(bytes1);

              Uint8List bytes2 = await File(widget.xfile2.path).readAsBytes();
              specialTeethimage = img.decodeImage(bytes2);

              guidelineImage = await getAssetImagesInSample5m3Folder('assets/classic_sample/');


              for (String name in guidelineImage) {
                correctAngle = 0;
                normalGuideimage = await decodeAssetImage('assets/classic_sample/$name');
                psnrMap[name] = calculatePSNR(specialGuideimage!, normalGuideimage!);

                guideimage = img.copyRotate(specialGuideimage, angle: 90);
                psnrValue = calculatePSNR(guideimage, normalGuideimage);
                if (psnrValue > psnrMap[name]!){
                  psnrMap[name] = psnrValue;
                  correctAngle = 90;
                }
                guideimage = img.copyRotate(specialGuideimage, angle: 180);
                psnrValue = calculatePSNR(guideimage, normalGuideimage);
                if (psnrValue > psnrMap[name]!){
                  psnrMap[name] = psnrValue;
                  correctAngle = 180;
                }
                guideimage = img.copyRotate(specialGuideimage, angle: 270);
                psnrValue = calculatePSNR(guideimage, normalGuideimage);
                if (psnrValue > psnrMap[name]!){
                  psnrMap[name] = psnrValue;
                  correctAngle = 270;
                }
                correctAngleList.add(correctAngle);
              }
              // 값을 기준으로 정렬된 Map 생성 (값과 키를 뒤집어 저장)
              SplayTreeMap<double, String> invertedMap = SplayTreeMap<double, String>.fromIterables(psnrMap.values, psnrMap.keys);

              // 가장 큰 값을 가진 키 가져오기
              String? keyWithMaxValue = invertedMap[invertedMap.lastKey()];

              int? dotIndex = keyWithMaxValue?.lastIndexOf('.');
              String? keyName = keyWithMaxValue?.substring(0,dotIndex);

              List<String> detectImageList = await getAssetImagesInSample5m3Folder('assets/$keyName/');
              correctAngle = correctAngleList[int.parse(keyName!.split('_').last)-1];

              // 여기에 경사하강법 적용 keyname = 맞는 폴더 이름

              normalGuideimage = await decodeAssetImage('assets/classic_sample/$keyName.jpg');

              List<double> deltas = [0.0,0.0,0.0];

              deltas = adjustImages(normalGuideimage!, specialGuideimage!);

              print(deltas);


              adjustedSpecialTeethimage = img.copyRotate(specialTeethimage!, angle: correctAngle);
              img.adjustColor(adjustedSpecialTeethimage, saturation: 12.0,brightness: 1.0);

              adjustedSpecialGuideimage = img.copyRotate(specialGuideimage, angle: correctAngle);
              img.adjustColor(adjustedSpecialGuideimage, saturation: 12.0,brightness: 1.0);

              for (String name in detectImageList) {
                img.Image? image = await decodeAssetImage('assets/$keyName/$name');
                psnrMap2[name] = calculatePSNR(adjustedSpecialTeethimage, image!);
              }

              // 가장 큰 값을 가진 키 가져오기
              String answer = findMaxValueKey(psnrMap2);


              dotIndex = answer.lastIndexOf('.');
              print("maxvalue = ${psnrMap2[answer]}");
              answer = answer.substring(0,dotIndex);

              print("keyname = $keyName");




              if(!mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowResult(result: answer, keyname: keyName,adjustedGuideImage: adjustedSpecialGuideimage!,adjustedTeethImage: adjustedSpecialTeethimage!, )));

            },backgroundColor: Colors.purple[800],child: const Icon(Icons.check,color: Colors.white),)
          ],
        ),
      ),
    );
  }
}