import 'package:FlutterMind/utils/Log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator_view/loading_indicator_view.dart';

class LoadingDialog extends StatefulWidget {
  LoadingDialog({Key key, this.title}) : super(key: key);
  final String title;
  _LoadingDialogState state;

  static LoadingDialog show(context) {
    LoadingDialog loading = LoadingDialog();
    Navigator.push(context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (ctx, animation, secondanimation) {
          return loading;
        }));
    return loading;
  }

  void hide() {
    if (state != null && state.mounted)
      state.hide();
  }

  @override
  _LoadingDialogState createState() {
    state = _LoadingDialogState();
    return state;
  } 
}

class _LoadingDialogState extends State<LoadingDialog> {
  int _orderNum = 1;
  int start_time;
  static const int MIN_DURATION = 1500;
  int duration = MIN_DURATION;

  @override
  void initState() {
    start_time = DateTime.now().millisecondsSinceEpoch;
  }

  void hide() {
    int end_time = DateTime.now().millisecondsSinceEpoch;
    duration = 0;
    if (end_time - start_time < MIN_DURATION) {
      duration = MIN_DURATION - (end_time - start_time);
    }
    Log.e("_LoadingDialogState hide duration left = " + duration.toString());
    Future.delayed(Duration(milliseconds: duration), () {
      duration = 0;
      setState(() {
        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (duration <=0 ) {
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(100, 100, 100, 100),
      body: Center(child: BallSpinFadeLoaderIndicator())
    );
  }
}