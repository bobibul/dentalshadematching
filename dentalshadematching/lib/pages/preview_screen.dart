import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'drag_and_drop.dart';




class ImagePreview extends StatefulWidget {


  final XFile xFile;
  final XFile xFile2;
  const ImagePreview({super.key, required this.xFile, required this.xFile2});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 300,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RepaintBoundary(
                child: Image.file(File(widget.xFile.path)),
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RepaintBoundary(
                child: Image.file(File(widget.xFile2.path)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.purple[800],
                  child: const Icon(
                    Icons.keyboard_return,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10,),
                FloatingActionButton(
                  onPressed: () async{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Croppingimage(xfile: widget.xFile)));
                  },
                  backgroundColor: Colors.purple[800],
                  child: const Icon(
                    Icons.check,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

