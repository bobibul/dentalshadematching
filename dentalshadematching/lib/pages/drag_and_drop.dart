import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'loading_image.dart';

class Croppingimage extends StatefulWidget {

  final XFile xfile;
  const Croppingimage({required this.xfile, super.key});


  @override
  State<Croppingimage> createState() => _CroppingimageState();
}
int b = 0;
double radius = 20.0;
class _CroppingimageState extends State<Croppingimage>{

  Offset _position1 = Offset(120,750);
  Offset _position2 = Offset(240,750);
  GlobalKey imageKey = GlobalKey();

  late XFile croppedImage1;
  late XFile croppedImage2;

  Future<XFile> saveImageToXFile(img.Image image) async {
    // Convert img.Image to Uint8List
    Uint8List pngBytes = img.encodePng(image);

    // Get the directory for saving the image
    final directory = await getTemporaryDirectory();
    String filePath = '${directory.path}/${b}image3.png';

    // Save the image to a file
    File imageFile = File(filePath);
    await imageFile.writeAsBytes(pngBytes);

    b += 1;

    // Return as XFile
    return XFile(filePath);
  }

  void _updatePosition1(Offset newPosition){
    setState(() {
      _position1 = newPosition;
    });
  }

  Future<XFile> cropImage(Offset position) async{

    String imagePath = widget.xfile.path;
    img.Image croppedImage;
    RenderBox renderBox = imageKey.currentContext?.findRenderObject() as RenderBox;
    Offset localPosition = renderBox.globalToLocal(position);
    double imageWidth = renderBox.size.width;
    double imageHeight = renderBox.size.height;
    Uint8List bytes = await File(imagePath).readAsBytes();
    img.Image? decodedImage = img.decodeImage(bytes);
    int localPositionx = (localPosition.dx/imageWidth*decodedImage!.width).round();
    int localPositiony = (localPosition.dy/imageHeight*decodedImage.height).round();


    XFile croppedXfile;
    croppedImage = img.copyCrop(decodedImage, x: localPositionx + 10, y: localPositiony, width: 150, height: 150);
    croppedXfile = await saveImageToXFile(croppedImage);
    return croppedXfile;
  }


  void _updatePosition2(Offset newPosition){
    setState(() {
      _position2 = newPosition;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 300,),
                Image.file(
                    key: imageKey, File(widget.xfile.path)),
              ],
            ),
            Positioned(
                left: _position1.dx,
                top: _position1.dy,
                child: DraggableBox1(updatePosition: _updatePosition1)),
            Positioned(
                left: _position2.dx,
                top: _position2.dy,
                child: DraggableBox2(updatePosition: _updatePosition2)),
            Positioned(
                left: _position1.dx + 3,
                top: _position1.dy + 50,
                child: Text(
                  '샘플',
                  style: TextStyle(fontSize: 20),
                )),
            Positioned(
                left: _position2.dx + 3,
                top: _position2.dy + 50,
                child: Text(
                  '치아',
                  style: TextStyle(fontSize: 20),
                )),
            Positioned(
                left: 310,
                top: 750,
                child: FloatingActionButton(
                  onPressed: _position2.dy <= 500 && _position1.dy <= 500
                      ? () async{
                    croppedImage1 = await cropImage(_position1);
                    croppedImage2 = await cropImage(_position2);
                    if(!mounted) return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnalyseImage(
                              xfile1: croppedImage1,
                              xfile2: croppedImage2,
                            )));
                  }
                      : null,
                  backgroundColor: _position2.dy <= 500 && _position1.dy <= 500
                      ? Colors.purple[800]
                      : Colors.grey,
                  disabledElevation: 0.0,
                  foregroundColor: Colors.grey,
                  child: const Icon(
                    Icons.check,
                    size: 30,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      ),
    );
  }



}


class DraggableBox1 extends StatefulWidget {
  final void Function(Offset) updatePosition;

  const DraggableBox1({required this.updatePosition, super.key});

  @override
  State<DraggableBox1> createState() => _DraggableBoxState();
}

class _DraggableBoxState extends State<DraggableBox1> {
  Offset _offset = Offset(120,750);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset += details.delta;
        });
        widget.updatePosition(_offset);
      },
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/circle-outline.png'),
        backgroundColor: Colors.transparent,
        radius: radius,
      ),
    );
  }
}

class DraggableBox2 extends StatefulWidget {
  final void Function(Offset) updatePosition;

  const DraggableBox2({required this.updatePosition, super.key});

  @override
  State<DraggableBox2> createState() => _DraggableBoxState2();
}

class _DraggableBoxState2 extends State<DraggableBox2> {
  Offset _offset = Offset(240,750);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _offset += details.delta;
        });
        widget.updatePosition(_offset);
      },
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/circle-outline.png'),
        backgroundColor: Colors.transparent,
        radius: radius,
      ),
    );
  }




}