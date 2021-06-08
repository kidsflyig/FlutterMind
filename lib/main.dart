import 'dart:io';

import 'package:FlutterMind/utils/ScreenUtil.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'MindMapView.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MindMapView()
    );
  }
}