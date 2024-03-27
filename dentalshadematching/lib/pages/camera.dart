import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'preview_screen.dart';
import 'package:image/image.dart' as img;
import 'package:audioplayers/audioplayers.dart';


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
  CameraApp({super.key});
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playSound() async {
    Source source = AssetSource('assets/camera_shutter_sound.mp3');
    await _audioPlayer.play(source); // 카메라 촬영 소리 재생
  }


  @override
  State<CameraApp> createState() => _CameraAppState();
}


class _CameraAppState extends State<CameraApp> {

  late CameraController controller;
  final _currentCameraIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0.0,
        title: SizedBox(height: 30,),
      ),
      body: FutureBuilder(
          future: initializationCamera(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(controller),
                  Image.asset('assets/overlay_cc2.png'),
                  Column(
                    children: [
                      const SizedBox(height: 600,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.white),height: 100,width: 100,),onTap:
                              () async {
                                XFile xfile = await getCroppedImage();
                                Navigator.of(context).pop();
                                if (!mounted) return;
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        ImagePreview(xFile: xfile,)));
                              })]
                          ),
                        ],
                      )

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

  Future<img.Image> getImagesize(XFile xfile) async{
    String imagePath = xfile.path;
    img.Image croppedImage;
    Uint8List bytes = await File(imagePath).readAsBytes();
    img.Image? decodedImage = img.decodeImage(bytes);
    if(_currentCameraIndex == 1){
      croppedImage = img.copyCrop(decodedImage!, x: 20, y: 530, width: decodedImage.width - 40, height: 450);
    }
    else{
      croppedImage = img.copyCrop(decodedImage!, x: 20, y: 1000, width: decodedImage.width - 40, height: 1000);
    }
    return croppedImage;
  }

  Future<XFile> getCroppedImage() async{
    img.Image croppedImage;
    XFile xfile = await onTakePicture();
    croppedImage = await getImagesize(xfile);
    XFile rexfile = await saveImageToXFile(croppedImage);

    return rexfile;
  }


}
