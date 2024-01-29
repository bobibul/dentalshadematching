
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:color/color.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'analyse_image.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:medical_app/util/yellow_outputs.dart';
import 'package:medical_app/util/helpers/HSVfunction.dart';



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
              String result = await DefineResult(widget.xfile1, widget.xfile2);
              if(!mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => ShowResult(result: result)));
            },backgroundColor: Colors.purple[800],child: const Icon(Icons.check,color: Colors.white),)
          ],
        ),
      ),
    );
  }
}