import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'preview_screen.dart';
import 'package:image/image.dart' as img;

int a = 0;

Future<XFile> saveImageToXFile(img.Image image) async {
  // Convert img.Image to Uint8List
  Uint8List pngBytes = img.encodePng(image);

  // Get the directory for saving the image
  final directory = await getTemporaryDirectory();

  String filePath = '${directory.path}/${a}image.png';

  // Save the image to a file
  File imageFile = File(filePath);
  await imageFile.writeAsBytes(pngBytes);

  a += 1;

  // Return as XFile
  return XFile(filePath);
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});


  @override
  State<CameraApp> createState() => _CameraAppState();
}


class _CameraAppState extends State<CameraApp> {

  late CameraController controller;
  int _currentCameraIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        leadingWidth: 0.0,
        title: SizedBox(height: 30,),
      ),
      body: FutureBuilder(
          future: initializationCamera(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  CameraPreview(controller),
                  Image.asset('assets/overlay_33.png'),
                  Column(
                    children: [
                      SizedBox(height: 600,),
                      Expanded(
                        child: Container(
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                  child: Container(decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white),height: 100,width: 100,),onTap:
                                  () async{
                                showDialog(context: context, builder: (context){
                                  return const Column(
                                    children: [
                                      SizedBox(height: 400,),
                                      Center(child: CircularProgressIndicator()),
                                      SizedBox(height: 100,),
                                      Text(
                                        '카메라를 고정한 상태로 기다려주세요',
                                        style: TextStyle(
                                            fontFamily: '진혁폰트',
                                            fontSize: 20.0,
                                            letterSpacing: 1.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.red
                                        ),
                                      )
                                    ],
                                  );
                                }
                                );
                                XFile xfile = await getCroppedImage();
                                Navigator.of(context).pop();
                                if(!mounted) return;
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePreview(xFile: xfile)));
                              },
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),

                ],
              );
            }else{
              return const Center(
                  child: CircularProgressIndicator()
              );
            }
          }
      ),

    );
  }

  Future<void> initializationCamera() async{
    var cameras = await availableCameras();
    controller = CameraController(
      cameras[_currentCameraIndex],
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );


    await controller.initialize();
    await controller.setExposureOffset(0.0);
    await controller.setFlashMode(FlashMode.off);
  }

  Future<XFile> onTakePicture() async{
    controller.setFocusMode(FocusMode.locked);
    //controller.setExposureMode(ExposureMode.locked);
    XFile xfile = await controller.takePicture();
    controller.setFocusMode(FocusMode.auto);
    //controller.setExposureMode(ExposureMode.auto);

    return xfile;
  }

  Future<img.Image> getImagesize(XFile xfile,int x,int y,int width,int height) async{
    String imagePath = xfile.path;
    img.Image croppedImage;
    Uint8List bytes = await File(imagePath).readAsBytes();
    img.Image? decodedImage = img.decodeImage(bytes);
    if(_currentCameraIndex == 1){
      croppedImage = img.copyCrop(decodedImage!, x: x, y: y, width: width, height: height);
    }
    else{
      croppedImage = img.copyCrop(decodedImage!, x: x, y: y, width: width, height: height);
    }
    print(decodedImage.width);
    print(decodedImage.height);
    return croppedImage;
  }

  // void _toggleCamera(){
  //   setState(() {
  //     if(_currentCameraIndex == 0){
  //       _currentCameraIndex = 1;
  //     }
  //     else{
  //       _currentCameraIndex = 0;
  //     }
  //   });
  // }

  Future<XFile> getCroppedImage() async{
    img.Image croppedImage;
    XFile xfile = await onTakePicture();
    croppedImage = await getImagesize(xfile,20,1000,2120,1000);
    XFile rexfile = await saveImageToXFile(croppedImage);

    return rexfile;
  }



}
