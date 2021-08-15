import 'package:FlutterMind/Foreground.dart';
import 'package:FlutterMind/dialogs/StyleEditorDialog.dart';
import 'package:FlutterMind/utils/ScreenUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../operations/OpCenterlize.dart';
import '../operations/OpLoadFromFile.dart';
import '../operations/OpWriteToFile.dart';
import 'FileDialog.dart';
import 'ScaleDialog.dart';
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

  Foreground foreground_;
  TopToolBar(this.foreground_) {
    textStyle = TextStyle(
      fontSize: 15,
      color: Colors.white,
      fontFamily: 'OpenSans',
    );

    textAlign = TextAlign.left;
  }

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
                icon: ImageIcon(AssetImage('assets/images/icons/icon_file.png')),
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
                    StyleEditorDialog.show(context, null).then((value){
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

          // TextStyleEditor(
          //   fonts: fonts,
          //   textStyle: textStyle,
          //   textAlign: textAlign,
          //   paletteColors: paletteColors,
          //   onTextAlignEdited: (align) {
          //     // setState(() {
          //     //   textAlign = align;
          //     // });
          //   },
          //   onTextStyleEdited: (style) {
          //     // setState(() {
          //     //   textStyle = textStyle.merge(style);
          //     // });
          //   },
          //   onCpasLockTaggle: (caps) {
          //     // Uppercase or lowercase letters
          //   },
          // )
        ],
      // )
    );
  }
}