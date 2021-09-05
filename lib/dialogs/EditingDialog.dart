import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/utils/PopRoute.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class EditConfig {
  Offset pos;
  Function onSubmit;
  Function onChanged;
  int maxLines = 1;
  int maxLength = 10;
  TextInputAction textInputAction = TextInputAction.done;
  TextInputType keyboardType = TextInputType.text;
  EditConfig(
      {this.pos,
      this.onSubmit,
      this.maxLength,
      this.onChanged,
      this.maxLines,
      this.keyboardType,
      this.textInputAction});
}

class EditingDialog extends StatefulWidget {
  EditingDialog();
  static Future show(BuildContext ctx) async {
    var result = await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(content: EditingDialog());
        });
    print("result   -- >  " + result.toString());
    return result;
  }

  static Future showMyDialog(BuildContext context, EditConfig config) async {
    Function onSubmitWapper = (msg) {
      print("showMyDialog1");
      if (config.onSubmit != null) {
        print("showMyDialog2");
        config.onSubmit(msg);
      }
      Navigator.pop(context);
    };
    String value;
    Navigator.push(
        context,
        PopRoute(
            child: Material(
          color: Colors.black26,
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                child:Column(
                crossAxisAlignment: CrossAxisAlignment .start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                SizedBox(height: 50,),
                Container(
                  alignment: Alignment.center,
                  color:Colors.red,
                  child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  IconButton(onPressed: () {
                    print("submit value = " + value);
                    onSubmitWapper(value);
                  }, icon: Icon(Icons.check)),
                  IconButton(onPressed: () {
                    onSubmitWapper("");
                  }, icon: Icon(Icons.clear)),
                  IconButton(onPressed: () {
                    print("cacel value = " + value);
                    Navigator.pop(context);
                  }, icon: Icon(Icons.cancel)),
                ])),
                Container(
                  // margin: EdgeInsets.only(
                  //     left: config.pos.dx,
                  //     top: config.pos.dy,
                  //     right: 5,
                  //     bottom: 5),
                  constraints: BoxConstraints(
                    minHeight: 100,
                    maxHeight: 400,
                  ),
                  height: 50,
                  color: Colors.white70,
                  child: TextField(
                    keyboardType: config.keyboardType,
                    textInputAction: config.textInputAction,
                    autofocus: true,
                    maxLines: config.maxLines,
                    maxLength: config.maxLength,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: "",
                    ),
                    style: new TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                    onChanged: (str) {
                      value = str;
                    },
                    // onSubmitted: onSubmitWapper,
                  ),
                )
              ]))),
        ))
        );
  }

  @override
  State<StatefulWidget> createState() {
    return EditingDialogState(Settings().scaleLevel);
  }
}

class EditingDialogState extends State<EditingDialog> {
  double _sliderItemA = 5;

  EditingDialogState(double scale_level) {
    _sliderItemA = scale_level;
    print("first scale:" + _sliderItemA.toString());
  }
  Widget build(BuildContext context) {
    return Material(
        color: Colors.green,
        child: Container(
            padding: EdgeInsets.only(top: 100, left: 100),
            child: TextField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              autofocus: true,
              maxLines: 10,
              style: new TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            )));
  }
}
