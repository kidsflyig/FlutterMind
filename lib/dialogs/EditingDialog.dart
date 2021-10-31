import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/Settings.dart';
import 'package:FlutterMind/utils/PopRoute.dart';
import 'package:FlutterMind/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'IconSelector.dart';

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
  EditConfig config;
  EditingDialog(this.config);

  static Future showMyDialog(BuildContext context, EditConfig config) async {
    // Navigator.push(context, PopRoute(child: EditingDialog(config)));

    Navigator.push(context,
      PageRouteBuilder(
        opaque: false,
        barrierDismissible:true,
        transitionDuration: Duration(milliseconds: 1000),
        transitionsBuilder: (ctx, anim1, anim2, child) {
          // return FadeTransition(opacity: Tween(begin: 0.0, end:1.0).
          //   animate(CurvedAnimation(parent: anim1, curve: Curves.fastOutSlowIn)), child:child);

          return new ScaleTransition(
            scale: new Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
                CurvedAnimation(
                  parent: anim1,
                  curve: Interval(
                    0.00,
                    0.25,
                    curve: Curves.linear,
                  ),
                ),
              ),
            child: child,
           );
        },
        pageBuilder: (ctx, animation, secondanimation) {
          return EditingDialog(config);
        }



        ));
  }

  @override
  State<StatefulWidget> createState() {
    return EditingDialogState();
  }
}

class EditingDialogState extends State<EditingDialog> {
  @override
  void initState() {
    super.initState();
    if (Utils().isAndroid) {
      print("EditingDialogState setEnabledSystemUIOverlays");
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  EditingDialogState() {}

  Widget build(BuildContext context) {
    Function onSubmitWapper = (msg) {
      print("showMyDialog1");
      if (widget.config.onSubmit != null) {
        print("showMyDialog2");
        widget.config.onSubmit(msg);
      }
      Navigator.pop(context);
      Utils.disableStatusBar();
    };
    String value;

    return Material(
      color: Colors.black26,
      child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                        alignment: Alignment.center,
                        color: Colors.red,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(flex: 1, child: 
                              IconButton(
                                  onPressed: () {
                                    print("submit value = " + value);
                                    onSubmitWapper(value);
                                  },
                                  icon: Icon(Icons.check))),
                              Expanded(flex: 1, child: 
                              IconButton(
                                  onPressed: () {
                                    onSubmitWapper("");
                                  },
                                  icon: Icon(Icons.clear))),
                              Expanded(flex: 12, child: SizedBox()),
                              Expanded(flex: 1, child: 
                              IconButton(
                                  onPressed: () {
                                    print("cacel value = ");
                                    Navigator.pop(context);
                                    Utils.disableStatusBar();
                                  },
                                  icon: Icon(Icons.cancel))),
                              // IconButton(
                              //     onPressed: () {
                              //       print("icon value = ");
                              //       IconSelector.showDialog(context);
                              //     },
                              //     icon: Icon(Icons.face)),
                            ])),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 100,
                        maxHeight: 400,
                      ),
                      height: 50,
                      color: Colors.white70,
                      child: TextField(
                        toolbarOptions: ToolbarOptions(copy : true, cut : true, paste : true, selectAll : true),
                        keyboardType: widget.config.keyboardType,
                        textInputAction: widget.config.textInputAction,
                        autofocus: true,
                        maxLines: widget.config.maxLines,
                        maxLength: widget.config.maxLength,
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
                    ),
                  ]))),
    );
  }
}
