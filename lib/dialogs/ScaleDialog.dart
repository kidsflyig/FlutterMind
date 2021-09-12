import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:flutter/material.dart';

class ScaleDialog extends StatefulWidget {
  double init_value;
  double max_value;
  double min_value;
  Function cb;

  ScaleDialog(this.init_value, this.max_value, this.min_value, this.cb);
  // Background(Data d):data = d;

  static Future show(BuildContext ctx, double init_value, double max, double min, cb) async {
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
                      content: ScaleDialog(init_value, max, min, cb)
                      );
        });
    print("result   -- >  " + result.toString());
    return result;
  }

  @override
  State<StatefulWidget> createState() {
    return ScaleDialogState();
  }
}

class ScaleDialogState extends State <ScaleDialog> {
  double _sliderItemA = 0;

  ScaleDialogState() {
  }

  void initState() {
    _sliderItemA = widget.init_value;
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
              setState(() {});
              widget.cb(value);
            },
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).accentColor.withOpacity(0.3),
            min: widget.min_value,
            max: widget.max_value,
            divisions: (widget.max_value - widget.min_value).toInt(),
            label: _sliderItemA.toString(),
          )
        )
        // painter: MyPainter(data),
      );
  }
}