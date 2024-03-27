import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_app/pages/home.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.purple[800]
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData().copyWith(
        primaryColor: Colors.purple[800],
        appBarTheme: AppBarTheme(backgroundColor: Colors.purple[800]),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.purple[800],)
      ),
      home:  Home(),
    );
  }
}


