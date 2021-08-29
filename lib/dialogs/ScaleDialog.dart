import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:flutter/material.dart';

class ScaleDialog extends StatefulWidget {
  // Data data;
  ScaleDialog();
  // Background(Data d):data = d;

  static Future show(BuildContext ctx) async {
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
                      content: ScaleDialog()
                      );
        });
    print("result   -- >  " + result.toString());
    return result;
  }

  @override
  State<StatefulWidget> createState() {
    return ScaleDialogState(Settings().scaleLevel);
  }
}

class ScaleDialogState extends State <ScaleDialog> {
  double _sliderItemA = 5;

  ScaleDialogState(double scale_level) {
    _sliderItemA = scale_level;
    print("first scale:"+_sliderItemA.toString());
  }
  Widget build(BuildContext context) {
    return Container(
        height:50,
        width:100,
        // margin:  EdgeInsets.only(left: 50, top: 50),
        child: Container(
          width: 100,
          child: Slider(
            value: _sliderItemA,
            onChanged: (value) {
              print("onChanged " + value.toString());
              _sliderItemA = value;
              setState(() {
                _sliderItemA = value;
              });

              MapController().setScaleLevel(value);
            },
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).accentColor.withOpacity(0.3),
            min: 1,
            max: 10,
            divisions: 9,
            label: (100 + (_sliderItemA - 5) * 10).toString() + '%',
          )
        )
        // painter: MyPainter(data),
      );
  }
}