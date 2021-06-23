import 'dart:io';

import 'package:FlutterMind/MindMapView.dart';
import 'package:FlutterMind/TestView.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import "package:flutter/material.dart";
// import 'package:flutter/services.dart';
// import 'MindMapView.dart';
// import 'Splash.dart';

main() {
  runApp(MyApp());
}

class Data {
  GlobalKey key;
}

class MyApp extends StatelessWidget {
  MyApp() {
    // WidgetsFlutterBinding.ensureInitialized();
    // // 全屏
    // if (Platform.isAndroid) {
    //   SystemChrome.setEnabledSystemUIOverlays ([]);
    // }
    // initialize
    ScreenUtil.initScreen();
    Log.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: Splash()
      home: MindMapView()
      // home: TestView()
    );
  }
}