
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


double calculatePSNR(img.Image? image1, img.Image? image2) {

  final decodedBytes1 = image1?.getBytes();
  final decodedBytes2 = image2?.getBytes();
  double mseH = 0.0, mseS = 0.0, mseV = 0.0;
  RgbColor rgbColor1 = RgbColor(0, 0, 0);
  HsvColor hsvColor1 = rgbColor1.toHsvColor();
  RgbColor rgbColor2 = RgbColor(0, 0, 0);
  HsvColor hsvColor2 = rgbColor2.toHsvColor();


  for (int y = 0; y < pixel; y++) {
    for (int x = 0; x < pixel; x++) {

      // Convert RGB to HSV
      rgbColor1 = RgbColor(decodedBytes1![x+pixel*y], decodedBytes1[x+1+pixel*y], decodedBytes1[x+2+pixel*y]);
      rgbColor2 = RgbColor(decodedBytes2![x+pixel*y], decodedBytes2[x+1+pixel*y], decodedBytes2[x+2+pixel*y]);

      hsvColor1 = rgbColor1.toHsvColor();
      hsvColor2 = rgbColor2.toHsvColor();


      mseH += pow((hsvColor1.h - hsvColor2.h).toDouble(), 2);
      mseS += 1.05*pow((hsvColor1.s - hsvColor2.s).toDouble(), 2);
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

              Uint8List bytes1 = await File(widget.xfile1.path).readAsBytes();
              img.Image? guideimage = img.decodeImage(bytes1);

              Uint8List bytes2 = await File(widget.xfile2.path).readAsBytes();
              img.Image? teethimage = img.decodeImage(bytes2);

              List<String> guidelineImage = await getAssetImagesInSample5m3Folder('assets/sample5m3/');

              double psnrValue;

              for (String name in guidelineImage) {
                img.Image? image = await decodeAssetImage('assets/sample5m3/$name');
                psnrMap[name] = calculatePSNR(guideimage, image);

                guideimage = img.copyRotate(guideimage!, angle: 90);
                psnrValue = calculatePSNR(guideimage, image);
                if (psnrValue > psnrMap[name]!){
                  psnrMap[name] = psnrValue;
                }
                guideimage = img.copyRotate(guideimage, angle: 180);
                psnrValue = calculatePSNR(guideimage, image);
                if (psnrValue > psnrMap[name]!){
                  psnrMap[name] = psnrValue;
                }
                guideimage = img.copyRotate(guideimage, angle: 270);
                psnrValue = calculatePSNR(guideimage, image);
                if (psnrValue > psnrMap[name]!){
                  psnrMap[name] = psnrValue;
                }
              }
              // 값을 기준으로 정렬된 Map 생성 (값과 키를 뒤집어 저장)
              SplayTreeMap<double, String> invertedMap = SplayTreeMap<double, String>.fromIterables(psnrMap.values, psnrMap.keys);

              // 가장 큰 값을 가진 키 가져오기
              String? keyWithMaxValue = invertedMap[invertedMap.lastKey()];

              int? dotIndex = keyWithMaxValue?.lastIndexOf('.');
              String? keyName = keyWithMaxValue?.substring(0,dotIndex);

              List<String> detectImageList = await getAssetImagesInSample5m3Folder('assets/$keyName/');


              for (String name in detectImageList) {
                img.Image? image = await decodeAssetImage('assets/$keyName/$name');
                psnrMap2[name] = calculatePSNR(teethimage, image);


                teethimage = img.copyRotate(teethimage!, angle: 90);
                psnrValue = calculatePSNR(teethimage, image);
                if (psnrValue > psnrMap2[name]!){
                  psnrMap2[name] = psnrValue;
                }

                teethimage = img.copyRotate(teethimage, angle: 180);
                psnrValue = calculatePSNR(teethimage, image);
                if (psnrValue > psnrMap2[name]!){
                  psnrMap2[name] = psnrValue;
                }

                teethimage = img.copyRotate(teethimage, angle: 270);
                psnrValue = calculatePSNR(teethimage, image);
                if (psnrValue > psnrMap2[name]!){
                  psnrMap2[name] = psnrValue;
                }


              }

              SplayTreeMap<double, String> invertedMap2 = SplayTreeMap<double, String>.fromIterables(psnrMap2.values, psnrMap2.keys);

              // 가장 큰 값을 가진 키 가져오기
              String answer = findMaxValueKey(psnrMap2);


              dotIndex = answer.lastIndexOf('.');
              print("maxvalue = ${psnrMap2[answer]}");
              answer = answer.substring(0,dotIndex);

              print("keyname = $keyName");




              if(!mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowDesult(string: answer, keyname: keyName!, xfile2: widget.xfile2,)));

            },child: Icon(Icons.check),)
          ],
        ),
      ),
    );
  }
}