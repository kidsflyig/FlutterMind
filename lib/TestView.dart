import 'dart:collection';
// import 'dart:html';
import 'dart:math';

import 'package:FlutterMind/Foreground.dart';
import 'package:FlutterMind/utils/HitTestResult.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:FlutterMind/widgets/NodeWidgetBase.dart';
import 'package:FlutterMind/utils/DragUtil.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:FlutterMind/widgets/RootNodeWidget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  String data = "";

  MyTextField(this.data);

  void test() {
    print("in test1");
    Future(() => print('in test2'));
    print("in test3");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((mag) {
      RenderBox box = context.findRenderObject();

       print("页面渲染完毕:" + box.size.toString());
    });
    return GestureDetector(
      child: Container(
      color: Colors.red,
      width:50,
      height:50,
      child:Text(data)
    ),
    onTap: () {
      print("before test");
      test();
      print("after test");
    },);
  }
}

class TestView extends NodeWidgetBase {
  @override
  State<StatefulWidget> createState() {
    return TestViewState();
  }
}

class TestViewState extends State<TestView> {

  UniqueKey key = new UniqueKey();
  String data = "";

  // Future fetchImage() async {
  //   var image = await ImagePicker.pickImage(source:ImageSource.);
  // }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("RichText学习"),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            child: TextButton(
              onPressed: () {
                print("11111");
              },
              child: Text("click")
            ))),
    );
  }
}



class TestView2 extends StatefulWidget {
  _LogoAppState createState() => new _LogoAppState();
}

class _LogoAppState extends State<TestView> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 4000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.forward();
  }

  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        margin: new EdgeInsets.symmetric(vertical: 10.0),
        height: animation.value,
        width: animation.value,
        child: new FlutterLogo(),
      ),
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
