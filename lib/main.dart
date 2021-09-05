import 'dart:io';

import 'package:FlutterMind/MindMapView.dart';
import 'package:FlutterMind/TestView.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/utils/Localization.dart';
import 'package:FlutterMind/utils/Utils.dart';
import "package:flutter/material.dart";
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
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
    // initialize
    ScreenUtil.initScreen();
    Log.init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FMLocalizationsDelegate.delegate,
      ],
      supportedLocales: [
        Locale("en"),
        Locale("zh")
      ],
      locale: Locale("zh"),
      // home: Splash()
      home: MindMapView()
      // home: TestView()
    );
  }
}