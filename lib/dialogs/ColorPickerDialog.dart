import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/third_party/color_picker/flutter_colorpicker.dart';
import 'package:FlutterMind/utils/Log.dart';
import 'package:flutter/material.dart';
import '../Foreground.dart';

class ColorPickerDialog extends StatefulWidget {

  // Data data;
  ColorPickerDialog(this.color);
  Color color = Color(0xff443a49);
  // Background(Data d):data = d;

  static Future show(BuildContext ctx, cb, color) async {
    ColorPickerDialog dialog = ColorPickerDialog(color);
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
                      content: dialog,
                          actions: <Widget>[
                            FlatButton(
                              child: const Text('Got it'),
                              onPressed: () {
                                if (cb != null && cb is Function) {
                                  Navigator.pop(context);
                                  cb(dialog.color);
                                }
                              }
                            ),
                          ]
                      );
        });
    return result;
  }

  @override
  State<StatefulWidget> createState() {
    return ColorPickerDialogState();
  }
}

class ColorPickerDialogState extends State <ColorPickerDialog> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
    widget.color = color;
  }

  ColorPickerDialogState() {
  }

  Widget build(BuildContext context) {
    currentColor = pickerColor = widget.color;

    return SingleChildScrollView(
      child: ColorPicker(
        pickerColor: pickerColor,
        onColorChanged: changeColor,
        showLabel: true,
        pickerAreaHeightPercent: 0.8,
      ));
  }
}