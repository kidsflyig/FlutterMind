import 'package:FlutterMind/Foreground.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../operations/OpCenterlize.dart';
import '../operations/OpLoadFromFile.dart';
import '../operations/OpWriteToFile.dart';
import 'FileDialog.dart';
import 'ScaleDialog.dart';
import 'OperationDialog.dart';

class TopToolBar extends StatelessWidget {

  Foreground foreground_;
  TopToolBar(this.foreground_);

  @override
  Widget build(BuildContext context) {
    return
    // Container(
    //   color: Colors.transparent,
    //   alignment: Alignment.center,
    //   margin: EdgeInsets.only(right: ScreenUtil.getDp(main_menu_padding_left)),
    //   height: 50,
    //   child:
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(6.0),bottomLeft:Radius.circular(6.0))
              ),
              child:IconButton(
                icon: ImageIcon(AssetImage('images/icons/icon_file.png')),
                color: Colors.black38,
                onPressed: () {
                  FileDialog.show(context).then((value){
                    // created or closed?
                  });
                },
              )
          ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
              ),
              child:IconButton(
                icon: Icon(Icons.notifications),
                color: Colors.black38,
                onPressed: () {
                    OperationDialog.show(context, foreground_).then((value){
                      // created or closed?
                    });
                },
              )
          ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(topRight:Radius.circular(6.0),bottomRight:Radius.circular(6.0))
              ),
              child:IconButton(
                icon: Icon(Icons.notifications),
                color: Colors.black38,
                onPressed: () {
                  ScaleDialog.show(context, foreground_).then((value){
                    // created or closed?
                  });
                },
              )
          ),
        ],
      // )
    );
  }
}