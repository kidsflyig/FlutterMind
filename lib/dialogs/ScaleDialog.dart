import 'package:flutter/material.dart';

import '../Foreground.dart';

class ScaleDialog extends StatefulWidget {
  Foreground _foreground;

  // Data data;
  ScaleDialog(this._foreground);
  // Background(Data d):data = d;

  static Future show(BuildContext ctx, Foreground foreground) async {
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
                      content: ScaleDialog(foreground)
                      );
        });
    print("result   -- >  " + result.toString());
    return result;
  }

  @override
  State<StatefulWidget> createState() {
    return ScaleDialogState(_foreground.scale);
  }
}

class ScaleDialogState extends State <ScaleDialog> {
  double _sliderItemA = 5;

  ScaleDialogState(double scale) {
    int temp = (scale * 100).toInt();
    _sliderItemA = temp.toDouble();
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
              // double scale = ((_sliderItemA - 5)*0.1 + 1);
              widget._foreground.SetScale(value / 100);
            },
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).accentColor.withOpacity(0.3),
            min: 10,
            max: 300,
            divisions: 29,
            label: '%' + _sliderItemA.ceil().toString(),
          )
        )
        // painter: MyPainter(data),
      );
  }
}