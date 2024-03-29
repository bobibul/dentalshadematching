
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ShowDesult extends StatefulWidget {

  final String string;
  final String keyname;
  final XFile xfile2;
  const ShowDesult({super.key,  required this.string, required this.keyname, required this.xfile2});


  @override
  State<ShowDesult> createState() => _ShowDesultState();
}

class _ShowDesultState extends State<ShowDesult> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[800],
      body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 70.0, 30.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100,),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black, width: 6)
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
                height: 60,
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  '당신의 치아 색은',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30,),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.black, width: 6)
                ),
                child: Text(
                  widget.string,
                  textAlign: TextAlign.center,

                  style: TextStyle(color: Colors.amber[200],
                      letterSpacing: 2.0,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30,),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  '입니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black,
                      letterSpacing: 2.0,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      backgroundImage:
                      AssetImage('assets/${widget.keyname}/${widget.string}.jpg'),
                      radius: 50.0,
                      backgroundColor: Colors.white),
                  const SizedBox(width: 30,),
                  CircleAvatar(
                      backgroundImage: FileImage(File(widget.xfile2.path)),
                      radius: 50.0,
                      backgroundColor: Colors.white
                  ),
                ],
              ),
            ],
          )),
    );

  }
}