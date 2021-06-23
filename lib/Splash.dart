import 'dart:async';
import 'dart:io';

import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/utils/Utils.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'MindMapView.dart';

class Splash extends StatefulWidget {
  SplashState state;

  @override
  State<StatefulWidget> createState() {
    state = SplashState();
    return state;
  }
}

class SplashState extends State<Splash> {
  final int timelimit = 5;
  int current ;
  var time;
  SplashState() {
    current = timelimit;
  }

  @override
  Widget build(BuildContext context) {

    if (time == null) {
      time = Timer.periodic(
        Duration(milliseconds: 1000),
        (t) {
          print('执行');
          if (--current < 0) {
            t.cancel();
            Navigator.push( context,
              MaterialPageRoute(
                builder: (context) {
                  return MindMapView();
                }));
          } else {
            setState((){
            });
          }
        }
      );
    }

    return new Scaffold(
      body: Container(
        // width: Utils.screenSize().width,
        // height: Utils.screenSize().height,
        child: Stack(
          children: [
            new Image(
              width: Utils.screenSize().width,
              height: Utils.screenSize().height,
              // fit:BoxFit.none,
              image: new AssetImage('images/test.jpg'),
              alignment: Alignment.center,
            ),
            Container(
              padding: EdgeInsets.only(right:10, bottom:10),
              alignment: Alignment.bottomRight,
              child:Text(current.toString() + "s", textAlign: TextAlign.end),
            )
          ]
        )
      )
    );
  }


}