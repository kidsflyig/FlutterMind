import 'package:FlutterMind/MapController.dart';
import 'package:FlutterMind/dialogs/StyleEditorDialog.dart';
import 'package:FlutterMind/third_party/SimpleImageButton.dart';
import 'package:FlutterMind/utils/Constants.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../operations/OpCenterlize.dart';
import '../operations/OpLoadFromFile.dart';
import '../operations/OpWriteToFile.dart';
import 'FileDialog.dart';
// import 'package:text_style_editor/text_style_editor.dart';

class TopToolBar extends StatelessWidget {
  List<String> fonts = [
    'Billabong',
    'AlexBrush',
    'Allura',
    'Arizonia',
    'ChunkFive',
    'GrandHotel',
    'GreatVibes',
    'Lobster',
    'OpenSans',
    'OstrichSans',
    'Oswald',
    'Pacifico',
    'Quicksand',
    'Roboto',
    'SEASRN',
    'Windsong',
  ];
  List<Color> paletteColors = [
    Colors.black,
    Colors.white,
    Color(int.parse('0xffEA2027')),
    Color(int.parse('0xff006266')),
    Color(int.parse('0xff1B1464')),
    Color(int.parse('0xff5758BB')),
    Color(int.parse('0xff6F1E51')),
    Color(int.parse('0xffB53471')),
    Color(int.parse('0xffEE5A24')),
    Color(int.parse('0xff009432')),
    Color(int.parse('0xff0652DD')),
    Color(int.parse('0xff9980FA')),
    Color(int.parse('0xff833471')),
    Color(int.parse('0xff112CBC4')),
    Color(int.parse('0xffFDA7DF')),
    Color(int.parse('0xffED4C67')),
    Color(int.parse('0xffF79F1F')),
    Color(int.parse('0xffA3CB38')),
    Color(int.parse('0xff1289A7')),
    Color(int.parse('0xffD980FA'))
  ];
  TextStyle textStyle;
  TextAlign textAlign;

  TopToolBar() {
    textStyle = TextStyle(
      fontSize: 15,
      color: Colors.white,
      fontFamily: 'OpenSans',
    );

    textAlign = TextAlign.left;
  }

  @override
  Widget build(BuildContext context) {
    var bg_color = Colors.black45;
    var width = ScreenUtil.getDp(C.top_toolbar_btn_width);
    return Padding(
      padding : EdgeInsets.only(top: 6),
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
                    decoration: BoxDecoration(
                      color: bg_color,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          bottomLeft: Radius.circular(6.0))),
                    child: SimpleImageButton(
                      width: width,
                      normalImage: 'assets/icons/icon_file.png',
                      pressedImage: 'assets/icons/icon_file.png',
                      onPressed: () {
                        FileDialog.showMyDialog(context).then((value) {
                          // created or closed?
                        });
                      },
                    )),
                Container(
                    padding: EdgeInsets.only(top: 10, left: 5, bottom: 10, right: 5),
                    decoration: BoxDecoration(
                      color: bg_color,
                    ),
                    child: SimpleImageButton(
                      width: width,
                      normalImage: 'assets/icons/icon_style_editor.png',
                      pressedImage: 'assets/icons/icon_style_editor.png',
                      onPressed: () {
                        StyleEditorDialog.show(context, null).then((value) {
                          // created or closed?
                        });
                      },
                    )),
                Container(
                    padding: EdgeInsets.only(top: 10, left: 5, bottom: 10, right: 5),
                    decoration: BoxDecoration(
                      color: bg_color,
                    ),
                    child: SimpleImageButton(
                      width: width,
                      normalImage: 'assets/icons/icon_undo.png',
                      pressedImage: 'assets/icons/icon_undo.png',
                      onPressed: () {
                        MapController().undo();
                      },
                    )),
                Container(
                    padding: EdgeInsets.only(top: 10, left: 5, bottom: 10, right: 10),
                    decoration: BoxDecoration(
                        color: bg_color,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0))),
                    child: SimpleImageButton(
                      width: width,
                      normalImage: 'assets/icons/icon_redo.png',
                      pressedImage: 'assets/icons/icon_redo.png',
                      onPressed: () {
                        MapController().redo();
                      },
                    )),
              ],
            )));
  }
}
